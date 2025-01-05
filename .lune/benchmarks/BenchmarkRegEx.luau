--!optimize 2
--!strict

local RegEx = require("@lune/regex")
local SpeedTester = require("./SpeedTester")
local StringUtilities = require("@utilities/StringUtilities")
local process = require("@lune/process")
local stdio = require("@lune/stdio")

local Benchmark = {}
Benchmark.BarGraphMultiplier = 70
Benchmark.TimeThreshold = 1
Benchmark.ArraySize = 1000

function Benchmark.Configure()
	local barGraphMultiplier =
		stdio.prompt("text", "What should the BarGraphMultiplier be?", tostring(Benchmark.BarGraphMultiplier))
	Benchmark.BarGraphMultiplier = StringUtilities.GetNumberFromString(barGraphMultiplier, Benchmark.BarGraphMultiplier)

	local timeThreshold = stdio.prompt("text", "What should the TimeThreshold be?", tostring(Benchmark.TimeThreshold))
	Benchmark.TimeThreshold = StringUtilities.GetNumberFromString(timeThreshold, Benchmark.TimeThreshold)

	local arraySize = stdio.prompt("text", "What should the ArraySize be?", tostring(Benchmark.ArraySize))
	Benchmark.ArraySize = StringUtilities.GetNumberFromString(arraySize, Benchmark.ArraySize)
end

local hasDriveLetter = RegEx.new("^[a-z-A-Z]:[\\\\/]")
local isUncPath = RegEx.new("^\\\\")
local IsMatch = hasDriveLetter.isMatch

local POSSIBLE_PATHS = table.pack(
	process.cwd,
	"/",
	"C:\\Path\\stylua2.exe",
	"C:/Path/stylua2.exe",
	"NoWay",
	"Bad\\Path",
	"Bad/Path",
	"\\Unc\\Path"
)

function Benchmark.Run()
	local benchmarks = {}
	local size = Benchmark.ArraySize

	local array = (function()
		local randomPaths: {string} = table.create(size)
		for index = 1, size do
			randomPaths[index] = POSSIBLE_PATHS[math.random(POSSIBLE_PATHS.n)]
		end
		return randomPaths
	end)()

	benchmarks["string"] = function()
		local valid = table.create(size)
		for index, path in array do
			valid[index] = string.match(path, "^[a-zA-Z]:[\\/]") ~= nil or string.match(path, "^\\\\") ~= nil
		end
		return valid
	end

	benchmarks["RegEx"] = function()
		local valid = table.create(size)
		for index, path in array do
			valid[index] = hasDriveLetter:isMatch(path) or isUncPath:isMatch(path)
		end
		return valid
	end

	benchmarks["RegEx (cached)"] = function()
		local valid = table.create(size)
		for index, path in array do
			valid[index] = IsMatch(hasDriveLetter, path) or IsMatch(isUncPath, path)
		end
		return valid
	end

	SpeedTester(benchmarks, {
		BarGraphMultiplier = Benchmark.BarGraphMultiplier;
		TimeThreshold = Benchmark.TimeThreshold;
		TitleText = "Benchmark";
	})

	return 0
end

return Benchmark
