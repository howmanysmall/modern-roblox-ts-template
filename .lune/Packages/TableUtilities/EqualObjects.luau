--!optimize 2
--!strict

--[=[
	Compares two or more tables to see if they are equal.

	```lua
	local a = {hello = "world"}
	local b = {hello = "world"}

	local equal = EqualObjects(a, b) -- false
	```

	```lua
	local a, b = table.unpack(table.create(2, {}), 1, 2)
	local equal = EqualObjects(a, b) -- true
	```

	@function EqualObjects
	@within TableUtilities

	@param ... ...{[unknown]: unknown} -- The tables to compare.
	@return boolean -- Whether or not the tables are equal.
]=]
local function EqualObjects(...: {[unknown]: unknown})
	local firstItem = ...
	for index = 2, select("#", ...) do
		if firstItem ~= select(index, ...) then
			return false
		end
	end
	return true
end

return EqualObjects
