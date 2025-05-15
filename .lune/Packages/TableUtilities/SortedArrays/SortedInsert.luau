--!optimize 2
--!strict

local FindInsertIndex = require("./FindInsertIndex")
type Comparison<T> = FindInsertIndex.Comparison<T>

--[=[
	Inserts a value into a sorted array using a binary search. This requires
	the elements to be either a number or a string.

	Inserts a value into a sorted array using a binary search. You will
	need to provide a compare function to use and possible an equality check.
	If you are using numbers or strings, you can get away with
	[TableUtilities.SortedInsertSimple] instead.

	:::danger Warning
	Your array *MUST* be already sorted because this uses a binary search. This
	function will not sort for you.
	:::

	```lua
	local array: {{Value: number}} = {}
	local function LessThan(a: {Value: number}, b: {Value: number})
		return a.Value < b.Value
	end
	local function EqualsCheck(a: {Value: number}, b: {Value: number})
		return a.Value == b.Value
	end

	SortedInsert(array, {Value = 3}, LessThan, EqualsCheck)
	SortedInsert(array, {Value = 1}, LessThan, EqualsCheck)
	SortedInsert(array, {Value = 2}, LessThan, EqualsCheck)
	SortedInsert(array, {Value = 4}, LessThan, EqualsCheck)
	print(array)
	```

	@function SortedInsert
	@within TableUtilities

	@param array {T} -- The array to insert into.
	@param value T -- The value to insert.
	@param lessThanCheck Comparison<T> -- The function to use to compare values.
	@param equalCheck? Comparison<T> -- The function to use to compare equality for values.
	@return number -- The index where the value was inserted.
]=]
local function SortedInsert<T>(array: {T}, value: T, lessThanCheck: Comparison<T>, equalCheck: Comparison<T>?): number
	local position = FindInsertIndex(array, value, lessThanCheck, equalCheck)
	local arrayValue = array[position :: never]

	local insertIndex = 1
	if arrayValue ~= nil then
		insertIndex = if lessThanCheck(value, arrayValue) then position :: number else (position :: number) + 1
	end

	table.insert(array, insertIndex, value)
	return insertIndex
end

return SortedInsert
