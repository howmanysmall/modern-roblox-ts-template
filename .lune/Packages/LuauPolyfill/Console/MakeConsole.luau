--!optimize 2
--!strict

local Chalk = require("@packages/Chalk")
local Collections = require("../Collections")
local Debug = require("@packages/Debug")

local Map = Collections.Map
local inspect = Collections.inspect

local INDENT = "  "

local RED = Chalk.Rgb(243, 53, 53)
local YELLOW = Chalk.Rgb(243, 174, 53)

local STRING_FORMAT_ARGUMENTS: {string} = {"c", "d", "i", "o", "u", "x", "X", "e", "E", "f", "g", "G", "q", "s", "*"}
local FORMAT_ARGUMENTS_MATCH = (function(): string
	local array = {}
	local set = {}
	local length = 0

	for _, key in STRING_FORMAT_ARGUMENTS do
		if set[key] then
			continue
		end

		length += 1
		array[length] = Debug.EscapeString(key)
		set[key] = true
	end

	return `%%[{table.concat(array)}]`
end)()

local function Pack<T...>(...: T...): {[number]: any, n: number}
	-- selene: allow(mixed_table)
	return {
		n = select("#", ...);
		select(1, ...);
	}
end
local function HasStringFormatArguments(formatString: string): boolean
	return string.match(formatString, FORMAT_ARGUMENTS_MATCH) ~= nil
end

type Memoized<T, U> = typeof(setmetatable(
	{} :: {[T]: U},
	{} :: {
		__call: (self: any, index: T) -> U,
		__index: (self: any, index: T) -> U,
	}
))

local function Memoize<T, U>(callback: (index: T) -> U): Memoized<T, U>
	local metatable = {}
	function metatable:__call(index: T): U
		return self[index]
	end

	function metatable:__index(index: T): U
		local value = callback(index)
		self[index] = value
		return value
	end

	return setmetatable({}, metatable) :: Memoized<T, U>
end

local BOLD_GRAY = Chalk.Bold .. Chalk.Gray

local BOLD_INVERSE = Chalk.Bold .. Chalk.Inverse
local BOLD_INVERSES = Memoize(function(color: Chalk.Styler): Chalk.Styler
	return BOLD_INVERSE .. color
end)

local function GetTag(functionName: string, styler: Chalk.Styler?): string
	local tag = ` {string.upper(functionName)} `
	return `{BOLD_GRAY("[")}{if styler then BOLD_INVERSES[styler](tag) else tag}{BOLD_GRAY("]")}`
end

-- local Warn = (function(): (...unknown) -> ()
-- 	if USE_GOOD_WARN then
-- 		local function GoodWarn(...: unknown): ()
-- 			print(YELLOW(Concat(GetTag("Warn", YELLOW), ...)))
-- 		end
-- 		return GoodWarn
-- 	end

-- 	local function BadWarn(...: unknown): ()
-- 		warn(YELLOW(Concat(...)))
-- 	end
-- 	return BadWarn
-- end)()

-- local function ErrorWarn(...: unknown): ()
-- 	print(RED(Concat(GetTag("Error", RED), ...)))
-- end

local function MakeConsole()
	local console = {}
	local indentDepth = 0

	local function indent(): string
		return string.rep(INDENT, indentDepth)
	end

	local function createPrint(name: string, styler: Chalk.Styler?, editsIndent: boolean?): (...unknown) -> ()
		local prefix = GetTag(name, styler)

		local function logFunction(...: unknown): ()
			local length = select("#", ...)
			if length == 0 then
				print()
				if editsIndent then
					indentDepth += 1
				end
				return
			end

			local content = (...)
			if type(content) == "string" and HasStringFormatArguments(content) then
				local arguments = Pack(...)
				local success, value = pcall(string.format, content, table.unpack(arguments, 2, arguments.n))
				if success then
					print(indent() .. prefix, value)
					if editsIndent then
						indentDepth += 1
					end
					return
				end
			end

			local array = table.create(length)
			for index = 1, length do
				local value = select(index, ...)
				array[index] = if type(value) == "string" then value else inspect(value)
			end
			print(indent() .. prefix, table.concat(array, " "))
			if editsIndent then
				indentDepth += 1
			end
		end

		return logFunction
	end

	console.log = createPrint("log", Chalk.White)
	console.info = createPrint("info", Chalk.Blue)
	console.debug = createPrint("debug", Chalk.Cyan)
	console.warn = createPrint("warn", YELLOW or Chalk.Yellow)
	console.error = createPrint("error", RED or Chalk.Red)
	console.group = createPrint("group", Chalk.Magenta, true)
	console.groupCollapsed = createPrint("groupCollapsed", Chalk.Magenta .. Chalk.Dim, true)

	function console.groupEnd(): ()
		if indentDepth > 0 then
			indentDepth -= 1
		end
	end

	local startTimes: Collections.Map<string, number> = Map.new()
	function console.time(label: string?): ()
		local trueLabel = label or "default"
		if startTimes:has(trueLabel) then
			console.warn(`Timer '{trueLabel}' already exists`)
			return
		end

		startTimes:set(trueLabel, os.clock())
	end
	function console.timeEnd(label: string?): ()
		local finishTime = os.clock()
		local trueLabel = label or "default"
		local startTime = startTimes:get(trueLabel)
		if startTime == nil then
			console.warn(`Timer '{trueLabel}' does not exist`)
			return
		end

		console.log(`{trueLabel}: {(finishTime - startTime) * 1000} ms`)
		startTimes:delete(trueLabel)
	end

	return table.freeze(console)
end

return MakeConsole
