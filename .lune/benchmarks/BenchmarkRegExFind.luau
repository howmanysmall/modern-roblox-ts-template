--!optimize 2
--!strict

local HttpPromise = require("@promises/HttpPromise")
local PromiseUtilities = require("@packages/PromiseUtilities")
local PromptFor = require("@utilities/PromptFor")
local RegEx = require("@lune/regex")
local SpeedTester = require("@utilities/SpeedTester")

local Benchmark = {}
Benchmark.BarGraphMultiplier = 70
Benchmark.TimeThreshold = 1
Benchmark.UseStartAt = false

local function StringFind(value: string, pattern: RegEx.Regex, startAt: number?): (number?, number?)
	if startAt then
		value = string.sub(value, startAt)
	end

	local match = pattern:find(value)
	if match then
		return match.start, match.finish
	end

	return nil :: number?, nil :: number?
end

local Find = RegEx.new(".").find
local function StringFindCached(value: string, pattern: RegEx.Regex, startAt: number?): (number?, number?)
	if startAt then
		value = string.sub(value, startAt)
	end

	local match = Find(pattern, value)
	if match then
		return match.start, match.finish
	end

	return nil :: number?, nil :: number?
end

local FIND_PATTERN = RegEx.new("<([^>]+)>([^<]*)")

Benchmark.Configure = PromptFor

function Benchmark.Run(): number
	local html = PromiseUtilities.Await(HttpPromise.PromiseGet("https://example.org/"))
	local startAt = if Benchmark.UseStartAt then 2 else nil

	local benchmarks = {}

	benchmarks["RegEx (inline)"] = function(): (number?, number?)
		local match = FIND_PATTERN:find(if startAt then string.sub(html, startAt) else html)
		if match then
			return match.start, match.finish
		end

		return nil :: number?, nil :: number?
	end
	benchmarks["RegEx (inline, cached)"] = function(): (number?, number?)
		local match = Find(FIND_PATTERN, if startAt then string.sub(html, startAt) else html)
		if match then
			return match.start, match.finish
		end
		return nil :: number?, nil :: number?
	end

	benchmarks["RegEx (function)"] = function(): (number?, number?)
		return StringFind(html, FIND_PATTERN, startAt)
	end
	benchmarks["RegEx (function, cached)"] = function(): (number?, number?)
		return StringFindCached(html, FIND_PATTERN, startAt)
	end

	benchmarks["string.find"] = function(): (number?, number?, string?, string?)
		return string.find(html, "<([^>]+)>([^<]*)", startAt)
	end

	SpeedTester.SpeedTester(benchmarks, {
		BarGraphMultiplier = Benchmark.BarGraphMultiplier;
		TimeThreshold = Benchmark.TimeThreshold;
		TitleText = "RegEx vs string.find Benchmark";
	})

	return 0
end

return Benchmark
