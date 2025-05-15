--!optimize 2
--!strict

local Error = require("@packages/Error")
local GreenTea = require("@packages/GreenTea")
local GreenTeaUtilities = require("@packages/GreenTeaUtilities")
local TableUtilities = require("@packages/TableUtilities")

type ComparisonFunction<T> = (a: T, b: T) -> boolean

export type SortedArray<T> = typeof(setmetatable(
	{} :: {
		Array: {T},
		Comparison: ComparisonFunction<T>?,

		-- add when luau sucks less
		-- Map: <U>(self: SortedArray<T>, callback: (value: T, index: number, array: {T}) -> U, comparison: ComparisonFunction<T>?) -> SortedArray<U>,
		-- MapFiltered: <U>(self: SortedArray<T>, callback: (value: T, index: number, array: {T}) -> U, comparison: ComparisonFunction<T>?) -> SortedArray<U>, -- NonNullable<U>

		Insert: (self: SortedArray<T>, value: T) -> number,

		Find: (
			self: SortedArray<T>,
			value: T,
			equalityCheck: ComparisonFunction<T>?,
			lessThan: ComparisonFunction<T>?,
			low: number?,
			high: number?
		) -> number?,
		IndexOf: (
			self: SortedArray<T>,
			value: T,
			equalityCheck: ComparisonFunction<T>?,
			lessThan: ComparisonFunction<T>?,
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
			equalityCheck: ComparisonFunction<T>?,
			lessThan: ComparisonFunction<T>?
		) -> T?,

		RemoveIndex: (self: SortedArray<T>, index: number) -> T?,
		Pop: (self: SortedArray<T>) -> T?,
		Shift: (self: SortedArray<T>) -> T?,

		Sort: (self: SortedArray<T>) -> SortedArray<T>,
		SortIndex: (self: SortedArray<T>, index: number) -> number,
		SortElement: (
			self: SortedArray<T>,
			element: T,
			equalityCheck: ComparisonFunction<T>?,
			lessThan: ComparisonFunction<T>?
		) -> number,

		GetIntersection: (
			self: SortedArray<T>,
			other: SortedArray<T>,
			equalityCheck: ComparisonFunction<T>?,
			lessThan: ComparisonFunction<T>?
		) -> SortedArray<T>,

		IsEmpty: (self: SortedArray<T>) -> boolean,
	},
	{} :: {
		__len: (self: SortedArray<T>) -> number,
		__tostring: (self: SortedArray<T>) -> string,
	}
))

type Static = {
	ClassName: "SortedArray",
	new: <T>(baseArray: {T}?, comparison: ComparisonFunction<T>?) -> SortedArray<T>,
	Is: (value: any) -> boolean,
	instanceof: (value: any) -> boolean,
}
type PrivateStatic = Static & {
	__len: (self: SortedArray<any>) -> number,
	__tostring: (self: SortedArray<any>) -> string,
}

--[=[
	A class to create automatically sorted arrays. Must contain objects
	comparable to one another (that can use the `<` and `==` operators).
	Numbers and strings support these operators by default.

	@tag Optimization
	@tag Supports Debug Mode
	@tag Supports __len
	@tag Supports __tostring
	@class SortedArray
]=]
local SortedArray = {} :: SortedArray<any> & Static
local Private = SortedArray :: SortedArray<any> & PrivateStatic
SortedArray.ClassName = "SortedArray"
(SortedArray :: any).__index = SortedArray

local cached: boolean = nil
local function IsUltraStrictMode(): boolean
	if cached ~= nil then
		return cached
	end

	local isUltraStrictMode = not not _G.__DEV__
	cached = isUltraStrictMode
	return isUltraStrictMode
end
local function Sort<T>(array: {T}, comparison: ComparisonFunction<T>?): {T}
	table.sort(array, comparison)
	return array
end

local IsIntegerRaw = GreenTea.number({integer = true})

