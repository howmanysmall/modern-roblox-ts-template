--!optimize 2
--!strict

local PromptFor = require("@utilities/PromptFor")
local SpeedTester = require("@utilities/SpeedTester")

local Benchmark = {}
Benchmark.ArraySize = 1E5
Benchmark.BarGraphMultiplier = 70
Benchmark.TimeThreshold = 1

Benchmark.Configure = PromptFor

function Benchmark.Run(): number
	local benchmarks = {}

	local arraySize = Benchmark.ArraySize
	local array = table.create(arraySize)
	for index = 1, arraySize do
		array[index] = index
	end

	local function WriteU16(_: number): () end
	local function ValueWrite(_: number): () end

	benchmarks["generalized"] = function(): ()
		local length = #array
		WriteU16(length)
		for _, value in array do
			ValueWrite(value)
		end
	end

	benchmarks["numeric"] = function(): ()
		local length = #array
		WriteU16(length)
		for index = 1, length do
			ValueWrite(array[index])
		end
	end

	SpeedTester.SpeedTester(benchmarks, {
		BarGraphMultiplier = Benchmark.BarGraphMultiplier;
		TimeThreshold = Benchmark.TimeThreshold;
		TitleText = "Array Iteration Benchmark";
	})

	return 0
end

return Benchmark
