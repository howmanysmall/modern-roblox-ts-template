--!optimize 2
--!strict
--[=[ lunar
	about = "Regenerates the Enums for our unit testing."
]=]

local FormatUtilities = require("@utilities/FormatUtilities")
local LuauPolyfill = require("@packages/LuauPolyfill")
local PathFileSystem = require("@packages/PathFileSystem")
local PromiseUtilities = require("@packages/PromiseUtilities")
local RobloxEnumUtilities = require("@utilities/RobloxEnumUtilities")

local console = LuauPolyfill.console

RobloxEnumUtilities.GenerateEnumsOffline(RobloxEnumUtilities.ReturnType.Array)

local PATH_TO_ENUMS = PathFileSystem.CWD:join(".lune/Packages/Enum/init.luau")

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

type FakeEnumItem = RobloxEnumUtilities.FakeEnumItem

local function SortByValue(a: FakeEnumItem, b: FakeEnumItem): boolean
	return a.Value < b.Value
end
local function ReturnName(value: FakeEnumItem): string
	return value.Name
end

local function HasIncrementalValue(array: {FakeEnumItem}): boolean
	if #array == 0 then
		return false
	end

	local newArray = Sort(array, SortByValue)
	local lastValue = (table.remove(newArray, 1) :: FakeEnumItem).Value
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

local function CreateEnumSetter(enumName: string, enumValues: {FakeEnumItem}, enumNames: {string}): string
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

local enums = RobloxEnumUtilities.GenerateEnumsOffline(RobloxEnumUtilities.ReturnType.Array)

local size = #enums
local stringBuilder = table.create(size + 1)

local allEnumNames = table.create(size)
local returnStringBuilder = {"return Enum :: Enums<{"}

console.log("Starting!")

for index, enum in enums do
	local enumValues = Sort(enum.EnumItems, SortByValue)
	local names = Map(enumValues, ReturnName)
	allEnumNames[index] = `{enum}Root`
	stringBuilder[index] = CreateEnumSetter(enum.Name, enumValues, names)
	returnStringBuilder[index + 1] = `\t{enum}: {enum}Root,`
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

console.log("Formatting...")
local success, source = PromiseUtilities.AwaitMulti(
	FormatUtilities.FormatAsync(string.format(ROOT_STRING, table.concat(stringBuilder, "\n\n")), {
		FormatAmount = 2;
		FormatWith = "stylua2-dg";
	})
)
console.log("Writing...")

if success then
	PathFileSystem.WriteFile(PATH_TO_ENUMS, source)
else
	console.error(`Failed to format the enums - {source}`)
end
