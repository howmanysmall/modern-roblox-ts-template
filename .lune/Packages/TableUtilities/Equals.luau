--!optimize 2
--!strict

local EqualObjects = require("./EqualObjects")

--@native
local function Compare(a: unknown, b: unknown)
	if type(a) ~= "table" or type(b) ~= "table" then
		return a == b
	end

	local castA = a :: {[unknown]: unknown}
	local castB = b :: {[unknown]: unknown}

	-- can't use generalized iteration because of __call
	for key, value in pairs(castA) do
		if castB[key] ~= value then
			return false
		end
	end

	for key, value in pairs(castB) do
		if castA[key] ~= value then
			return false
		end
	end

	return true
end

--[=[
	Compares two dictionaries for equality.

	```lua
	local dictionary = {hello = "world", goodbye = "world"}
	local other1 = {hello = "world", goodbye = "world"}
	local other2 = {hello = "hello", world = "goodbye"}

	local value = Equals(dictionary, other1) -- true
	local value = Equals(dictionary, other1, other2) -- false
	```

	@function Equals
	@within TableUtilities

	@param ... ...{[unknown]: unknown} -- The tables to compare.
	@return boolean -- Whether the tables are equal.
]=]
--@native
local function Equals(...: {[unknown]: unknown})
	if EqualObjects(...) then
		return true
	end

	local totalArguments = select("#", ...)
	local firstObject = ...

	for index = 2, totalArguments do
		local object = select(index, ...)
		if not Compare(firstObject, object) then
			return false
		end
	end

	return true
end

return Equals
