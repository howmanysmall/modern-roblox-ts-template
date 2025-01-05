--!optimize 2
--!strict

local ThreadUtilities = require("@utilities/ThreadUtilities")
local task = require("@lune/task")

-- --------------------------------------------------------------------------------------------------------
--               Batched Yield-Safe Signal Implementation                                                --
-- This is a Signal class which has effectively identical behavior to a                                  --
-- normal RBXScriptSignal, with the only difference being a couple extra                                 --
-- stack frames at the bottom of the stack trace when an error is thrown.                                --
-- This implementation caches runner coroutines, so the ability to yield in                              --
-- the signal handlers comes at minimal extra cost over a naive signal                                   --
-- implementation that either always or never spawns a thread.                                           --
--                                                                                                       --
-- API:                                                                                                  --
--   local Signal = require(THIS MODULE)                                                                 --
--   local sig = Signal.new()                                                                            --
--   local connection = sig:Connect(function(arg1, arg2, ...) ... end)                                   --
--   sig:Fire(arg1, arg2, ...)                                                                           --
--   connection:Disconnect()                                                                             --
--   sig:DisconnectAll()                                                                                 --
--   local arg1, arg2, ... = sig:Wait()                                                                  --
--                                                                                                       --
-- License:                                                                                              --
--   Licensed under the MIT license.                                                                     --
--                                                                                                       --
-- Authors:                                                                                              --
--   stravant - July 31st, 2021 - Created the file.                                                      --
--   sleitnick - August 3rd, 2021 - Modified for Knit.                                                   --
--   HowManySmall - July 30th, 2024 - Added several new features and strict mode.                        --
-- --------------------------------------------------------------------------------------------------------

-- The currently idle thread to run the next handler on
local FreeRunnerThread: thread? = nil

-- Function which acquires the currently idle handler runner thread, runs the
-- function fn on it, and then releases the thread, returning it to being the
-- currently idle one.
-- If there was a currently idle runner thread already, that's okay, that old
-- one will just get thrown and eventually GCed.
local function AcquireRunnerThreadAndCallEventHandler<Arguments...>(callback: (Arguments...) -> (), ...: Arguments...)
	local acquiredRunnerThread = FreeRunnerThread
	FreeRunnerThread = nil
	callback(...)
	-- The handler finished running, this runner thread is free again.
	FreeRunnerThread = acquiredRunnerThread
end

-- Coroutine runner that we create coroutines of. The coroutine can be
-- repeatedly resumed with functions to run followed by the argument to run
-- them with.
local function RunEventHandlerInFreeThread<Arguments...>(callback: (Arguments...) -> (), ...: Arguments...)
	AcquireRunnerThreadAndCallEventHandler(callback, ...)
	while true do
		AcquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

--[=[
	Represents a connection to a signal.

	```lua
	local connection = signal:Connect(function() end)
	print(connection.Connected) --> true
	connection:Disconnect()
	print(connection.Connected) --> false
	```

	@interface Connection
	@field Connected boolean
	@field Disconnect (self: Connection) -> ()
	@field Destroy (self: Connection) -> ()
	@field disconnect (self: Connection) -> ()
	@within Signal
]=]

type Connectable<Function, Arguments...> = {
	Connect: (self: Connectable<Function, Arguments...>, callback: Function) -> RBXScriptConnection,
}
type RbxScriptSignal<Function, Arguments...> = RBXScriptSignal & Connectable<Function, Arguments...>

export type Connection = {
	Connected: boolean,

	Disconnect: (self: Connection) -> (),
	Destroy: (self: Connection) -> (),
	disconnect: (self: Connection) -> (),
}
type ConnectionPrivate<Function, Arguments...> = {
	Connected: boolean,

	Function: Function,
	Next: ConnectionPrivate<Function, Arguments...>?,
	Signal: Private<Function, Arguments...>,

	Disconnect: (self: ConnectionPrivate<Function, Arguments...>) -> (),
	Destroy: (self: ConnectionPrivate<Function, Arguments...>) -> (),
	disconnect: (self: ConnectionPrivate<Function, Arguments...>) -> (),
}
type ConnectionStatic = {
	ClassName: "Connection",
	new: <Function, Arguments...>(signal: Private<Function, Arguments...>, callback: Function) -> Connection,
}
type ConnectionStaticPrivate = ConnectionStatic & {__tostring: (self: Connection) -> string}

