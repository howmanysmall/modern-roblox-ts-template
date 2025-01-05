--!optimize 2
--!strict

local Chalk = require("@packages/Chalk")
local GreenTea = require("@packages/GreenTea")
local LuauPolyfill = require("@packages/LuauPolyfill")
local ProgressBar = require("@utilities/ProgressBar")

local Error = LuauPolyfill.Error

local boldGreen = Chalk.Bold .. Chalk.GreenBright
local boldRed = Chalk.Bold .. Chalk.RedBright
local boldYellow = Chalk.Ansi(33)
local blue = Chalk.Ansi256(39)
local boldBlue = Chalk.Bold .. blue

type TimeEntry = {
	Function: () -> (),
	Name: string,
	Time: number,
}

local function SortByTime(a: TimeEntry, b: TimeEntry)
	return a.Time < b.Time
end

local isOptionsRaw = {
	BarGraphMultiplier = GreenTea.optional(GreenTea.number({range = "(0, ]"}));
	TimeThreshold = GreenTea.optional(GreenTea.number({range = "(0, ]"}));
	TitleText = GreenTea.optional(GreenTea.string());
}
export type Options = typeof(isOptionsRaw)

local isFunctionsTable = GreenTea.build({
	[GreenTea.string()] = GreenTea.fn(GreenTea.args(), GreenTea.returns());
})
local isMaybeOptions = GreenTea.build(GreenTea.optional(isOptionsRaw))
type Functions = typeof(isFunctionsTable:type())

local function SpeedTester(functionsTable: Functions, options: Options?): ()
	do
		local typeSuccess0, typeError0 = isFunctionsTable:matches(functionsTable)
		if not typeSuccess0 then
			local exception = Error.new(tostring(typeError0))
			exception.name = "TypeError"
			Error.captureStackTrace(exception, SpeedTester)
			error(exception)
		end
		local typeSuccess1, typeError1 = isMaybeOptions:matches(options)
		if not typeSuccess1 then
			local exception = Error.new(tostring(typeError1))
			exception.name = "TypeError"
			Error.captureStackTrace(exception, SpeedTester)
			error(exception)
		end
	end

	if not functionsTable or type(functionsTable) ~= "table" then
		error("FunctionsTable doesn't exist or isn't a table.")
	end

	local trueOptions: Options = options or {}
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

return SpeedTester
