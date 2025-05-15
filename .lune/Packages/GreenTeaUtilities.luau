--!optimize 2
--!strict

local DateTime = require("@lune/DateTime")
local Debug = require("@packages/Debug")
local Error = require("@packages/Error")
local GreenTea = require("@packages/GreenTea")
local LuauPolyfill = require("@packages/LuauPolyfill")
local TypeError = require("@errors/TypeError")

local instanceof = LuauPolyfill.instanceof

local GreenTeaUtilities = {}

local IsMaybeString = GreenTea.build(GreenTea.optional(GreenTea.string()))
local IsTable = GreenTea.build(GreenTea.anyTable())

-- function GreenTeaUtilities.IsEnumeration<T>(enumType: T, name: string, enumeration: any): T
-- 	return GreenTea.withCustom(enumType, function(value: unknown): (boolean, string?)
-- 		local result = enumeration:CastResult(value)
-- 		if result.Success then
-- 			return true
-- 		end

-- 		return false, result.Error
-- 	end, `Enumeration.{name}`)
-- end

local USES_AN = {
	[97] = true;
	[101] = true;
	[105] = true;
	[111] = true;
	[117] = true;
}

local function GetIndefiniteArticle(value: string): string
	return if USES_AN[string.byte(value)] then "an" else "a"
end

function GreenTeaUtilities.IsLuauClass<T, A...>(classRoot: {new: (A...) -> T}, className: string, ...: A...): T
	local classObject = classRoot.new(...)
	local checker = GreenTea.withCustom(classObject, function(value): (boolean, any?)
		if not instanceof(value, classRoot) then
			return false, `expected {GetIndefiniteArticle(className)} {className}, got {Debug.Inspect(value)}`
		end

		return true
	end)

	if type(classObject) == "table" and type(classObject.Destroy) == "function" then
		pcall(function()
			classObject:Destroy()
		end)
	end

	return checker
end

local function InspectTable(classTable: any): string
	if type(classTable) == "table" then
		local metatable = getmetatable(classTable :: any)
		if metatable and type(metatable) == "table" and type(rawget(metatable, "__tostring")) == "function" then
			return tostring(classTable)
		end

		if type(classTable.ClassName) == "string" then
			return classTable.ClassName
		end
	end

	return Debug.Inspect(classTable)
end

type ConstructorClass<T> = {
	new: (...any) -> T,
	[any]: any,
}

function GreenTeaUtilities.IsInstanceOfLuauClassFromTable<T>(luauClass: ConstructorClass<T>, className: string?)
	do
		local typeSuccess0, typeError0 = IsTable:matches(luauClass)
		if not typeSuccess0 then
			local exception = TypeError.new(tostring(typeError0))
			Error.captureStackTrace(exception, GreenTeaUtilities.IsInstanceOfLuauClassFromTable)
			error(exception)
		end
		local typeSuccess1, typeError1 = IsMaybeString:matches(className)
		if not typeSuccess1 then
			local exception = TypeError.new(tostring(typeError1))
			Error.captureStackTrace(exception, GreenTeaUtilities.IsInstanceOfLuauClassFromTable)
			error(exception)
		end
	end
	assert(type(luauClass) == "table", "Luau")

	local trueClassName = className or "class object"
	local indefiniteArticle = if className then GetIndefiniteArticle(className) else "a"

	return GreenTea.withCustom((nil :: never) :: T, function(classObject): (boolean, any?)
		local typeSuccess, typeError = IsTable:matches(classObject)
		if not typeSuccess then
			return false, tostring(typeError)
		end

		local metatable = getmetatable(classObject)
		if not metatable then
			return false,
				`expected {indefiniteArticle} {trueClassName} with a metatable, got {InspectTable(classObject)}`
		end

		if type(metatable) ~= "table" then
			return false,
				`expected {indefiniteArticle} {trueClassName} with a table metatable, got __metatable = {Debug.Inspect(
					metatable
				)}`
		end

		if metatable.__index ~= luauClass then
			return false, `expected {indefiniteArticle} {trueClassName}, got {InspectTable(metatable)}`
		end

		return true
	end)
end

function GreenTeaUtilities.SmartLiteral<T>(...: T): T
	local count = select("#", ...)
	local array = table.create(count)

	for index = 1, count do
		local value = select(index, ...)
		array[index] = GreenTea.literal(value)
	end

	return GreenTea.union(table.unpack(array))
end
GreenTeaUtilities.EasyLiteral = GreenTeaUtilities.SmartLiteral

