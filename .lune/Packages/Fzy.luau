--!optimize 2
--!strict

local GreenTea = require("@packages/GreenTea")
local LuauPolyfill = require("@packages/LuauPolyfill")

local Error = LuauPolyfill.Error

--[=[
	The lua implementation of the fzy string matching algorithm. This algorithm
	is optimized for matching stuff on the terminal, but should serve well as a
	baseline search algorithm within a game too.

	See:
	* https://github.com/swarn/fzy-lua
	* https://github.com/jhawthorn/fzy/blob/master/ALGORITHM.md

	Modified from the initial code to fit this codebase. While this
	definitely messes with some naming which may have been better, it
	also keeps usage of this library consistent with other libraries.

	Notes:
	* A higher score is better than a lower score
	* Scoring time is `O(n*m)` where `n` is the length of the needle
	  and `m` is the length of the haystack.
	* Scoring memory is also `O(n*m)`
	* Should do quite well with small lists

	This was ported from Quenty's [Fzy](https://github.com/Quenty/NevermoreEngine/blob/main/src/fzy/src/Shared/Fzy.lua).

	TODO: Support UTF8

	@class FastFzy
]=]

--[[
The MIT License (MIT)

Copyright (c) 2020 Seth Warn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]

local MAX_SCORE = math.huge
local MIN_SCORE = -math.huge

local FastFzy = {}

--[=[
	Configuration for FastFzy. See [FastFzy.CreateConfiguration] for details. This affects scoring
	and how the matching is done.

	@interface FzyConfiguration
	@field CapitalMatchScore number
	@field CaseSensitive boolean
	@field ConsecutiveMatchScore number
	@field DotMatchScore number
	@field GapInnerScore number
	@field GapLeadingScore number
	@field GapTrailingScore number
	@field MaxMatchLength number
	@field SlashMatchScore number
	@field WordMatchScore number
	@within FastFzy
]=]
local isFzyConfiguration = GreenTea.build({
	CapitalMatchScore = GreenTea.number();
	CaseSensitive = GreenTea.boolean();
	ConsecutiveMatchScore = GreenTea.number();
	DotMatchScore = GreenTea.number();
	GapInnerScore = GreenTea.number();
	GapLeadingScore = GreenTea.number();
	GapTrailingScore = GreenTea.number();
	MaxMatchLength = GreenTea.number();
	SlashMatchScore = GreenTea.number();
	WordMatchScore = GreenTea.number();
})
export type FzyConfiguration = typeof(isFzyConfiguration:type())

local isMaybeNumberRaw = GreenTea.optional(GreenTea.number())
local isPartialFzyConfiguration = GreenTea.build({
	CapitalMatchScore = isMaybeNumberRaw;
	CaseSensitive = GreenTea.optional(GreenTea.boolean());
	ConsecutiveMatchScore = isMaybeNumberRaw;
	DotMatchScore = isMaybeNumberRaw;
	GapInnerScore = isMaybeNumberRaw;
	GapLeadingScore = isMaybeNumberRaw;
	GapTrailingScore = isMaybeNumberRaw;
	MaxMatchLength = isMaybeNumberRaw;
	SlashMatchScore = isMaybeNumberRaw;
	WordMatchScore = isMaybeNumberRaw;
})
type PartialFzyConfiguration = typeof(isPartialFzyConfiguration:type())

--[=[
	Creates a new configuration for Fzy.

	@param maybeConfiguration table
	@return FzyConfiguration
]=]
function FastFzy.CreateConfiguration(maybeConfiguration: PartialFzyConfiguration?): FzyConfiguration
	local typeSuccess, typeError = isPartialFzyConfiguration:matches(maybeConfiguration)
	if not typeSuccess then
		local exception = Error.new(tostring(typeError))
		exception.name = "TypeError"
		Error.captureStackTrace(exception, FastFzy.CreateConfiguration)
		error(exception)
	end

	local configuration = (maybeConfiguration or {}) :: FzyConfiguration

	if configuration.CaseSensitive == nil then
		configuration.CaseSensitive = false
	end

	-- These numbers are from the Fzy, algorithm but may be adjusted
	configuration.GapLeadingScore = configuration.GapLeadingScore or -0.005
	configuration.GapTrailingScore = configuration.GapTrailingScore or -0.005
	configuration.GapInnerScore = configuration.GapInnerScore or -0.01
	configuration.ConsecutiveMatchScore = configuration.ConsecutiveMatchScore or 1
	configuration.SlashMatchScore = configuration.SlashMatchScore or 0.9
	configuration.WordMatchScore = configuration.WordMatchScore or 0.8
	configuration.CapitalMatchScore = configuration.CapitalMatchScore or 0.7
	configuration.DotMatchScore = configuration.DotMatchScore or 0.6
	configuration.MaxMatchLength = configuration.MaxMatchLength or 1024

	return configuration
end

--[=[
	Returns true if it is a [FzyConfiguration].

	@param configuration any
	@return boolean
]=]
function FastFzy.IsFzyConfiguration(configuration: any): boolean
	return type(configuration) == "table"
		and type(configuration.CapitalMatchScore) == "number"
		and type(configuration.CaseSensitive) == "boolean"
		and type(configuration.ConsecutiveMatchScore) == "number"
		and type(configuration.DotMatchScore) == "number"
		and type(configuration.GapInnerScore) == "number"
		and type(configuration.GapLeadingScore) == "number"
		and type(configuration.GapTrailingScore) == "number"
		and type(configuration.MaxMatchLength) == "number"
		and type(configuration.SlashMatchScore) == "number"
		and type(configuration.WordMatchScore) == "number"
end

--[=[
	Check if `needle` is a subsequence of the `haystack`.

	Usually called before [FastFzy.Score] or [FastFzy.Positions].

	@function HasMatch
	@within FastFzy

	@param configuration FzyConfiguration
	@param needle string
	@param haystack string
	@return boolean
]=]
local function HasMatch(configuration: FzyConfiguration, needle: string, haystack: string): boolean
	if not configuration.CaseSensitive then
		needle = string.lower(needle)
		haystack = string.lower(haystack)
	end

	local jndex: number? = 1
	for index = 1, #needle do
		jndex = string.find(haystack, string.sub(needle, index, index), jndex, true)
		if not jndex then
			return false
		end

		jndex += 1
	end

	return true
end
FastFzy.HasMatch = HasMatch

local function PreComputeBonus(configuration: FzyConfiguration, haystack: string): {number}
	local size = #haystack
	local matchBonus = table.create(size)
	local lastByte = 47

	local slashMatchScore = configuration.SlashMatchScore
	local wordMatchScore = configuration.WordMatchScore
	local dotMatchScore = configuration.DotMatchScore
	local capitalMatchScore = configuration.CapitalMatchScore

	for index = 1, size do
		local thisByte = string.byte(haystack, index)
		if lastByte == 47 or lastByte == 92 then
			matchBonus[index] = slashMatchScore
		elseif lastByte == 45 or (lastByte == 95 or lastByte == 32) then
			matchBonus[index] = wordMatchScore
		elseif lastByte == 46 then
			matchBonus[index] = dotMatchScore
		elseif lastByte >= 97 and lastByte <= 122 and thisByte >= 65 and thisByte <= 90 then
			matchBonus[index] = capitalMatchScore
		else
			matchBonus[index] = 0
		end

		lastByte = thisByte
	end

	return matchBonus
end

local function Compute(
	configuration: FzyConfiguration,
	needle: string,
	haystack: string,
	D: {{number}},
	M: {{number}}
): ()
	-- Note that the match bonuses must be computed before the arguments are
	-- converted to lowercase, since there are bonuses for camelCase.

	local matchBonus = PreComputeBonus(configuration, haystack)
	local needleLength = #needle
	local haystackLength = #haystack

	if not configuration.CaseSensitive then
		needle = string.lower(needle)
		haystack = string.lower(haystack)
	end

	-- Because lua only grants access to chars through substring extraction,
	-- get all the characters from the haystack once now, to reuse below.

	-- checking with string.byte is actually faster than checking with string.sub
	-- so lets use that here!
	local haystackBytes: {number} = table.create(haystackLength)
	for index = 1, haystackLength do
		haystackBytes[index] = string.byte(haystack, index)
	end

	local gapTrailingScore = configuration.GapTrailingScore
	local gapInnerScore = configuration.GapInnerScore
	local gapLeadingScore = configuration.GapLeadingScore
	local consecutiveMatchScore = configuration.ConsecutiveMatchScore

	for index = 1, needleLength do
		local arrayD = table.create(haystackLength)
		local arrayM = table.create(haystackLength)
		D[index] = arrayD
		M[index] = arrayM

		local previousScore = MIN_SCORE
		local gapScore = if index == needleLength then gapTrailingScore else gapInnerScore
		local needleByte = string.byte(needle, index)

		for jndex = 1, haystackLength do
			if needleByte == haystackBytes[jndex] then
				local score = MIN_SCORE
				if index == 1 then
					score = (jndex - 1) * gapLeadingScore + matchBonus[jndex]
				elseif jndex > 1 then
					local scoreA = M[index - 1][jndex - 1] + matchBonus[jndex]
					local scoreB = D[index - 1][jndex - 1] + consecutiveMatchScore
					score = math.max(scoreA, scoreB)
				end

				arrayD[jndex] = score
				previousScore = math.max(score, previousScore + gapScore)
				arrayM[jndex] = previousScore
			else
				arrayD[jndex] = MIN_SCORE
				previousScore += gapScore
				arrayM[jndex] = previousScore
			end
		end
	end
end

--[=[
	Computes whether a needle or haystack are a perfect match or not

	@function IsPerfectMatch
	@within FastFzy

	@param configuration FzyConfiguration
	@param needle string -- must be a subsequence of `haystack`, or the result is undefined.
	@param haystack string
	@return boolean
]=]
local function IsPerfectMatch(configuration: FzyConfiguration, needle: string, haystack: string): boolean
	return if configuration.CaseSensitive then needle == haystack else string.lower(needle) == string.lower(haystack)
end
FastFzy.IsPerfectMatch = IsPerfectMatch

--[=[
	Compute a matching score.

	@function Score
	@within FastFzy

	@param configuration FzyConfiguration
	@param needle string -- must be a subsequence of `haystack`, or the result is undefined.
	@param haystack string
	@return number -- higher scores indicate better matches. See also [FastFzy.GetMinScore] and [FastFzy.GetMaxScore].
]=]
local function Score(configuration: FzyConfiguration, needle: string, haystack: string): number
	local needleLength = #needle
	local haystackLength = #haystack

	if
		needleLength == 0
		or haystackLength == 0
		or haystackLength > configuration.MaxMatchLength
		or needleLength > haystackLength
	then
		return MIN_SCORE
	end

	if IsPerfectMatch(configuration, needle, haystack) then
		return MAX_SCORE
	end

	local D = table.create(needleLength)
	local M = table.create(needleLength)
	Compute(configuration, needle, haystack, D, M)
	return M[needleLength][haystackLength]
end
FastFzy.Score = Score

--[=[
	Compute the locations where fzy matches a string.

	Determine where each character of the `needle` is matched to the `haystack`
	in the optimal match.

	@function Positions
	@within FastFzy

	@param configuration FzyConfiguration
	@param needle string -- must be a subsequence of `haystack`, or the result is undefined.
	@param haystack string

	@return {int} -- indices, where `indices[n]` is the location of the `n`th character of `needle` in `haystack`.
	@return number -- the same matching score returned by `score`
]=]
local function Positions(configuration: FzyConfiguration, needle: string, haystack: string): ({number}, number)
	local needleLength = #needle
	local haystackLength = #haystack

	if
		needleLength == 0
		or haystackLength == 0
		or haystackLength > configuration.MaxMatchLength
		or needleLength > haystackLength
	then
		return {}, MIN_SCORE
	end

	if IsPerfectMatch(configuration, needle, haystack) then
		local consecutive = table.create(needleLength)
		for index = 1, needleLength do
			consecutive[index] = index
		end

		return consecutive, MAX_SCORE
	end

	local D = table.create(needleLength)
	local M = table.create(needleLength)
	Compute(configuration, needle, haystack, D, M)

	local consecutiveMatchScore = configuration.ConsecutiveMatchScore

	local positions = table.create(needleLength)
	local matchRequired = false
	local jndex = haystackLength
	for index = needleLength, 1, -1 do
		while jndex >= 1 do
			if D[index][jndex] ~= MIN_SCORE and (matchRequired or D[index][jndex] == M[index][jndex]) then
				matchRequired = index ~= 1
					and jndex ~= 1
					and M[index][jndex] == D[index - 1][jndex - 1] + consecutiveMatchScore

				positions[index] = jndex
				jndex -= 1
				break
			end

			jndex -= 1
		end
	end

	return positions, M[needleLength][haystackLength]
end
FastFzy.Positions = Positions

--[=[
	Apply [FastFzy.HasMatch] and [FastFzy.Positions] to an array of haystacks.

	Returns an array with one entry per matching line in `haystacks`,
	each entry giving the index of the line in `haystacks` as well as
	the equivalent to the return value of `positions` for that line.

	:::info Notice
	For Luau, I'd recommend using [FastFzy.BetterFilter] instead, as
	this specific function doesn't really have the best Luau support.
	:::

	@param configuration FzyConfiguration
	@param needle string
	@param haystack {string}
	@return {{idx, positions, score}, ...}
]=]
function FastFzy.Filter(configuration: FzyConfiguration, needle: string, haystack: {string}): {{number | {number}}}
	local result: {{number | {number}}} = {}
	local length = 0

	for index, line in haystack do
		if HasMatch(configuration, needle, line) then
			local position, score = Positions(configuration, needle, line)
			length += 1
			result[length] = {index, position, score}
		end
	end

	return result
end

--[=[
	An interface returned by [FastFzy.BetterFilter].
	@interface FilterResult
	@field Index number -- The index of the line in `haystacks`.
	@field Positions {int} -- The positions of the `needle` in `haystack`.
	@field Score number -- The score returned by [FastFzy.Score]
	@field String string -- The line in `haystacks`.
	@within FastFzy
]=]
export type FilterResult = {
	Index: number,
	Positions: {number},
	Score: number,
	String: string,
}

--[=[
	An alternative to [FastFzy.Filter] that returns an array of [FastFzy.FilterResult]. This
	is more ideal for Luau at the cost of some speed, as Luau does not support strict arrays
	the same way that TypeScript would

	@param configuration FzyConfiguration
	@param needle string
	@param haystack {string}
	@return {FilterResult}
]=]
function FastFzy.BetterFilter(configuration: FzyConfiguration, needle: string, haystack: {string}): {FilterResult}
	local result = {}
	local length = 0

	for index, line in haystack do
		if HasMatch(configuration, needle, line) then
			local positions, score = Positions(configuration, needle, line)
			length += 1
			result[length] = {
				Index = index;
				Positions = positions;
				Score = score;
				String = line;
			}
		end
	end

	return result
end

--[=[
	Gets the highest scored match.

	@param configuration FzyConfiguration
	@param needle string
	@param haystack {string}
	@return string?
]=]
function FastFzy.GetHighestScoredMatch(configuration: FzyConfiguration, needle: string, haystack: {string}): string?
	local highestScore = MIN_SCORE
	local match: string? = nil

	for _, value in haystack do
		local score = Score(configuration, needle, value)
		if score > highestScore then
			match = value
			highestScore = score
		end
	end

	return match
end

--[=[
	The lowest value returned by `score`.

	In two special cases:
	 - an empty `needle`, or
	 - a `needle` or `haystack` larger than than [FastFzy.GetMaxLength],

	the [FastFzy.Score] function will return this exact value, which can be used as a
	sentinel. This is the lowest possible score.

	@return number
]=]
function FastFzy.GetMinScore(): number
	return MIN_SCORE
end

--[=[
	The score returned for exact matches. This is the highest possible score.

	@return number
]=]
function FastFzy.GetMaxScore(): number
	return MAX_SCORE
end

--[=[
	The maximum size for which `fzy` will evaluate scores.

	@param configuration FzyConfiguration
	@return number
]=]
function FastFzy.GetMaxLength(configuration: FzyConfiguration): number
	local typeSuccess, typeError = isFzyConfiguration:matches(configuration)
	if not typeSuccess then
		local exception = Error.new(tostring(typeError))
		exception.name = "TypeError"
		Error.captureStackTrace(exception, FastFzy.GetMaxLength)
		error(exception)
	end

	return configuration.MaxMatchLength
end

--[=[
	The minimum score returned for normal matches.

	For matches that don't return [FastFzy.GetMinScore], their score will be greater
	than than this value.

	@param configuration FzyConfiguration
	@return number
]=]
function FastFzy.GetScoreFloor(configuration: FzyConfiguration): number
	local typeSuccess, typeError = isFzyConfiguration:matches(configuration)
	if not typeSuccess then
		local exception = Error.new(tostring(typeError))
		exception.name = "TypeError"
		Error.captureStackTrace(exception, FastFzy.GetScoreFloor)
		error(exception)
	end

	return configuration.MaxMatchLength * configuration.GapInnerScore
end

--[=[
	The maximum score for non-exact matches.

	For matches that don't return [FastFzy.GetMaxScore], their score will be less than
	this value.

	@param configuration FzyConfiguration
	@return number
]=]
function FastFzy.GetScoreCeiling(configuration: FzyConfiguration): number
	local typeSuccess, typeError = isFzyConfiguration:matches(configuration)
	if not typeSuccess then
		local exception = Error.new(tostring(typeError))
		exception.name = "TypeError"
		Error.captureStackTrace(exception, FastFzy.GetScoreCeiling)
		error(exception)
	end

	return configuration.MaxMatchLength * configuration.ConsecutiveMatchScore
end

return table.freeze(FastFzy)
