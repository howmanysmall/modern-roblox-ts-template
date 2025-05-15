--!optimize 2
--!strict

local CopyDeep = require("@self/CopyDeep")
local EqualObjects = require("@self/EqualObjects")
local Equals = require("@self/Equals")
local EqualsDeep = require("@self/EqualsDeep")
local FastMerge = require("@self/FastMerge")
local FastMergeDeep = require("@self/FastMergeDeep")
local GetLength = require("@self/GetLength")
local IsArray = require("@self/IsArray")
local LockDeep = require("@self/LockDeep")
local Repr = require("@self/Repr")

local FindInsertIndex = require("@self/SortedArrays/FindInsertIndex")
local FindInsertIndexSimple = require("@self/SortedArrays/FindInsertIndexSimple")
local SortedInsert = require("@self/SortedArrays/SortedInsert")
local SortedInsertSimple = require("@self/SortedArrays/SortedInsertSimple")

-- TODO: When we get @native in selene (and roblox? don't know if it's on without fflag mods) we should transform some of these to @native

--[=[
	A library that contains various utilities for tables.

	@class TableUtilities
]=]
local TableUtilities = table.freeze({
	CopyDeep = CopyDeep;
	EqualObjects = EqualObjects;
	Equals = Equals;
	EqualsDeep = EqualsDeep;
	FastMerge = FastMerge;
	FastMergeDeep = FastMergeDeep;
	GetLength = GetLength;
	IsArray = IsArray;
	LockDeep = LockDeep;
	Repr = Repr;

	FindInsertIndex = FindInsertIndex;
	FindInsertIndexSimple = FindInsertIndexSimple;
	SortedInsert = SortedInsert;
	SortedInsertSimple = SortedInsertSimple;
})

export type DateTimeFormatType = Repr.DateTimeFormatType
export type Locale = Repr.Locale
export type ReprSettings = Repr.ReprSettings

return TableUtilities
