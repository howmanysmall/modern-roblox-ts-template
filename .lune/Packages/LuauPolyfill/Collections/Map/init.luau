--!optimize 2
local ES7Types = require("../../ES7Types")
local Map = require("./Map")
local coerceToMap = require("./coerceToMap")
local coerceToTable = require("./coerceToTable")

export type Map<K, V> = ES7Types.Map<K, V>

return table.freeze({
	Map = Map;
	coerceToMap = coerceToMap;
	coerceToTable = coerceToTable;
})
