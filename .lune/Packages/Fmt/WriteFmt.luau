--!optimize 2
--!strict

local LuauPolyfill = require("@packages/LuauPolyfill")
local Types = require("./Types")

local Error = LuauPolyfill.Error

type Formatter = Types.Formatter

local repeatCache: {[string]: {[number]: string}} = {}
local function StringRep(value: string, count: number)
	local cache = repeatCache[value]
	if not cache then
		cache = {}
		repeatCache[value] = cache
	end

	local result = cache[count]
	if not result then
		result = string.rep(value, count)
		cache[count] = result
	end

	return result
end

local KEYWORDS = {
	["and"] = true;
	["break"] = true;
	["continue"] = false;
	["do"] = true;
	["else"] = true;
	["elseif"] = true;
	["end"] = true;
	["export"] = false;
	["false"] = true;
	["for"] = true;
	["function"] = true;
	["if"] = true;
	["in"] = true;
	["local"] = true;
	["nil"] = true;
	["not"] = true;
	["or"] = true;
	["repeat"] = true;
	["return"] = true;
	["self"] = false;
	["then"] = true;
	["true"] = true;
	["type"] = false;
	["typeof"] = false;
	["until"] = true;
	["while"] = true;
}

local function IsValidVariable(variable: string)
	return variable ~= "" and KEYWORDS[variable] == nil and string.find(variable, "^[_%a]+[_%w]+$") ~= nil
end
local function Amountify(amount: number)
	return if amount == 1 then "is " .. amount else "are " .. amount
end
local function Pluralize(amount: number, value: string)
	return if amount == 1 then value else value .. "s"
end