type Private<Function, Arguments...> = {
	DebugMode: boolean,

	HandlerListHead: ConnectionPrivate<Function, Arguments...>?,
	ProxyHandler: RBXScriptConnection?,
	YieldedThreads: {[thread]: true}?,

	Connect: (self: Private<Function, Arguments...>, callback: Function) -> Connection,
	Once: (self: Private<Function, Arguments...>, callback: Function) -> Connection,
	ConnectOnce: (self: Private<Function, Arguments...>, callback: Function) -> Connection,

	ConnectClassic: (self: Private<Function, Arguments...>, callback: Function) -> RBXScriptConnection,
	OnceClassic: (self: Private<Function, Arguments...>, callback: Function) -> RBXScriptConnection,
	ConnectOnceClassic: (self: Private<Function, Arguments...>, callback: Function) -> RBXScriptConnection,

	GetConnections: (self: Private<Function, Arguments...>) -> {Connection},
	IsConnectedTo: (self: Private<Function, Arguments...>) -> boolean,

	Fire: (self: Private<Function, Arguments...>, Arguments...) -> (),
	FireDeferred: (self: Private<Function, Arguments...>, Arguments...) -> (),
	FireDeferredUnsafe: (self: Private<Function, Arguments...>, Arguments...) -> (),
	FireBindable: (self: Private<Function, Arguments...>, Arguments...) -> (),
	FireBindableUnsafe: (self: Private<Function, Arguments...>, Arguments...) -> (),

	Wait: (self: Private<Function, Arguments...>) -> Arguments...,

	DisconnectAll: (self: Private<Function, Arguments...>) -> (),
	Destroy: (self: Private<Function, Arguments...>) -> (),
}

-- Connection class
local Connection = {} :: Connection & ConnectionStatic
local ConnectionPrivate = Connection :: ConnectionPrivate<any, ...any> & ConnectionStaticPrivate
Connection.ClassName = "Connection";
(Connection :: any).__index = Connection

function Connection.new<Function, Arguments...>(signal: Private<Function, Arguments...>, callback: Function): Connection
	return setmetatable({
		Connected = true;

		Function = callback;
		Next = nil;
		Signal = signal;
	}, Connection) :: never
end

function ConnectionPrivate:Disconnect()
	if not self.Connected then
		return
	end

	self.Connected = false

	-- Unhook the node, but DON'T clear it. That way any fire calls that are
	-- currently sitting on this node will be able to iterate forwards off of
	-- it, but any subsequent fire calls will not hit it, and it will be GCed
	-- when no more fire calls are sitting on it.
	local signal = self.Signal
	local previous = signal.HandlerListHead
	if previous == self then
		signal.HandlerListHead = self.Next
	else
		while previous and previous.Next ~= self do
			previous = previous.Next
		end

		if previous then
			previous.Next = self.Next
		end
	end
end

Connection.disconnect = Connection.Disconnect
Connection.Destroy = Connection.Disconnect

function ConnectionPrivate:__tostring()
	return "Connection"
end

--[=[
	A function connected to a signal.
	@type ConnectionFunction (...any) -> ()
	@within Signal
]=]

local IS_DEFERRED = true

