--!optimize 2
--!strict

local DateTime = require("@lune/datetime")
local FastMergeDeep = require("./FastMergeDeep")
local IsArray = require("./IsArray")
local roblox = require("@lune/roblox")

type DateTime = DateTime.DateTime
export type Locale = DateTime.Locale

--[=[
	Indicates that [DateTime]s should be formatted using the
	[DateTime.fromLocalTime] format.

	@interface LocalTimeFormat
	@field Type "LocalTime"
	@field Format string
	@field Locale? string
	@within TableUtilities
]=]
--[=[
	Indicates that [DateTime]s should be formatted using the
	[DateTime.fromUniversalTime] format.

	@interface UniversalTimeFormat
	@field Type "UniversalTime"
	@field Format string
	@field Locale? string
	@within TableUtilities
]=]
--[=[
	Indicates how we should format [DateTime]s.

	@type DateTimeFormatType "UnixTimestamp" | "UnixTimestampMillis" | "IsoDate" | "LocalTimeTable" | "UniversalTimeTable" | LocalTimeFormat | UniversalTimeFormat
	@within TableUtilities
]=]
export type DateTimeFormatType =
	| "UnixTimestamp"
	| "UnixTimestampMillis"
	| "IsoDate"
	| "LocalTimeTable"
	| "UniversalTimeTable"
	| {
		Type: "LocalTime",
		Format: string,
		Locale: Locale?,
	}
	| {
		Type: "UniversalTime",
		Format: string,
		Locale: Locale?,
	}

--[=[
	Configures how the Repr function formats.

	@interface ReprSettings
	@field DateTimeFormatType? DateTimeFormatType -- How to format [DateTime]s.
	@field Pretty? boolean -- Whether to use pretty formatting.
	@field RobloxClassName? boolean -- Whether to include Roblox class names.
	@field RobloxDirectoryToString? boolean -- Whether or not to use the DirectoryToString function, which is a fixed version of [Instance.GetFullName].
	@field RobloxFullName? boolean -- Whether to include Roblox full names.
	@field RobloxProperFullName? boolean -- Whether to include Roblox proper full names.
	@field Semicolons? boolean -- Whether to use semicolons.
	@field SortKeys? boolean -- Whether to sort keys.
	@field Spaces? number -- How many spaces to use.
	@field Tabs? boolean -- Whether to use tabs over spaces.
	@within TableUtilities
]=]
type RequiredReprSettings = {
	DateTimeFormatType: DateTimeFormatType,
	Pretty: boolean,
	RobloxClassName: boolean,
	RobloxDirectoryToString: boolean,
	RobloxFullName: boolean,
	RobloxProperFullName: boolean,
	Semicolons: boolean,
	SortKeys: boolean,
	Spaces: number,
	Tabs: boolean,
	[any]: never,
}
export type ReprSettings = {
	DateTimeFormatType: DateTimeFormatType?,
	Pretty: boolean?,
	RobloxClassName: boolean?,
	RobloxDirectoryToString: boolean?,
	RobloxFullName: boolean?,
	RobloxProperFullName: boolean?,
	Semicolons: boolean?,
	SortKeys: boolean?,
	Spaces: number?,
	Tabs: boolean?,
	[any]: never,
}

local DEFAULT_SETTINGS: RequiredReprSettings = {
	DateTimeFormatType = "UnixTimestamp";
	Pretty = true;
	RobloxClassName = false;
	RobloxDirectoryToString = true;
	RobloxFullName = true;
	RobloxProperFullName = false;
	Semicolons = true;
	SortKeys = true;
	Spaces = 4;
	Tabs = true;
}

local LUAU_KEYWORDS = {
	["and"] = true;
	["break"] = true;
	["do"] = true;
	["else"] = true;
	["elseif"] = true;
	["end"] = true;
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
	["then"] = true;
	["true"] = true;
	["until"] = true;
	["while"] = true;
}

local function IsNumber(value: string)
	local byte = string.byte(value, 1, 1)
	return byte > 47 and byte < 58
end
local function IsLuaIdentifier(value: unknown)
	return not (
		type(value) ~= "string"
		or #value == 0
		or string.find(value, "[^%d%a_]")
		or IsNumber(value)
		or LUAU_KEYWORDS[value]
	)
end

