--!optimize 2
--!strict

local GreenTea = require("@packages/GreenTea")
local LuauPolyfill = require("@packages/LuauPolyfill")

local Error = LuauPolyfill.Error

type CompareFunction<T> = (a: T, b: T) -> boolean

export type SortedArray<T> = typeof(setmetatable({} :: {
	Array: {T},

	Insert: (self: SortedArray<T>, value: T) -> number,
	Find: (
		self: SortedArray<T>,
		value: T,
		equalityCheck: CompareFunction<T>?,
		lessThan: CompareFunction<T>?,
		low: number?,
		high: number?
	) -> number?,
	IndexOf: (
		self: SortedArray<T>,
		value: T,
		equalityCheck: CompareFunction<T>?,
		lessThan: CompareFunction<T>?,
		low: number?,
		high: number?
	) -> number?,

	Copy: (self: SortedArray<T>) -> {T},
	CopyDeep: (self: SortedArray<T>) -> {T},

	Clone: (self: SortedArray<T>) -> SortedArray<T>,
	CloneDeep: (self: SortedArray<T>) -> SortedArray<T>,

	RemoveElement: (
		self: SortedArray<T>,
		signature: T,
		equalityCheck: CompareFunction<T>?,
		lessThan: CompareFunction<T>?
	) -> T?,

	RemoveIndex: (self: SortedArray<T>, index: number) -> T?,
	Pop: (self: SortedArray<T>) -> T?,
	Shift: (self: SortedArray<T>) -> T?,

	Sort: (self: SortedArray<T>) -> SortedArray<T>,
	SortIndex: (self: SortedArray<T>, index: number) -> number,
	SortElement: (
		self: SortedArray<T>,
		element: T,
		equalityCheck: CompareFunction<T>?,
		lessThan: CompareFunction<T>?
	) -> number,

	IsEmpty: (self: SortedArray<T>) -> boolean,
}, {} :: {
	__len: (self: SortedArray<T>) -> number,
	__tostring: (self: SortedArray<T>) -> string,
}))

type Static = {
	ClassName: "SortedArray",
	new: <T>(baseArray: {T}?, comparison: CompareFunction<T>?) -> SortedArray<T>,
	Is: (value: any) -> boolean,
	instanceof: (value: any) -> boolean,
}
type PrivateStatic = Static & {
	__len: (self: SortedArray<any>) -> number,
	__tostring: (self: SortedArray<any>) -> string,
}

local Comparisons: {[any]: CompareFunction<any>?} = setmetatable({}, {__mode = "k"}) :: never

local SortedArray = {} :: SortedArray<any> & Static
local Private = SortedArray :: SortedArray<any> & PrivateStatic
SortedArray.ClassName = "SortedArray";
(SortedArray :: any).__index = SortedArray

local function Sort<T>(array: {T}, comparison: CompareFunction<T>?): {T}
	table.sort(array, comparison)
	return array
end

local IsIntegerRaw = GreenTea.number({integer = true})

local IsInteger = GreenTea.build(IsIntegerRaw)
local IsMaybeArray = GreenTea.build(GreenTea.optional(GreenTea.array(GreenTea.unknown())))
local IsMaybeFunction = GreenTea.build(GreenTea.optional(GreenTea.anyfn()))
local IsMaybeInteger = GreenTea.build(GreenTea.optional(IsIntegerRaw))
local IsUnknown = GreenTea.build(GreenTea.unknown())

local IS_ULTRA_STRICT_MODE = _G.__DEV__

local function FindClosest<T>(
	self: SortedArray<T>,
	value: T,
	low: number,
	high: number,
	equalityCheck: CompareFunction<T>?,
	lessThan: CompareFunction<T>?
): number?
	local middle = (low + high) // 2
	if middle == 0 then
		return nil
	end

	local array = self.Array
	local compare: CompareFunction<T>? = lessThan or Comparisons[self]
	local value2 = array[middle]
	while middle ~= high do
		if equalityCheck then
			if equalityCheck(value, value2) then
				return middle
			end
		elseif value == value2 then
			return middle
		end

		local boolean = if compare then compare(value, value2) else (value :: never) < value2
		if boolean then
			high = middle - 1
		else
			low = middle + 1
		end

		middle = (low + high) // 2
		value2 = array[middle]
	end

	return middle
