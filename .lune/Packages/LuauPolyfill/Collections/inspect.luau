--!optimize 2

-- derived from these upstream sources:
-- https://github.com/graphql/graphql-js/blob/1951bce42092123e844763b6a8e985a8a3327511/src/jsutils/inspect.js

local ES7Types = require("../ES7Types")
local isArray = require("./Array/isArray")
local net = require("@lune/net")

type Array<T> = ES7Types.Array<T>
-- local NULL = require(srcWorkspace.luaUtils.null)

-- Support for options partial implementation
-- see: https://nodejs.org/dist/latest-v16.x/docs/api/util.html#utilinspectobject-options
export type InspectOptions = {
	depth: number?,
}

type FormatOptions = {
	depth: number,
}

local MAX_ARRAY_LENGTH = 10
local DEFAULT_RECURSIVE_DEPTH = 2

-- deviation: pre-declare functions
local formatValue
local formatObjectValue
local formatArray
local formatObject
local getObjectTag

--[[
 * Used to print values in error messages.
 ]]
local function inspect(value, options: InspectOptions?): string
	local inspectOptions: InspectOptions = options or {depth = DEFAULT_RECURSIVE_DEPTH}
	local depth = inspectOptions.depth or DEFAULT_RECURSIVE_DEPTH
	inspectOptions.depth = if depth >= 0 then depth else DEFAULT_RECURSIVE_DEPTH
	return formatValue(value, {}, inspectOptions :: FormatOptions)
end

local function isIndexKey(k, contiguousLength)
	return type(k) == "number"
		and k <= contiguousLength -- nothing out of bounds
		and 1 <= k -- nothing illegal for array indices
		and k % 1 == 0 -- no float keys
end

local function getTableLength(tbl)
	local length = 1
	local value = rawget(tbl, length)
	while value ~= nil do
		length += 1
		value = rawget(tbl, length)
	end

	return length - 1
end

local function sortKeysForPrinting(a: any, b)
	local typeofA = type(a)
	local typeofB = type(b)

	-- strings and numbers are sorted numerically/alphabetically
	if typeofA == typeofB and (typeofA == "number" or typeofA == "string") then
		return a < b
	end

	-- sort the rest by type name
	return typeofA < typeofB
end

local function getFragmentedKeys(tbl)
	local keys = {}
	local keysLength = 0
	local tableLength = getTableLength(tbl)
	for key in next, tbl do
		if not isIndexKey(key, tableLength) then
			keysLength += 1
			keys[keysLength] = key
		end
	end

	table.sort(keys, sortKeysForPrinting)
	return keys, keysLength, tableLength
end

function formatValue(value, seenValues, options: FormatOptions)
	local valueType = type(value)
	if valueType == "string" then
		return net.jsonEncode(value)
		-- deviation: format numbers like in JS
	end

	if valueType == "number" then
		if value ~= value then
			return "NaN"
		end

		if value == math.huge then
			return "Infinity"
		end

		if value == -math.huge then
			return "-Infinity"
		end

		return tostring(value)
	end

	if valueType == "function" then
		local result = "[function"
		local functionName = debug.info(value :: (any) -> any, "n")
		if functionName ~= nil and functionName ~= "" then
			result ..= ` {functionName}`
		end

		return `{result}]`
	end

	if valueType == "table" then
		-- ROBLOX TODO: parameterize inspect with the library-specific NULL sentinel. maybe function generics?
		-- if value == NULL then
		-- 	return 'null'
		-- end
		return formatObjectValue(value, seenValues, options)
	end

	return tostring(value)
end

function formatObjectValue(value, previouslySeenValues, options: FormatOptions)
	if table.find(previouslySeenValues, value) ~= nil then
		return "[Circular]"
	end

	-- local seenValues = {table.unpack(previouslySeenValues)}
	local seenValues = table.clone(previouslySeenValues)
	table.insert(seenValues, value)

	if type(value.toJSON) == "function" then
		local jsonValue = value:toJSON(value)
		if jsonValue ~= value then
			return if type(jsonValue) == "string" then jsonValue else formatValue(jsonValue, seenValues, options)
		end
	end

	if isArray(value) then
		return formatArray(value, seenValues, options)
	end

	return formatObject(value, seenValues, options)
end

function formatObject(object, seenValues, options: FormatOptions)
	local mt = getmetatable(object)
	if mt and rawget(mt, "__tostring") then
		return tostring(object)
	end

	local fragmentedKeys, fragmentedKeysLength, keysLength = getFragmentedKeys(object)

	if keysLength == 0 and fragmentedKeysLength == 0 then
		return "{}"
	end

	if #seenValues > options.depth then
		return `[{getObjectTag(object)}]`
	end

	local properties = table.create(keysLength + fragmentedKeysLength)
	for i = 1, keysLength do
		local value = formatValue(object[i], seenValues, options)
		table.insert(properties, value)
	end

	for i = 1, fragmentedKeysLength do
		local key = fragmentedKeys[i]
		local value = formatValue(object[key], seenValues, options)

		table.insert(properties, `{key}: {value}`)
	end

	return "{ " .. table.concat(properties, ", ") .. " }"
end

function formatArray(array: Array<any>, seenValues: Array<any>, options: FormatOptions): string
	local length = #array
	if length == 0 then
		return "[]"
	end

	if #seenValues > options.depth then
		return "[Array]"
	end

	local len = math.min(MAX_ARRAY_LENGTH, length)
	local remaining = length - len
	local items = table.create(len)

	for i = 1, len do
		items[i] = formatValue(array[i], seenValues, options)
	end

	if remaining == 1 then
		table.insert(items, "... 1 more item")
	elseif remaining > 1 then
		table.insert(items, `... {remaining} more items`)
	end

	return `[{table.concat(items, ", ")}]`
end

function getObjectTag(_object): string
	-- local tag = Object.prototype.toString
	-- 	.call(object)
	-- 	.replace("")
	-- 	.replace("")

	-- if tag == "Object" and typeof(object.constructor) == "function" then
	-- 	local name = object.constructor.name

	-- 	if typeof(name) == "string" and name ~= "" then
	-- 		return name
	-- 	end
	-- end

	-- return tag
	return "Object"
end

return inspect
