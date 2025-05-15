--!optimize 2
--!strict

local LuauPolyfill = require("@packages/LuauPolyfill")
local PathFileSystem = require("@packages/PathFileSystem")
local RegEx = require("@lune/regex")
local process = require("@lune/process")

local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean.toJSBoolean
local String = LuauPolyfill.String
local Path = PathFileSystem.Path

local MATCH_LINE = RegEx.new("^([^=:#]+?)[=:]((.|\n)*)")

local DotEnv = {}

export type Data = {[string]: string}
export type Input = {[string]: unknown}

local function RemoveQuotes(value: string): string
	local firstByte = string.byte(value)
	local finalByte = string.byte(value, -1)
	return if (firstByte == 34 and finalByte == 34) or (firstByte == 39 and finalByte == 39)
		then string.sub(value, 2, -2)
		else value
end

local function JsonValueToEnv(value: unknown): string
	local processedValue = string.gsub(tostring(value), "\n", "\\n")
	return if String.includes(processedValue, "\\n") then `"{processedValue}"` else processedValue
end

local function FixLineBreaks(captured: string): string
	return (string.gsub(captured, "\n", "__LINE_BREAK__"))
end
local function RemoveEmptyLines(value: string): boolean
	return Boolean(String.trim(value))
end
local function UndoLineBreaks(value: string): string
	return (string.gsub(value, "__LINE_BREAK__", "\n"))
end

local function SplitInLines(value: string): {string}
	return Array.map(
		Array.filter(string.split(string.gsub(value, "(\"[%s%S]*?\")", FixLineBreaks), "\n"), RemoveEmptyLines),
		UndoLineBreaks
	)
end

function DotEnv.Parse(source: string): Data
	local result: Data = {}
	for _, line in SplitInLines(source) do
		local captures = MATCH_LINE:captures(line)
		if not captures then
			continue
		end

		local keyMatch = captures:get(1)
		local valueMatch = captures:get(2)
		if keyMatch and valueMatch then
			result[String.trim(keyMatch.text)] = RemoveQuotes(String.trim(valueMatch.text))
		end
	end

	return result
end

function DotEnv.Stringify(object: Input): string
	local result = ""
	for key, value in object do
		local line = `{key}={JsonValueToEnv(value)}`
		result ..= line .. "\n"
	end

	return result
end

function DotEnv.Load(overwrite: boolean?, target: PathFileSystem.AsPath?)
	local trueTarget = Path.from(target or ".env")
	if not PathFileSystem.IsFileSafe(trueTarget) then
		-- error(`No .env file found at {trueTarget}?`)
		return
	end

	local environment = process.env
	for key, value in DotEnv.Parse(PathFileSystem.ReadFile(trueTarget)) do
		if not environment[key] or overwrite then
			environment[key] = value
		end
	end
end

return table.freeze(DotEnv)
