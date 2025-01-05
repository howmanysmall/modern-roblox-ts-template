--!optimize 2
--!strict

local TypeOf = require("@packages/TypeOf")

local Debug = {}
local TAB = "\t"

type GenericDictionary = {[string]: any}
type GenericTable = {[any]: any}

local Debug_Inspect: (...any) -> string

local REPLACERS = {
	["Index ?"] = "__index";
	["Newindex ?"] = "__newindex";
}

local function GetErrorData(
	formatString: string,
	...: unknown
): (string, number?) -- Make sure if you don't intend to format arguments in, you do %%f instead of %f
	if type(formatString) ~= "string" then
		error(GetErrorData("!The first parameter of error formatting must be a string", "Debug"))
	end

	local length = select("#", ...)
	local packedArguments = {...}
	local arguments: {string} = table.create(length)

	local traceback = debug.traceback()
	local errorDepth = select(2, string.gsub(traceback, "\n", "")) - 2

	local prefix
	formatString, prefix = string.gsub(formatString, "^!", "", 1)

	local debugInfo = debug.info(errorDepth, "s")
	local moduleName = if not debugInfo
		then prefix == 1 and table.remove(packedArguments, 1) or "Command bar"
		else prefix == 1 and table.remove(packedArguments, 1)
			or table.remove(string.split(debugInfo, "."))
			or "Command bar"

	local functionName = ""

	for index = 1, length do
		arguments[index] = Debug_Inspect(packedArguments[index])
	end

	for matched in string.gmatch(string.sub(traceback, 1, -11), "%- [^\r\n]+[\r\n]") do
		functionName = matched
	end

	functionName =
		string.gsub(string.gsub(string.sub(functionName, 3, -2), "%l+ (%S+)$", "%1"), " ([^\n\r]+)", " %1", 1)

	local index = 0
	for matched in string.gmatch(formatString, "%%%l") do
		index += 1
		if matched == "%q" then
			arguments[index] = string.gsub(arguments[index], " (%S+)$", " \"%1\"", 1)
		end
	end

	local success, errorString = pcall(
		string.format,
		"[%*] {%*} " .. string.gsub(formatString, "%%q", "%%*"),
		moduleName,
		REPLACERS[functionName] or functionName,
		table.unpack(arguments)
	)

	if success then
		return errorString, errorDepth
	end

	error(
		GetErrorData(
			"!Error formatting failed, perhaps try escaping non-formattable tags like so: %%%%f\n(Error Message): "
				.. errorString,
			"Debug"
		)
	)
end

function Debug.InspectFormat(formatString: string, ...): string
	if type(formatString) ~= "string" then
		error(GetErrorData("!The first parameter of error formatting must be a string", "Debug"))
	end

	local arguments = {...}
	formatString = string.gsub(formatString, "^!", "", 1)

	for index = 1, select("#", ...) do
		arguments[index] = Debug_Inspect(arguments[index])
	end

	local index = 0
	for matched in string.gmatch(formatString, "%%%l") do
		index += 1
		if matched == "%q" then
			arguments[index] = string.gsub(arguments[index], " (%S+)$", " \"%1\"", 1)
		end
	end

	local success, errorString =
		pcall(string.format, (string.gsub(formatString, "%%q", "%%*")), table.unpack(arguments))

	if success then
		return errorString
	end

	error(
		GetErrorData(
			"!Error formatting failed, perhaps try escaping non-formattable tags like so: %%%%f\n(Error Message): "
				.. errorString,
			"Debug"
		)
	)
end

function Debug.Warn(...)
	warn((GetErrorData(...)))
end

function Debug.Error(...)
	error(GetErrorData(...))
end

function Debug.Assert(condition, ...)
	return condition or error(GetErrorData(...))
end

local function AssertNoTypes(condition, ...)
	return condition or error(GetErrorData(...))
end
Debug.AssertNoTypes = AssertNoTypes :: (...any) -> any

local function Alphabetically(a: unknown, b: unknown): boolean
	local typeA = TypeOf(a)
	local typeB = TypeOf(b)

	if typeA == typeB then
		return if typeA == "number"
			then (a :: number) < b :: number
			else string.lower(tostring(a)) < string.lower(tostring(b))
	end

	return typeA < typeB
end

local function AlphabeticalOrder<K, V>(dictionary: {[K]: V})
	local order = {}
	local length = 0

	for key in dictionary do
		length += 1
		order[length] = key
	end

	table.sort(order, Alphabetically)

	local index = 0
	-- stylua: ignore
	return function(iteratedTable)
		index += 1
		local key = order[index]
		return key, iteratedTable[key], index
	end, dictionary, nil
end

Debug.AlphabeticalOrder = AlphabeticalOrder :: <K, V>(dictionary: {[K]: V}) -> () -> (K, V, number)