local IsInteger = GreenTea.build(IsIntegerRaw)
local IsMaybeArray = GreenTea.build(GreenTea.optional(GreenTea.array(GreenTea.unknown())))
local IsMaybeFunction = GreenTea.build(GreenTea.optional(GreenTea.anyfn()))
local IsMaybeInteger = GreenTea.build(GreenTea.optional(IsIntegerRaw))
local IsSortedArray = GreenTea.build(GreenTeaUtilities.IsInstanceOfLuauClassFromTable(SortedArray, "SortedArray"))
local IsUnknown = GreenTea.build(GreenTea.unknown())

--[=[
	The actual array of data. You can iterate over this or index it.

	:::warning Readonly
	_PLEASE_ treat this array as readonly. Do not mutate it directly.
	:::

	@readonly
	@prop Array ReadonlyArray<T>
	@within SortedArray
]=]

--[=[
	The comparison function of the `SortedArray`.

	@readonly
	@prop Comparison ComparisonFunction<T>?
	@within SortedArray
]=]

local function FindClosest<T>(
	array: {T},
	value: T,
	low: number,
	high: number,
	equalityCheck: ComparisonFunction<T>?,
	lessThan: ComparisonFunction<T>?
): number?
	local middle = (low + high) // 2
	if middle == 0 then
		return nil
	end

	local value2 = array[middle]
	while middle ~= high do
		if equalityCheck then
			if equalityCheck(value, value2) then
				return middle
			end
		elseif value == value2 then
			return middle
		end

		local boolean = false
		if value2 then
			boolean = if lessThan then lessThan(value, value2) else (value :: never) < value2
		end

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

--[=[
	Instantiates and returns a new SortedArray, with optional parameters.

	@error DebugTypeError -- Thrown when you are using debug mode and you pass an incorrect type.

	@param baseArray? {T} -- An array of data which will be sorted upon instantiation. If this is omitted, an empty array is used.
	@param comparison? ComparisonFunction<T> -- An optional comparison function which is used to customize the element sorting, which will be given two elements `a` and `b` from the array as parameters. The function should return a boolean value specifying whether the first argument should be before the second argument in the sequence. If no comparison function is passed, the Luau-default `a < b` sorting is used.
	@return SortedArray<T>
]=]
function SortedArray.new<T>(baseArray: {T}?, comparison: ComparisonFunction<T>?): SortedArray<T>
	if IsUltraStrictMode() then
		local typeSuccess0, typeError0 = IsMaybeArray:matches(baseArray)
		if not typeSuccess0 then
			local exception = Error.new(tostring(typeError0))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.new)
			error(exception)
		end
		local typeSuccess1, typeError1 = IsMaybeFunction:matches(comparison)
		if not typeSuccess1 then
			local exception = Error.new(tostring(typeError1))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.new)
			error(exception)
		end
	end

	return setmetatable({
		Array = if baseArray then Sort(table.clone(baseArray), comparison) else {};
		Comparison = comparison;
	}, SortedArray) :: never
end

--[=[
	Checks if `value` is literally a `SortedArray`.

	```lua
	SortedArray.Is(SortedArray.new()) -- true
	SortedArray.Is(SortedArray) -- false
	SortedArray.Is({}) -- false
	SortedArray.Is(nil) -- false
	SortedArray.Is(1) -- false
	```

	@param value unknown
	@return boolean
]=]
function SortedArray.Is(value)
	return type(value) == "table" and getmetatable(value) == SortedArray
end
--[=[
	An alias for [SortedArray.Is].

	@function instanceof
	@within SortedArray

	@param value unknown
	@return boolean
]=]
SortedArray.instanceof = SortedArray.Is

