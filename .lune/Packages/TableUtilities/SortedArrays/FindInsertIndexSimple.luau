--!optimize 2
--!strict

--[=[
	Used to find where to insert an element into a sorted array. This requires
	the elements to be either a number or a string.

	:::danger Warning
	Your array *MUST* be already sorted because this uses a binary search. This
	function will not sort for you.
	:::

	```lua
	local array: {number} = {}
	local function Insert(value: number)
		local position = FindInsertIndexSimple(array, value)
		local value2 = array[position :: never]

		if value2 == nil then
			position = 1
		else
			position = if value < value2 then position else (position :: number) + 1
		end

		print(string.format("Inserting %* at index %*", value, position))
		table.insert(array, position :: number, value)
	end

	Insert(3) -- Inserting 3 at index 1
	Insert(1) -- Inserting 1 at index 1
	Insert(2) -- Inserting 2 at index 2
	Insert(4) -- Inserting 4 at index 4
	```

	@function FindInsertIndexSimple
	@within TableUtilities

	@param array {number | string} -- The array to insert into.
	@param value number | string -- The value to insert.
	@return number?
]=]
local function FindInsertIndexSimple(array: {any}, value: any): number?
	local low = 1
	local high = #array

	local middle = (low + high) // 2
	if middle == 0 then
		return nil
	end

	local arrayValue = array[middle]
	while middle ~= high do
		if value == arrayValue then
			return middle
		end

		if value < arrayValue then
			high = middle - 1
		else
			low = middle + 1
		end

		middle = (low + high) // 2
		arrayValue = array[middle]
	end

	return middle
end

return FindInsertIndexSimple :: ((array: {number}, value: number) -> number?) & ((array: {string}, value: string) -> number?)