function GreenTeaUtilities.SmartLiteralArray<T>(array: {T}): T
	local new = table.create(#array)

	for index, value in array do
		new[index] = GreenTea.literal(value)
	end

	return GreenTea.union(table.unpack(new))
end
function GreenTeaUtilities.SmartLiteralValues<T>(object: {[unknown]: T}): T
	local new = table.create(#object)
	local length = 0

	for _, value in object do
		length += 1
		new[length] = GreenTea.literal(value)
	end

	return GreenTea.union(table.unpack(new))
end

local IsString = GreenTea.build(GreenTea.string())

function GreenTeaUtilities.CaseInsensitiveLiterals<T>(...: string): T
	local count = select("#", ...)
	local array = table.create(count)
	local strings = table.create(count)

	for index = 1, count do
		local value = select(index, ...)
		local typeSuccess, typeError = IsString:matches(value)
		if not typeSuccess then
			local exception = Error.new(tostring(typeError))
			exception.name = "TypeError"
			Error.captureStackTrace(exception, GreenTeaUtilities.CaseInsensitiveLiterals)
			error(tostring(exception))
		end

		array[index] = GreenTea.literal(string.lower(value))
		strings[index] = string.format("%q", value)
	end

	local isValidLiterals = GreenTea.build(GreenTea.union(table.unpack(array)))
	return (
		GreenTea.withCustom("CaseInsensitive", function(value)
			local typeSuccess, typeError = IsString(value)
			if not typeSuccess then
				return false, typeError
			end

			return isValidLiterals(string.lower(value :: string))
		end, `CaseInsensitive<{table.concat(strings, " | ")}>`) :: unknown
	) :: T
end

type IntersectionType =
	& (<T1, T2>(T1, T2) -> T1 & T2)
	& (<T1, T2, T3>(T1, T2, T3) -> T1 & T2 & T3)
	& (<T1, T2, T3, T4>(T1, T2, T3, T4) -> T1 & T2 & T3 & T4)
	& (<T1, T2, T3, T4, T5>(T1, T2, T3, T4, T5) -> T1 & T2 & T3 & T4 & T5)
	& (<T1, T2, T3, T4, T5, T6>(T1, T2, T3, T4, T5, T6) -> T1 & T2 & T3 & T4 & T5 & T6)
	& (<T1, T2, T3, T4, T5, T6, T7>(T1, T2, T3, T4, T5, T6, T7) -> T1 & T2 & T3 & T4 & T5 & T6 & T7)
	& (<T1, T2, T3, T4, T5, T6, T7, T8>(T1, T2, T3, T4, T5, T6, T7, T8) -> T1 & T2 & T3 & T4 & T5 & T6 & T7 & T8)
	& (<T1, T2, T3, T4, T5, T6, T7, T8, T9>(
		T1,
		T2,
		T3,
		T4,
		T5,
		T6,
		T7,
		T8,
		T9
	) -> T1 & T2 & T3 & T4 & T5 & T6 & T7 & T8 & T9)
	& (<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(
		T1,
		T2,
		T3,
		T4,
		T5,
		T6,
		T7,
		T8,
		T9,
		T10
	) -> T1 & T2 & T3 & T4 & T5 & T6 & T7 & T8 & T9 & T10)
	& (<T>(...T) -> T)
type UnionType =
	& (<T1, T2>(T1, T2) -> T1 | T2)
	& (<T1, T2, T3>(T1, T2, T3) -> T1 | T2 | T3)
	& (<T1, T2, T3, T4>(T1, T2, T3, T4) -> T1 | T2 | T3 | T4)
	& (<T1, T2, T3, T4, T5>(T1, T2, T3, T4, T5) -> T1 | T2 | T3 | T4 | T5)
	& (<T1, T2, T3, T4, T5, T6>(T1, T2, T3, T4, T5, T6) -> T1 | T2 | T3 | T4 | T5 | T6)
	& (<T1, T2, T3, T4, T5, T6, T7>(T1, T2, T3, T4, T5, T6, T7) -> T1 | T2 | T3 | T4 | T5 | T6 | T7)
	& (<T1, T2, T3, T4, T5, T6, T7, T8>(T1, T2, T3, T4, T5, T6, T7, T8) -> T1 | T2 | T3 | T4 | T5 | T6 | T7 | T8)
	& (<T1, T2, T3, T4, T5, T6, T7, T8, T9>(
		T1,
		T2,
		T3,
		T4,
		T5,
		T6,
		T7,
		T8,
		T9
	) -> T1 | T2 | T3 | T4 | T5 | T6 | T7 | T8 | T9)
	& (<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10>(
		T1,
		T2,
		T3,
		T4,
		T5,
		T6,
		T7,
		T8,
		T9,
		T10
	) -> T1 | T2 | T3 | T4 | T5 | T6 | T7 | T8 | T9 | T10)
	& (<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11>(
		T1,
		T2,
		T3,
		T4,
		T5,
		T6,
		T7,
		T8,
		T9,
		T10,
		T11
	) -> T1 | T2 | T3 | T4 | T5 | T6 | T7 | T8 | T9 | T10 | T11)
	& (<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12>(
		T1,
		T2,
		T3,
		T4,
		T5,
		T6,
		T7,
		T8,
		T9,
		T10,
		T11,
		T12
	) -> T1 | T2 | T3 | T4 | T5 | T6 | T7 | T8 | T9 | T10 | T11 | T12)
	& (<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13>(
		T1,
		T2,
		T3,
		T4,
		T5,
		T6,
		T7,
		T8,
		T9,
		T10,
		T11,
		T12,
		T13
	) -> T1 | T2 | T3 | T4 | T5 | T6 | T7 | T8 | T9 | T10 | T11 | T12 | T13)
	& (<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14>(
		T1,
		T2,
		T3,
		T4,
		T5,
		T6,
		T7,
		T8,
		T9,
		T10,
		T11,
		T12,
		T13,
		T14
	) -> T1 | T2 | T3 | T4 | T5 | T6 | T7 | T8 | T9 | T10 | T11 | T12 | T13 | T14)
	& (<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15>(
		T1,
		T2,
		T3,
		T4,
		T5,
		T6,
		T7,
		T8,
		T9,
		T10,
		T11,
		T12,
		T13,
		T14,
		T15
	) -> T1 | T2 | T3 | T4 | T5 | T6 | T7 | T8 | T9 | T10 | T11 | T12 | T13 | T14 | T15)
	& (<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16>(
		T1,
		T2,
		T3,
		T4,
		T5,
		T6,
		T7,
		T8,
		T9,
		T10,
		T11,
		T12,
		T13,
		T14,
		T15,
		T16
	) -> T1 | T2 | T3 | T4 | T5 | T6 | T7 | T8 | T9 | T10 | T11 | T12 | T13 | T14 | T15 | T16)
	& (<T>(...T) -> T)

GreenTeaUtilities.Intersection = GreenTea.intersection :: IntersectionType
GreenTeaUtilities.Union = GreenTea.union :: UnionType

-- Missing for some reason...
GreenTeaUtilities.DateTime = GreenTea.withCustom(DateTime.now(), function(value): (boolean, any?)
	if typeof(value) ~= "DateTime" then
		return false, `expected DateTime, got {typeof(value)}`
	end

	return true
end, "DateTime")

GreenTeaUtilities.SafeString = GreenTea.withCustom("", function(value): (boolean, any?)
	if type(value) ~= "string" then
		return false, `expected string, got {typeof(value)}`
	end

	if not utf8.len(value) then
		return false, `expected valid string, got {value}`
	end

	return true
end, "SafeString")

local function AsType(value: any)
	if GreenTea.isGreenTeaType(value) then
		return value
	end

	if type(value) == "function" then
		return GreenTea.custom(value)
	end

	if value == nil then
		return GreenTea.none()
	end

	return GreenTea.typeof(value)
end

function GreenTeaUtilities.InstanceWithChildren<T, C>(root: T, children: C): C & T
	assert(type(children) == "table", "children must be a table.")
	local childrenMapped = {}
	for key, childType in children do
		assert(type(key) == "string", "children keys must be strings.")
		childrenMapped[key] = AsType(childType)
	end

	local rootType = AsType(root)

	return GreenTea.withCustom(rootType :: T & C, function(value): (boolean, any?)
		if not value or typeof(value) ~= "Instance" then
			return false, `expected an instance, got {Debug.Inspect(value)}`
		end

		for key, typeCheck in childrenMapped do
			local child = value:FindFirstChild(key)
			if not child then
				return false, `missing child {key}`
			end

			local success, exception = typeCheck(child)
			if not success then
				return false, exception
			end
		end

		local existingChildren = {}
		for _, child in value:GetChildren() do
			if existingChildren[child.Name] then
				return false, `duplicate child {child.Name}`
			end

			existingChildren[child.Name] = true
		end

		return true
	end)
end

function GreenTeaUtilities.InstanceWithChildrenAllowDuplicates<T, C>(root: T, children: C): C & T
	assert(type(children) == "table", "children must be a table.")
	local childrenMapped = {}
	for key, childType in children do
		assert(type(key) == "string", "children keys must be strings.")
		childrenMapped[key] = AsType(childType)
	end

	local rootType = AsType(root)

	local instanceType = GreenTea.withCustom(rootType :: T & C, function(value): (boolean, any?)
		if not value or typeof(value) ~= "Instance" then
			return false, `expected an instance, got {Debug.Inspect(value)}`
		end

		for key, typeCheck in childrenMapped do
			local child = value:FindFirstChild(key)
			if not child then
				return false, `missing child {key}`
			end

			local success, exception = typeCheck(child)
			if not success then
				return false, exception
			end
		end

		return true
	end)

	return instanceType
end

function GreenTeaUtilities.MakeStrict<T>(object: T): T & {[any]: never}
	do
		local typeSuccess, typeError = IsTable:matches(object)
		if not typeSuccess then
			local exception = TypeError.new(tostring(typeError))
			Error.captureStackTrace(exception, GreenTeaUtilities.MakeStrict)
			error(exception)
		end
	end
	assert(type(object) == "table", "give me extends")

	local strictObject = table.clone(object) :: T & {[any]: never}
	assert(type(strictObject) == "table", "cringe")
	strictObject[GreenTea.any()] = GreenTea.never()
	return strictObject
end

function GreenTeaUtilities.Set<T>(key: T): {[T]: true}
	return {[AsType(key)] = GreenTea.literal(true) :: true}
end
function GreenTeaUtilities.SafeSet<T>(key: T): {[T]: boolean}
	return {[AsType(key)] = GreenTea.boolean()}
end

return table.freeze(GreenTeaUtilities)
