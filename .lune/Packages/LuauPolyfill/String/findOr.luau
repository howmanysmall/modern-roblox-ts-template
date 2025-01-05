--!optimize 2
--!strict
type Match = {
	index: number,
	match: string,
}

-- excluding the `+` and `*` character, since findOr tests and graphql use them explicitly
local luauPatternCharacters = "([" .. string.gsub("$%^()-[].?", "(.)", "%%%1") .. "])"

local function findOr(value: string, patternTable: {string}, initialIndex: number?): Match?
	-- loop through all options in pattern patternTable

	local initial = utf8.offset(value, initialIndex or 1)
	local matches = {}
	local length = 0

	for _, pattern in patternTable do
		pattern = string.gsub(pattern, luauPatternCharacters, "%%%1")
		local startIndex, finishIndex = string.find(value, pattern, initial)
		if startIndex then
			local prefix = string.sub(value, 1, startIndex - 1)
			local prefixEnd, invalidBytePosition = utf8.len(prefix)
			if prefixEnd == nil then
				error(string.format("string `%*` has an invalid byte at position %*", prefix, invalidBytePosition))
			end

			local atIndex = prefixEnd :: number + 1
			length += 1
			matches[length] = {
				index = atIndex;
				match = string.sub(value, startIndex, finishIndex);
			}
		end
	end

	-- if no matches, return nil
	if length == 0 then
		return nil
	end

	-- find the first matched index (after the init param)
	-- for each, if we get a hit, return the earliest index and matched term

	local firstMatch
	for _, match in matches do
		-- load first condition
		if firstMatch == nil then
			firstMatch = match
		end

		-- identify if current match comes before first match
		if match.index < firstMatch.index then
			firstMatch = match
		end
	end

	-- return first match
	return firstMatch
end

return findOr
