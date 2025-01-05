--!optimize 2
--!strict
local Number = require("../Number")
local findOr = require("./findOr")
local slice = require("./slice")
local types = require("../ES7Types")

local MAX_SAFE_INTEGER = Number.MAX_SAFE_INTEGER
type Array<T> = types.Array<T>

type Pattern = string | Array<string>

local function split(str: string, _pattern: Pattern?, _limit: number?): Array<string>
	if _pattern == nil then
		return {str}
	end

	if _limit == 0 then
		return {}
	end

	local limit = if _limit == nil or _limit < 0 then MAX_SAFE_INTEGER else _limit
	local pattern = _pattern
	local patternList: Array<string>
	if type(pattern) == "string" then
		if pattern == "" then
			return string.split(str, "")
		end

		patternList = {pattern}
	else
		patternList = pattern :: Array<string>
	end

	local init = 1
	local result = {}
	local lastMatch
	local strLen, invalidBytePosition = utf8.len(str)
	assert(strLen ~= nil, string.format("string `%*` has an invalid byte at position %*", str, invalidBytePosition))

	repeat
		local match = findOr(str, patternList, init)
		if match ~= nil then
			table.insert(result, slice(str, init, match.index))
			local matchLength = utf8.len(match.match)
			-- Luau FIXME? Luau doesn't understand that str has already been shown to be valid utf8 on line 26 and therefore won't be nil
			init = match.index + matchLength :: number
		else
			table.insert(result, slice(str, init, nil))
		end

		if match ~= nil then
			lastMatch = match
		end
	until match == nil or init > strLen or #result >= limit

	if lastMatch ~= nil then
		local lastMatchLength, invalidBytePosition_ = utf8.len(lastMatch.match)
		assert(
			lastMatchLength ~= nil,
			string.format("string `%*` has an invalid byte at position %*", lastMatch.match, invalidBytePosition_)
		)

		if lastMatch.index + lastMatchLength == strLen + 1 then
			table.insert(result, "")
		end
	end

	return result
end

return split
