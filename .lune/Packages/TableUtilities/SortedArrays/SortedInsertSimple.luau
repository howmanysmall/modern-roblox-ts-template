--!native
--!optimize 2
--!strict

local FindInsertIndexSimple = require("./FindInsertIndexSimple")

--[=[
	Inserts a value into a sorted array using a binary search. This requires
	the elements to be either a number or a string.

	:::danger Warning
	Your array *MUST* be already sorted because this uses a binary search. This
	function will not sort for you.
	:::

	```lua
	local array: {number} = {}
	SortedInsertSimple(array, 3)
	SortedInsertSimple(array, 1)
	SortedInsertSimple(array, 2)
	SortedInsertSimple(array, 4)
	print(array)
	```

	@function SortedInsertSimple
	@within TableUtilities

	@param array {number | string} -- The array to insert into.
	@param value number | string -- The value to insert.
	@return number -- The index where the value was inserted.
]=]
local function SortedInsertSimple(array: {any}, value: any): number
	local position = FindInsertIndexSimple(array, value)
	local arrayValue = array[position :: never]

	local insertIndex = 1
	if arrayValue ~= nil then
		insertIndex = if value < arrayValue then position :: number else (position :: number) + 1
	end

	table.insert(array, insertIndex, value)
	return insertIndex
end

return SortedInsertSimple :: ((array: {number}, value: number) -> number) & ((array: {string}, value: string) -> number)
