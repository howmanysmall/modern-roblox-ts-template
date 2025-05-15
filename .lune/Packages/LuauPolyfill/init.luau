--!optimize 2
--!strict

local AssertionError = require("@self/AssertionError")
local Boolean = require("@self/Boolean")
local Collections = require("@self/Collections")
local Console = require("@self/Console")
local Error = require("@self/Error")
local Math = require("@self/Math")
local Number = require("@self/Number")
local PromiseModule = require("@self/Promise")
local String = require("@self/String")
local Symbol = require("@self/Symbol")
local Timers = require("@self/Timers")
local encodeURIComponent = require("@self/encodeURIComponent")
local extends = require("@self/extends")
local instanceof = require("@packages/InstanceOf")
local types = require("@packages/ES7Types")

export type Array<T> = types.Array<T>
export type AssertionError = AssertionError.AssertionError
export type Error = Error.Error
export type Map<T, V> = types.Map<T, V>
export type Object = types.Object

export type PromiseLike<T> = PromiseModule.PromiseLike<T>
export type Promise<T> = PromiseModule.Promise<T>

export type Set<T> = types.Set<T>
export type Symbol = Symbol.Symbol
export type Timeout = Timers.Timeout
export type Interval = Timers.Interval
export type WeakMap<T, V> = Collections.WeakMap<T, V>

return table.freeze({
	Array = Collections.Array;
	AssertionError = AssertionError;
	Boolean = Boolean;
	console = Console;
	Error = Error;
	extends = extends;
	instanceof = instanceof;
	Math = Math;
	Number = Number;
	Object = Collections.Object;
	Map = Collections.Map;
	coerceToMap = Collections.coerceToMap;
	coerceToTable = Collections.coerceToTable;
	Set = Collections.Set;
	WeakMap = Collections.WeakMap;
	String = String;
	Symbol = Symbol;

	clearInterval = Timers.clearInterval;
	clearTimeout = Timers.clearTimeout;
	encodeURIComponent = encodeURIComponent;
	setInterval = Timers.setInterval;
	setTimeout = Timers.setTimeout;
	util = table.freeze({
		encodeURIComponent = encodeURIComponent;
		inspect = Collections.inspect;
	});
})