end

function SortedArray.new<T>(baseArray: {T}?, comparison: CompareFunction<T>?): SortedArray<T>
	if IS_ULTRA_STRICT_MODE then
		local typeSuccess0, typeError0 = IsMaybeArray:matches(baseArray)
		if not typeSuccess0 then
			local exception = Error.new(tostring(typeError0))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.new)
			error(exception)
		end
		local typeSuccess1, typeError1 = IsMaybeFunction:matches(comparison)
		if not typeSuccess1 then
			local exception = Error.new(tostring(typeError1))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.new)
			error(exception)
		end
	end

	local self = setmetatable({
		Array = if baseArray then Sort(table.clone(baseArray), comparison) else {};
	}, SortedArray) :: never
	Comparisons[self] = comparison
	return self
end

function SortedArray.Is(value)
	return type(value) == "table" and getmetatable(value) == SortedArray
end
SortedArray.instanceof = SortedArray.Is

local function Insert<T>(self: SortedArray<T>, value: T): number
	if IS_ULTRA_STRICT_MODE then
		local typeSuccess, typeError = IsUnknown:matches(value)
		if not typeSuccess then
			local exception = Error.new(tostring(typeError))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.Insert)
			error(exception)
		end
	end

	local array = self.Array
	local position = FindClosest(self, value, 1, #array)

	local insertAt = 1
	local value2 = array[position :: never]

	if value2 ~= nil then
		local comparison = Comparisons[self]
		local boolean = if comparison then comparison(value, value2) else (value :: never) < value2
		insertAt = if boolean then position :: number else (position :: number) + 1
	end

	table.insert(array, insertAt, value)
	return insertAt
end
SortedArray.Insert = Insert

local function Find<T>(
	self: SortedArray<T>,
	value: T,
	equalityCheck: CompareFunction<T>?,
	lessThan: CompareFunction<T>?,
	low: number?,
	high: number?
): number?
	if IS_ULTRA_STRICT_MODE then
		local typeSuccess0, typeError0 = IsUnknown:matches(value)
		if not typeSuccess0 then
			local exception = Error.new(tostring(typeError0))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.Find)
			error(exception)
		end
		local typeSuccess1, typeError1 = IsMaybeFunction:matches(equalityCheck)
		if not typeSuccess1 then
			local exception = Error.new(tostring(typeError1))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.Find)
			error(exception)
		end
		local typeSuccess2, typeError2 = IsMaybeFunction:matches(lessThan)
		if not typeSuccess2 then
			local exception = Error.new(tostring(typeError2))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.Find)
			error(exception)
		end
		local typeSuccess3, typeError3 = IsMaybeInteger:matches(low)
		if not typeSuccess3 then
			local exception = Error.new(tostring(typeError3))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.Find)
			error(exception)
		end
		local typeSuccess4, typeError4 = IsMaybeInteger:matches(high)
		if not typeSuccess4 then
			local exception = Error.new(tostring(typeError4))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.Find)
			error(exception)
		end
	end

	local array = self.Array
	local position = FindClosest(self, value, low or 1, high or #array, equalityCheck, lessThan or Comparisons[self])
	local boolean = false

	if position then
		boolean = if equalityCheck then equalityCheck(value, array[position]) else value == array[position]
	end

	return if boolean then position else nil
end
SortedArray.Find = Find
SortedArray.IndexOf = Find

function SortedArray:Copy()
	return table.clone(self.Array)
end

local function CopyDeepHelper<T>(object: T): T
	local new = table.clone(object :: never)
	for index, value in next, object :: never do
		if type(value) == "table" then
			new[index] = CopyDeepHelper(value)
		end
	end
	return new :: never
end
local function CopyDeep<T>(array: {T}): {T}
	local new = table.clone(array)
	for index, value in array do
		if type(value) == "table" then
			new[index] = CopyDeepHelper(value)
		end
	end
	return new
end

function SortedArray:CopyDeep()
	return CopyDeep(self.Array)
end

function SortedArray:Clone()
	return SortedArray.new(table.clone(self.Array), Comparisons[self]):Sort()
end

function SortedArray:CloneDeep()
	return SortedArray.new(CopyDeep(self.Array), Comparisons[self]):Sort()
end

local function RemoveElement<T>(
	self: SortedArray<T>,
	signature: T,
	equalityCheck: CompareFunction<T>?,
	lessThan: CompareFunction<T>?
): T?
	if IS_ULTRA_STRICT_MODE then
		local typeSuccess0, typeError0 = IsUnknown:matches(signature)
		if not typeSuccess0 then
			local exception = Error.new(tostring(typeError0))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.RemoveElement)
			error(exception)
		end
		local typeSuccess1, typeError1 = IsMaybeFunction:matches(equalityCheck)
		if not typeSuccess1 then
			local exception = Error.new(tostring(typeError1))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.RemoveElement)
			error(exception)
		end
		local typeSuccess2, typeError2 = IsMaybeFunction:matches(lessThan)
		if not typeSuccess2 then
			local exception = Error.new(tostring(typeError2))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.RemoveElement)
			error(exception)
		end
	end

	local position = Find(self, signature, equalityCheck, lessThan)
	return if position == nil then nil else table.remove(self.Array, position)
