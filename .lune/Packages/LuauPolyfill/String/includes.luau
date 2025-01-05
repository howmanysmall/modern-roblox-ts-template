--!optimize 2
--!strict

-- excluding the `+` and `*` character, since findOr tests and graphql use them explicitly
local luauPatternCharacters = "([" .. string.gsub("$%^()-[].?", "(.)", "%%%1") .. "])"

local function includes(value: string, substring: string, position: nil | number | string): boolean
	local stringLength, invalidBytePosition = utf8.len(value)
	assert(
		stringLength ~= nil,
		string.format("string `%*` has an invalid byte at position %*", value, invalidBytePosition)
	)
	if stringLength == 0 then
		return false
	end

	if #substring == 0 then
		return true
	end

	local startIndex = 1
	if position ~= nil then
		startIndex = tonumber(position) or 1
		if startIndex > stringLength then
			return false
		end
	end

	if startIndex < 1 then
		startIndex = 1
	end

	local initial = utf8.offset(value, startIndex)
	return string.find(value, string.gsub(substring, luauPatternCharacters, "%%%1"), initial) ~= nil
end

return includes