local ConvertTableIntoString: (
	object: {[any]: any},
	tableName: string?,
	multiline: boolean?,
	depth: number,
	encounteredTables: {[any]: any}
) -> string

local function Parse(object: any, multiline: boolean?, depth: number, encounteredTables: {[any]: any}): string
	local typeOf = TypeOf(object)

	return typeOf == "table"
			and (encounteredTables[object] and "[table " .. encounteredTables[object] .. "]" or ConvertTableIntoString(
				object,
				nil,
				multiline,
				depth + 1,
				encounteredTables
			))
		or typeOf == "string" and "\"" .. object .. "\""
		-- or typeOf == "Instance" and "<" .. Debug.DirectoryToString(object) .. ">"
		or (typeOf == "function" or typeOf == "userdata") and typeOf
		or tostring(object)
end

function ConvertTableIntoString(
	object: {[any]: any},
	tableName: string?,
	multiline: boolean?,
	depth: number,
	encounteredTables: {[any]: any}
): string
	local n = encounteredTables.n + 1
	encounteredTables[object] = n
	encounteredTables.n = n

	local array: {string} = {}
	local length = 1
	local currentArrayIndex = 1

	if tableName then
		array[1] = tableName
		array[2] = " = {"
		length = 2
	else
		array[1] = "{"
	end

	if not next(object) then
		array[length + 1] = "}"
		return table.concat(array)
	end

	for key, value in Debug.AlphabeticalOrder(object) do
		if not multiline and type(key) == "number" then
			if key == currentArrayIndex then
				currentArrayIndex += 1
			else
				length += 1
				array[length] = "[" .. key .. "] = "
			end

			length += 1
			array[length] = Parse(value, multiline, depth, encounteredTables)

			length += 1
			array[length] = ", "
		else
			if multiline then
				length += 1
				array[length] = "\n"

				length += 1
				array[length] = string.rep(TAB, depth)
			end

			if type(key) == "string" and string.find(key, "^[%a_][%w_]*$") then
				length += 1
				array[length] = key
			else
				length += 1
				array[length] = "["

				length += 1
				array[length] = Parse(key, multiline, depth, encounteredTables)

				length += 1
				array[length] = "]"
			end

			length += 1
			array[length] = " = "

			length += 1
			array[length] = Parse(value, multiline, depth, encounteredTables)

			length += 1
			array[length] = multiline and ";" or ", "
		end
	end

	if multiline then
		length += 1
		array[length] = "\n"

		length += 1
		array[length] = string.rep(TAB, depth - 1)
	else
		array[length] = nil
		length -= 1
	end

	length += 1
	array[length] = "}"

	local metatable = getmetatable(object :: never)

	if metatable then
		length += 1
		array[length] = " <- "

		length += 1
		array[length] = if type(metatable) == "table"
			then ConvertTableIntoString(metatable, nil, multiline, depth, encounteredTables)
			else Debug_Inspect(metatable)
	end

	return table.concat(array)
end

function Debug.TableToString<K, V>(object: {[K]: V}, multiline: boolean?, tableName: string?): string
	return ConvertTableIntoString(object, tableName, multiline, 1, {n = 0})
end

local ESCAPED_CHARACTERS = {"%", "^", "$", "(", ")", ".", "[", "]", "*", "+", "-", "?"}
local ESCAPABLE = "([%" .. table.concat(ESCAPED_CHARACTERS, "%") .. "])"

function Debug.EscapeString(value: string): string
	return (string.gsub(string.gsub(value, ESCAPABLE, "%%%1"), "([\"'\\])", "\\%1"))
end

function Debug_Inspect(...: any): string
	local variableArgumentsLength = select("#", ...)
	if variableArgumentsLength == 0 then
		return "NONE"
	end

	local stringBuilder = table.create(variableArgumentsLength * 2)
	local length = 0

	for index = 1, variableArgumentsLength do
		local data = select(index, ...)
		local dataType = TypeOf(data)
		local dataString

		if dataType == "EnumItem" then
			dataType = tostring(data.EnumType)
			dataString = tostring(data)
		elseif dataType == "EnumerationItem" then
			dataType = tostring(data.EnumerationType)
			dataString = tostring(data)
		else
			dataString = if dataType == "table"
				then Debug.TableToString(data)
				elseif dataType == "string" then "\"" .. data .. "\""
				else tostring(data)
		end

		stringBuilder[length + 1] = ", "
		stringBuilder[length + 2] =
			string.gsub(dataType .. " " .. dataString, "^" .. dataType .. " " .. dataType, dataType, 1)
		length += 2
	end

	return string.sub(table.concat(stringBuilder), 3)
end
Debug.Inspect = Debug_Inspect

return table.freeze(Debug)
