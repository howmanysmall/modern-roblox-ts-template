--!optimize 2
--!strict

local Array = require("@self/Array")
local Map = require("@self/Map")
local Object = require("@self/Object")
local Set = require("@self/Set")
local WeakMap = require("@self/WeakMap")
local inspect = require("@self/inspect")
local types = require("@packages/ES7Types")

export type Array<T> = types.Array<T>
export type Map<T, V> = types.Map<T, V>
export type Object = types.Object
export type Set<T> = types.Set<T>
export type WeakMap<T, V> = types.WeakMap<T, V>

return table.freeze({
	Array = Array;
	Object = Object;
	Map = Map.Map;
	coerceToMap = Map.coerceToMap;
	coerceToTable = Map.coerceToTable;
	Set = Set;
	WeakMap = WeakMap;
	inspect = inspect;
})