export type Signal<Function, Arguments...> = {
	DebugMode: boolean,
	Connect: (self: Signal<Function, Arguments...>, Function: Function) -> Connection,
	Once: (self: Signal<Function, Arguments...>, Function: Function) -> Connection,
	ConnectOnce: (self: Signal<Function, Arguments...>, Function: Function) -> Connection,

	ConnectClassic: (self: Signal<Function, Arguments...>, Function: Function) -> RBXScriptConnection,
	OnceClassic: (self: Signal<Function, Arguments...>, Function: Function) -> RBXScriptConnection,
	ConnectOnceClassic: (self: Signal<Function, Arguments...>, Function: Function) -> RBXScriptConnection,

	GetConnections: (self: Signal<Function, Arguments...>) -> {Connection},
	IsConnectedTo: (self: Signal<Function, Arguments...>) -> boolean,

	Fire: (self: Signal<Function, Arguments...>, Arguments...) -> (),
	FireDeferred: (self: Signal<Function, Arguments...>, Arguments...) -> (),
	FireDeferredUnsafe: (self: Signal<Function, Arguments...>, Arguments...) -> (),
	FireBindable: (self: Signal<Function, Arguments...>, Arguments...) -> (),
	FireBindableUnsafe: (self: Signal<Function, Arguments...>, Arguments...) -> (),

	Wait: (self: Signal<Function, Arguments...>) -> Arguments...,

	DisconnectAll: (self: Signal<Function, Arguments...>) -> (),
	Destroy: (self: Signal<Function, Arguments...>) -> (),
}
export type VoidSignal = Signal<() -> ()>
export type SmartSignal<Function, Arguments...> = Signal<Function, Arguments...>
export type ClassicSignal<T...> = {
	DebugMode: boolean,

	Connect: (self: ClassicSignal<T...>, Function: (T...) -> ()) -> Connection,
	Once: (self: ClassicSignal<T...>, Function: (T...) -> ()) -> Connection,
	ConnectOnce: (self: ClassicSignal<T...>, Function: (T...) -> ()) -> Connection,

	ConnectClassic: (self: ClassicSignal<T...>, Function: (T...) -> ()) -> RBXScriptConnection,
	OnceClassic: (self: ClassicSignal<T...>, Function: (T...) -> ()) -> RBXScriptConnection,
	ConnectOnceClassic: (self: ClassicSignal<T...>, Function: (T...) -> ()) -> RBXScriptConnection,

	GetConnections: (self: ClassicSignal<T...>) -> {Connection},
	IsConnectedTo: (self: ClassicSignal<T...>) -> boolean,

	Fire: (self: ClassicSignal<T...>, T...) -> (),
	FireDeferred: (self: ClassicSignal<T...>, T...) -> (),
	FireDeferredUnsafe: (self: ClassicSignal<T...>, T...) -> (),
	FireBindable: (self: ClassicSignal<T...>, T...) -> (),
	FireBindableUnsafe: (self: ClassicSignal<T...>, T...) -> (),

	Wait: (self: ClassicSignal<T...>) -> T...,

	DisconnectAll: (self: ClassicSignal<T...>) -> (),
	Destroy: (self: ClassicSignal<T...>) -> (),
}

type Static = {
	ClassName: "Signal",
	new: <Function, Arguments...>(janitor: any?) -> Signal<Function, Arguments...>,
	Wrap: <Function, Arguments...>(signal: RBXScriptSignal, janitor: any?) -> Signal<Function, Arguments...>,

	Is: (value: any) -> boolean,
	instanceof: (value: any) -> boolean,
}
type PrivateStatic = Static & {__tostring: (self: Private<any, ...any>) -> string}

--[=[
	Signals allow events to be dispatched and handled.

	For example:

	```lua
	local signal: Signal<(message: string) -> (), string> = Signal.new()

	signal:Connect(function(message) -- message type is inferred and the parameter name is as well :)
		print("Got message:", message)
	end)

	signal:Fire("Hello world!")
	```

	@class Signal
]=]
local Signal = {} :: Signal<any, ...any> & Static
local Private = Signal :: Private<any, ...any> & PrivateStatic
Signal.ClassName = "Signal";
(Signal :: any).__index = Signal

--[=[
	Whether or not to do a warning when a thread is suspended when
	[Signal.DisconnectAll] is called. By default it is `false`.

	@since v2.1.0
	@prop DebugMode boolean
	@within Signal
]=]

--[=[
	Constructs a new Signal.

	@param janitor? Janitor -- Adds the Signal to the Janitor.
	@return Signal<Function, Arguments...>
]=]
function Signal.new<Function, Arguments...>(janitor): Signal<Function, Arguments...>
	local self: Private<Function, Arguments...> = setmetatable({}, Signal) :: never
	self.DebugMode = false
	self.HandlerListHead = nil
	self.ProxyHandler = nil
	self.YieldedThreads = nil

	if janitor then
		janitor:Add(self, "Destroy")
	end

	return self
end

--[=[
	Constructs a new Signal that wraps around an RBXScriptSignal.

	For example:

	```lua
	local signal = Signal.Wrap(workspace.ChildAdded)
	signal:Connect(function(part) print(part.Name .. " added") end)
	Instance.new("Part").Parent = workspace
	```

	@param rbxScriptSignal RBXScriptSignal -- Existing RBXScriptSignal to wrap
	@param janitor? Janitor -- Adds the Signal to the Janitor.
	@return Signal
]=]
function Signal.Wrap<Function, Arguments...>(rbxScriptSignal, janitor): Signal<Function, Arguments...>
	local self: Private<Function, Arguments...> = setmetatable({}, Signal) :: never
	self.DebugMode = false
	self.HandlerListHead = nil
	self.YieldedThreads = nil

	if janitor then
		janitor:Add(self, "Destroy")
	end

	self.ProxyHandler = rbxScriptSignal:Connect(function(...)
		self:Fire(...)
	end)

	return self
end

--[=[
	Checks if the given value is a Signal.

	@param value unknown -- Object to check.
	@return boolean -- `true` if the value is a Signal.
]=]
function Signal.Is(value)
	return type(value) == "table" and getmetatable(value) == Signal
