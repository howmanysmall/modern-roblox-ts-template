--!optimize 2
--!strict

local EqualObjects = require("./EqualObjects")

--@native
local function CompareDeep(a: unknown, b: unknown)
	if type(a) ~= "table" or type(b) ~= "table" then
		return a == b
	end

	local castA = a :: {[unknown]: unknown}
	local castB = b :: {[unknown]: unknown}

	-- can't use generalized iteration because of __call
	for key, value in pairs(castA) do
		if not CompareDeep(value, castB[key]) then
			return false
		end
	end

	for key, value in pairs(castB) do
		if not CompareDeep(value, castA[key]) then
			return false
		end
	end

	return true
end

--[=[
	Compares two tables for equality using deep comparison.

	```lua
	local dictionary = {hello = "world", goodbye = {world = "hello"}}
	local other1 = {hello = "world", goodbye = {world = "hello"}}
	local other2 = {hello = "hello", world = "goodbye"}

	local value = EqualsDeep(dictionary, other1) -- true
	local value = EqualsDeep(dictionary, other1, other2) -- false
	```

	@function EqualsDeep
	@within TableUtilities

	@param ... ...{[unknown]: unknown} -- The tables to compare.
	@return boolean -- Whether the tables are equal.
]=]
--@native
local function EqualsDeep(...: {[unknown]: unknown})
	if EqualObjects(...) then
		return true
	end

	local totalArguments = select("#", ...)
	local firstObject = ...

	for index = 2, totalArguments do
		local object = select(index, ...)
		if not CompareDeep(firstObject, object) then
			return false
		end
	end

	return true
end

return EqualsDeep
