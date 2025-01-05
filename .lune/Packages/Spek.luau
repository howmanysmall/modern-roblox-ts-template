--!optimize 2
--!strict

local Chalk = require("@packages/Chalk")
local DateTime = require("@lune/datetime")
local FileInstance = require("@classes/FileInstance")
local Fmt = require("@packages/Fmt")
local PathFileSystem = require("@packages/PathFileSystem")
local RegEx = require("@lune/regex")
local SemanticVersion = require("@packages/SemanticVersion")
local roblox = require("@lune/roblox")
local task = require("@lune/task")

local LuauPath = PathFileSystem.Path

local IS_SPEK = RegEx.new("\\.spek\\.luau?$")
local IS_SPEK_ROBLOX = RegEx.new("\\.spek$")
local MATCH_CHALK = RegEx.new("[\\u001b\\u009b][\\[()#;?]*(?:[0-9]{1,4}(?:;[0-9]{0,4})*)?[0-9A-ORZcf-nqry=><]")

local VERSION = SemanticVersion.new("0.0.0")

local IsMatch = IS_SPEK.isMatch
local ReplaceAll = MATCH_CHALK.replaceAll

local repeatCache: {[string]: {string}} = {}
local function StringRep(repeatString: string, count: number): string
	local cache = repeatCache[repeatString]
	if not cache then
		cache = {}
		repeatCache[repeatString] = cache
	end

	local value = cache[count]
	if not value then
		value = string.rep(repeatString, count)
		cache[count] = value
	end

	return value
end
for index = 0, 50 do
	StringRep("…", index)
	StringRep(" ", index)
	StringRep("-", index)
end

local freeThreads: {thread} = table.create(500)
local freeAmount = 0

local function RunFunction<Arguments...>(callback: (Arguments...) -> (), thread: thread, ...: Arguments...): ()
	callback(...)
	freeAmount += 1
	freeThreads[freeAmount] = thread
end
local function Yield(): ()
	while true do
		RunFunction(coroutine.yield())
	end
end
local function FastDefer<Arguments...>(callback: (Arguments...) -> (), ...: Arguments...): thread
	local thread: thread

	if freeAmount > 0 then
		thread = freeThreads[freeAmount]
		freeThreads[freeAmount] = nil
		freeAmount -= 1
	else
		thread = coroutine.create(Yield)
		coroutine.resume(thread)
	end

	return task.defer(thread, callback, thread, ...)
end

--@sec: Spek
--@ord: -10
--@doc: All-in-one module for testing and benchmarking.
--
-- ## Speks
--
-- A specification or **spek** is a module that defines requirements (tests) and
-- measurements (benchmarks). As a Roblox instance, a spek is any ModuleScript
-- whose Name has the `.spek` suffix.
--
-- The principle value returned by a module is a **plan**, or a function that
-- receives a [T][T] object. A table of plans can be returned instead.
-- ModuleScripts may also be returned, which will be required as speks. The full
-- definition for the returned value is as follows:
--
-- ```lua
-- type Input = Plan | ModuleScript | {[any]: Input}
-- type Plan = (t: T) -> ()
-- ```
--
-- Each plan function specifies a discrete set of units that remain grouped
-- together and separated from other plans. For example, when specifying
-- benchmarks, measurements that belong to the same plan will be tabulated into
-- one table, and wont mix with measurements from other plans.
--
-- The following can be used as a template for writing a spek:
--
-- ```lua
-- -- Optional; used only to get exported types.
-- local Spek = require(game:FindFirstDescendant("Spek"))
-- -- Require dependencies as usual.
-- local Eieren = require(script.Parent.Eieren)
--
-- return function(t: Spek.T)
-- 	--TODO: Test Eieren module.
-- end
-- ```
local export = {}

-- Due to type limitations, pcall has a type signature that evaluates
-- incorrectly with functions that return no values. Casting such a function to
-- this allows the return types to work correctly. This can be removed once
-- pcall gets a better type signature.
type PCALLABLE = any

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--@sec: Path
--@def: type Path
--@doc: A unique symbol representing a path referring to a value within a result
-- tree. Converting to a string displays a formatted path.
local Path = {}
Path.__index = Path

export type Path = {
	Base: (self: Path) -> any,
	Elements: (self: Path) -> {any},
}

type _Path = Path & {
	_elements: {any}, -- Actual elements of the path.
	_string: string, -- Cached string.
}