local function LeadingZeroes(formatter: Formatter, argument: unknown, argumentLeadingZeroes: number)
	local stringified = tostring(argument)
	if type(argument) == "number" then
		formatter("WriteRaw", StringRep("0", argumentLeadingZeroes - #stringified) .. stringified)
	else
		formatter("WriteRaw", stringified)
	end
end
local function Width(formatter: Formatter, argument: unknown, argumentWidth: number)
	local stringified = tostring(argument)
	formatter("WriteRaw", stringified .. StringRep(" ", argumentWidth - #stringified))
end
local function Precision(formatter: Formatter, argument: unknown, argumentPrecision: number)
	if type(argument) == "number" then
		formatter("WriteRaw", string.format("%." .. argumentPrecision .. "f", argument))
	else
		formatter("WriteRaw", tostring(argument))
	end
end
local function Sign(formatter: Formatter, argument: unknown)
	local stringified = tostring(argument)
	if type(argument) == "number" then
		formatter("WriteRaw", if argument >= 0 then "+" .. stringified else stringified)
	else
		formatter("WriteRaw", stringified)
	end
end

local function DebugTable(formatter: Formatter, object: {[unknown]: unknown})
	formatter("WriteRaw", "{")
	for key, value in object do
		formatter("Write", "[{:?}] = {:?}", key, value)
		if next(object, key) ~= nil then
			formatter("WriteRaw", ", ")
		end
	end
	formatter("WriteRaw", "}")
end
local function DebugTableExtended(formatter: Formatter, object: {[unknown]: unknown})
	if next(object) == nil then
		formatter("WriteRaw", "{}")
	else
		formatter("WriteLineRaw", "{")
		formatter("Indent")

		for key, value in object do
			formatter("Write", "[{:?}] = {:#?}", key, value)
			if next(object, key) ~= nil then
				formatter("WriteRaw", ",")
			end
			formatter("WriteLine", "")
		end

		formatter("Unindent")
		formatter("WriteRaw", "}")
	end
end

local function DebugImplementation(formatter: Formatter, argument: any, isExtendedForm: boolean)
	if type(argument) == "string" then
		formatter("WriteRaw", string.format("%q", argument))
	elseif type(argument) == "table" then
		local argumentMetatable = getmetatable(argument)
		if argumentMetatable and type(argumentMetatable) == "table" then
			local fmtDebug = argumentMetatable.__FmtDebug
			if fmtDebug and type(fmtDebug) == "function" then
				fmtDebug(argument, formatter, isExtendedForm)
				return
			end
		end

		formatter("AddTable", argument)
		formatter("Lock")

		if isExtendedForm then
			DebugTableExtended(formatter, argument)
		else
			DebugTable(formatter, argument)
		end

		formatter("Unlock")
	else
		formatter("WriteRaw", tostring(argument))
	end
end

type Writer = {
	Arguments: {unknown},
	BiggestPositionalParameter: number,
	CurrentArgument: number,
	HadNamedParameter: boolean,
	NamedParameters: {[unknown]: unknown}?,
}

local function Interpolate(formatter: Formatter, parameter: string, writer: Writer)
	local formatParameterStart = string.find(parameter, ":")
	local leftSide = string.sub(parameter, 1, if formatParameterStart then formatParameterStart - 1 else -1)
	local rightSide = if formatParameterStart then string.sub(parameter, formatParameterStart + 1) else nil

	local positionalParameter = tonumber(leftSide)
	local isRegularParameter = leftSide == ""

	local arguments = writer.Arguments
	local argument: unknown

	if positionalParameter then
		if positionalParameter < 0 or positionalParameter % 1 ~= 0 then
			local exception = Error.new("Invalid positional parameter `" .. positionalParameter .. "`.")
			Error.captureStackTrace(exception, Interpolate)
			error(exception, 4)
		end

		if positionalParameter + 1 > #arguments then
			local exception = Error.new(
				`Invalid positional argument {positionalParameter} (there {Amountify(#arguments)} {Pluralize(
					#arguments,
					"argument"
				)}). Note: Positional arguments are zero-based.`
			)
			Error.captureStackTrace(exception, Interpolate)
			error(exception, 4)
		end

		writer.BiggestPositionalParameter = math.max(writer.BiggestPositionalParameter, positionalParameter + 1)
		argument = arguments[positionalParameter + 1]
	elseif isRegularParameter then
		local currentArgument = writer.CurrentArgument + 1
		writer.CurrentArgument = currentArgument
		argument = arguments[currentArgument]
	else
		if not IsValidVariable(leftSide) then
			local exception = Error.new("Invalid named parameter `" .. leftSide .. "`.")
			Error.captureStackTrace(exception, Interpolate)
			error(exception, 4)
		end

		local namedParameters = writer.NamedParameters
		if not namedParameters or namedParameters[leftSide] == nil then
			local exception = Error.new("There is no named argument `" .. leftSide .. "`.")
			Error.captureStackTrace(exception, Interpolate)
			error(exception, 4)
		end

		writer.HadNamedParameter = true
		argument = namedParameters[leftSide]
	end

	if rightSide then
		local number = tonumber(rightSide)
		local firstCharacter = string.byte(rightSide, 1)
		local numberAfterFirstCharacter = tonumber(string.sub(rightSide, 2))

		if rightSide == "?" then
			DebugImplementation(formatter, argument, false)
		elseif rightSide == "#?" then
			DebugImplementation(formatter, argument, true)
		elseif rightSide == "+" then
			Sign(formatter, argument)
		elseif firstCharacter == 46 and numberAfterFirstCharacter then
			Precision(formatter, argument, numberAfterFirstCharacter)
		elseif firstCharacter == 48 and numberAfterFirstCharacter then
			LeadingZeroes(formatter, argument, numberAfterFirstCharacter)
		elseif number and number > 0 then
			Width(formatter, argument, number)
		else
			local exception = Error.new("Unsupported format parameter `" .. rightSide .. "`.")
			Error.captureStackTrace(exception, Interpolate)
			error(exception, 4)
		end
	else
		formatter("WriteRaw", tostring(argument))
	end
end

local function ComposeWriter(arguments: {unknown}): Writer
	local lastArgument = arguments[#arguments]

	return {
		Arguments = arguments;
		BiggestPositionalParameter = 0;
		CurrentArgument = 0;
		HadNamedParameter = false;
		NamedParameters = if type(lastArgument) == "table" then lastArgument :: {[unknown]: unknown} else nil;
	}
end

local function WriteFmt(formatter: Formatter, template: string, ...: unknown)
	local index = 1
	local writer = ComposeWriter({...})
	local length = #template

	while index <= length do
		local brace = string.find(template, "[{}]", index)
		if brace then
			local braceCharacter = string.sub(template, brace, brace)
			if braceCharacter == string.sub(template, brace + 1, brace + 1) then
				formatter("WriteRaw", braceCharacter)
				index = brace + 2
			else
				if braceCharacter == "}" then
					local exception =
						Error.new("Unmatched '}'. If you intended to write '}', you can escape it using '}}'.")
					Error.captureStackTrace(exception, WriteFmt)
					error(exception, 3)
				end

				local closeBrace = string.find(template, "}", index + 1)
				if closeBrace then
					if brace - index > 0 then
						formatter("WriteRaw", string.sub(template, index, brace - 1))
					end

					local formatSpecifier = string.sub(template, brace + 1, closeBrace - 1)
					Interpolate(formatter, formatSpecifier, writer)
					index = closeBrace + 1
				else
					local exception = Error.new(
						"Expected a '}' to close format specifier. If you intended to write '{', you can escape it using '{{'."
					)
					Error.captureStackTrace(exception, WriteFmt)
					error(exception, 3)
				end
			end
		else
			formatter("WriteRaw", string.sub(template, index))
			break
		end
	end

	local numberOfArguments = if writer.HadNamedParameter then #writer.Arguments - 1 else #writer.Arguments

	if writer.CurrentArgument > numberOfArguments then
		local exception = Error.new(
			`{writer.CurrentArgument} {Pluralize(writer.CurrentArgument, "parameter")} found in template string, but there {Amountify(
				numberOfArguments
			)} {Pluralize(numberOfArguments, "argument")}.`
		)
		Error.captureStackTrace(exception, WriteFmt)
		error(exception, 3)
	end

	if numberOfArguments > writer.CurrentArgument and writer.BiggestPositionalParameter < numberOfArguments then
		local exception = Error.new(
			`{writer.CurrentArgument} {Pluralize(writer.CurrentArgument, "parameter")} found in template string, but there {Amountify(
				numberOfArguments
			)} {Pluralize(numberOfArguments, "argument")}.`
		)
		Error.captureStackTrace(exception, WriteFmt)
		error(exception, 3)
	end
end

return WriteFmt