end

SortedArray.RemoveElement = RemoveElement

local function RemoveIndex<T>(self: SortedArray<T>, index: number): T?
	if IS_ULTRA_STRICT_MODE then
		local typeSuccess, typeError = IsInteger:matches(index)
		if not typeSuccess then
			local exception = Error.new(tostring(typeError))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.RemoveIndex)
			error(exception)
		end
	end
	return table.remove(self.Array, index)
end

SortedArray.RemoveIndex = RemoveIndex

function SortedArray:Pop()
	local array = self.Array
	local length = #array

	local value = array[length]
	array[length] = nil
	return value
end

function SortedArray:Shift()
	return table.remove(self.Array, 1)
end

function SortedArray:Sort()
	table.sort(self.Array, Comparisons[self])
	return self
end

function SortedArray:SortIndex(index)
	if IS_ULTRA_STRICT_MODE then
		local typeSuccess, typeError = IsInteger:matches(index)
		if not typeSuccess then
			local exception = Error.new(tostring(typeError))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.SortIndex)
			error(exception)
		end
	end

	local removedValue = RemoveIndex(self, index)
	if removedValue == nil then
		local exception = Error.new(`Could not find element at index {index}?`)
		exception.name = "ElementNotFoundError"
		Error.captureStackTrace(exception, SortedArray.SortIndex)
		error(exception)
	end

	return Insert(self, removedValue)
end

function SortedArray:SortElement(signature, equalityCheck, lessThan)
	if IS_ULTRA_STRICT_MODE then
		local typeSuccess0, typeError0 = IsUnknown:matches(signature)
		if not typeSuccess0 then
			local exception = Error.new(tostring(typeError0))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.SortElement)
			error(exception)
		end
		local typeSuccess1, typeError1 = IsMaybeFunction:matches(equalityCheck)
		if not typeSuccess1 then
			local exception = Error.new(tostring(typeError1))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.SortElement)
			error(exception)
		end
		local typeSuccess2, typeError2 = IsMaybeFunction:matches(lessThan)
		if not typeSuccess2 then
			local exception = Error.new(tostring(typeError2))
			exception.name = "StrictTypeError"
			Error.captureStackTrace(exception, SortedArray.SortElement)
			error(exception)
		end
	end

	local removedValue = RemoveElement(self, signature, equalityCheck, lessThan)
	if removedValue == nil then
		local exception = Error.new(`Could not find element {signature}?`)
		exception.name = "ElementNotFoundError"
		Error.captureStackTrace(exception, SortedArray.SortElement)
		error(exception)
	end

	return Insert(self, removedValue)
end

function SortedArray:IsEmpty()
	return #self.Array == 0
end

function Private:__len()
	return #self.Array
end

function Private:__tostring()
	local array = self.Array
	local stringBuilder = table.create(#array)
	for index, value in array do
		stringBuilder[index] = tostring(value)
	end
	return `SortedArray<[{table.concat(stringBuilder, ", ")}]>`
end

return table.freeze(SortedArray :: Static)