-- Creates a new path from the given elements.
local function newPath(...: unknown): Path
	local elements = table.freeze({...})
	local elementString = table.create(#elements)
	if #elements == 0 then
		elementString[1] = "(root)"
	end

	for index, element in elements do
		local asString = tostring(element)
		if string.match(asString, "[%[%]]") then
			elementString[index] = string.format("[%q]", asString)
		else
			elementString[index] = string.format("[%*]", asString)
		end
	end

	local self: _Path = setmetatable({
		_elements = elements;
		_string = table.concat(elementString);
	}, Path) :: never

	return table.freeze(self)
end

function Path.__tostring(self: _Path): string
	return self._string
end

--@sec: Path.Base
--@def: function Path:Base(): any
--@doc: Returns the last element of the path.
function Path.Base(self: _Path): any
	local elements = self._elements
	return elements[#elements]
end

--@sec: Path.Elements
--@def: function Path:Elements(): {any}
--@doc: Returns the path as a list of elements.
function Path.Elements(self: _Path): {any}
	return table.clone(self._elements)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Used to wait for multiple threads to finish.
local WaitGroup = {}
WaitGroup.__index = WaitGroup

type WaitGroup = {
	-- Threads the group is waiting on.
	_dependencies: {[thread]: true?},
	-- Threads waiting on the group.
	_dependents: {thread},
	-- Optional function to call before resuming dependents.
	_beforeFinish: (wg: WaitGroup) -> ()?,

	Finish: (self: WaitGroup) -> (),
	--TODO: Add: <X...>(self: WaitGroup, func: (X...)->(), X...) -> (),
	Add: (self: WaitGroup, func: (...any) -> (), ...any) -> (),
	AddThread: (self: WaitGroup, thread: thread) -> (),
	AddWaitGroup: (self: WaitGroup, wg: WaitGroup) -> (),
	Wait: (self: WaitGroup) -> (),
	Cancel: (self: WaitGroup) -> (),
}

-- Creates a new WaitGroup. Receives an optional function to run before each
-- time the WaitGroup finishes.
local function newWaitGroup(beforeFinish: (wg: WaitGroup) -> ()?): WaitGroup
	local self: WaitGroup = setmetatable({
		_dependencies = {};
		_dependents = {};
		_beforeFinish = beforeFinish;
	}, WaitGroup) :: never

	return table.freeze(self)
end

-- Called by a dependency to indicate that it is finished.
function WaitGroup.Finish(self: WaitGroup)
	local currentThread = coroutine.running()
	if not self._dependencies[currentThread] then
		-- Ignore if thread is not a dependency.
		return
	end

	self._dependencies[currentThread] = nil
	if next(self._dependencies) then
		-- Still waiting on dependencies.
		return
	end

	if self._beforeFinish then
		self._beforeFinish(self)
	end

	for _, thread in self._dependents do
		task.defer(thread)
	end

	table.clear(self._dependents)
end

-- Adds a function call as a dependency thread to wait on.
function WaitGroup.Add<X...>(self: WaitGroup, callback: (X...) -> (), ...: X...)
	local function execute<X...>(internalCallback: (X...) -> (), ...: X...)
		local success, exception = pcall(internalCallback :: never, ...)
		if not success then
			error(string.format("waitgroup dependency errored: %*", exception))
		end

		self:Finish()
	end

	local thread = FastDefer(execute, callback, ...)
	self._dependencies[thread] = true
end

-- Adds a thread as a dependency. The thread is expected to call Finish before
-- it dies.
function WaitGroup.AddThread<X...>(self: WaitGroup, thread: thread)
	self._dependencies[thread] = true
end

-- Adds a WaitGroup as a dependency.
function WaitGroup.AddWaitGroup<X...>(self: WaitGroup, waitGroup: WaitGroup)
	local thread = FastDefer(function()
		waitGroup:Wait()
		self:Finish()
	end)

	self._dependencies[thread] = true
end

-- Called by a dependent thread to block until the WaitGroup is done.
function WaitGroup.Wait(self: WaitGroup)
	if not next(self._dependencies) then
		return
	end

	table.insert(self._dependents, coroutine.running())
	coroutine.yield()
end

-- Called by a dependent thread to cancel all dependency threads and resume all
-- dependent threads.
function WaitGroup.Cancel(self: WaitGroup)
	for thread in self._dependencies do
		task.cancel(thread)
	end

	table.clear(self._dependencies)
	for _, thread in self._dependents do
		task.defer(thread)
	end

	table.clear(self._dependents)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Enables the creation of thread-scoped "contexts". An "object" contains a
-- number of predefined "context functions", which do different things depending
-- on the context.
--
-- The primary use is to have the object provide a number of upvalue functions
-- that receive closures. Such a closure is received in one context, then called
-- in another, while still using the same upvalue functions.
type ContextManager<X> = {
	-- Sets the context for the running thread for the duration of the call to
	-- *body*, then calls *body*. *verb* is a description indicating what is
	-- happening while function is running (e.g. while "executing"). *context*
	-- is called to populate the context with implementations for each
	-- predefined function.
	--
	-- *context* does not need to implement all functions. If an unimplemented
	-- function is called, an error will be thrown indicating that the function
	-- cannot be called in that context.
	--
	-- The user of a context is not expected to call these functions from
	-- different threads. An error will be thrown if a function is called from a
	-- thread not known by the ContextManager.
	While: (self: ContextManager<X>, verb: string, context: (ContextObject) -> (), body: () -> ()) -> (),
	-- Returns the object containing the public-facing context functions.
	Object: X,
	-- Returns whether an error in the running thread originated from the
	-- context manager.
	Errored: (self: ContextManager<X>) -> boolean,
}

type ContextObject = {[string]: any}

-- Creates a new ContextManager. Each argument is the name of a function
-- expected to be in object X. If an argument is a table, then it's fields are
-- mapped directly to X.
local function newContextManager<X>(...: string | {[any]: any}): ContextManager<X>
	local self = {}

	type ThreadState = {
		-- Name used for context.
		Verb: string,
		-- Represents current state of context.
		Object: ContextObject,
		-- Stores whether an error produced by the caller originated from the
		-- context manager.
		Errored: boolean,
	}

	-- Must cast as any because type T is not implemented by T+metatable.
	local threadStates: {[thread]: ThreadState} = setmetatable({}, {__mode = "k"}) :: never

	local object: ContextObject = {}
	for index = 1, select("#", ...) do
		local field = select(index, ...)
		if type(field) == "table" then
			for key, value in field do
				object[key] = value
			end

			continue
		end

		object[field] = function(...)
			local state = threadStates[coroutine.running()]
			if not state then
				-- Running thread is not present in context. The user must have
				-- called this function from a different thread.
				error(string.format("cannot call %* in new thread", field), 2)
			end

			state.Errored = false
			local implementation = state.Object[field]
			if implementation == nil then
				-- Not implemented by this context.
				state.Errored = true
				error(string.format("cannot call %q while %*", field, state.Verb), 2)
			end

			return implementation(...)
		end
	end

	-- Assume that given fields implement X.
	self.Object = table.freeze(object) :: never

	function self.While(
		_: ContextManager<X>,
		verb: string,
		context: (contextObject: ContextObject) -> (),
		body: () -> ()
	)
		local contextObject: ContextObject = {}
		context(contextObject)
		local state = {Verb = verb, Object = contextObject, Errored = false}
		local thread = coroutine.running()
		threadStates[thread] = state
		local success, exception = pcall(body :: never)
		threadStates[thread] = nil
		if not success then
			error(string.format("body errored: %*", exception))
		end
	end

	function self.Errored(_: ContextManager<X>): boolean
		local state = threadStates[coroutine.running()]
		return state and state.Errored
	end

	return table.freeze(self)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--@sec: Config
--@ord: -3
--@def: type Config = {
-- 	Iterations: number?,
-- 	Duration: number?,
-- }
--@doc: Configures options for running a unit.
--
-- Field      | Type    | Description
-- -----------|---------|------------
-- Iterations | number? | Target iterations for each benchmark. If unspecified, or zero or less, Duration is used.
-- Duration   | number? | Target duration for each benchmark, in seconds. Defaults to 1.
--
export type Config = {
	Iterations: number?,
	Duration: number?,
}

-- Constructs an immutable Config.
local function newConfig(config: Config?): Config
	if type(config) == "table" then
		local configuration: Config = {}
		if type(config.Iterations) == "number" then
			configuration.Iterations = config.Iterations
		elseif config.Iterations ~= nil then
			error(string.format("Config.Iterations: number expected, got %*", typeof(config.Iterations)), 3)
		end

		if type(config.Duration) == "number" then
			configuration.Duration = config.Duration
		elseif config.Duration ~= nil then
			error(string.format("Config.Duration: number expected, got %*", typeof(config.Duration)), 3)
		end

		return table.freeze(configuration)
	elseif config == nil then
		return table.freeze({
			Iterations = nil;
			Duration = 1;
		})
	else
		error(string.format("Config expected, got %*", typeof(config)), 3)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--@sec: Result
--@def: type Result = {
-- 	Type: ResultType,
-- 	Path: Path,
-- 	Status: ResultStatus,
-- 	Reason: string,
-- 	Trace: string?,
-- }
--@doc: Represents the result of a unit. Converting to a string displays a
-- formatted result.
--
-- The **Type** field is a [ResultType][ResultType] that indicates the type of
-- result.
--
-- The **Path** field is a [Path][Path] indicating the origin of the result.
--
-- The **Status** field is a [ResultStatus][ResultStatus] indicating whether the
-- unit succeeded or failed. For nodes and plans, represents the conjunction of
-- the status of all sub-units. If any sub-unit has a pending result, then the
-- status will also be pending.
--
-- The **Reason** field is a message describing the reason for the status.
-- Usually empty if the unit succeeded.
--
-- The **Trace** field is an optional stack trace to supplement the Reason.
export type Result = {
	Type: ResultType,
	Path: Path,
	Status: ResultStatus,
	Reason: string,
	Trace: string?,
}

-- Constructs a new immutable Result.
local function newResult(node: Node, status: ResultStatus, reason: string, trace: string?): Result
	--TODO: Should be formattable.
	return table.freeze({
		Type = node.Type;
		Path = node.Path;
		Status = status;
		Reason = reason;
		Trace = trace;
	})
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- The interface for running a testing unit and handling the result. A Node is
-- immutable, but contains a mutable Data field. However, if the node is created
-- as an error node, the Data will be immutable.
local Node = {}
Node.__index = Node

type Node = {
	-- Type of the node.
	Type: ResultType,
	-- The tree the node belongs to.
	Tree: Tree,
	-- Path symbol that refers to this node.
	Path: Path,
	-- Parent node, or nil if root node.
	Parent: Node?,
	-- List of child nodes.
	Children: {Node},
	-- Mutable data. Immutable if the node was created as an error.
	Data: {
		-- Context associated with a plan.
		ContextManager: ContextManager<T>?,
		-- By default, siblings nodes are run serially. If true, this node
		-- should be run concurrently in separate thread.
		Concurrent: boolean?,
		-- If true, this node should be among the only nodes run.
		Only: boolean?,
		-- If true, this node should not run.
		Skip: boolean?,
		-- Deferred closure associated with the node.
		Closure: Closure?,
		--  Closures to run before Closure.
		Before: {Closure},
		--  Closures to run after Closure.
		After: {Closure},
		-- Specific or aggregate result of the node. If the node was created as
		-- an error, this will be filled in with the error.
		Result: Result,
		-- Specific or aggregate measurements about the node.
		Metrics: Metrics,
		-- Number of times the unit ran.
		Iterations: number,
		-- Total duration of all iterations of the unit.
		Duration: number,
		-- Benchmark categories.
		Categories: {[string]: true}?,
	},
	-- Marks data has having changed.
	Pending: {
		-- Corresponds to Data.Result.
		Result: boolean,
		-- Corresponds to Data.Metrics.
		Metrics: {[string]: true},
		-- Corresponds to Data.Iterations+Duration.
		Benchmark: boolean,
	},

	-- Whether the node type indicates a leaf node.
	IsLeaf: (self: Node) -> boolean,

	-- Updates data of the node. Returns false if the node is frozen.
	UpdateResult: (self: Node, result: Result) -> boolean,
	UpdateMetric: (self: Node, unit: string, value: number) -> boolean,
	UpdateBenchmark: (self: Node, iterations: number, duration: number) -> boolean,

	-- Reconciles derivative results and metrics.
	ReconcileResults: (self: Node) -> boolean,
	ReconcileMetrics: (self: Node) -> boolean,

	-- Calls the given observers with the node's pending data.
	Inform: (self: Node, result: ResultObserver, metric: MetricObserver) -> (),
}

--@sec: ResultType
--@def: type ResultType = "node" | "plan" | "test" | "benchmark"
--@doc: Indicates the type of a result tree node.
--
-- Value     | Description
-- ----------|------------
-- node      | A general node aggregating a number of units.
-- plan      | A discrete node representing a plan.
-- test      | A test unit.
-- benchmark | A benchmark unit.
--
export type ResultType = "node" | "plan" | "test" | "benchmark"

--@sec: ResultStatus
--@def: type ResultStatus = "pending" | "passed" | "failed" | "skipped" | "errored" | "TODO"
--@doc: Indicates the status of a result tree node.
--
-- Value   | Description
-- --------|------------
-- pending | The result has not been computed.
-- passed  | The unit succeeded.
-- failed  | The unit failed.
-- skipped | The unit was skipped and not run.
-- errored | An error was produced during planning.
-- TODO    | The unit is not fully implemented.
export type ResultStatus = "pending" | "passed" | "failed" | "skipped" | "errored" | "TODO"

--@sec: Metrics
--@def: type Metrics = {[string]: number}
--@doc: Metrics contains measurements made during a test or benchmark. It maps
-- the unit of a measurement to its value.
--
-- For a benchmark result, contains default and custom measurements reported
-- during the benchmark.
--
-- For a test result, contains basic measurements reported during the test.
--
-- For a node or plan result, contains aggregated measurements of all sub-units.
export type Metrics = {[string]: number}

-- Creates under *tree* a new Node of type *type*, parented to *parent* under
-- *key*. If *parent* is nil, the node assumed to be the root of *tree*.
local function newNode(tree: Tree, type: ResultType, parent: Node?, key: any): Node
	local node: Node = setmetatable({
		Type = type;
		Tree = tree;
		Path = nil;
		Parent = parent;
		Children = {};
		Data = {
			ContextManager = nil;
			Concurrent = false;
			Only = false;
			Skip = false;
			Closure = nil;
			Before = {};
			After = {};
			Metrics = {};
			Iterations = 0;
			Duration = 0;
		};
		Pending = {
			Result = false;
			Metrics = {};
			Benchmark = false;
		};
	}, Node) :: never

	if parent == nil then
		-- Root node.
		node.Path = newPath()
		tree.Root = node
	elseif parent ~= nil then
		assert(key ~= nil, "key cannot be nil")
		local elements = parent.Path:Elements()
		table.insert(elements, key)
		node.Path = newPath(table.unpack(elements))
		table.insert(parent.Children, node)
	end

	tree.Nodes[node.Path] = node
	node.Data.Result = newResult(node, "pending", "")
	return table.freeze(node)
end

-- Returns whether Type indicates a leaf node.
function Node.IsLeaf(self: Node): boolean
	return self.Type == "test" or self.Type == "benchmark"
end

-- Returns true if *old* and *new* are equivalent.
local function tablesEqual(old: {[string]: any}, new: {[string]: any}): boolean
	for key, value in old do
		if new[key] ~= value then
			return false
		end
	end

	for key, value in new do
		if old[key] ~= value then
			return false
		end
	end

	return true
end

-- Sets the result of the node to *result*. Marks the result as pending, and
-- marks the tree as dirty. Returns whether the data changed.
function Node.UpdateResult(self: Node, result: Result): boolean
	if table.isfrozen(self.Data) then
		return false
	end

	if tablesEqual(self.Data.Result, result) then
		return false
	end

	self.Data.Result = result
	self.Pending.Result = true
	self.Tree:Dirty()
	return true
end

-- Sets a metric of the node. Marks the metric as pending, and marks the tree as
-- dirty. Returns whether the data changed.
function Node.UpdateMetric(self: Node, unit: string, value: number): boolean
	if table.isfrozen(self.Data) then
		return false
	end

	if self.Data.Metrics[unit] == value then
		return false
	end

	self.Data.Metrics[unit] = value
	self.Pending.Metrics[unit] = true
	self.Tree:Dirty()
	return true
end

-- Sets the benchmark metrics of the node. Marks the metrics as pending, and
-- marks the tree as dirty. Returns whether the data changed.
function Node.UpdateBenchmark(self: Node, iterations: number, duration: number): boolean
	if table.isfrozen(self.Data) then
		return false
	end

	if self.Data.Iterations == iterations and self.Data.Duration == duration then
		return false
	end

	self.Data.Iterations = iterations
	self.Data.Duration = duration
	self.Pending.Benchmark = true
	self.Tree:Dirty()
	return true
end

-- Returns first child with *status*, or nil.
local function anyStatus(node: Node, status: ResultStatus): Result?
	for _, child in node.Children do
		if child.Data.Result.Status == status then
			return child.Data.Result
		end
	end

	return nil
end

-- Returns true of all children have *status*.
local function allStatus(node: Node, status: ResultStatus): boolean
	for _, child in node.Children do
		if child.Data.Result.Status ~= status then
			return false
		end
	end

	return true
end

-- If the node has child nodes, the Result of the node will be set to the
-- aggregation of the children's results. Returns whether there were changes.
function Node.ReconcileResults(self: Node): boolean
	if #self.Children == 0 then
		if self:IsLeaf() then
			-- Return whether leaf node has pending result.
			return self.Pending.Result
		end

		-- Non-leaf node with no children; aggregate as passed. May have skipped
		-- status at this point, so set only if it is pending.
		if self.Data.Result.Status == "pending" then
			return self:UpdateResult(newResult(self, "passed", ""))
		end

		return false
	end

	-- Reconcile children.
	for _, node in self.Children do
		node:ReconcileResults()
	end

	-- Aggregate results.

	-- If any child errored, set to the first errored result.
	local result = anyStatus(self, "errored")
	if result then
		return self:UpdateResult(result)
	end

	-- Otherwise, if any child is pending, set to pending.
	result = anyStatus(self, "pending")
	if result then
		return self:UpdateResult(result)
	end

	-- Otherwise, if any child failed, set to the first failed result.
	result = anyStatus(self, "failed")
	if result then
		return self:UpdateResult(result)
	end

	-- Otherwise, if any child has TODO, set to the first TODO result.
	result = anyStatus(self, "TODO")
	if result then
		return self:UpdateResult(result)
	end

	-- Otherwise, if all children were skipped, set to skipped.
	if allStatus(self, "skipped") then
		return self:UpdateResult(newResult(self, "skipped", ""))
	end

	-- Otherwise, set to passed.
	return self:UpdateResult(newResult(self, "passed", ""))
end

-- If the node has child nodes, the Metrics of the node will be set to the
-- aggregation of the children's metrics.
function Node.ReconcileMetrics(self: Node): boolean
	if #self.Children == 0 then
		-- Return whether leaf node has pending metrics.
		return self.Pending.Benchmark or next(self.Pending.Metrics) ~= nil
	end

	-- Reconcile children.
	local changed = false
	for _, node in self.Children do
		changed = node:ReconcileMetrics() or changed
	end

	if not changed then
		-- No changes, no need to process.
		return false
	end

	local iterations = 0
	local duration = 0
	for _, node in self.Children do
		iterations += node.Data.Iterations
		duration += node.Data.Duration
	end

	local wasChanged = self:UpdateBenchmark(iterations, duration)

	local metrics: Metrics = {}
	for _, node in self.Children do
		for unit, value in node.Data.Metrics do
			if metrics[unit] then
				metrics[unit] += value
			else
				metrics[unit] = value
			end
		end
	end

	for unit, value in metrics do
		wasChanged = self:UpdateMetric(unit, value) or wasChanged
	end

	return wasChanged
end

-- Produces the actual value of a metric with a specific prefix.
local function calculateMetric(value: number, unit: string, iterations: number, duration: number): number
	if string.match(unit, "/op$") then
		return value / iterations
	end

	if string.match(unit, "/s$") then
		return value / duration
	end

	if string.match(unit, "/ms$") then
		return value / (duration * 1000)
	end

	if string.match(unit, "/us$") then
		return value / (duration * 1_000_000)
	end

	return value
end

-- Calls *visit* for each metric in *node*. Values are the final calculated
-- value based on the unit. If not overridden, the "iterations" and "duration"
-- metrics are included from benchmark data.
local function buildMetrics(node: Node, visit: (unit: string, value: number) -> ())
	local iterations = node.Data.Iterations
	local duration = node.Data.Duration
	if not node.Data.Metrics.iterations then
		visit("iterations", iterations)
	end

	if not node.Data.Metrics.duration then
		visit("duration", duration)
	end

	for unit, value in node.Data.Metrics do
		visit(unit, calculateMetric(value, unit, iterations, duration))
	end
end

-- Calls the given observers with the node's pending data. Unmarks the data as
-- pending.
function Node.Inform(self: Node, result: ResultObserver, metric: MetricObserver)
	for _, node in self.Children do
		node:Inform(result, metric)
	end

	if self.Pending.Result then
		result(self.Path, self.Data.Result)
		self.Pending.Result = false
	end

	if self.Pending.Benchmark or next(self.Pending.Metrics) then
		if self.Pending.Benchmark then
			if not self.Data.Metrics.iterations then
				self.Pending.Metrics.iterations = true
			end

			if not self.Data.Metrics.duration then
				self.Pending.Metrics.duration = true
			end
		end

		buildMetrics(self, function(unit: string, value: number)
			if self.Pending.Metrics[unit] then
				metric(self.Path, unit, value)
			end
		end)

		self.Pending.Benchmark = false
		table.clear(self.Pending.Metrics)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Represents a tree of Runner results and metrics.
local Tree = {}
Tree.__index = Tree

type Tree = {
	-- Encapsulates active state of a Runner.
	Active: {_active: WaitGroup?},
	-- Flat map of paths to nodes.
	Nodes: {[Path]: Node},
	-- The implicit root node.
	Root: Node,

	-- Observes the results of nodes in the tree.
	ResultObserver: ResultObserver?,
	-- Observes the metrics of nodes in the tree.
	MetricObserver: MetricObserver?,

	-- Creates a new node.
	CreateNode: (self: Tree, type: ResultType, parent: Node, key: any) -> Node,

	-- Creates a new node frozen with an error result.
	CreateErrorNode: (self: Tree, type: ResultType, parent: Node, key: any, format: string, ...any) -> Node,

	-- Active deferred maintenance thread. Indicates that the tree contains
	-- pending data.
	MaintenanceThread: thread?,
	-- Reconciles any dirty nodes.
	Maintenance: (self: Tree) -> (),
	-- Mark tree as dirty. At a defer point, the tree will perform maintenance.
	Dirty: (self: Tree) -> (),
	-- Update derivative data.
	ReconcileData: (self: Tree) -> (),
	-- Inform observers of changes.
	InformObservers: (self: Tree) -> (),
	-- Resets node results to pending.
	Reset: (self: Tree) -> (),
}

-- Creates a new Tree witht the given configuration.
local function newTree(): Tree
	local self: Tree = setmetatable({
		Active = nil;
		Nodes = {};
		Root = nil;
		ResultObserver = nil;
		MetricObserver = nil;
		MaintenanceThread = nil;
	}, Tree) :: never
	newNode(self, "node", nil)
	return self
end

-- Creates a new node refered to by *key* under *parent*, or root if *parent* is
-- nil.
function Tree.CreateNode(self: Tree, type: ResultType, parent: Node, key: any): Node
	return newNode(self, type, parent, key)
end

-- Creates a node as usual, but the result is filled in with an error, and the
-- node's data is frozen.
function Tree.CreateErrorNode(self: Tree, type: ResultType, parent: Node, key: any, format: string, ...: any): Node
	local node = self:CreateNode(type, parent, key)
	node:UpdateResult(newResult(node, "errored", string.format(format, ...)))
	table.freeze(node.Data)
	return node
end

-- Reconciles data and informs the configured observers of changed data.
function Tree.Maintenance(self: Tree)
	self:ReconcileData()
	self:InformObservers()
	self.MaintenanceThread = nil
end

-- If the tree is not dirty, marks the tree as dirty, and defers a task that
-- performs maintenance.
function Tree.Dirty(self: Tree)
	if self.MaintenanceThread then
		return
	end

	local thread = task.delay(0, function(this: Tree)
		this:Maintenance()
		if this.Active._active then
			this.Active._active:Finish()
		end
	end, self)

	self.MaintenanceThread = thread
	if self.Active._active then
		self.Active._active:AddThread(thread)
	end
end

-- Reconciles derivative data.
function Tree.ReconcileData(self: Tree)
	self.Root:ReconcileResults()
	self.Root:ReconcileMetrics()
end

local function NoOperation() end

-- Calls the Inform method of each root node with the configured observers.
function Tree.InformObservers(self: Tree)
	local result = self.ResultObserver or NoOperation
	local metric = self.MetricObserver or NoOperation
	self.Root:Inform(result, metric)
end

-- Resets node results to pending. If any maintenance is needed, it is performed
-- immediately.
function Tree.Reset(self: Tree)
	for _, node in self.Nodes do
		if not table.isfrozen(node.Data) then
			node:UpdateResult(newResult(node, "pending", ""))
			for unit, value in node.Data.Metrics do
				node:UpdateMetric(unit, value)
			end
		end
	end

	-- Skip any deferred maintenance.
	if self.MaintenanceThread then
		task.cancel(self.MaintenanceThread)
	end

	self:Maintenance()
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--@sec: T
--@ord: -2
--@def: type T
--@doc: Contains functions used to define a spek.
--
-- These functions are not methods, so its safe to call them as-is. It is also
-- safe to store them in variables for convenience.
--
-- ```lua
-- return function(t: Spek.T)
-- 	local describe = t.describe
-- 	describe "can be stored in a variable" (function()end)
--
-- 	t.describe "or can be called as-is" (function()end)
-- end
-- ```
--
-- ## Statement functions
--
-- Some functions are "Statements". A statement is a function that receives a
-- value of some specified type.
--
-- ```lua
-- return function(t: Spek.T)
-- 	-- A Statement<Closure>, so it is a function that receives a Closure.
-- 	t.beforeEach(function()end)
-- end
-- ```
--
-- Some functions are "Clauses". A Clause can be a regular Statement, or it can
-- be a function that receives a string. If the latter, it returns a Statement.
-- This enables several syntaxes for annotating a function with an optional
-- description:
--
-- ```lua
-- return function(t: Spek.T)
-- 	t.describe "clause with a description" (function()end)
--
-- 	-- Clause without a description.
-- 	t.describe(function()end)
-- end
-- ```
--
-- A Closure is a function that is expected to receive no arguments and return
-- no values. Typically it uses upvalues to further define the spek within the
-- context of the outer function.
--
-- ```lua
-- return function(t: Spek.T)
-- 	t.describe "uses a closure" (function()
-- 		t.it "further defines within this context" (function()end)
-- 	end)
-- end
-- ```
--
-- An Assertion is like a Closure, except that it is expected to return a value
-- to be asserted.
--
-- ```lua
-- return function(t: Spek.T)
-- 	t.it "makes an assertion" (function()
-- 		t.assert "that pi is a number" (function()
-- 			return type(math.pi) == "number"
-- 		end)
-- 	end)
-- end
-- ```
--
-- Certain functions may only be called within certain **contexts**. For
-- example, [expect][T.expect] may only be called while testing, so it should
-- only be called within an [it][T.it] closure. Each description of a function
-- lists which contexts the function is allowed to be called.
--
-- The following contexts are available:
--
-- - **planning**: While processing the current [Plan][Plan].
-- - **testing**: While running a test.
-- - **benchmarking**: While running a benchmark.
--
-- ## Benchmark functions
--
-- The [measure][T.measure] function defines a benchmark.
--
-- ## Units
--
-- While planning, certain functions will produce a **unit**.
--
-- - The [it][T.it] function produces a test unit.
-- - The [measure][T.measure] function produces a benchmark unit.
-- - The [describe][T.describe] function produces an aggregate unit. This runs
--   each sub-unit it contains.
--
-- By default, aggregate units run their sub-units serially. This means that, in
-- turn, all units run serially. This is to ensure that upvalues aren't accessed
-- by more than one unit at the same time.
--
-- The above functions allow the "concurrently" flag to be specified. Doing so
-- will cause the unit to run concurrently with sibling units. This allows a
-- series of independent units to run at the same time rather than sequentially,
-- but care must be taken to ensure that no upvalues are shared with other
-- concurrent units.
--
-- An aggregate unit will wait for all sub-units to complete, whether they're
-- serial or concurrent.
--
-- ```lua
-- return function(t: Spek.T)
-- 	local describe = t.describe
-- 	local it = t.it
-- 	local expect = t.expect
-- 	local concurrently = t.concurrently
--
-- 	-- This context will run concurrently, but its contents still run serially.
-- 	describe "unit that takes 6 seconds to complete" (concurrently) (function()
-- 		it "takes 1 second to complete" (function()
-- 			task.wait(1)
-- 			expect(function()
-- 				return true
-- 			end)
-- 		end)
-- 		it "takes 2 seconds to complete" (function()
-- 			task.wait(2)
-- 			expect(function()
-- 				return true
-- 			end)
-- 		end)
-- 		it "takes 3 seconds to complete" (function()
-- 			task.wait(3)
-- 			expect(function()
-- 				return true
-- 			end)
-- 		end)
-- 	end)
-- 	-- This context will run serially, though it has no serial siblings.
-- 	describe "unit that takes 3 seconds to complete" (function()
-- 		it "takes 1 second to complete" (concurrently) (function()
-- 			task.wait(1)
-- 			expect(function()
-- 				return true
-- 			end)
-- 		end)
-- 		it "takes 2 seconds to complete" (concurrently) (function()
-- 			task.wait(2)
-- 			expect(function()
-- 				return true
-- 			end)
-- 		end)
-- 		it "takes 3 seconds to complete" (concurrently) (function()
-- 			task.wait(3)
-- 			expect(function()
-- 				return true
-- 			end)
-- 		end)
-- 	end)
-- end
-- ```
export type T = {
	--@sec: T.concurrently
	--@def: concurrently: Flag
	--@doc: When passed to a [FlagClause][FlagClause], causes the created unit
	-- to run concurrently with sibling units.
	concurrently: Flag,
	--@sec: T.only
	--@def: only: Flag
	--@doc: When passed to a [FlagClause][FlagClause], causes the created unit
	-- to be among the only units that run.
	only: Flag,
	--@sec: T.skip
	--@def: skip: Flag
	--@doc: When passed to a [FlagClause][FlagClause], causes the created unit
	-- to be skipped.
	skip: Flag,

	--@sec: T.describe
	--@def: describe: FlagClause<Closure>
	--@doc: **While:** planning
	--
	-- Defines a new scope for a test or benchmark. The closure is called
	-- immediately, while planning.
	describe: FlagClause<Closure>,

	--@sec: T.beforeEach
	--@def: beforeEach: Statement<Closure>
	--@doc: **While:** planning
	--
	-- Defines function to call before each unit within the scope. The closure
	-- is called while testing or benchmarking.
	beforeEach: Statement<Closure>,

	--@sec: T.afterEach
	--@def: afterEach: Statement<Closure>
	--@doc: **While:** planning
	--
	-- Defines a function to call after each unit within the scope. The closure
	-- is called while testing or benchmarking.
	afterEach: Statement<Closure>,

	--@sec: T.it
	--@def: it: FlagClause<Closure>
	--@doc: **While:** planning
	--
	-- Defines a new test unit. The closure is called while testing.
	it: FlagClause<Closure>,

	--@sec: T.expect
	--@def: expect: Clause<Assertion>
	--@doc: **While:** testing
	--
	-- Expects the result of an assertion to be truthy. The closure is called
	-- while testing. This function cannot be called within another expect
	-- function.
	expect: Clause<Assertion>,

	--@sec: T.expectError
	--@def: expectError: Clause<Closure>
	--@doc: **While:** testing
	--
	-- Expects the closure to throw an error. The closure is called while
	-- testing. This function cannot be called within another expect function.
	expectError: Clause<Closure>,

	--@sec: T.parameter
	--@def: parameter: ParameterClause
	--@doc: **While:** planning
	--
	-- Defines a parameter symbol that can be passed to [measure][T.measure].
	parameter: ParameterClause,

	--@sec: T.measure
	--@def: measure: BenchmarkClause
	--@doc: **While:** planning
	--
	-- Defines a new benchmark unit. The closure is called while benchmarking.
	measure: BenchmarkClause,

	--@sec: T.operation
	--@def: operation: Statement<Closure>
	--@doc: **While:** benchmarking (only once)
	--
	-- Defines the operation of a benchmark unit that is being measured. This
	-- operation is run repeatedly. The operation is called while benchmarking.
	-- This function must only be called once per benchmark.
	operation: Statement<Closure>,

	--@sec: T.resetTimer
	--@def: resetTimer: () -> ()
	--@doc: **While:** testing, benchmarking
	--
	-- Resets the unit's elapsed time and all metrics. Does not affect whether
	-- the timer is running.
	resetTimer: () -> (),

	--@sec: T.startTimer
	--@def: startTimer: () -> ()
	--@doc: **While:** testing, benchmarking
	--
	-- Starts or resumes the unit timer.
	startTimer: () -> (),

	--@sec: T.stopTimer
	--@def: stopTimer: () -> ()
	--@doc: **While:** testing, benchmarking
	--
	-- Stops the unit timer.
	stopTimer: () -> (),

	--@sec: T.report
	--@def: report: Detailed<number>
	--@doc: **While:** planning, testing, benchmarking
	--
	-- Reports a user-defined metric. Any previously reported value will be
	-- overridden.
	--
	-- The description determines the unit of the reported value, which is
	-- user-defined. If the description has a specific suffix, the value is
	-- altered:
	--
	-- - `/op`: Value is divided by the number of operations performed by the
	--   unit (1 for tests, many for benchmarks).
	-- - `/us`: Value is divided by the number microseconds elapsed during the
	--   unit.
	-- - `/ms`: Value is divided by the number milliseconds elapsed during the
	--   unit.
	-- - `/s`: Value is divided by the number seconds elapsed during the
	--   unit.
	-- - (no suffix): Value is reported as-is.
	--
	-- **Examples:**
	--
	-- ```lua
	-- report "compares" (compares) -- Report value per unit.
	-- report "compares/op" (compares) -- Report value per operation.
	-- report "compares/s" (compares) -- Report value per second.
	-- ```
	report: Detailed<number>,

	--@sec: T.TODO
	--@def: TODO: (format: string?, ...any) -> ()
	--@doc: Produces a passing result, but with a reason indicating that the
	-- plan or statement is not yet implemented. May optionally specify a
	-- formatted message as the reason.
	TODO: (format: string?, ...any) -> (),
}

--@sec: Clause
--@def: type Clause<X> = Statement<X> & Detailed<X>
--@doc: Returns a chain of functions based on received argument type, enabling
-- the following syntax sugars:
--
-- ```lua
-- clause(a)                -- statement
-- clause (description) (x) -- detailed
-- ```
--
-- The statement form is used when the function receives a function. The
-- detailed form is used otherwise. The function cannot receive nil.
export type Clause<X> = Statement<X> & Detailed<X>
export type Statement<X> = (X) -> ()
export type Detailed<X> = (description: string) -> Statement<X>

--@sec: FlagClause
--@def: type FlagClause<X> = Statement<X> & FlagDetailed<X> & Flagged<X>
--@doc: Returns a chain of functions based on received argument type, enabling
-- the following syntax sugars:
--
-- ```lua
-- clause(x)                           -- statement
-- clause (flags...) (x)               -- flagged
-- clause (description) (x)            -- detailed
-- clause (description) (flags...) (x) -- detailed flagged
-- ```
--
-- The statement form is used when the function receives a function. The flagged
-- form is used when the function receives a flag. The function cannot receive
-- nil. Otherwise, the detailed form is used when the second function receives a
-- function. The detailed flagged form is used when the second function receives
-- a flag.
export type FlagClause<X> = Statement<X> & FlagDetailed<X> & Flagged<X>
export type FlagDetailed<X> = (description: string) -> Statement<X> & Flagged<X>
export type Flagged<X> = (...Flag) -> Statement<X>

--@sec: Flag
--@def: type Flag = {type: "flag"}
--@doc: Refers to one of a specific set of values. These values are passed
-- through a [T][T] to be used by a [FlagClause][FlagClause].
--
-- - concurrent: Causes a unit to run concurrently.
-- - only: Causes a unit to be among the only units that run.
-- - skip: Causes a unit to be skipped.
export type Flag = {type: "flag"}

--@sec: Closure
--@def: type Closure = () -> ()
--@doc: A general function operating on upvalues.
export type Closure = () -> ()

--@sec: Assertion
--@def: type Assertion = () -> any
--@doc: Like a [Closure][Closure], except the caller expects a truthy or falsy
-- result. If an optional second value is returned with a falsy result, then it
-- will be used as the reason.
export type Assertion = () -> (any, any?)

--@sec: BenchmarkClause
--@def: type BenchmarkClause = BenchmarkStatement & BenchmarkDetailed & BenchmarkFlagged
--@doc: Variation of [FlagClause][FlagClause] for benchmarks, which receives a
-- [Benchmark][Benchmark] and a variable number of [Parameter][Parameter] or
-- string values. Each string passed adds the benchmark to the category
-- indicated by the value.
--
-- ```lua
-- clause(benchmark, ...Parameter|string)
-- clause (flags...) (benchmark, ...Parameter|string)
-- clause (description) (benchmark, ...Parameter|string)
-- clause (description) (flags...) (benchmark, ...Parameter|string)
-- ```
export type BenchmarkClause = BenchmarkStatement & BenchmarkDetailed & BenchmarkFlagged
export type BenchmarkStatement = (Benchmark, ...Parameter | string) -> ()
export type BenchmarkDetailed = (description: string) -> BenchmarkStatement & BenchmarkFlagged
export type BenchmarkFlagged = (...Flag) -> BenchmarkStatement

--@sec: Benchmark
--@def: type Benchmark = (...any) -> ()
--@doc: Like a [Closure][Closure], but receives values corresponding to the
-- [Parameters][Parameter] passed to [BenchmarkClause][BenchmarkClause].
export type Benchmark = (...any) -> ()

--@sec: ParameterClause
--@def: type ParameterClause = (name: string) -> (...any) -> Parameter
--@doc: Creates an parameter to be passed to a benchmark statement. *name* is
-- the name of the parameter, which is not optional. Each value passed is a
-- "variation" of the parameter to be benchmarked individually.
export type ParameterClause = (name: string) -> (...any) -> Parameter

--@sec: Parameter
--@def: type Parameter = {type: "parameter"}
--@doc: An opaque parameter returned by [T.parameter][T.parameter] to be passed
-- to a [BenchmarkClause][BenchmarkClause].
export type Parameter = {type: "parameter"}

type _Parameter<X> = Parameter & {
	_name: string,
	_variations: {[number]: X, n: number},
}

-- Returns a clause function that can be called in one of two ways:
--
--     clause (closure)
--     clause (description) (closure)
--
-- If called with the non-description form, the description will be nil. If
-- called with the description form, errors if nil is passed as the description.
local function newClause<X>(process: (description: string?, closure: X) -> ()): Clause<X>
	return function(description: any | X): any
		if type(description) == "function" then
			process(nil, description)
			return
		end

		if type(description) == "string" then
			return function(closure: X)
				process(description, closure)
			end
		end

		error(string.format("description must be a string, got %*", typeof(description)), 2)
	end
end

-- Contains flags that have been set on a clause.
type Flags = {
	Concurrent: boolean,
	Only: boolean,
	Skip: boolean,
}

-- Constants representing flags passed to a FlagClause.
local CONCURRENT: Flag = table.freeze({type = "flag", kind = "concurrently"}) :: never
local ONLY: Flag = table.freeze({type = "flag", kind = "only"}) :: never
local SKIP: Flag = table.freeze({type = "flag", kind = "skip"}) :: never

-- Returns whether a value is a valid flag.
local function isFlag(flag: never): boolean
	return flag == CONCURRENT or flag == ONLY or flag == SKIP
end

-- Converts a list of arguments into a Flags.
local function parseFlags(...: unknown): Flags
	local flags = {
		Concurrent = false;
		Only = false;
		Skip = false;
	}

	for index = 1, select("#", ...) do
		local argument = select(index, ...)
		if argument == CONCURRENT then
			flags.Concurrent = true
		elseif argument == ONLY then
			flags.Only = true
		elseif argument == SKIP then
			flags.Skip = true
		else
			error("unknown flag", 3)
		end
	end

	return table.freeze(flags)
end

-- Sets flags on the given node.
local function setFlags(node: Node, flags: Flags)
	if table.isfrozen(node.Data) then
		return
	end

	node.Data.Concurrent = flags.Concurrent
	node.Data.Only = flags.Only
	node.Data.Skip = flags.Skip
end

-- Returns a FlagClause function, where flags can optionally be passed after the
-- description.
--
--     clause (closure)
--     clause (description) (closure)
--     clause (flags...) (closure)
--     clause (description) (flags...) (closure)
--
-- If called with the non-description form, the description will be nil. If
-- called with the description form, errors if nil is passed as the description.
local function newFlagClause<X>(process: (description: string?, flags: Flags, closure: X) -> ()): FlagClause<X>
	return function(...: any): any
		if type((...)) == "string" then
			-- clause (description) ...
			local description = ...
			return function(...: any): Statement<X>?
				if type(...) == "function" then
					-- clause (description) (closure)
					local closure = ... :: X
					process(description, parseFlags(), closure)
					return
				end

				if isFlag(...) then
					-- clause (description) (flags...) (closure)
					local flags = parseFlags(...)
					return function(closure: X)
						process(description, flags, closure)
					end
				end

				error("closure must be a function", 2)
			end
		end

		if type((...)) == "function" then
			-- clause (closure)
			local closure = ...
			process(nil, parseFlags(), closure)
			return
		end

		if isFlag(...) then
			-- clause (flags...) (closure)
			local flags = parseFlags(...)
			return function(closure: X)
				process(nil, flags, closure)
			end
		end

		error(string.format("description must be a string, got %*", typeof((...))), 2)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- Represents the state of a plan. A plan may contain nested scopes, so the
-- plan's state is stacked-based.
type PlanState = {
	-- Stack of nodes.
	Stack: {Node},
	-- Creates a new node as a child of the node at the top of the stack,
	-- referred to using *key*. If *key* is equal to *compare* then the node's
	-- child location is used instead. A Unit of type *type* is set to the
	-- node's data.
	CreateNode: (self: PlanState, node: ResultType, key: any?, flags: Flags, closure: Closure?) -> (),
	-- Returns the node at the top of the stack.
	PeekNode: (self: PlanState) -> Node,
	-- Pop the top node from the stack.
	PopNode: (self: PlanState) -> Node,
}

-- Creates a new PlanState.
local function newPlanState(tree: Tree): PlanState
	local self = {
		Stack = {};
	}

	function self.CreateNode(this: PlanState, node: ResultType, key: any?, flags: Flags, closure: Closure?)
		local parent = this:PeekNode()
		if key == nil then
			-- Unlabeled statement. Use node's predicted location in
			-- parent.
			key = #parent.Children + 1
		end

		local subNode = tree:CreateNode(node, parent, key)
		subNode.Data.Closure = closure
		setFlags(subNode, flags)
		table.insert(this.Stack, subNode)
	end

	function self.PeekNode(this: PlanState): Node
		local stack = this.Stack
		local node = stack[#stack]
		if not node then
			error("empty stack")
		end
		return node
	end

	function self.PopNode(this: PlanState): Node
		local node = table.remove(this.Stack)
		if not node then
			error("empty stack")
		end
		return node
	end

	return self
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--@sec: Runner
--@ord: -1
--@def: type Runner
--@doc: Used to run speks. The results are represented as a tree. Each node in
-- the tree has a key, and can be visited using a path.
--
-- Converting to a string displays formatted results of the latest run. Metrics
-- are tabulated per plan.
--
-- Note that the runner requires spek modules as-is.
local Runner = {}
Runner.__index = Runner

export type Runner = {
	Running: (self: Runner) -> boolean,
	Run: (self: Runner) -> (),
	Start: (self: Runner) -> (),
	Wait: (self: Runner) -> (),
	Stop: (self: Runner) -> (),
	Reset: (self: Runner) -> (),
	Metadata: (self: Runner) -> Metadata,
	StatusCount: (self: Runner) -> {[ResultStatus]: number},
	Root: (self: Runner) -> Path,
	All: (self: Runner) -> {Path},
	Paths: (self: Runner, path: Path) -> {Path}?,
	Category: (self: Runner, ...string?) -> {Path},
	Categories: (self: Runner) -> {string},
	Result: (self: Runner, path: Path) -> Result?,
	Metrics: (self: Runner, path: Path) -> Metrics?,
	TabulateBenchmarks: (self: Runner, path: {Path}?) -> Table?,
	ObserveResult: (self: Runner, observer: ResultObserver) -> () -> (),
	ObserveMetric: (self: Runner, observer: MetricObserver) -> () -> (),
}

type _Runner = Runner & {
	_metadata: Metadata,
	_active: WaitGroup?,
	_tree: Tree,
	_config: Config,
	_resultObservers: {[Unsubscribe]: ResultObserver},
	_metricObservers: {[Unsubscribe]: MetricObserver},
	_start: (self: _Runner) -> WaitGroup,
}

--@sec: Input
--@def: type Input = Plan | ModuleScript | {[any]: Input}
--@doc: Represents a [Plan][Plan], a valid spek ModuleScript, or a tree of such.
-- Inputs produce nodes within a [Runner][Runner]:
--
-- - A table produces a node for each entry.
-- - A spek produces a node for the spek.
-- - A plan does not produce a node, but its content usually does.
-- - Other values produce a node indicating an error.
export type Input = Plan | string | {[any]: Input}
--TODO: Unioned table of union is not analyzed correctly (roblox/luau#664). To
--workaround, cast tables to whatever input types they include.

--@sec: Plan
--@def: type Plan = (t: T) -> ()
--@doc: Receives a [T][T] to plan a testing suite.
export type Plan = (t: T) -> ()

--@sec: Metadata
--@def: type Metadata = {
--	LuaVersion: string,
--	RobloxVersion: string,
--	SpekVersion: string,
--	StartTime: string,
--}
--@doc: Contains metadata for the latest run of a [Runner][Runner].
--
-- The **LuaVersion** field is the version of Lua used for the run, according
-- the `_VERSION` global variable.
--
-- The **RobloxVersion** field is the version of Roblox used for the run,
-- according to the `version` global function. Set to "nil" if the version is
-- not available.
--
-- The **SpekVersion** field is the version of the Spek framework used for the
-- run.
--
-- The **StartTime** field is an ISO 8601 formatted string indicating the
-- starting time of the run in universal time. Note that, if Roblox's DateTime
-- is not available, then local time will be used instead.
export type Metadata = {
	LuaVersion: string,
	RobloxVersion: string,
	SpekVersion: string,
	StartTime: string,
}

local function version()
	return roblox.getReflectionDatabase().Version
end

local function try<T...>(callback: (T...) -> string, ...: T...): string
	local success, result = pcall(callback, ...)
	return if success then result else "nil"
end

local function IsoDate()
	return DateTime.now():toIsoDate()
end

-- Produces Metadata filled with data relevant to the start of a run.
local function startMetadata(): Metadata
	return {
		LuaVersion = tostring(_VERSION);
		RobloxVersion = try(version);
		SpekVersion = tostring(VERSION);
		StartTime = try(function()
			local time = try(IsoDate)
			if time then
				return time
			end

			return os.date("%Y-%m-%dT%H:%M:%S")
		end);
	}
end

-- If a statement description is a string, returns it prefixed with *prefix*.
-- Otherwise, returns it unchanged.
local function wrapDescription<T>(prefix: string, description: T): T
	if type(description) == "string" then
		description = prefix .. " " .. description
	end
	return description
end

-- Sets a context for running a plan.
local function planContext(_contextManager: ContextManager<T>, tree: Tree, parent: Node): (ContextObject) -> ()
	local state = newPlanState(tree)

	-- Use parent node as the root context.
	table.insert(state.Stack, parent)

	return function(contextObject: ContextObject)
		contextObject.describe = newFlagClause(function(description: string?, flags: Flags, closure: Closure)
			-- Run closure using created node as context.
			state:CreateNode("node", description, flags)
			closure()
			state:PopNode()
		end)

		function contextObject.beforeEach(closure: Closure)
			local node = state:PeekNode()
			table.insert(node.Data.Before, closure)
		end

		function contextObject.afterEach(closure: Closure)
			local node = state:PeekNode()
			table.insert(node.Data.After, closure)
		end

		contextObject.it = newFlagClause(function(description: string?, flags: Flags, closure: Closure)
			state:CreateNode("test", description, flags, closure)
			state:PopNode()
		end)

		function contextObject.parameter<X>(name: string): (...X) -> Parameter
			if type(name) ~= "string" then
				error("parameter name must be a string", 2)
			end

			return function(...: X): Parameter
				return table.freeze({
					type = "parameter" :: "parameter";
					_name = name;
					_variations = table.freeze(table.pack(...));
				})
			end
		end

		-- Visit each permutation of parameter variations.
		local function permuteParameters(
			parameters: {_Parameter<never>},
			visit: (...never) -> (),
			n: number?,
			...: never
		)
			local length = n or #parameters
			if length <= 0 then
				visit(...)
			else
				local parameter = parameters[length]
				for _, variation in ipairs(parameter._variations) do
					permuteParameters(parameters, visit, length - 1, variation, ...)
				end
			end
		end

		-- Generates a benchmark unit for each permutation of the given parameters.
		-- If the given description cannot be formatted according to the given
		-- parameters, then only one benchmark is generated.
		local function generateBenchmarks(key: string?, flags: Flags, benchmark: Benchmark, ...: Parameter | string)
			local hasCategories = false
			local categories: {[string]: boolean} = {}
			local parameters: {_Parameter<never>} = {}
			for index = 1, select("#", ...) do
				local argument = select(index, ...)
				if type(argument) == "string" then
					categories[argument] = true
					hasCategories = true
					continue
				end

				if type(argument) == "table" then
					if
						argument.type == "parameter"
						and type(argument._name) == "string"
						and type(argument._variations) == "table"
						and type(argument._variations.n) == "number"
					then
						table.insert(parameters, argument)
					end

					continue
				end

				error(string.format("invalid benchmark parameter #%*", index))
			end

			table.freeze(parameters)

			-- List of first variation of each parameter.
			local firsts: {n: number, [number]: any} = table.create(#parameters) :: never
			for index, parameter in parameters do
				firsts[index] = parameter._variations[1]
			end
			firsts.n = #parameters
			table.freeze(firsts)

			for category in categories do
				-- Value in categories indicates whether category can be used to
				-- format parameters.
				categories[category] = pcall(function()
					local _ = string.format(category :: never, table.unpack(firsts, 1, firsts.n))
				end)
			end
			table.freeze(categories)

			-- Set the categories of the current node in state.
			local function setCategories(...)
				if hasCategories then
					local newCategories: {[string]: true} = {}
					for category, success in categories do
						if success then
							category = string.format(category, ...)
						end

						newCategories[category] = true
					end

					table.freeze(newCategories)
					state:PeekNode().Data.Categories = newCategories
				end
			end

			-- Check whether key can be used to format parameters.
			local success = pcall(function()
				local _ = string.format(key :: never, table.unpack(firsts, 1, firsts.n))
			end)

			if success then
				-- Generate a benchmark for each permutation of parameters.
				permuteParameters(parameters, function(...)
					if not key then
						error("key expected")
					end

					local formatted = string.format(key, ...)
					local values = table.freeze(table.pack(...))
					state:CreateNode("benchmark", formatted, flags, function()
						benchmark(table.unpack(values, 1, values.n))
					end)
					setCategories(...)
					state:PopNode()
				end)
			else
				-- Cannot produce variations of key. Generate only one benchmark
				-- using the first variation of each parameter.
				state:CreateNode("benchmark", key, flags, function()
					benchmark(table.unpack(firsts, 1, firsts.n))
				end)
				setCategories(table.unpack(firsts, 1, firsts.n))
				state:PopNode()
			end
		end

		function contextObject.measure<X...>(...: any): BenchmarkStatement?
			if type((...)) == "string" then
				-- clause (description) ...
				local description = ...
				return function(...: any)
					if type(...) == "function" then
						-- clause (description) (benchmark, parameters...)
						local benchmark = ...
						generateBenchmarks(description, parseFlags(), benchmark, select(2, ...))
					elseif isFlag(...) then
						-- clause (description) (flags...) (benchmark, parameters...)
						local flags = parseFlags(...)
						return function(benchmark: Benchmark, ...: Parameter | string)
							assert(type(benchmark) == "function", "function expected")
							generateBenchmarks(description, flags, benchmark, ...)
						end
					else
						error("closure must be a function", 2)
					end
				end
			end

			if type((...)) == "function" then
				-- clause (benchmark, parameters...)
				local benchmark = ...
				generateBenchmarks(nil, parseFlags(), benchmark, select(2, ...))
				return
			end

			if isFlag(...) then
				-- clause (flags...) (benchmark, parameters...)
				local flags = parseFlags(...)
				return function(benchmark: Benchmark, ...: Parameter | string)
					generateBenchmarks(nil, flags, benchmark, ...)
				end
			end

			error(string.format("description must be a string, got %*", typeof((...))), 2)
		end

		function contextObject.report(unit: string)
			assert(type(unit) == "string", "string expected")
			return function(value: number)
				assert(type(value) == "number", "number expected")
				local node = state:PeekNode()
				node:UpdateMetric(unit, value)
			end
		end

		function contextObject.TODO(format: string?, ...: any)
			local todo = if format == nil then "not implemented" else string.format(format, ...)
			local node = state:PeekNode()
			node:UpdateResult(newResult(node, "TODO", todo))
			table.freeze(node.Data)
		end
	end
end

-- Creates nodes under *parent* according to *input*.
local function processInput(tree: Tree, parent: Node, input: Input)
	if type(input) == "function" then
		-- Assumed to be a plan function.
		local contextManager = newContextManager(
			{
				concurrently = CONCURRENT;
				only = ONLY;
				skip = SKIP;
			},
			"describe",
			"beforeEach",
			"afterEach",
			"it",
			"expect",
			"expectError",
			"parameter",
			"measure",
			"operation",
			"resetTimer",
			"startTimer",
			"stopTimer",
			"report",
			"TODO"
		)
		-- A plan does not produce a node, because there's no reasonable key to
		-- use for it. Instead, the parent node is used. A consequence is that
		-- any input that contains a plan must produce a node in order for the
		-- plan to have something to operate on.
		parent.Data.ContextManager = contextManager
		local context = planContext(contextManager, tree, parent)
		local success, exception
		contextManager:While("planning", context, function()
			-- Generate sub-tree by processing plan provided by plan.
			success, exception = pcall(input :: never, contextManager.Object)
		end)

		if not success then
			-- Create single node representing the error.
			tree:CreateErrorNode("plan", parent, "error while planning", exception)
			return
		end

		if #parent.Children == 0 then
			-- Plan must produce structure.
			tree:CreateErrorNode("plan", parent, "error while planning", "plan produced empty structure")
			return
		end
	elseif type(input) == "string" then -- This is a PATH.
		local inputPath = LuauPath.from(input)
		local key = inputPath:fileName()

		if not key then
			tree:CreateErrorNode("node", parent, inputPath, "invalid path")
			return
		end

		if not PathFileSystem.IsFileSafeSilent(inputPath) then
			tree:CreateErrorNode("node", parent, inputPath, "path does not exist")
			return
		end

		if not IsMatch(IS_SPEK, key) then
			tree:CreateErrorNode("node", parent, key, "spek Name must have \".spek\" suffix")
			return
		end

		local node = tree:CreateNode("node", parent, key)
		local success, inner = pcall(function()
			return require(input) :: never
		end)

		if not success then
			tree:CreateErrorNode("plan", parent, key, inner)
			return
		end

		processInput(tree, node, inner)
	elseif typeof(input) == "Instance" then
		-- A spek always creates a node.
		local key = input.Name
		if not input:IsA("ModuleScript") then
			tree:CreateErrorNode("node", parent, key, "unexpected spek class %q", input.ClassName)
			return
		end

		if not IsMatch(IS_SPEK_ROBLOX, input.Name) then
			tree:CreateErrorNode("node", parent, key, "spek Name must have \".spek\" suffix")
			return
		end

		local node = tree:CreateNode("node", parent, key)
		local success, inner = pcall(require, input)
		if not success then
			tree:CreateErrorNode("plan", parent, key, inner)
			return
		end
		processInput(tree, node, inner)
	elseif type(input) == "table" then
		-- Each element of a table produces a node.
		for key, inner in input do
			local node = tree:CreateNode("node", parent, key)
			processInput(tree, node, inner)
		end
	else
		-- Anything else produces an error node.
		tree:CreateErrorNode("node", parent, "error traversing inputs", "unexpected input type %q", typeof(input))
	end
end

--@sec: Spek.runner
--@def: function Spek.runner(input: Input, config: Config?): Runner
--@doc: Creates a new [Runner][Runner] that runs the given [Input][Input]. An
-- optional [Config][Config] configures how units are run.
function export.runner(input: Input?, config: Config?): Runner
	local tree = newTree()
	local self: _Runner = setmetatable({
		_metadata = startMetadata();
		_active = nil;
		_tree = tree;
		_config = newConfig(config);
		_resultObservers = {};
		_metricObservers = {};
	}, Runner) :: never
	tree.Active = self
	if input ~= nil then
		processInput(tree, tree.Root, input)
	end

	tree.ResultObserver = function(path: Path, result: Result)
		for _, observer in self._resultObservers do
			observer(path, result)
		end
	end

	tree.MetricObserver = function(path: Path, unit: string, value: number)
		for _, observer in self._metricObservers do
			observer(path, unit, value)
		end
	end

	return self
end

local BOLD = Chalk.Bold
local BLUE = Chalk.Blue
local BLUE_BOLD = BLUE .. BOLD
local CYAN = Chalk.Cyan
local CYAN_BOLD = CYAN .. BOLD
local YELLOW = Chalk.Yellow
local MAGENTA = Chalk.Magenta
local GREEN = Chalk.Green
local RED_BOLD = Chalk.Red .. BOLD

-- Writes metadata to a string concatenation.
local function sprintMetadata(self: _Runner, out: {string})
	local meta = self._metadata

	table.insert(out, BOLD("METADATA:"))
	table.insert(out, "- " .. BOLD("lua version") .. ": " .. meta.LuaVersion)
	table.insert(out, "- " .. BOLD("roblox version") .. ": " .. meta.RobloxVersion)
	table.insert(out, "- " .. BOLD("framework version") .. ": " .. meta.SpekVersion)
	table.insert(out, "- " .. BOLD("start time") .. ": " .. meta.StartTime)
	table.insert(out, "")
end

-- Walks a tree to produce formatted results.
local function walkTree(parent: Node, visit: ({node: Node, name: string}) -> (), level: string?)
	local children = table.clone(parent.Children)
	local sorted: {any} = table.create(#children)
	local length = 0

	for _, node in children do
		if node.Data.Result.Status == "skipped" then
			continue
		end

		length += 1
		sorted[length] = node
	end

	for index, node in sorted do
		sorted[index] = {
			name = tostring(node.Path:Base());
			node = node;
		}
	end

	table.sort(sorted, function(a, b)
		return a.name < b.name
	end)

	for index, node in sorted do
		local last = index == length
		local this = if last then "└───" else "├───"
		node.name = if level then level .. this .. node.name else node.name
		visit(node)
		walkTree(node.node, visit, if level then level .. (if last then "    " else "│   ") else "")
	end
end

local RESULT_STATUS_TO_CHALK_STYLER: {[ResultStatus]: Chalk.Styler} = {
	pending = Chalk.Yellow;
	passed = Chalk.Green;
	failed = Chalk.Red;
	errored = Chalk.Red .. Chalk.Bold;
	skipped = Chalk.Yellow .. Chalk.Bold;
	TODO = Chalk.Magenta;
}

-- Writes a result tree to a string concatenation.
local function sprintTree(self: _Runner, out: {string})
	local statusString: {[ResultStatus]: string} = {
		pending = "pend";
		passed = "pass";
		failed = "FAIL";
		errored = "ERR ";
		skipped = "skip";
		TODO = "TODO";
	}

	local nodes = {}
	local nodesLength = 0
	local max = 0

	walkTree(self._tree.Root, function(node: {node: Node, name: string})
		nodesLength += 1
		nodes[nodesLength] = node
		local length = utf8.len(node.name) or #node.name
		if length > max then
			max = length
		end
	end)

	local stat = {}
	local statLength = 0
	local total = 0
	for status: ResultStatus, count in self:StatusCount() do
		if count <= 0 then
			continue
		end

		local styler = RESULT_STATUS_TO_CHALK_STYLER[status]
		if styler then
			status = styler(status) :: ResultStatus
		end

		total += count
		statLength += 1
		stat[statLength] = `{BLUE_BOLD(tostring(count))} {BOLD(status)}`
	end

	table.sort(stat)
	table.insert(out, `overall results: of {BLUE_BOLD(tostring(total))} total, {table.concat(stat, ", ")}`)

	local root = self._tree.Root.Data.Result

	local rootStatus: ResultStatus = root.Status
	local rootStyler = RESULT_STATUS_TO_CHALK_STYLER[rootStatus]

	if rootStatus == "pending" then
		if rootStyler then
			rootStatus = rootStyler(rootStatus) :: ResultStatus
		end
		table.insert(out, `test results: {rootStatus}: {root.Path}`)
	elseif rootStatus == "failed" or rootStatus == "errored" or (rootStatus == "TODO" and root.Reason ~= "") then
		if rootStyler then
			rootStatus = rootStyler(rootStatus) :: ResultStatus
		end
		table.insert(out, `test results: {rootStatus}: {root.Path}: {root.Reason}`)
	else
		if rootStyler then
			rootStatus = rootStyler(rootStatus) :: ResultStatus
		end
		table.insert(out, `test results: {rootStatus}`)
	end

	for _, node in nodes do
		local result = node.node.Data.Result

		local name = node.name

		local status: ResultStatus = result.Status
		local statusValue = statusString[status]
		local styler = RESULT_STATUS_TO_CHALK_STYLER[status]

		if styler then
			statusValue = styler(statusValue)
		end

		table.insert(
			out,
			name
				.. " "
				.. StringRep("…", max - (utf8.len(name) or #name))
				.. " | "
				.. statusValue
				.. " | "
				.. result.Reason
		)
	end
end

-- Writes tabulated benchmark results to a string concatenation.
local function sprintTables(self: _Runner, out: {string})
	local tables = {}
	local tablesLength = 0

	-- Tabulate benchmarks per category.
	local categories = self:Categories()

	-- Adding 1 includes nil, or non-categorized.
	for index = 1, #categories + 1 do
		local category = categories[index]
		local paths = self:Category(category)
		local tabulated = self:TabulateBenchmarks(paths)
		if tabulated then
			tablesLength += 1
			tables[tablesLength] = ""
			if category ~= nil then
				tablesLength += 1
				tables[tablesLength] = `{category}:`
			end

			tablesLength += 1
			tables[tablesLength] = tostring(tabulated)
		end
	end

	if tablesLength > 0 then
		table.insert(out, "benchmark results:")
		table.move(tables, 1, tablesLength, #out + 1, out)
	end
end

-- function Runner.ToString(self: _Runner): string
-- 	local out = {""}

-- 	sprintMetadata(self, out)
-- 	sprintTree(self, out)
-- 	sprintTables(self, out)

-- 	return table.concat(out, "\n")
-- end

-- A readable representation of the runner's results.
function Runner.__tostring(self: _Runner): string
	local out = {""}

	sprintMetadata(self, out)
	sprintTree(self, out)
	sprintTables(self, out)

	return table.concat(out, "\n")
end

-- Metamethods disallow pausing, so this is provided for debugging.
function Runner.String(self: _Runner): string
	local out = {""}

	sprintMetadata(self, out)
	sprintTree(self, out)
	sprintTables(self, out)

	return table.concat(out, "\n")
end

--@sec: Runner.Metadata
--@def: function Runner:Metadata(): Metadata
--@doc: Returns [Metadata][Metadata] for the latest run.
function Runner.Metadata(self: _Runner): Metadata
	return table.freeze(table.clone(self._metadata))
end

--@sec: Runner.StatusCount
--@def: function Runner:StatusCount(): {[ResultStatus]: number}
--@doc: Returns a table containing the number of times each
-- [ResultStatus][ResultStatus] appears.
function Runner.StatusCount(self: _Runner): {[ResultStatus]: number}
	local statuses: {[ResultStatus]: number} = {}
	for _, node in self._tree.Nodes do
		local status: ResultStatus = node.Data.Result.Status
		local count = statuses[status]
		if count then
			statuses[status] = count + 1
		else
			statuses[status] = 1
		end
	end

	return statuses
end

--@sec: Table
--@def: type Table = {
--	Headers: {string},
--	Rows: {{Path|number}},
--}
--@doc: A table of benchmark results. **Headers** contains the name of each
-- column, and **Rows** contains each row. Each row contains cells corresponding
-- to each column.
--
-- The first four columns are reserved for the benchmark name, duration,
-- iterations, and operations per time, respectively. The remaining columns are
-- the union of benchmark metrics in lexicographical order. All cells are
-- numbers, except for the first column, which contains [Paths][Path].
--
-- Converting the table to a string displays a formatted representation.
local Table = {}
-- Table.__index = Table

export type Table = {
	Headers: {string},
	Rows: {{Path | number}},
	-- ToString: (self: Table) -> string,
}

-- Produces a tabulation of the results of *benchmarks*. *timeUnit* specifies
-- the time unit of the derived operations-per-time column.
local function newTable(runner: _Runner, benchmarks: {Node}, timeUnit: "s" | "ms" | "us"?): Table
	assert(#benchmarks > 0, "no benchmarks")

	local benchmarkMetrics = {}
	local metricHeaders = {}
	for _, benchmark in benchmarks do
		local metrics = runner:Metrics(benchmark.Path)
		if not metrics then
			error("unknown path")
		end

		for unit in metrics do
			if unit == "duration" or unit == "iterations" then
				continue
			end

			if not table.find(metricHeaders, unit) then
				table.insert(metricHeaders, unit)
			end
		end

		benchmarkMetrics[benchmark] = metrics
	end

	table.sort(metricHeaders)

	-- Determine operations-per-time column.
	local opPerTime
	if timeUnit then
		opPerTime = "op/" .. timeUnit
	else
		local FACTOR = 1000
		-- Ordered by decreasing magnitude by FACTOR, starting at 1.
		local units = {"s", "ms", "us"}
		-- Tally number of values that fit each unit.
		local tally = table.create(#units, 0)
		for _, metrics in benchmarkMetrics do
			local value = metrics.iterations / metrics.duration
			-- Selects the magnitude that best fits the calculated value between
			-- 0 and FACTOR.
			local index
			if value == value then
				local magnitude = math.modf(math.log(value, FACTOR))
				index = math.clamp(magnitude + 1, 1, #units)
			else
				index = 1
			end

			tally[index] += 1
		end

		-- Select unit with greatest number of fitting values, preferring the
		-- larget unit.
		local max = -1
		local foundIndex = 0
		for index, count in tally do
			if count > max then
				max = count
				foundIndex = index
			end
		end
		opPerTime = "op/" .. units[foundIndex]
	end

	-- Build headers.
	local headers = {"benchmark", "duration", "iterations", opPerTime}
	for _, unit in metricHeaders do
		table.insert(headers, unit)
	end
	table.freeze(headers)

	-- Build rows.
	local rows = {}
	for _, benchmark in benchmarks do
		local row: {Path | number} = table.create(#headers, 0)
		local metrics = benchmarkMetrics[benchmark]
		row[1] = benchmark.Path
		row[2] = metrics.duration
		row[3] = metrics.iterations
		row[4] = calculateMetric(metrics.iterations, opPerTime, metrics.iterations, metrics.duration)
		for index, unit in metricHeaders do
			row[4 + index] = metrics[unit]
		end

		table.freeze(row)
		table.insert(rows, row)
	end
	table.freeze(rows)

	-- Build table.
	local self: Table = setmetatable({
		Headers = headers;
		Rows = rows;
	}, Table) :: never

	return table.freeze(self)
end

local function SizeOf(value: string)
	return utf8.len(value) or #value
end
-- A readable representation of the table.
function Table.__tostring(self: Table): string
	local out = {}

	--TODO: character-based width.
	local headers = table.clone(self.Headers)
	local headersSize = #headers

	local widths = table.create(headersSize, 0)
	local alignment = table.create(headersSize, 0)
	for index, header in headers do
		local asString = tostring(header)
		local length = SizeOf(asString)

		if length > widths[index] then
			widths[index] = length
		end
	end

	local formatRows = table.create(#self.Rows)
	for index, row in self.Rows do
		local formatRow = table.create(headersSize, "")
		for jndex = 2, #row do
			local rowString = tostring(row[jndex])
			local startIndex = string.find(rowString, ".", 1, true) or SizeOf(rowString) + 1
			if startIndex > alignment[jndex] then
				alignment[jndex] = startIndex
			end
		end

		for jndex, cell in row do
			local cellRow = tostring(cell)

			if jndex > 1 then
				local startIndex = string.find(cellRow, ".", 1, true) or SizeOf(cellRow) + 1
				cellRow = StringRep(" ", alignment[jndex] - startIndex) .. cellRow
			end

			local cellRowLength = SizeOf(cellRow)
			if cellRowLength > widths[jndex] then
				widths[jndex] = cellRowLength
			end

			formatRow[jndex] = cellRow
		end

		formatRows[index] = formatRow
	end

	local rowFormatValues = table.create(#widths)
	for index, width in widths do
		rowFormatValues[index] = `%-{width}s`
	end

	local rowFormat = `| {table.concat(rowFormatValues, " | ")} |`
	local rowFormatGeneric = `| {table.concat(table.create(#widths, "%*"), " | ")} |`
	out[1] = string.format(rowFormat, table.unpack(headers))

	local newHeaders = table.create(#widths)
	for index, width in widths do
		newHeaders[index] = StringRep("-", width)
	end

	out[2] = string.format(string.gsub(rowFormat, " ", "-"), table.unpack(newHeaders))
	for index, formatRow in formatRows do
		local newFormatRow = table.create(#formatRow)
		for jndex, cellRow in formatRow do
			local header = headers[jndex]
			local rowFormatValue = rowFormatValues[jndex]

			if header then
				if header == "duration" then
					cellRow = YELLOW(string.format(rowFormatValue, cellRow))
				elseif header == "iterations" then
					cellRow = CYAN(string.format(rowFormatValue, cellRow))
				elseif string.find(header, "op", 1, true) then
					cellRow = MAGENTA(string.format(rowFormatValue, cellRow))
				elseif header == "benchmark" then
					local indexValue, name, description = string.match(cellRow, "%[(%d+)%]%[(.*)%]%[(.*)%]")
					if indexValue and name and description then
						local currentWidth = string.match(rowFormatValue, "%-(%d+)s")
						if not currentWidth then
							continue
						end

						local asNumber = tonumber(currentWidth)
						if not asNumber then
							continue
						end

						local colorified =
							string.format("[%*][%*][%*]", GREEN(indexValue), CYAN_BOLD(name), RED_BOLD(description))

						cellRow = Fmt(
							string.format(
								"{:%*}",
								(asNumber - SizeOf(ReplaceAll(MATCH_CHALK, colorified, ""))) + SizeOf(colorified)
							),
							colorified
						)
					end
				end
			end

			newFormatRow[jndex] = cellRow
		end

		out[index + 2] = string.format(rowFormatGeneric, table.unpack(newFormatRow))
	end

	return table.concat(out, "\n")
end

-- Recursively finds benchmark nodes under *node* and inserts them into
-- *benchmarks*.
local function findBenchmarks(benchmarks: {[Node]: true}, node: Node)
	if node.Type == "benchmark" then
		benchmarks[node] = true
	else
		for _, child in node.Children do
			findBenchmarks(benchmarks, child)
		end
	end
end

--@sec: Runner.TabulateBenchmarks
--@def: function Runner:TabulateBenchmarks(paths: {Path}?, timeUnit: "s"|"ms"|"us"?): Table
--@doc: Returns a [Table][Table] tabulating all benchmarks in *paths*, or the
-- root if unspecified. For branch nodes, all benchmark descendant nodes are
-- included. Returns nil if *path* contains no benchmarks.
--
-- If *timeUnit* is specified, it sets the time unit of the operations-per-time
-- column. If unspecified, the unit is determined by what best fits the data.
--
-- - `s`: Seconds.
-- - `ms` Milliseconds.
-- - `us`: Microseconds.
--
function Runner.TabulateBenchmarks(self: _Runner, paths: {Path}?, timeUnit: "s" | "ms" | "us"?): Table?
	local benchmarks = {}
	for _, path in (paths or {self._tree.Root.Path}) :: never do
		findBenchmarks(benchmarks, self._tree.Nodes[path])
	end

	local list = {}
	local length = 0
	for node in benchmarks do
		length += 1
		list[length] = node
	end

	if length == 0 then
		return nil
	end

	table.sort(list, function(a: any, b: any): boolean
		return a.Path._string < b.Path._string
	end)

	return newTable(self, list, timeUnit)
end

-- Accumulate all before and after functions to run around the test.
local function gatherEnvironment(node: Node?, befores: {Closure}, afters: {Closure})
	-- Only walk back to nearest plan node. plan will not contain other plans, so
	-- it wont ever stop too early.
	if node and node.Type ~= "plan" then
		gatherEnvironment(node.Parent, befores, afters)

		local before = node.Data.Before
		table.move(before, 1, #before, #befores + 1, befores)

		local after = node.Data.After
		table.move(after, 1, #after, #afters + 1, afters)
	end
end

-- Runs the closure of *node*, which is assumed to operate on *state*.
-- Afterwards, propagates the data in *state* to the node.
local function runUnit(node: Node, state: UnitState)
	local closure = node.Data.Closure
	if not closure then
		error("unit node must have closure")
	end

	local befores, afters = {}, {}
	gatherEnvironment(node, befores, afters)

	local result: Result? = nil;
	(function()
		for _, before in befores do
			local beforeSuccess, beforeException = pcall(before :: never)
			if not beforeSuccess then
				--TODO: add context to error
				result = newResult(node, "failed", beforeException)
				-- Exit early; errors occurring before are considered fatal.
				return
			end
		end

		local closureSuccess, closureException = pcall(closure :: never)
		if not closureSuccess then
			--TODO: add context to error

			-- Don't override existing result, which is likely the result of a
			-- failed expectation, and the error is the result of being in an
			-- unexpected state.
			if not result then
				result = newResult(node, "failed", closureException)
			end
			-- Run afters even if test fails.
		end

		for _, after in afters do
			local afterSuccess, afterException = pcall(after :: never)
			if not afterSuccess then
				--TODO: add context to error
				if not result then
					result = newResult(node, "failed", afterException)
				end

				-- Override and exit early; errors occurring after are considered
				-- fatal and more significant, given that they are a problem with
				-- the plan itself.
				return
			end
		end
	end)()

	if result == nil then
		result = state.Result
	end

	if result == nil then
		if node.Type == "test" and not state.Expected then
			result = newResult(node, "failed", "test must have at least one expectation")
		elseif node.Type == "benchmark" and not state.Operated then
			result = newResult(node, "failed", "benchmark must have one operation")
		end
	end

	if result == nil then
		node:UpdateResult(newResult(node, "passed", ""))
	else
		node:UpdateResult(result)
	end

	node:UpdateBenchmark(state.Iterations, state.Duration)
	for unit, value in state.Metrics do
		node:UpdateMetric(unit, value)
	end
end

-- Contains the state of a running unit.
type UnitState = {
	Timing: boolean, -- Whether time measurement is active.
	Duration: number, -- Accumulated time measurement.
	StartTime: number, -- Last time the clock was updated.
	Result: Result?, -- Nil indicates passing, or no error.
	Iterations: number, -- Number of iterations of the unit.
	Metrics: Metrics, -- Reported metrics.

	Expected: boolean, -- Whether a test called an expectation.
	Operated: boolean, -- Whether a benchmark called an operation.
}

-- Creates a new UnitState.
local function newUnitState(): UnitState
	return {
		Timing = false;
		Duration = 0;
		StartTime = 0;
		Result = nil;
		Iterations = 0;
		Metrics = {};
		Expected = false;
		Operated = false;
	}
end

-- Runs the closure of *node* as a test unit using *ctxm* to provide context.
local function runTest(node: Node, contextManager: ContextManager<T>)
	local state = newUnitState()
	state.Iterations = 1
	local expecting = false
	local function context(contextObject: ContextObject)
		contextObject.expect = newClause(function(description: string?, assertion: Assertion)
			state.Expected = true
			if expecting then
				state.Result = newResult(node, "failed", "cannot expect within expect")
				return
			end

			expecting = true
			if state.Result then
				expecting = false
				return
			end

			local ok, result, reason = pcall(assertion)
			if state.Result then
				-- In case of inner expect.
				expecting = false
				return
			end

			if ok then
				if result then
					-- Nil state result indicates passing result.
					do
					end
				elseif reason ~= nil then
					state.Result = newResult(node, "failed", tostring(reason))
				elseif description ~= nil then
					state.Result = newResult(node, "failed", wrapDescription("expect", description))
				else
					state.Result = newResult(node, "failed", "expectation failed")
				end
			else
				state.Result = newResult(node, "failed", result)
			end

			expecting = false
		end)

		contextObject.expectError = newClause(function(description: string?, closure: Closure)
			state.Expected = true
			if expecting then
				state.Result = newResult(node, "failed", "cannot expect within expect")
				return
			end

			expecting = true
			local ok, err = pcall(closure :: never)
			if state.Result then
				-- In case of inner expect.
				expecting = false
				return
			end

			if contextManager:Errored() then
				-- If expectError calls an invalid function, that counts as an
				-- unexpected error.
				state.Result = newResult(node, "failed", err)
			elseif ok then
				local reason
				if description == nil then
					reason = "expect error"
				else
					reason = wrapDescription("expect error", description)
				end

				state.Result = newResult(node, "failed", reason)
			end

			expecting = false
		end)

		function contextObject.resetTimer()
			state.Duration = 0
			if state.Timing then
				state.StartTime = os.clock()
			end
		end

		function contextObject.startTimer()
			if not state.Timing then
				state.Timing = true
				state.StartTime = os.clock()
			end
		end

		function contextObject.stopTimer()
			if state.Timing then
				local currentTime = os.clock()
				state.Duration += currentTime - state.StartTime
				state.Timing = false
			end
		end

		function contextObject.report(unit: string)
			assert(type(unit) == "string", "string expected")
			return function(value: number)
				assert(type(value) == "number", "number expected")
				state.Metrics[unit] = value
			end
		end

		function contextObject.TODO(format: string?, ...: any)
			local todo = if format == nil then "not implemented" else string.format(format, ...)
			state.Result = newResult(node, "TODO", todo)
		end
	end

	contextManager:While("testing", context, function()
		runUnit(node, state)
	end)
end

-- Runs the closure of *node* as a benchmark unit using *ctxm* to provide
-- context.
local function runBenchmark(node: Node, contextManager: ContextManager<T>, config: Config)
	local state = newUnitState()
	local function context(contextObject: ContextObject)
		function contextObject.operation(closure: Closure)
			if state.Operated then
				state.Result = newResult(node, "failed", "multiple operations per measure")
				return
			end
			state.Operated = true
			-- Do all work within pcall so that slow pcall is called once per
			-- benchmark instead of once per operation.
			local success, exception = pcall(function() --TODO: use xpcall to acquire trace
				--TODO: Script can be timed out by Studio.ScriptTimeoutLength.
				--If we're allowed to read settings(), insert yields required to
				--keep time just under configured timeout.
				--
				--If setting is zero or inaccessible, perform with default yield
				--frequency to give user chance to cancel out of a large target
				--duration.
				--
				--NOTE: With parallel runs, Actors require syncing each frame,
				--so durations have to be limited to framerate.
				local DEFAULT_DURATION = 1
				local iterations = config.Iterations or 0
				state.Duration = 0
				if iterations > 0 then
					-- Run configured number of iterations.
					for _ = 1, iterations do
						state.Timing = true
						state.StartTime = os.clock()
						closure()
						local currentTime = os.clock()
						state.Duration += currentTime - state.StartTime
					end

					state.Timing = false
					state.Iterations = iterations
				else
					-- Run for configured duration.
					local targetD = config.Duration or DEFAULT_DURATION
					while state.Duration < targetD do
						state.Iterations += 1
						state.Timing = true
						state.StartTime = os.clock()
						closure()
						local currentTime = os.clock()
						state.Duration += currentTime - state.StartTime
					end

					state.Timing = false
				end
			end)

			if not success then
				state.Result = newResult(node, "failed", exception)
			end
		end

		function contextObject.resetTimer()
			state.Duration = 0
			if state.Timing then
				state.StartTime = os.clock()
			end
		end

		function contextObject.startTimer()
			if not state.Timing then
				state.Timing = true
				state.StartTime = os.clock()
			end
		end

		function contextObject.stopTimer()
			if state.Timing then
				local currentTime = os.clock()
				state.Duration += currentTime - state.StartTime
				state.Timing = false
			end
		end

		function contextObject.report(unit: string)
			assert(type(unit) == "string", "string expected")
			return function(value: number)
				assert(type(value) == "number", "number expected")
				state.Metrics[unit] = value
			end
		end

		function contextObject.TODO(format: string?, ...: any)
			local todo = if format == nil then "not implemented" else string.format(format, ...)
			state.Result = newResult(node, "TODO", todo)
		end
	end

	contextManager:While("benchmarking", context, function()
		runUnit(node, state)
		task.wait()
	end)
end

-- Set result status of all descendants to skipped.
local function skipNodes(node: Node)
	node:UpdateResult(newResult(node, "skipped", ""))
	for _, child in node.Children do
		skipNodes(child)
	end
end

-- Runs each unit in *node*. *outer* is an outer WaitGroup to which an inner
-- WaitGroup may be added. *ctxm* is passed down to children nodes. If
-- *onlyMode* is true, then leaf units do not run by default.
local function runUnits(
	self: _Runner,
	node: Node,
	outer: WaitGroup,
	onlyMode: boolean,
	contextManager: ContextManager<T>?
)
	if node.Data.Skip then
		skipNodes(node)
		return
	end

	-- Whether to skip leaf unit. Also used for branch units: if branch unit has
	-- Only flag set while onlyMode is on, then it will run as though onlyMode
	-- is off, causing all descendant leaf units to run. Otherwise, it will run
	-- while passing state of onlyMode.
	local skip = onlyMode and not node.Data.Only

	-- Leaf units can be called directly. We may be inside a serial unit, where
	-- an error in one unit would prevent subsequent units from running, but the
	-- only potential errors are non-userspace.
	if node.Type == "test" then
		if skip then
			node:UpdateResult(newResult(node, "skipped", ""))
			return
		end

		if not contextManager then
			error("missing thread context")
		end

		runTest(node, contextManager)
		return
	elseif node.Type == "benchmark" then
		if skip then
			node:UpdateResult(newResult(node, "skipped", ""))
			return
		end

		if not contextManager then
			error("missing thread context")
		end

		runBenchmark(node, contextManager, self._config)
		return
	end

	-- Branch unit.

	if #node.Children == 0 and skip then
		-- Empty non-leaf node in only-mode. Ensure it is skipped.
		node:UpdateResult(newResult(node, "skipped", ""))
		return
	end

	-- Pass context manager to children, if available.
	if node.Data.ContextManager and contextManager then
		error("nested context managers")
	end

	contextManager = node.Data.ContextManager or contextManager

	-- Divide children into serial and concurrent units.
	local serial = {}
	local concurrent = {}
	for _, child in node.Children do
		if child.Data.Concurrent then
			table.insert(concurrent, child)
		else
			table.insert(serial, child)
		end
	end

	-- Represents lifetime of children units.
	local inner = newWaitGroup()

	-- Add serial units as one dependency.
	inner:Add(function(otherSerial: {Node}, otherContextManager: ContextManager<T>?)
		for _, child in otherSerial do
			runUnits(self, child, inner, skip, otherContextManager)
		end
	end, serial, contextManager)

	-- Add each concurrent unit individually.
	for _, child in concurrent do
		inner:Add(runUnits, self, child, inner, skip, contextManager)
	end

	-- Add inner as dependency of outer.
	outer:AddWaitGroup(inner)
end

-- Begins a new run, visiting each node and running its unit.
function Runner._start(self: _Runner): WaitGroup
	self._metadata = startMetadata()
	self._tree:Reset()

	-- Represents lifetime of entire run.
	local waitGroup = newWaitGroup(function(internalWaitGroup)
		self._tree:Maintenance()
		if self._active == internalWaitGroup then
			self._active = nil
		end
	end)
	self._active = waitGroup

	if self._tree.MaintenanceThread then
		waitGroup:AddThread(self._tree.MaintenanceThread)
	end

	-- Determine whether there are any nodes that have Only flag set.
	local only = false
	for _, node in self._tree.Nodes do
		only = only or (not not node.Data.Only and not node.Data.Skip)
		if only then
			break
		end
	end

	runUnits(self, self._tree.Root, waitGroup, only)

	return waitGroup
end

--@sec: Runner.Running
--@def: function Runner:Running(): boolean
--@doc: Returns whether the runner is currently active.
function Runner.Running(self: _Runner): boolean
	return not not self._active
end

--@sec: Runner.Run
--@def: function Runner:Run()
--@doc: Runs the spek and waits for it to complete. Errors if the runner is
-- already active.
function Runner.Run(self: _Runner)
	if self._active then
		error("runner is already active", 2)
	end

	self:_start():Wait()
end

--@sec: Runner.Start
--@def: function Runner:Start()
--@doc: Begins running spek without waiting for it to complete. Errors if the
-- runner is already active.
function Runner.Start(self: _Runner)
	if self._active then
		error("runner is already active", 2)
	end

	self:_start()
end

--@sec: Runner.Wait
--@def: function Runner:Wait()
--@doc: Waits for the runner to complete. Does nothing if the runner is not
-- active.
function Runner.Wait(self: _Runner)
	if self._active then
		self._active:Wait()
	end
end

--@sec: Runner.Stop
--@def: function Runner:Stop()
--@doc: Stops the runner, canceling all pending units. Does nothing if the
-- runner is not running.
function Runner.Stop(self: _Runner)
	if self._active then
		self._active:Cancel()
	end
end

--@sec: Runner.Reset
--@def: function Runner:Reset()
--@doc: Clears all results.
function Runner.Reset(self: _Runner)
	self._tree:Reset()
end

--@sec: Runner.Root
--@def: function Runner:Root(): Path
--@doc: Returns the [Path][Path] of the root node. The path contains zero
-- elements.
function Runner.Root(self: _Runner): Path
	return self._tree.Root.Path
end

--@sec: Runner.All
--@def: function Runner:All(): {Path}
--@doc: Returns a list of all paths in the runner. Paths are sorted by their
-- string representation.
function Runner.All(self: _Runner): {Path}
	local paths = {}
	local length = 0
	for path in self._tree.Nodes do
		length += 1
		paths[length] = path
	end

	table.sort(paths, function(a: any, b: any): boolean
		return a._string < b._string
	end)

	return paths
end

--@sec: Runner.Paths
--@def: function Runner:Paths(path: Path): {Path}?
--@doc: Returns paths of nodes that exist under the node of *path*. Returns nil
-- if *path* does not exist.
function Runner.Paths(self: _Runner, path: Path): {Path}?
	assert(path, "path expected")
	local node = self._tree.Nodes[path]

	if node then
		local children = node.Children
		local paths = table.create(#children)
		for index, child in children do
			paths[index] = child.Path
		end

		return paths
	end

	return nil
end

--@sec: Runner.Category
--@def: function Runner:Category(self: _Runner, ...: string?): {Path}
--@doc: Returns the paths of nodes matching any of the given categories. Nil
-- matches nodes that have no category.
function Runner.Category(self: _Runner, ...: string?): {Path}
	local selection = {}
	for path in self._tree.Nodes do
		local node = self._tree.Nodes[path]
		for index = 1, select("#", ...) do
			local category = select(index, ...)
			if category == nil then
				if not node.Data.Categories and node:IsLeaf() then
					selection[path] = true
				end
			elseif node.Data.Categories and node.Data.Categories[category] then
				selection[path] = true
			end
		end
	end

	local paths = {}
	local length = 0
	for path in selection do
		length += 1
		paths[length] = path
	end

	table.sort(paths, function(a: any, b: any): boolean
		return a._string < b._string
	end)

	return paths
end

--@sec: Runner.Categories
--@def: function Runner:Categories(self: _Runner): {Path}
--@doc: Returns a list of category names.
function Runner.Categories(self: _Runner): {string}
	local selection = {}
	for path in self._tree.Nodes do
		local node = self._tree.Nodes[path]
		if node.Data.Categories then
			for category in node.Data.Categories do
				selection[category] = true
			end
		end
	end

	local categories = {}
	local length = 0
	for category in selection do
		length += 1
		categories[length] = category
	end

	table.sort(categories)
	return categories
end

--@sec: Runner.Result
--@def: function Runner:Result(path: Path): Result?
--@doc: Returns the current [result][Result] at *path*. Returns nil if *path*
-- does not exist or does not have a result.
function Runner.Result(self: _Runner, path: Path): Result?
	local node = self._tree.Nodes[path]
	if not node then
		return nil
	end

	return node.Data.Result
end

--@sec: Runner.Metrics
--@def: function Runner:Metrics(path: Path): Metrics?
--@doc: Returns a snapshot of the [metrics][Metrics] at *path*. Returns nil if
-- *path* does not exist or does not have a result.
function Runner.Metrics(self: _Runner, path: Path): Metrics?
	local node = self._tree.Nodes[path]
	if not node then
		return nil
	end

	local metrics = {}
	buildMetrics(node, function(unit: string, value: number)
		metrics[unit] = value
	end)

	return metrics
end

--@sec: ResultObserver
--@def: type ResultObserver = (path: Path, result: Result) -> ()
--@doc: Observes the result of *path*.
export type ResultObserver = (path: Path, result: Result) -> ()

--@sec: MetricObserver
--@def: type MetricObserver = (path: Path, unit: string, value: number) -> ()
--@doc: Observes metric *unit* of *path*.
export type MetricObserver = (path: Path, unit: string, value: number) -> ()

--@sec: Unsubscribe
--@def: type Unsubscribe = () -> ()
--@doc: Causes the associated observer to stop observing when called.
export type Unsubscribe = () -> ()

--@sec: Runner.ObserveResult
--@def: function Runner:ObserveResult(observer: ResultObserver): Unsubscribe
--@doc: Sets an observer to be called whenever a result changes. Returns a
-- function that removes the observer when called.
function Runner.ObserveResult(self: _Runner, observer: ResultObserver): Unsubscribe
	local function unsubscribe()
		self._resultObservers[unsubscribe] = nil
	end

	self._resultObservers[unsubscribe] = observer
	for path, node in self._tree.Nodes do
		observer(path, node.Data.Result)
	end

	return unsubscribe
end

--@sec: Runner.ObserveMetric
--@def: function Runner:ObserveMetric(observer: MetricObserver): Unsubscribe
--@doc: Sets an observer to be called whenever a single metric changes. Returns
-- a function that removes the observer when called.
function Runner.ObserveMetric(self: _Runner, observer: MetricObserver): Unsubscribe
	local function unsubscribe()
		self._metricObservers[unsubscribe] = nil
	end

	self._metricObservers[unsubscribe] = observer
	for _, node in self._tree.Nodes do
		buildMetrics(node, function(unit: string, value: number)
			observer(node.Path, unit, value)
		end)
	end

	return unsubscribe
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function AsPathToString(asPath: PathFileSystem.AsPath): string
	if type(asPath) == "string" then
		return asPath
	end

	return LuauPath.from(asPath):toString()
end

--[=[
	Locates speks under a given path.
	@param root Components | Path | string -- The path to search.
	@return {string} -- The paths of the found speks.
]=]
function export.find(root: PathFileSystem.AsPath): {string}
	local speks: {string} = {}
	local length = 0

	for _, fileInstance in FileInstance.Mark(AsPathToString(root)):GetDescendants() do
		local descendant = fileInstance:GetFullName()
		if PathFileSystem.IsFileSafeSilent(descendant) then
			if not IsMatch(IS_SPEK, descendant) then
				continue
			end
			length += 1
			speks[length] = descendant
		end
	end

	return speks
end

-- function export.find(root: Instance): {ModuleScript}
-- 	local speks: {ModuleScript} = {}
-- 	for _, desc in root:GetDescendants() do
-- 		if desc:IsA("ModuleScript") then
-- 			if not desc.Name:match("%.spek$") then
-- 				continue
-- 			end
-- 			table.insert(speks, desc)
-- 		end
-- 	end
-- 	return speks
-- end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--[=[
	A [semver](https://semver.org/)-formatted string indicating the version of
	the Spek module. [Runner]s include the version when displaying results to
	encourage the fair comparison of benchmarks.
]=]
export.version = VERSION

return table.freeze(export)
