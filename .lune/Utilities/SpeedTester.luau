--!optimize 2
--!strict

local Chalk = require("@packages/Chalk")
local ProgressBar = require("@utilities/ProgressBar")

local boldGreen = Chalk.Bold .. Chalk.GreenBright
local boldRed = Chalk.Bold .. Chalk.RedBright
local boldYellow = Chalk.Ansi(33)
local blue = Chalk.Ansi256(39)
local boldBlue = Chalk.Bold .. blue

--[=[
	A function that benchmarks functions against each other.
	@class SpeedTester
	@ignore
]=]

type TimeEntry = {
	Function: () -> (),
	Name: string,
	Time: number,
}

local function SortByTime(a: TimeEntry, b: TimeEntry): boolean
	return a.Time < b.Time
end

--[=[
	@interface IOptions
	.BarGraphMultiplier? number -- The multiplier for the bar graph, a higher number means longer bars which is obviously more precise. Defaults to 50.
	.TimeThreshold? number -- The time at which the function benchmarking stops. Defaults to 1.
	.TitleText? string -- The title of the benchmark. Defaults to "No Title Given".
	@within SpeedTester
]=]
type Options = {
	BarGraphMultiplier: number?,
	TimeThreshold: number?,
	TitleText: string?,
}

--[=[
	Performs a benchmark.

	@function SpeedTester
	@param FunctionsTable {[string]: () -> ()} -- The functions you are speed testing.
	@param Options IOptions? -- The options for the benchmark.
	@within SpeedTester
]=]
local function SpeedTester(functionsTable: {[string]: () -> ()}, options: Options?): ()
	if not functionsTable or type(functionsTable) ~= "table" then
		error("FunctionsTable doesn't exist or isn't a table.")
	end

	local trueOptions: Options = if options then options else {}
	local barGraphMultiplier = trueOptions.BarGraphMultiplier or 50
	local timeThreshold = trueOptions.TimeThreshold or 1
	local titleText = trueOptions.TitleText or "No Title Given"

	local barOptions = {
		Length = barGraphMultiplier;
		PrintEnd = "";
		PrintStart = "";
		Surrounding = "";
	}

	do
		local timesArray: {TimeEntry} = {}
		local totalFunctions = 0

		for name, benchmark in functionsTable do
			totalFunctions += 1
			timesArray[totalFunctions] = {
				Function = benchmark;
				Name = name;
				Time = 0;
			}
		end

		repeat
			local longestTime = 0
			for _, timeEntry in timesArray do
				local benchmark = timeEntry.Function
				local previousTime = timeEntry.Time

				local startTime = os.clock()
				benchmark()
				local time = os.clock() - startTime + previousTime

				if time > longestTime then
					longestTime = time
				end

				timeEntry.Time = time
			end
		until longestTime > timeThreshold

		table.sort(timesArray, SortByTime)
		local slowestFunction = timesArray[totalFunctions]

		print(
			`In {Chalk.Bold(titleText)}, {boldGreen(timesArray[1].Name)} is {boldBlue(
				string.format("%.2f%%", 100 - 100 * (timesArray[1].Time / slowestFunction.Time))
			)} faster than {boldRed(slowestFunction.Name)}`
		)

		local barLengths: {number} = table.create(totalFunctions)
		local maxLength = -1
		for order, timeEntry in timesArray do
			local length = timeEntry.Time * barGraphMultiplier / slowestFunction.Time
			maxLength = math.max(maxLength, length)
			barLengths[order] = length
		end

		for order, timeEntry in timesArray do
			print(
				`\t[{blue(tostring(order))}] {boldYellow(timeEntry.Name)}:\n\t{ProgressBar(
					barLengths[order],
					maxLength,
					barOptions
				)}`
			)
		end
	end
end

local Metatable = {}
function Metatable:__call(functionsTable: {[string]: () -> ()}, options: Options?): ()
	return SpeedTester(functionsTable, options)
end

return setmetatable({SpeedTester = SpeedTester}, Metatable)