-- function SortedArray:Map(callback, comparison)
-- 	if IsUltraStrictMode() then
-- 		local typeSuccess0, typeError0 = IsFunction:matches(callback)
-- 		if not typeSuccess0 then
-- 			local exception = Error.new(tostring(typeError0))
-- 			exception.name = "DebugTypeError"
-- 			Error.captureStackTrace(exception, SortedArray.Map)
-- 			error(exception)
-- 		end
-- 		local typeSuccess1, typeError1 = IsMaybeFunction:matches(comparison)
-- 		if not typeSuccess1 then
-- 			local exception = Error.new(tostring(typeError1))
-- 			exception.name = "DebugTypeError"
-- 			Error.captureStackTrace(exception, SortedArray.Map)
-- 			error(exception)
-- 		end
-- 	end

-- 	local array = self.Array
-- 	local newArray = table.create(#array)
-- 	for index, value in array do
-- 		newArray[index] = callback(value, index, array)
-- 	end
-- 	return SortedArray.new(newArray, comparison):Sort()
-- end
-- function SortedArray:MapFiltered(callback, comparison)
-- 	if IsUltraStrictMode() then
-- 		local typeSuccess0, typeError0 = IsFunction:matches(callback)
-- 		if not typeSuccess0 then
-- 			local exception = Error.new(tostring(typeError0))
-- 			exception.name = "DebugTypeError"
-- 			Error.captureStackTrace(exception, SortedArray.MapFiltered)
-- 			error(exception)
-- 		end
-- 		local typeSuccess1, typeError1 = IsMaybeFunction:matches(comparison)
-- 		if not typeSuccess1 then
-- 			local exception = Error.new(tostring(typeError1))
-- 			exception.name = "DebugTypeError"
-- 			Error.captureStackTrace(exception, SortedArray.MapFiltered)
-- 			error(exception)
-- 		end
-- 	end

-- 	local array = self.Array
-- 	local newArray = table.create(#array)
-- 	for index, value in array do
-- 		local newValue = callback(value, index, array)
-- 		if newValue ~= nil then
-- 			newArray[index] = newValue
-- 		end
-- 	end
-- 	return SortedArray.new(newArray, comparison):Sort()
-- end

local function Insert<T>(self: SortedArray<T>, value: T): number
	if IsUltraStrictMode() then
		local typeSuccess, typeError = IsUnknown:matches(value)
		if not typeSuccess then
			local exception = Error.new(tostring(typeError))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.Insert)
			error(exception)
		end
	end

	local array = self.Array
	local comparison = self.Comparison

	local position = FindClosest(array, value, 1, #array, nil, comparison)

	local insertAt = 1
	local value2 = array[position :: never]

	if value2 ~= nil then
		local boolean = if comparison then comparison(value, value2) else (value :: never) < value2
		insertAt = if boolean then position :: number else (position :: number) + 1
	end

	table.insert(array, insertAt, value)
	return insertAt
end

--[=[
	Inserts an element in the proper place which would preserve the array's
	sorted order. Returns the index the element was inserted.

	@error DebugTypeError -- Thrown when you are using debug mode and you pass an incorrect type.

	@method Insert
	@within SortedArray

	@param value T -- The value you want to insert.
	@return integer -- The index at which it was inserted.
]=]
SortedArray.Insert = Insert

local function Find<T>(
	self: SortedArray<T>,
	value: T,
	equalityCheck: ComparisonFunction<T>?,
	lessThan: ComparisonFunction<T>?,
	low: number?,
	high: number?
): number?
	if IsUltraStrictMode() then
		local typeSuccess0, typeError0 = IsUnknown:matches(value)
		if not typeSuccess0 then
			local exception = Error.new(tostring(typeError0))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.Find)
			error(exception)
		end
		local typeSuccess1, typeError1 = IsMaybeFunction:matches(equalityCheck)
		if not typeSuccess1 then
			local exception = Error.new(tostring(typeError1))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.Find)
			error(exception)
		end
		local typeSuccess2, typeError2 = IsMaybeFunction:matches(lessThan)
		if not typeSuccess2 then
			local exception = Error.new(tostring(typeError2))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.Find)
			error(exception)
		end
		local typeSuccess3, typeError3 = IsMaybeInteger:matches(low)
		if not typeSuccess3 then
			local exception = Error.new(tostring(typeError3))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.Find)
			error(exception)
		end
		local typeSuccess4, typeError4 = IsMaybeInteger:matches(high)
		if not typeSuccess4 then
			local exception = Error.new(tostring(typeError4))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.Find)
			error(exception)
		end
	end

	local array = self.Array
	local length = #array
	if length == 0 then
		return nil
	end

	if length == 1 then
		local atPosition = array[1]
		return if if equalityCheck then equalityCheck(value, atPosition) else value == atPosition then 1 else nil
	end

	local boolean = false
	local position = FindClosest(array, value, low or 1, high or length, equalityCheck, lessThan or self.Comparison)

	local atPosition = array[position :: number]
	if atPosition ~= nil then
		boolean = if equalityCheck then equalityCheck(value, atPosition) else value == atPosition
	end

	return if boolean then position else nil
