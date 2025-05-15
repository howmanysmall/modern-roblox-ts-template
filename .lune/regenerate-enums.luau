--!optimize 2
--!strict
--[=[ lunar
	about = "Regenerates the Enums for our unit testing."
]=]

local ApiDumpUtilities = require("@utilities/ApiDumpUtilities")
local FormatUtilities = require("@utilities/FormatUtilities")
local GetGlobalTypesAsync = require("@promises/GetGlobalTypesAsync")
local LuauPolyfill = require("@packages/LuauPolyfill")
local PathFileSystem = require("@packages/PathFileSystem")
local PromiseUtilities = require("@packages/PromiseUtilities")

local Await = PromiseUtilities.Await
local console = LuauPolyfill.console

local PATH_TO_ENUMS = PathFileSystem.CWD:join(".lune/Packages/Enum/init.luau")

local apiDump = Await(ApiDumpUtilities.GetEnumsFromDumpAsync())
local globalTypes = Await(GetGlobalTypesAsync(true))

local function CreateItemType(enumName: string, enumNames: {string}): string
	local stringBuilder = table.create(#enumNames)
	for index, enumValue in enumNames do
		stringBuilder[index] = string.format("\t| EnumItem<number, %*, %q>", enumName, enumValue)
	end
	return `export type {enumName} =\n{table.concat(stringBuilder, "\n")}`
end
local function CreateEnumType(enumName: string, enumNames: {string}): string
	local stringBuilder = table.create(#enumNames)
	for index, enumValue in enumNames do
		stringBuilder[index] = string.format("\t%*: EnumItem<number, %*, %q>,", enumValue, enumName, enumValue)
	end
	return `export type {enumName}Root = EnumObject<\{\n{table.concat(stringBuilder, "\n")}\n}, {enumName}>`
end

local function Map<T, U>(array: {T}, callback: (value: T) -> U): {U}
	local new = table.create(#array)
	for index, value in array do
		new[index] = callback(value)
	end
	return new
end
local function Sort<T>(array: {T}, callback: nil | (a: T, b: T) -> boolean): {T}
	local new = table.clone(array)
	table.sort(new, callback)
	return new
end

type EnumItem = {
	Name: string,
	Value: number,
}

local function SortByValue(a: EnumItem, b: EnumItem): boolean
	return a.Value < b.Value
end
local function ReturnName(value: EnumItem): string
	return value.Name
end

local function HasIncrementalValue(array: {EnumItem}): boolean
	if #array == 0 then
		return false
	end

	local newArray = Sort(array, SortByValue)
	local lastValue = (table.remove(newArray, 1) :: EnumItem).Value
	if lastValue ~= 0 then
		return false
	end

	for _, entry in newArray do
		local value = entry.Value
		if lastValue + 1 ~= value then
			return false
		end
		lastValue = value
	end

	return true
end

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

local function IsNumber(value: string): boolean
	local byte = string.byte(value, 1, 1)
	return byte > 47 and byte < 58
end
local function IsNotLuauIdentifier(value: unknown): boolean
	return not (
		type(value) ~= "string"
		or #value == 0
		or string.find(value, "[^%d%a_]")
		or IsNumber(value)
		or LUAU_KEYWORDS[value]
	)
end

local function CreateEnumSetter(enumName: string, enumValues: {EnumItem}, enumNames: {string}): string
	local stringBuilder = table.create(#enumValues)
	local enumString: string = nil
	local beforeAfterBraces = ""

	if HasIncrementalValue(enumValues) then
		for index, enumValue in enumNames do
			stringBuilder[index] = string.format("%q", enumValue)
		end
		enumString = table.concat(stringBuilder, ", ")
	else
		for index, enumValue in enumValues do
			local name = enumValue.Name
			if IsNotLuauIdentifier(name) then
				stringBuilder[index] = `\t{name} = {enumValue.Value};`
			else
				stringBuilder[index] = string.format("\t%q = %*;", name, enumValue.Value)
			end
		end
		enumString = table.concat(stringBuilder, "\n")
		beforeAfterBraces = "\n"
	end

	return `{CreateItemType(enumName, enumNames)}\n{CreateEnumType(enumName, enumNames)}\nEnum.{enumName} = \{{beforeAfterBraces}{enumString}{beforeAfterBraces}}`
end

local function Filter<T>(array: {T}, predicate: (value: T) -> boolean): {T}
	local new = table.create(#array)
	local length = 0

	for _, value in array do
		if predicate(value) then
			length += 1
			new[length] = value
		end
	end

	return new
end

local enums = Sort(
	Filter(apiDump.Enums, function(enum)
		return string.find(globalTypes, `Enum{enum.Name}`) ~= nil
	end),
	function(a, b): boolean
		return a.Name < b.Name
	end
)

local size = #enums
local stringBuilder = table.create(size + 1)

local allEnumNames = table.create(size)
local returnStringBuilder = {"return Enum :: Enums<{"}

for index, enum in enums do
	local enumValues = Sort(enum.Items, SortByValue)
	local enumName = enum.Name
	local enumNames = Map(enumValues, ReturnName)
	allEnumNames[index] = `{enumName}Root`
	stringBuilder[index] = CreateEnumSetter(enumName, enumValues, enumNames)
	returnStringBuilder[index + 1] = `\t{enumName}: {enumName}Root,`
end
returnStringBuilder[size + 1] = `}, {table.concat(allEnumNames, " | ")}>`
stringBuilder[size + 1] = table.concat(returnStringBuilder, "\n")

local ROOT_STRING = [[--!nocheck
--!optimize 2

local Enum = require("@self/Enum")

type SimpleResult<T, E> = {
	Success: true,
	Value: T,
} | {
	Success: false,
	Error: E,
}

type EnumItem<Value, Type, Name = string> = {
	EnumType: Type,
	Name: Name,
	Value: Value,
}
type EnumObject<Values, ArrayValues> = {
	Cast: ((self: EnumObject<Values, ArrayValues>, check: unknown) -> ArrayValues)
		& ((self: EnumObject<Values, ArrayValues>, check: unknown) -> (false, string)),
	CastResult: (self: EnumObject<Values, ArrayValues>, check: unknown) -> SimpleResult<ArrayValues, string>,
	GetEnumItems: (self: EnumObject<Values, ArrayValues>) -> {ArrayValues},
} & Values

type Enums<Values, ArrayValues> = {
	GetEnums: (self: Enums<Values, ArrayValues>) -> {ArrayValues},
} & Values

%*]]

local success, source = PromiseUtilities.AwaitMulti(
	FormatUtilities.FormatAsync(string.format(ROOT_STRING, table.concat(stringBuilder, "\n\n")), {
		FormatAmount = 2;
		FormatWith = "stylua2-dg";
	})
)
if success then
	PathFileSystem.WriteFile(PATH_TO_ENUMS, source)
else
	console.error(`Failed to format the enums - {source}`)
end