end

--[=[
	A shorthand for [Signal.Is].

	@function instanceof
	@within Signal

	@param value unknown -- Object to check.
	@return boolean -- `true` if the value is a Signal.
]=]
Signal.instanceof = Signal.Is

--[=[
	Connects a function to the signal, which will be called anytime the signal
	is fired.

	```lua
	signal:Connect(function(msg, num)
		print(msg, num)
	end)

	signal:Fire("Hello", 25)
	```

	@method Connect
	@within Signal

	@param callback (Arguments...) -> () -- The function you are connecting.
	@return Connection
]=]
function Private:Connect(callback)
	-- TODO: optimize this further
	local connection: ConnectionPrivate<any, ...any> = setmetatable({
		Connected = true;

		Function = callback;
		Next = nil;
		Signal = self;
	}, Connection) :: never

	local handlerListHead = self.HandlerListHead
	if handlerListHead then
		connection.Next = handlerListHead
		self.HandlerListHead = connection
	else
		self.HandlerListHead = connection
	end

	return connection
end

--[=[
	@deprecated v1.3.0 -- Use `Signal:Once` instead.
	@param callback (Arguments...) -> () -- The function you are connecting.
	@return Connection
]=]
function Signal:ConnectOnce(callback)
	return self:Once(callback)
end

--[=[
	Connects a function to the signal, which will be called the next time the signal fires. Once
	the connection is triggered, it will disconnect itself.

	```lua
	signal:Once(function(msg, num)
		print(msg, num)
	end)

	signal:Fire("Hello", 25)
	signal:Fire("This message will not go through", 10)
	```

	@param callback (Arguments...) -> () -- The function you are connecting.
	@return Connection
]=]
function Signal:Once(callback)
	local connection
	local hasFired = false
	connection = self:Connect(function(...)
		if hasFired then
			return
		end

		hasFired = true
		connection:Disconnect()
		callback(...)
	end)

	return connection
end

--[=[
	The exact same as [Signal.Connect], but it returns an [RBXScriptConnection]
	instead.

	@since v2.0.0
	@method ConnectClassic
	@within Signal

	@param callback (Arguments...) -> () -- The function you are connecting.
	@return RBXScriptConnection
]=]
Signal.ConnectClassic = Signal.Connect :: never
Signal.ConnectOnceClassic = Signal.ConnectOnce :: never
--[=[
	The exact same as [Signal.Once], but it returns an [RBXScriptConnection]
	instead.

	@since v2.0.0
	@method OnceClassic
	@within Signal

	@param callback (Arguments...) -> () -- The function you are connecting.
	@return RBXScriptConnection
]=]
Signal.OnceClassic = Signal.Once :: never

--[=[
	Gets all the connections in the signal.

	@method GetConnections
	@within Signal

	@return {Connection}
]=]
function Private:GetConnections()
	local items: {Connection} = {}
	local length = 0

	local item = self.HandlerListHead
	while item do
		length += 1
		items[length] = item
		item = item.Next
	end

	return items
end

--[=[
	Checks if there are any active connections in the signal.

	@since v1.0.1
	@method IsConnectedTo
	@within Signal

	@return boolean
]=]
function Private:IsConnectedTo()
	return not not self.HandlerListHead
end

-- Signal:Fire(...) implemented by running the handler functions on the
-- coRunnerThread, and any time the resulting thread yielded without returning
-- to us, that means that it yielded to the Roblox scheduler and has been taken
-- over by Roblox scheduling, meaning we have to make a new coroutine runner.
--[=[
	Fire the signal, which will call all of the connected functions with the
	given arguments.

	```lua
	signal:Fire("Hello")

	-- Any number of arguments can be fired:
	signal:Fire("Hello", 32, {Test = "Test"}, true)
	```

	@method Fire
	@within Signal

	@param ... Arguments...
]=]
function Private:Fire(...)
	local item = self.HandlerListHead
	while item do
		if item.Connected then
			if not FreeRunnerThread then
				FreeRunnerThread = coroutine.create(RunEventHandlerInFreeThread)
			end

			task.spawn(FreeRunnerThread :: thread, item.Function, ...)
		end

		item = item.Next
	end
end

-- cheese it? yeah
local function DeferExecution<Function, Arguments...>(connection: ConnectionPrivate<any, Arguments...>, ...: Arguments...)
	if connection.Connected then
		connection.Function(...)
	end
end

