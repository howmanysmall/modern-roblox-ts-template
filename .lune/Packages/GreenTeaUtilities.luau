--!optimize 2
--!strict

local Debug = require("@packages/Debug")
local GreenTea = require("@packages/GreenTea")
local LuauPolyfill = require("@packages/LuauPolyfill")

local Error = LuauPolyfill.Error
local instanceof = LuauPolyfill.instanceof

local GreenTeaUtilities = {}

type IntersectionType =
	(<T1, T2>(T1, T2) -> T1 & T2)
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
GreenTeaUtilities.Intersection = GreenTea.intersection :: IntersectionType
GreenTeaUtilities.IntersectionPlus = GreenTea.intersection :: IntersectionType

type UnionType =
	(<T1, T2>(T1, T2) -> T1 | T2)
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
	& (<T>(...T) -> T)
GreenTeaUtilities.Union = GreenTea.union :: UnionType
GreenTeaUtilities.UnionPlus = GreenTea.union :: UnionType

function GreenTeaUtilities.EasyLiteral<T>(...: any): T
	local count = select("#", ...)
	local array = table.create(count)

	for index = 1, count do
		local value = select(index, ...)
		array[index] = GreenTea.literal(value)
	end

	return GreenTea.union(table.unpack(array))
end

local IsString = GreenTea.build(GreenTea.string())

function GreenTeaUtilities.CaseInsensitiveLiterals(...: string): string
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
			error(exception)
		end

		array[index] = GreenTea.literal(string.lower(value))
		strings[index] = string.format("%q", value)
	end

	local isValidLiterals = GreenTea.build(GreenTea.union(table.unpack(array)))
	return GreenTea.withCustom("CaseInsensitive", function(value)
		local typeSuccess, typeError = IsString(value)
		if not typeSuccess then
			return false, typeError
		end

		return isValidLiterals(string.lower(value :: string))
	end, `CaseInsensitive<{table.concat(strings, " | ")}>`)
end

local USES_AN = {
	[97] = true;
	[101] = true;
	[105] = true;
	[111] = true;
	[117] = true;
}
local function GetIndefiniteArticle(value: string): string
	return if USES_AN[string.byte(value) or 0] then "an" else "a"
end

function GreenTeaUtilities.IsLuauClass<T, A...>(classRoot: {new: (A...) -> T}, className: string, ...: A...): T
	local classObject = classRoot.new(...)
	local checker = GreenTea.withCustom((nil :: never) :: T, function(value)
		if not instanceof(value, classRoot) then
			return false, `expected {GetIndefiniteArticle(className)} {className}, got {Debug.Inspect(value)}`
		end

		return true
	end, className)

	if type(classObject) == "table" and type(classObject.Destroy) == "function" then
		pcall(function()
			classObject:Destroy()
		end)
	end

	return checker
end

return table.freeze(GreenTeaUtilities)