end

--[=[
	Finds an element in a `SortedArray` and returns its position (or `nil` if
	non-existent).

	@method Find
	@within SortedArray

	@error DebugTypeError -- Thrown when you are using debug mode and you pass an incorrect type.

	@param value T -- The value you want to find.
	@param equalityCheck? ComparisonFunction<T> -- An optional function which checks for equality between the passed-in element and the other elements in the SortedArray.
	@param lessThan? ComparisonFunction<T> -- An optional less-than comparison function, which falls back on the comparison passed in from [SortedArray.new].
	@param low? integer -- An optional lower bound for the search. Defaults to `1`.
	@param high? integer -- An optional upper bound for the search. Defaults to the length of the SortedArray.
	@return integer? -- The index of the element, or `nil` if it doesn't exist.
]=]
SortedArray.Find = Find
--[=[
	An alias for [SortedArray.Find].

	@method IndexOf
	@within SortedArray

	@error DebugTypeError -- Thrown when you are using debug mode and you pass an incorrect type.

	@param value T -- The value you want to find.
	@param equalityCheck? ComparisonFunction<T> -- An optional function which checks for equality between the passed-in element and the other elements in the SortedArray.
	@param lessThan? ComparisonFunction<T> -- An optional less-than comparison function, which falls back on the comparison passed in from [SortedArray.new].
	@param low? integer -- An optional lower bound for the search. Defaults to `1`.
	@param high? integer -- An optional upper bound for the search. Defaults to the length of the SortedArray.
	@return integer? -- The index of the element, or `nil` if it doesn't exist.
]=]
SortedArray.IndexOf = Find

--[=[
	Makes a shallow copy of the SortedArray's array.
	@return {T} -- A shallow copy of the data.
]=]
function SortedArray:Copy()
	return table.clone(self.Array)
end

local function CopyDeep<T>(object: T): T
	local new = table.clone(object :: never)
	for index, value in next, object :: never do
		if type(value) == "table" then
			new[index] = CopyDeep(value)
		end
	end
	return new :: never
end

--[=[
	Makes a deep copy of the SortedArray's array.
	@return {T} -- A deep copy of the data.
]=]
function SortedArray:CopyDeep()
	return CopyDeep(self.Array)
end

--[=[
	Makes a shallow copy of the SortedArray and returns a new SortedArray.
	Probably would recommend [SortedArray.CloneDeep] instead because of
	funny cache misses.
	
	@return SortedArray<T> -- A shallow copy of the SortedArray.
]=]
function SortedArray:Clone()
	return SortedArray.new(table.clone(self.Array), self.Comparison):Sort()
end

--[=[
	Makes a deep copy of the SortedArray and returns a new SortedArray.
	@return SortedArray<T> -- A deep copy of the SortedArray.
]=]
function SortedArray:CloneDeep()
	return SortedArray.new(CopyDeep(self.Array), self.Comparison):Sort()
end

