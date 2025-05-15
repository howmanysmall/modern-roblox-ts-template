--!native
--!optimize 2
--!strict

local ScriptEditorService = game:GetService("ScriptEditorService")
local Workspace = game:GetService("Workspace")

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

local function SortByValue(a: EnumItem, b: EnumItem): boolean
	return a.Value < b.Value
end
local function ReturnName(value: EnumItem): string
	return value.Name
end

local function HasIncrementalValue(array: {EnumItem}): boolean
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

local enums = Sort(Enum:GetEnums(), function(a: Enum, b: Enum): boolean
	return tostring(a) < tostring(b)
end)

local size = #enums
local stringBuilder = table.create(size + 1)

local allEnumNames = table.create(size)
local returnStringBuilder = {"return Enum :: Enums<{"}

for index, enum in enums do
	local enumValues = Sort(enum:GetEnumItems(), SortByValue)
	local enumName = tostring(enum)
	local enumNames = Map(enumValues, ReturnName)
	allEnumNames[index] = `{enumName}Root`
	stringBuilder[index] = CreateEnumSetter(enumName, enumValues, enumNames)
	returnStringBuilder[index + 1] = `\t{enumName}: {enumName}Root,`
end
returnStringBuilder[size + 1] = `}, {table.concat(allEnumNames, " | ")}>`
stringBuilder[size + 1] = table.concat(returnStringBuilder, "\n")

local moduleScript = Instance.new("ModuleScript")
moduleScript.Name = "Exports"

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

ScriptEditorService:UpdateSourceAsync(moduleScript, function(): string
	return string.format(ROOT_STRING, table.concat(stringBuilder, "\n\n"))
end)
moduleScript.Parent = Workspace

return true