--[=[
	Same as [Signal.Fire], but uses `task.defer` internally & doesn't take
	advantage of thread reuse.

	```lua
	signal:FireDeferred("Hello")
	```

	@method FireDeferred
	@within Signal

	@param ... Arguments...
]=]
function Private:FireDeferred(...)
	local item = self.HandlerListHead

	while item do
		task.defer(DeferExecution, item, ...)
		item = item.Next
	end
end

--[=[
	An "unsafe" version of [Signal.FireDeferred] that uses recycled threads
	to fire. Don't know if this will work the exact same, therefore it is
	unsafe. This should be faster than even [Signal.Fire] though, or around its
	performance level.

	@since v2.0.0
	@method FireDeferredUnsafe
	@within Signal

	@param ... Arguments...
]=]
function Private:FireDeferredUnsafe(...)
	local item = self.HandlerListHead
	while item do
		ThreadUtilities.FastDefer(DeferExecution, item, ...)
		item = item.Next
	end
end

--[=[
	This function mirrors how a [BindableEvent] would be fired given the
	current [Workspace.SignalBehavior] setting. If it is set to
	`Enum.SignalBehavior.Deferred`, it will use [Signal.FireDeferred] and if it
	is set to `Enum.SignalBehavior.Immediate`, it will use [Signal.Fire].

	@since v2.1.0
	@method FireBindable
	@within Signal

	@param ... Arguments...
]=]
Signal.FireBindable = if IS_DEFERRED then Signal.FireDeferred else Signal.Fire

--[=[
	This function mirrors how a [BindableEvent] would be fired given the
	current [Workspace.SignalBehavior] setting. If it is set to
	`Enum.SignalBehavior.Deferred`, it will use [Signal.FireDeferredUnsafe]
	and if it is set to `Enum.SignalBehavior.Immediate`, it will use
	[Signal.Fire].

	@since v2.1.0
	@method FireBindableUnsafe
	@within Signal

	@param ... Arguments...
]=]
Signal.FireBindableUnsafe = if IS_DEFERRED then Signal.FireDeferredUnsafe else Signal.Fire

--[=[
	Yields the current thread until the signal is fired, and returns the
	arguments fired from the signal. Yielding the current thread is not always
	desirable. If the desire is to only capture the next event fired, using
	[Signal.Once] might be a better solution.

	```lua
	task.spawn(function()
		local msg, num = signal:Wait()
		print(msg, num) --> "Hello", 32
	end)

	signal:Fire("Hello", 32)
	```

	@method Wait
	@within Signal

	@yields
	@return ... Arguments...
]=]
function Private:Wait()
	local yieldedThreads = self.YieldedThreads :: {[thread]: true}
	if not yieldedThreads then
		yieldedThreads = {}
		self.YieldedThreads = yieldedThreads
	end

	local thread = coroutine.running()
	yieldedThreads[thread] = true

	self:Once(function(...)
		yieldedThreads[thread] = nil
		task.spawn(thread, ...)
	end)

	return coroutine.yield()
end

--[=[
	Disconnect all handlers. Since we use a linked list it suffices to clear
	the reference to the head handler.

	```lua
	signal:DisconnectAll()
	```

	@method DisconnectAll
	@within Signal
]=]
function Private:DisconnectAll()
	local item = self.HandlerListHead
	while item do
		item.Connected = false
		item = item.Next
	end

	self.HandlerListHead = nil

	local yieldedThreads = self.YieldedThreads
	if yieldedThreads then
		local debugMode = self.DebugMode
		for thread in yieldedThreads do
			if coroutine.status(thread) == "suspended" then
				if debugMode then
					warn(debug.traceback(thread, "signal disconnected; yielded thread cancelled", 2))
				end
				task.cancel(thread)
			end
		end
		table.clear(yieldedThreads)
	end
end

--[=[
	Cleans up the signal and renders it completely unusable.

	:::tip Cleanups
	Technically, this is only necessary if the signal is created using
	[Signal.Wrap]. Connections should be properly GC'd once the signal is no
	longer referenced anywhere. However, it is still good practice to include
	ways to strictly clean up resources. Calling [Signal.Destroy] on a signal
	will also disconnect all connections immediately.
	:::

	```lua
	signal:Destroy()
	```

	@method Destroy
	@within Signal
]=]
function Private:Destroy()
	self:DisconnectAll()

	local proxyHandler = self.ProxyHandler
	if proxyHandler then
		proxyHandler:Disconnect()
	end

	table.clear(self)
	setmetatable(self, nil)
end

function Private:__tostring()
	return "Signal"
end

return table.freeze(Signal :: Static)
