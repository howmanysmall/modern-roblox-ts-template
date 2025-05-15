--!optimize 2
--!strict

export type Comparison<T> = (a: T, b: T) -> boolean

--[=[
	Used to find where to insert an element into a sorted array. You will
	need to provide a compare function to use and possible an equality check.
	If you are using numbers or strings, you can get away with
	[TableUtilities.FindInsertIndexSimple] instead.

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

	local function Insert(value: {Value: number})
		local position = FindInsertIndex(array, value, LessThan, EqualsCheck)
		local value2 = array[position :: never]

		if value2 == nil then
			position = 1
		else
			position = if LessThan(value, value2) then position else (position :: number) + 1
		end

		print(string.format("Inserting %* at index %*", value.Value, position))
		table.insert(array, position :: number, value)
	end

	Insert({Value = 3}) -- Inserting 3 at index 1
	Insert({Value = 1}) -- Inserting 1 at index 1
	Insert({Value = 2}) -- Inserting 2 at index 2
	Insert({Value = 4}) -- Inserting 4 at index 4
	```

	@function FindInsertIndex
	@within TableUtilities

	@param array {T} -- The array to insert into.
	@param value T -- The value to insert.
	@param lessThanCheck Comparison<T> -- The function to use to compare values.
	@param equalCheck? Comparison<T> -- The function to use to compare equality for values.
	@return number?
]=]
local function FindInsertIndex<T>(array: {T}, value: T, lessThanCheck: Comparison<T>, equalCheck: Comparison<T>?): number?
	local low = 1
	local high = #array

	local middle = (low + high) // 2
	if middle == 0 then
		return nil
	end

	local arrayValue = array[middle]
	while middle ~= high do
		if equalCheck then
			if equalCheck(value, arrayValue) then
				return middle
			end
		elseif value == arrayValue then
			return middle
		end

		if lessThanCheck(value, arrayValue) then
			high = middle - 1
		else
			low = middle + 1
		end

		middle = (low + high) // 2
		arrayValue = array[middle]
	end

	return middle
end

return FindInsertIndex
