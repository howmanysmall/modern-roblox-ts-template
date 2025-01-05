--!optimize 2
--!strict

local IsDeferred = require("./IsDeferred")
local ThreadUtilities = require("@utilities/ThreadUtilities")
local task = require("@lune/task")

local freeRunnerThread: thread?

local function AcquireRunnerThreadAndCallEventHandler<Arguments...>(callback: (Arguments...) -> (), ...: Arguments...): ()
	local acquiredRunnerThread = freeRunnerThread
	freeRunnerThread = nil
	callback(...)
	freeRunnerThread = acquiredRunnerThread
end

local function RunEventHandlerInFreeThread<Arguments...>(callback: (Arguments...) -> (), ...: Arguments...): ()
	AcquireRunnerThreadAndCallEventHandler(callback, ...)
	while true do
		AcquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

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

type SignalEvent<Function, Arguments...> = {
	Connect: (self: SignalEvent<Function, Arguments...>, callback: Function) -> Connection,
	Once: (self: SignalEvent<Function, Arguments...>, callback: Function) -> Connection,
	Wait: (self: SignalEvent<Function, Arguments...>) -> Arguments...,
}
type Private<Function, Arguments...> = {
	DebugMode: boolean,
	Event: SignalEvent<Function, Arguments...>,

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

function ConnectionPrivate:Disconnect(): ()
	if not self.Connected then
		return
	end

	self.Connected = false

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

function ConnectionPrivate:__tostring(): string
	return "Connection"
end

local IS_DEFERRED = IsDeferred()

type ClassicSignalEvent<Arguments...> = {
	Connect: (self: ClassicSignalEvent<Arguments...>, callback: (Arguments...) -> ()) -> Connection,
	Once: (self: ClassicSignalEvent<Arguments...>, callback: (Arguments...) -> ()) -> Connection,
	Wait: (self: ClassicSignalEvent<Arguments...>) -> Arguments...,
}

export type Signal<Function, Arguments...> = {
	DebugMode: boolean,
	Event: SignalEvent<Function, Arguments...>,

	Connect: (self: Signal<Function, Arguments...>, callback: Function) -> Connection,
	Once: (self: Signal<Function, Arguments...>, callback: Function) -> Connection,
	ConnectOnce: (self: Signal<Function, Arguments...>, callback: Function) -> Connection,

	ConnectClassic: (self: Signal<Function, Arguments...>, callback: Function) -> RBXScriptConnection,
	OnceClassic: (self: Signal<Function, Arguments...>, callback: Function) -> RBXScriptConnection,
	ConnectOnceClassic: (self: Signal<Function, Arguments...>, callback: Function) -> RBXScriptConnection,

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
	Event: ClassicSignalEvent<T...>,

	Connect: (self: ClassicSignal<T...>, callback: (T...) -> ()) -> Connection,
	Once: (self: ClassicSignal<T...>, callback: (T...) -> ()) -> Connection,
	ConnectOnce: (self: ClassicSignal<T...>, callback: (T...) -> ()) -> Connection,

	ConnectClassic: (self: ClassicSignal<T...>, callback: (T...) -> ()) -> RBXScriptConnection,
	OnceClassic: (self: ClassicSignal<T...>, callback: (T...) -> ()) -> RBXScriptConnection,
	ConnectOnceClassic: (self: ClassicSignal<T...>, callback: (T...) -> ()) -> RBXScriptConnection,

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

local Signal = {} :: Signal<any, ...any> & Static
local Private = Signal :: Private<any, ...any> & PrivateStatic
Signal.ClassName = "Signal";
(Signal :: any).__index = Signal

function Signal.new<Function, Arguments...>(janitor): Signal<Function, Arguments...>
	local self: Private<Function, Arguments...> = setmetatable({}, Signal) :: never
	self.DebugMode = false
	self.HandlerListHead = nil
	self.ProxyHandler = nil
	self.YieldedThreads = nil

	local event = newproxy(true)
	local metatable = getmetatable(event)
	metatable.__type = "RBXScriptSignal"
	function metatable.__index(_, key)
		if key == "Connect" or key == "connect" then
			return function(_, callback)
				return self:Connect(callback)
			end
		end

		if key == "Once" then
			return function(_, callback)
				return self:Once(callback)
			end
		end

		if key == "Wait" or key == "wait" then
			return function()
				return self:Wait()
			end
		end

		error("unknown key " .. tostring(key))
	end
	self.Event = event

	if janitor then
		janitor:Add(self, "Destroy")
	end

	return self
end

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

function Signal.Is(value)
	return type(value) == "table" and getmetatable(value) == Signal
end

Signal.instanceof = Signal.Is

function Private:Connect(callback)
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

function Signal:ConnectOnce(callback)
	return self:Once(callback)
end

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

Signal.ConnectClassic = Signal.Connect :: never
Signal.ConnectOnceClassic = Signal.ConnectOnce :: never

Signal.OnceClassic = Signal.Once :: never

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

function Private:IsConnectedTo()
	return not not self.HandlerListHead
end

function Private:Fire(...)
	local item = self.HandlerListHead
	while item do
		if item.Connected then
			if not freeRunnerThread then
				freeRunnerThread = coroutine.create(RunEventHandlerInFreeThread)
			end

			task.spawn(freeRunnerThread :: thread, item.Function, ...)
		end

		item = item.Next
	end
end

local function DeferExecution<Function, Arguments...>(connection: ConnectionPrivate<any, Arguments...>, ...: Arguments...): ()
	if connection.Connected then
		connection.Function(...)
	end
end

function Private:FireDeferred(...)
	local item = self.HandlerListHead

	while item do
		task.defer(DeferExecution, item, ...)
		item = item.Next
	end
end

function Private:FireDeferredUnsafe(...)
	local item = self.HandlerListHead
	while item do
		ThreadUtilities.FastDefer(DeferExecution, item, ...)
		item = item.Next
	end
end

Signal.FireBindable = if IS_DEFERRED then Signal.FireDeferred else Signal.Fire
Signal.FireBindableUnsafe = if IS_DEFERRED then Signal.FireDeferredUnsafe else Signal.Fire

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
