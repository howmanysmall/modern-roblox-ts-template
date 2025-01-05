--!optimize 2
--!strict

local types = require("./ES7Types")
type Function = types.Function

export type Error = {
	name: string,
	message: string,
	stack: string?,
}
type Private = Error & {__stack: string?}

local Error = {}

local DEFAULT_NAME = "Error"
Error.__index = Error
Error.__tostring = function(self)
	-- Luau FIXME: I can't cast to Error or Object here: Type 'Object' could not be converted into '{ @metatable *unknown*, {|  |} }'
	return getmetatable(Error :: any).__tostring(self)
end

local function RecalculateStacktrace(self: Error)
	local exception = self :: Private
	local message = exception.message
	local name = exception.name or DEFAULT_NAME

	local errorName = name .. (if message ~= nil and message ~= "" then ": " .. message else "")
	local stack = exception.__stack or ""

	local newStackString = string.split(stack, "\n")
	local length = #newStackString
	if newStackString[length] == "" then
		newStackString[length] = nil
	end

	for index, stackLine in newStackString do
		newStackString[index] = `\tat {stackLine}`
	end

	exception.stack = errorName .. "\n" .. table.concat(newStackString, "\n")
end

local function CaptureStackTrace(self: Error, level: number, options: Function?)
	local exception = self :: Private
	if type(options) == "function" then
		local stack = debug.traceback(nil, level)
		local functionName: string = debug.info(options, "n")
		local sourceFilePath: string = debug.info(options, "s")

		local escapedSourceFilePath = string.gsub(sourceFilePath, "([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1")
		local stackTraceLinePattern = escapedSourceFilePath .. ":%d* function " .. functionName
		local start = string.find(stack, stackTraceLinePattern)
		local finish = nil
		if start ~= nil then
			start, finish = string.find(stack, "\n", start + 1)
		end

		if finish ~= nil then
			stack = string.sub(stack, finish + 1)
		end

		exception.__stack = stack
	else
		exception.__stack = debug.traceback(nil, level)
	end

	RecalculateStacktrace(exception)
end

-- ROBLOX NOTE: extracted __createError function so that both Error.new() and Error() can capture the stack trace at the same depth
local function CreateError(message: string?): Error
	local self: Error = setmetatable({
		name = DEFAULT_NAME;
		message = message or "";
	}, Error) :: never

	CaptureStackTrace(self, 4)
	return self
end

function Error.new(message: string?): Error
	return CreateError(message)
end

function Error.captureStackTrace(exception: Error, options: Function?)
	CaptureStackTrace(exception, 3, options)
end

return setmetatable(Error, {
	__call = function(_, ...)
		return CreateError(...)
	end;
	__tostring = function(self)
		local stack = self.stack
		if stack and stack ~= "" then
			return stack
		end

		local name = self.name
		if name ~= nil then
			local message = self.message
			if message and message ~= "" then
				return string.format("%*: %*", name, message)
			end

			return tostring(name)
		end

		return tostring(DEFAULT_NAME)
	end;
})
