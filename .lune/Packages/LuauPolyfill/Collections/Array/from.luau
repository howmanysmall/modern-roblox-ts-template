--!optimize 2
--!strict

local ES7Types = require("@packages/ES7Types")
local InstanceOf = require("@packages/InstanceOf")

local Map = require("../Map/Map")
local Set = require("../Set")
local fromString = require("./fromString")
local isArray = require("./isArray")

type Array<T> = ES7Types.Array<T>
type Map<K, V> = ES7Types.Map<K, V>
type Object = ES7Types.Object
type Set<T> = ES7Types.Set<T>

type FromArrayFunction<T, U> = (element: T, index: number) -> U
type FromArrayThisFunction<T, U> = (thisArg: any, element: T, index: number) -> U
local function fromArray<T, U>(
	value: Array<T>,
	callback: FromArrayFunction<T, U> | FromArrayThisFunction<T, U> | nil,
	thisArg: Object?
): Array<U> | Array<T> | Array<string>
	local array = {}

	if callback then
		local arrayLength = #(value :: Array<T>)
		array = table.create(arrayLength)
		for i = 1, arrayLength do
			if thisArg ~= nil then
				(array :: Array<U>)[i] = (callback :: FromArrayThisFunction<T, U>)(thisArg, (value :: Array<T>)[i], i)
			else
				(array :: Array<U>)[i] = (callback :: FromArrayFunction<T, U>)((value :: Array<T>)[i], i)
			end
		end
	else
		array = table.clone(value :: Array<T>)
	end

	return array
end

type FromMapFunction<T, U> = (element: T, index: number) -> U
type FromMapThisFunction<T, U> = (thisArg: any, element: T, index: number) -> U
local function fromMap<T, U>(
	value: Map<any, any>,
	callback: nil | FromMapFunction<T, U> | FromMapThisFunction<T, U>,
	thisArg: Object?
	-- FIXME Luau: need overloading so the return type on this is more sane and doesn't require manual casts
): Array<U> | Array<T> | Array<string>
	local array = {}

	if callback then
		array = {}
		for i, v in value :: any do
			if thisArg ~= nil then
				(array :: Array<U>)[i] = (callback :: FromMapThisFunction<T, U>)(thisArg, v, i)
			else
				(array :: Array<U>)[i] = (callback :: FromMapFunction<T, U>)(v, i)
			end
		end
	else
		array = {}
		for i, v in value :: any do
			(array :: Array<T>)[i] = v
		end
	end

	return array
end

type FromSetFunction<T, U> = (element: T, index: number) -> U
type FromSetThisFunction<T, U> = (thisArg: any, element: T, index: number) -> U
local function fromSet<T, U>(
	value: Set<T>,
	callback: nil | FromSetFunction<T, U> | FromSetThisFunction<T, U>,
	thisArg: Object?
	-- FIXME Luau: need overloading so the return type on this is more sane and doesn't require manual casts
): Array<U> | Array<T> | Array<string>
	local array = {}

	if callback then
		array = {}
		for i, v in value :: any do
			if thisArg ~= nil then
				(array :: Array<U>)[i] = (callback :: FromSetThisFunction<T, U>)(thisArg, v, i)
			else
				(array :: Array<U>)[i] = (callback :: FromSetFunction<T, U>)(v, i)
			end
		end
	else
		array = table.clone((value :: any)._array)
	end

	return array
end

type Function<T, U> = (element: T, index: number) -> U
type ThisFunction<T, U> = (thisArg: any, element: T, index: number) -> U

local function From<T, U>(
	value: string | Array<T> | Set<T> | Map<any, any>,
	mapFn: (Function<T, U> | ThisFunction<T, U>)?,
	thisArg: Object?
	-- FIXME Luau: need overloading so the return type on this is more sane and doesn't require manual casts
): Array<U> | Array<T> | Array<string>
	if value == nil then
		error("cannot create array from a nil value")
	end

	local valueType = type(value)

	local array: Array<U> | Array<T> | Array<string>

	if valueType == "string" then
		array = fromString(value :: string, mapFn, thisArg)
	elseif valueType == "table" and isArray(value) then
		array = fromArray(value :: Array<T>, mapFn, thisArg)
	elseif InstanceOf(value, Set) then
		array = fromSet(value :: Set<T>, mapFn, thisArg)
	elseif InstanceOf(value, Map) then
		array = fromMap(value :: Map<any, any>, mapFn, thisArg)
	else
		array = {}
	end

	return array
end

return From
