--!optimize 2
--!strict

local GreenTea = require("@packages/GreenTea")
local GreenTeaAssert = require("@functions/GreenTeaAssert")
local GreenTeaUtilities = require("@packages/GreenTeaUtilities")
local LuauPolyfill = require("@packages/LuauPolyfill")
local TypeError = require("@errors/TypeError")
local roblox = require("@lune/roblox")

local console = LuauPolyfill.console

local RobloxEnumUtilities = {}

local ReturnType = table.freeze({
	Array = "Array" :: "Array";
	Dictionary = "Dictionary" :: "Dictionary";
})
export type ReturnType = "Array" | "Dictionary"
RobloxEnumUtilities.ReturnType = ReturnType

local IsReturnTypeRaw = GreenTeaUtilities.SmartLiteralValues(ReturnType) :: ReturnType

local IsMaybeReturnType = GreenTea.build(GreenTea.optional(IsReturnTypeRaw) :: ReturnType?)

-- local function AsReturnType(returnType: ReturnType): ReturnType
-- 	return returnType
-- end

export type FakeEnumItem = {
	Name: string,
	Value: number,
}
local function AsFakeEnumItem(fakeEnumItem: FakeEnumItem): FakeEnumItem
	return if table.isfrozen(fakeEnumItem) then fakeEnumItem else table.freeze(fakeEnumItem)
end
local function AsFakeEnumItems(fakeEnumItems: {FakeEnumItem}): {FakeEnumItem}
	return if table.isfrozen(fakeEnumItems) then fakeEnumItems else table.freeze(fakeEnumItems)
end
export type FakeEnum = {
	EnumItems: {FakeEnumItem},
	Name: string,
}
local function AsFakeEnum(fakeEnum: FakeEnum): FakeEnum
	return if table.isfrozen(fakeEnum) then fakeEnum else table.freeze(fakeEnum)
end

local function Sort<T>(array: {T}, callback: nil | (a: T, b: T) -> boolean): {T}
	local new = table.clone(array)
	table.sort(new, callback)
	return new
end
local function SortByValue(a: FakeEnumItem, b: FakeEnumItem): boolean
	return a.Value < b.Value
end
local function ExhaustiveMatch(value: never): never
	error(`Unknown value in exhaustive match: {value}`)
end

type GenerateEnumsOffline =
	& ((returnType: "Array") -> {FakeEnum})
	& ((returnType: "Dictionary") -> {[string]: {FakeEnumItem}})
	& ((returnType: ReturnType?) -> {[string]: {FakeEnumItem}})

local cachedEnums: {[ReturnType]: {FakeEnum} | {[string]: {FakeEnumItem}}} = {}

local function GetEnumItems(items: {[string]: number}): {FakeEnumItem}
	local enumItems: {FakeEnumItem} = {}
	local enumItemsLength = 0

	for name, value in items do
		enumItemsLength += 1
		enumItems[enumItemsLength] = AsFakeEnumItem({
			Name = name;
			Value = value;
		})
	end

	return AsFakeEnumItems(Sort(enumItems, SortByValue))
end

local function GenerateEnumsOffline(returnType: ReturnType?): {FakeEnum} | {[string]: {FakeEnumItem}}
	GreenTeaAssert(IsMaybeReturnType, returnType, GenerateEnumsOffline, TypeError)

	local trueReturnType: ReturnType = returnType or ReturnType.Dictionary
	local cached = cachedEnums[trueReturnType]
	if cached then
		return cached
	end

	local reflectionDatabase = roblox.getReflectionDatabase()
	local enumNames = Sort(reflectionDatabase:GetEnumNames())

	if trueReturnType == ReturnType.Array then
		local enums: {FakeEnum} = table.create(#enumNames)
		local enumsLength = 0

		for _, enumName in enumNames do
			local enum = reflectionDatabase:GetEnum(enumName)
			if not enum then
				console.error(`Failed to get enum '{enumName}'?`)
				continue
			end

			enumsLength += 1
			enums[enumsLength] = AsFakeEnum({
				EnumItems = GetEnumItems(enum.Items);
				Name = enumName;
			})
		end

		cachedEnums[trueReturnType] = table.freeze(enums)
		return enums
	end

	if trueReturnType == ReturnType.Dictionary then
		local enums: {[string]: {FakeEnumItem}} = {}
		for _, enumName in enumNames do
			local enum = reflectionDatabase:GetEnum(enumName)
			if not enum then
				console.error(`Failed to get enum '{enumName}'?`)
				continue
			end
			enums[enumName] = GetEnumItems(enum.Items)
		end

		cachedEnums[trueReturnType] = table.freeze(enums)
		return enums
	end

	ExhaustiveMatch(trueReturnType)
	error("unreachable")
end
RobloxEnumUtilities.GenerateEnumsOffline = GenerateEnumsOffline :: GenerateEnumsOffline

return table.freeze(RobloxEnumUtilities)