local function RemoveElement<T>(
	self: SortedArray<T>,
	signature: T,
	equalityCheck: ComparisonFunction<T>?,
	lessThan: ComparisonFunction<T>?
): T?
	if IsUltraStrictMode() then
		local typeSuccess0, typeError0 = IsUnknown:matches(signature)
		if not typeSuccess0 then
			local exception = Error.new(tostring(typeError0))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.RemoveElement)
			error(exception)
		end
		local typeSuccess1, typeError1 = IsMaybeFunction:matches(equalityCheck)
		if not typeSuccess1 then
			local exception = Error.new(tostring(typeError1))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.RemoveElement)
			error(exception)
		end
		local typeSuccess2, typeError2 = IsMaybeFunction:matches(lessThan)
		if not typeSuccess2 then
			local exception = Error.new(tostring(typeError2))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.RemoveElement)
			error(exception)
		end
	end

	local position = Find(self, signature, equalityCheck, lessThan)
	return if position == nil then nil else table.remove(self.Array, position)
end

--[=[
	Searches the array via [SortedArray.Find]. If found, it removes the value
	and returns the value, otherwise returns undefined. Only removes a single
	occurrence.

	@method RemoveElement
	@within SortedArray

	@error DebugTypeError -- Thrown when you are using debug mode and you pass an incorrect type.

	@param signature T -- The value you want to remove.
	@param equalityCheck? ComparisonFunction<T> -- An optional function which checks for equality between the passed-in element and the other elements in the SortedArray.
	@param lessThan? ComparisonFunction<T> -- An optional less-than comparison function, which falls back on the comparison passed in from [SortedArray.new].
	@return T? -- The removed value.
]=]
SortedArray.RemoveElement = RemoveElement

local function RemoveIndex<T>(self: SortedArray<T>, index: number): T?
	if IsUltraStrictMode() then
		local typeSuccess, typeError = IsInteger:matches(index)
		if not typeSuccess then
			local exception = Error.new(tostring(typeError))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.RemoveIndex)
			error(exception)
		end
	end
	return table.remove(self.Array, index)
end

--[=[
	Removes an element from the SortedArray by index. Returns the removed
	element. This is literally just `table.remove`.

	@method RemoveIndex
	@within SortedArray

	@error DebugTypeError -- Thrown when you are using debug mode and you pass an incorrect type.

	@param index integer -- The index of the element to remove.
	@return T? -- The removed element.
]=]
SortedArray.RemoveIndex = RemoveIndex

--[=[
	Pops an element from the SortedArray. This just removes the last element.
	@return T? -- The removed element.
]=]
function SortedArray:Pop()
	local array = self.Array
	local length = #array

	local value = array[length]
	array[length] = nil
	return value
end

--[=[
	Shifts element from the SortedArray. This just removes the first element.
	@return T? -- The removed element.
]=]
function SortedArray:Shift()
	return table.remove(self.Array, 1)
end

--[=[
	Does `table.sort` on the SortedArray's array. Pretty useless.
	@return SortedArray<T>
]=]
function SortedArray:Sort()
	table.sort(self.Array, self.Comparison)
	return self
end

--[=[
	Removes the value at `index` and re-inserts it. This is useful for when a
	value may have updated in a way that could change it's position in a
	`SortedArray`. Returns the new position of the element.

	@error DebugTypeError -- Thrown when you are using debug mode and you pass an incorrect type.
	@error ElementNotFoundError -- Thrown when the element you are trying to sort is not found.

	@param index integer -- The index of the element to sort.
	@return integer -- The new position of the element.
]=]
function SortedArray:SortIndex(index)
	if IsUltraStrictMode() then
		local typeSuccess, typeError = IsInteger:matches(index)
		if not typeSuccess then
			local exception = Error.new(tostring(typeError))
			exception.name = "DebugTypeError"
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

