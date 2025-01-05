--!optimize 2
--!strict

-- excluding the `+` and `*` character, since findOr tests and graphql use them explicitly
local luauPatternCharacters = "([" .. string.gsub("$%^()-[].?", "(.)", "%%%1") .. "])"

-- Implements equivalent functionality to JavaScript's `String.indexOf`,
-- implementing the interface and behaviors defined at:
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/indexOf

return function(value: string, searchElement: string, fromIndex: number?): number
	local length = #value
	local trueFromIndex = 1
	if fromIndex then
		trueFromIndex = if fromIndex < 1 then 1 else fromIndex :: number
	end

	if #searchElement == 0 then
		return if trueFromIndex > length then length else trueFromIndex
	end

	if trueFromIndex > length then
		return -1
	end

	searchElement = string.gsub(searchElement, luauPatternCharacters, "%%%1")
	local searchElementLength = #searchElement

	for index = trueFromIndex, length do
		if string.sub(value, index, index + searchElementLength - 1) == searchElement then
			return index
		end
	end

	return -1
end
