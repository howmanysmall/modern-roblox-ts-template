--!optimize 2
--!strict

local Types = require("./Types")
local WriteFmt = require("./WriteFmt")

local INDENTATION = "    "
local repeatCache: {[string]: {[number]: string}} = {}
local function StringRep(value: string, count: number)
	local cache = repeatCache[value]
	if not cache then
		cache = {}
		repeatCache[value] = cache
	end

	local result = cache[count]
	if not result then
		result = string.rep(value, count)
		cache[count] = result
	end

	return result
end

for index = 1, 10 do
	StringRep(INDENTATION, index)
end

export type Formatter = Types.Formatter

type Methods =
	"AsString"
	| "AsTuple"
	| "AddTable"
	| "Lock"
	| "Unlock"
	| "AddToBuffer"
	| "Indent"
	| "NextLine"
	| "Unindent"
	| "Write"
	| "WriteLine"
	| "WriteLineRaw"
	| "WriteRaw"

local function CreateFormatter(): Formatter
	local stringBuilder = {}
	local length = 0

	local display = ""
	local indentation = ""
	local indentLevel = 0
	local isLocked = false
	local startOfLine = true

	local function formatter(method: Methods, ...): ()
		if method == "AsString" then
			return display
		end

		if method == "AsTuple" then
			return table.unpack(stringBuilder)
		end

		if method == "Write" then
			WriteFmt(formatter :: never, ...)
			return
		end

		if method == "AddToBuffer" then
			if not isLocked then
				local value = ...
				local finalValue = stringBuilder[length]

				if type(value) == "string" and type(finalValue) == "string" then
					stringBuilder[length] = finalValue .. value
				else
					length += 1
					stringBuilder[length] = value
				end
			end
		elseif method == "NextLine" then
			formatter("AddToBuffer", "\n")
			display ..= "\n"
			startOfLine = true
		elseif method == "WriteRaw" then
			local value: string = ...
			if #value > 0 then
				if startOfLine and indentLevel > 0 then
					startOfLine = false
					formatter("AddToBuffer", indentation)
					display ..= indentation
				end

				startOfLine = false
				formatter("AddToBuffer", value)
				display ..= value
			end
		elseif method == "WriteLine" then
			WriteFmt(formatter :: never, ...)
			formatter("NextLine")
		elseif method == "WriteLineRaw" then
			formatter("WriteRaw", ...)
			formatter("NextLine")
		elseif method == "AddTable" then
			length += 1
			stringBuilder[length] = (...)
		elseif method == "Indent" then
			indentLevel += 1
			indentation = StringRep(INDENTATION, indentLevel)
		elseif method == "Unindent" then
			indentLevel = math.max(indentLevel - 1, 0)
			indentation = StringRep(INDENTATION, indentLevel)
		elseif method == "Lock" then
			isLocked = true
		elseif method == "Unlock" then
			isLocked = false
		end
	end

	return formatter :: never
end

return CreateFormatter