local ToLocalTime = DateTime.now().toLocalTime
local ToUniversalTime = DateTime.now().toUniversalTime
local ToIsoDate = DateTime.now().toIsoDate

local Depth = 0
local Shown: {[any]: any}
local CurrentIndent: string

type TimeTable = DateTime.DateTimeValueReturns

local function GetFloat(number: number): string
	local asString = tostring(number)
	if tonumber(asString) == number then
		return asString
	end

	for index = 15, 99 do
		asString = string.format("%." .. index .. "f", number)
		if tonumber(asString) == number then
			return asString
		end
	end

	error(`Couldn't convert {number} to a float?`, 2)
end

local function IntegerOrFloat(number: number | string)
	local trueNumber = tonumber(number) or 0
	return if trueNumber ~= trueNumber
		then "0 / 0"
		elseif trueNumber % 1 == 0 then string.format("%d", trueNumber)
		else GetFloat(trueNumber)
end

local Repr: (value: any, reprSettings: ReprSettings?) -> string
local FORMATTERS: {[string]: string | (value: any, reprOptions: RequiredReprSettings, tabs: string) -> string} = {
	string = function(newValue: string)
		return string.format("%q", newValue)
	end;
	number = function(newValue: number)
		if newValue ~= newValue then
			return "0/0"
		end

		if newValue == math.huge then
			return "math.huge"
		end

		if newValue == -math.huge then
			return "-math.huge"
		end

		return IntegerOrFloat(newValue)
	end;
	boolean = tostring;
	["nil"] = "nil";
	table = function(newValue: {[any]: any}, reprOptions, tabs)
		if Shown[newValue] then
			return "{CYCLIC}"
		end

		if type(rawget(newValue, "__tostring")) == "function" then
			return tostring(newValue)
		end

		local metatable = getmetatable(newValue :: never)
		if type(metatable) == "table" and type(rawget(metatable, "__tostring")) then
			return tostring(newValue)
		end

		Shown[newValue] = true
		local isArray = IsArray(newValue)

		local pretty = reprOptions.Pretty
		local semicolons = reprOptions.Semicolons

		if isArray then
			local length = #newValue
			if length == 0 then
				Shown[newValue] = false
				return "{}"
			end

			local reprString = {"{"}
			local count = 1

			local reprValues = table.create(length)
			local totalStringLength = 0
			local isMultiline = false

			for index, arrayValue in ipairs(newValue) do
				Depth += 1
				local reprValue = Repr(arrayValue, reprOptions)
				Depth -= 1

				reprValues[index] = reprValue
				if not isMultiline then
					totalStringLength += #reprValue
					if totalStringLength >= 120 then
						isMultiline = true
					end
				end
			end

			local separator = if isMultiline and semicolons then ";" else ","
			local first = true
			if isMultiline and pretty then
				count += 1
				reprString[count] = "\n" .. CurrentIndent .. tabs
			end

			for index, reprValue in reprValues do
				if not first then
					count += 1
					reprString[count] = if isMultiline and pretty then "\n" .. CurrentIndent .. tabs else " "
				end

				count += 1
				reprString[count] = reprValue

				if (isMultiline and pretty) or index < length then
					count += 1
					reprString[count] = separator
				end
				first = false
			end

			Shown[newValue] = false
			if isMultiline and pretty then
				reprString[count + 1] = "\n"
				reprString[count + 2] = tabs
			end
			return table.concat(reprString) .. "}"
		end

		local reprString = {"{", if pretty then "\n" .. CurrentIndent .. tabs else ""}
		local count = 2

		local keyOrder = {}
		local length = 0
		local keyValueStrings = {}
		for key, dictionaryValue in next, newValue do
			Depth += 1
			local keyString = if IsLuaIdentifier(key) then key else "[" .. Repr(key, reprOptions) .. "]"
			local valueString = Repr(dictionaryValue, reprOptions)

			length += 1
			keyOrder[length] = keyString

			keyValueStrings[keyString] = valueString
			Depth -= 1
		end

		if reprOptions.SortKeys then
			table.sort(keyOrder)
		end

		local first = true
		local separator = if semicolons then ";" else ","
		for index, keyString in keyOrder do
			if not first then
				count += 1
				reprString[count] = if pretty then "\n" .. CurrentIndent .. tabs else " "
			end

			count += 1
			reprString[count] = string.format("%* = %*", keyString, keyValueStrings[keyString])

			if pretty or index < length then
				count += 1
				reprString[count] = separator
			end

			first = false
		end

		Shown[newValue] = false
		if pretty then
			reprString[count + 1] = "\n"
			reprString[count + 2] = tabs
		end

		return table.concat(reprString) .. "}"
	end;
	userdata = function(newValue: any)
		local metatable = getmetatable(newValue)
		return if type(metatable) == "table" and type(rawget(metatable, "__tostring")) == "function"
			then tostring(newValue)
			else "<userdata>"
	end;
	buffer = function(newValue: buffer)
		return "<buffer:" .. buffer.tostring(newValue) .. ">"
	end;
	vector = function(newValue: Vector3)
		return string.format(
			"vector(%*, %*, %*)",
			IntegerOrFloat(newValue.X),
			IntegerOrFloat(newValue.Y),
			IntegerOrFloat(newValue.Z)
		)
	end;

	DateTime = function(newValue: DateTime, reprOptions)
		local dateTimeFormatType = reprOptions.DateTimeFormatType

		if type(dateTimeFormatType) == "table" then
			local formatType = dateTimeFormatType.Type
			local format = dateTimeFormatType.Format
			local locale: DateTime.Locale = dateTimeFormatType.Locale or "en"

			return string.format(
				"<DateTime:%*:%*>",
				formatType,
				if formatType == "LocalTime"
					then newValue:formatLocalTime(format, locale)
					else newValue:formatUniversalTime(format, locale)
			)
		end

		if dateTimeFormatType == "IsoDate" then
			return string.format("DateTime.fromIsoDate(%q)", ToIsoDate(newValue))
		end

		if dateTimeFormatType == "UnixTimestamp" then
			return string.format("DateTime.fromUnixTimestamp(%*)", newValue.unixTimestamp)
		end
		if dateTimeFormatType == "UnixTimestampMillis" then
			return string.format("DateTime.fromUnixTimestampMillis(%*)", newValue.unixTimestampMillis)
		end

		if dateTimeFormatType == "LocalTimeTable" then
			local timeTable: TimeTable = ToLocalTime(newValue) :: never
			return string.format(
				"DateTime.fromLocalTime(%*, %*, %*, %*, %*, %*, %*)",
				timeTable.year,
				timeTable.month,
				timeTable.day,
				timeTable.hour,
				timeTable.minute,
				timeTable.second,
				timeTable.millisecond
			)
		end

		local timeTable: TimeTable = ToUniversalTime(newValue) :: never
		return string.format(
			"DateTime.fromUniversalTime(%*, %*, %*, %*, %*, %*, %*)",
			timeTable.year,
			timeTable.month,
			timeTable.day,
			timeTable.hour,
			timeTable.minute,
			timeTable.second,
			timeTable.millisecond
		)
	end;

	["function"] = "<function>";
	thread = "<thread>";

	DatabaseEnum = function(newValue: roblox.DatabaseEnum, reprOptions): string
		return Repr({
			Item = newValue.Items;
			Name = newValue.Name;
		}, reprOptions)
	end;
}

--[=[
	Basically the same as the `repr` function from Python. Formats things in a
	a pretty way.

	@function Repr
	@within TableUtilities

	@param value unknown -- The value to format.
	@param reprSettings? ReprSettings -- The settings to use.
	@return string -- The formatted value.
]=]
function Repr(value: unknown, reprSettings: ReprSettings?): string
	local reprOptions: RequiredReprSettings = FastMergeDeep(DEFAULT_SETTINGS, reprSettings)

	if reprOptions.Tabs then
		CurrentIndent = "\t"
	else
		CurrentIndent = string.rep(" ", reprOptions.Spaces)
	end

	local tabs = string.rep(CurrentIndent, Depth)
	if Depth == 0 then
		Shown = {}
	end

	local typeOf = typeof(value)
	local stringifyOrString = FORMATTERS[typeOf]
	if stringifyOrString then
		return if type(stringifyOrString) == "function"
			then stringifyOrString(value, reprOptions, tabs)
			else stringifyOrString
	end

	local typeString = type(value)
	return if typeString == typeOf then "<" .. typeString .. ">" else "<Lune:" .. typeOf .. ">"
end

return Repr
