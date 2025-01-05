--!optimize 2
--!strict

local SpeedTester = require("./SpeedTester")
local StringUtilities = require("@utilities/StringUtilities")
local stdio = require("@lune/stdio")

local Benchmark = {}
Benchmark.BarGraphMultiplier = 70
Benchmark.TimeThreshold = 1

function Benchmark.Configure()
	local barGraphMultiplier =
		stdio.prompt("text", "What should the BarGraphMultiplier be?", tostring(Benchmark.BarGraphMultiplier))
	Benchmark.BarGraphMultiplier = StringUtilities.GetNumberFromString(barGraphMultiplier, Benchmark.BarGraphMultiplier)

	local timeThreshold = stdio.prompt("text", "What should the TimeThreshold be?", tostring(Benchmark.TimeThreshold))
	Benchmark.TimeThreshold = StringUtilities.GetNumberFromString(timeThreshold, Benchmark.TimeThreshold)
end

function Benchmark.Run()
	local benchmarks = {}

	local array = (function()
		local length = math.random(1E4, 1E5)
		local localArray = table.create(length)

		for index = 1, length do
			localArray[index] = index
		end

		return localArray
	end)()

	local function WriteU16(_: number) end
	local function ValueWrite(_: number) end

	benchmarks["generalized"] = function()
		local length = #array
		WriteU16(length)
		for _, value in array do
			ValueWrite(value)
		end
	end

	benchmarks["numeric"] = function()
		local length = #array
		WriteU16(length)

		for index = 1, length do
			ValueWrite(array[index])
		end
	end

	SpeedTester(benchmarks, {
		BarGraphMultiplier = Benchmark.BarGraphMultiplier;
		TimeThreshold = Benchmark.TimeThreshold;
		TitleText = "Array Iteration Benchmark";
	})

	return 0
end

return Benchmark