--[=[
	Calls [SortedArray.RemoveElement]`(signature, equalityCheck, lessThan)` and
	re-inserts the value. This is useful for when a value may have updated in a
	way that could change it's position in a `SortedArray`. Returns the new
	position of the element.

	@error DebugTypeError -- Thrown when you are using debug mode and you pass an incorrect type.
	@error ElementNotFoundError -- Thrown when the element you are trying to sort is not found.

	@param signature T -- The value you want to remove.
	@param equalityCheck? ComparisonFunction<T> -- An optional function which checks for equality between the passed-in element and the other elements in the SortedArray.
	@param lessThan? ComparisonFunction<T> -- An optional less-than comparison function, which falls back on the comparison passed in from [SortedArray.new].
	@return integer -- The new position of the element.
]=]
function SortedArray:SortElement(signature, equalityCheck, lessThan)
	if IsUltraStrictMode() then
		local typeSuccess0, typeError0 = IsUnknown:matches(signature)
		if not typeSuccess0 then
			local exception = Error.new(tostring(typeError0))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.SortElement)
			error(exception)
		end
		local typeSuccess1, typeError1 = IsMaybeFunction:matches(equalityCheck)
		if not typeSuccess1 then
			local exception = Error.new(tostring(typeError1))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.SortElement)
			error(exception)
		end
		local typeSuccess2, typeError2 = IsMaybeFunction:matches(lessThan)
		if not typeSuccess2 then
			local exception = Error.new(tostring(typeError2))
			exception.name = "DebugTypeError"
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

--[=[
	Gets an intersection between two SortedArrays.

	@error DebugTypeError -- Thrown when you are using debug mode and you pass an incorrect type.

	@param other SortedArray<T> -- The other SortedArray to get the intersection with.
	@param equalityCheck? ComparisonFunction<T> -- An optional function which checks for equality between the passed-in element and the other elements in the SortedArray.
	@param lessThan? ComparisonFunction<T> -- An optional less-than comparison function, which falls back on the comparison passed in from [SortedArray.new].
	@return SortedArray<T> -- The intersection of the two SortedArrays. This is a new SortedArray.
]=]
function SortedArray:GetIntersection<T>(other, equalityCheck, lessThan)
	if IsUltraStrictMode() then
		local typeSuccess0, typeError0 = IsSortedArray:matches(other)
		if not typeSuccess0 then
			local exception = Error.new(tostring(typeError0))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.GetIntersection)
			error(exception)
		end
		local typeSuccess1, typeError1 = IsMaybeFunction:matches(equalityCheck)
		if not typeSuccess1 then
			local exception = Error.new(tostring(typeError1))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.GetIntersection)
			error(exception)
		end
		local typeSuccess2, typeError2 = IsMaybeFunction:matches(lessThan)
		if not typeSuccess2 then
			local exception = Error.new(tostring(typeError2))
			exception.name = "DebugTypeError"
			Error.captureStackTrace(exception, SortedArray.GetIntersection)
			error(exception)
		end
	end

	local commonalities: SortedArray<T> = SortedArray.new({}, self.Comparison)
	local count = 0
	local position = 0

	local selfArray = self.Array
	local selfLength = #selfArray

	local otherArray = other.Array
	local otherLength = #otherArray

	if selfLength > otherLength then
		selfLength, otherLength = otherLength, selfLength
		selfArray, otherArray = otherArray, selfArray
		self, other = other, self
	end

	for index = 1, otherLength do
		local current = selfArray[index]
		local currentPosition = other:Find(current, equalityCheck, lessThan, position, otherLength)
		if currentPosition then
			position = currentPosition
			count += 1
			commonalities.Array[count] = current
		end
	end

	return commonalities
end

--[=[
	Checks if the SortedArray is empty.
	@return boolean
]=]
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
		stringBuilder[index] = TableUtilities.Repr(value)
	end
	return `SortedArray<[{table.concat(stringBuilder, ", ")}]>`
end

return table.freeze(SortedArray :: Static)
