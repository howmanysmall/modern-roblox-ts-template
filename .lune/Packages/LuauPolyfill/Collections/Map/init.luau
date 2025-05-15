--!optimize 2
--!strict

local ES7Types = require("@packages/ES7Types")
local Map = require("@self/Map")
local coerceToMap = require("@self/coerceToMap")
local coerceToTable = require("@self/coerceToTable")

export type Map<K, V> = ES7Types.Map<K, V>

return table.freeze({
	Map = Map;
	coerceToMap = coerceToMap;
	coerceToTable = coerceToTable;
})
