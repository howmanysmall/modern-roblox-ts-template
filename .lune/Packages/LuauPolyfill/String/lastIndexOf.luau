--!optimize 2
--!strict

local function lastIndexOf(value: string, searchValue: string, fromIndex: number?): number
	local valueLength = #value
	local calculatedFromIndex
	if fromIndex then
		calculatedFromIndex = fromIndex
	else
		calculatedFromIndex = valueLength
	end

	if fromIndex and fromIndex < 1 then
		calculatedFromIndex = 1
	end

	if fromIndex and fromIndex > valueLength then
		calculatedFromIndex = valueLength
	end

	if searchValue == "" then
		-- FIXME: Luau DFA doesn't understand that
		return calculatedFromIndex :: number
	end

	local lastFoundStartIndex, foundStartIndex
	-- Luau FIXME: Luau doesn't look beyond assignment for type, it should infer number? from loop bound
	local foundEndIndex: number? = 0
	repeat
		lastFoundStartIndex = foundStartIndex
		-- Luau FIXME: DFA doesn't understand until clause means foundEndIndex is never nil within loop
		foundStartIndex, foundEndIndex = string.find(value, searchValue, foundEndIndex :: number + 1, true)
	until foundStartIndex == nil or foundStartIndex > calculatedFromIndex

	if lastFoundStartIndex == nil then
		return -1
	end

	-- Luau FIXME: Luau should see the predicate above and known the line below can only be a number
	return lastFoundStartIndex :: number
end

return lastIndexOf
