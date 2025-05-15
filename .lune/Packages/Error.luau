--!optimize 2
--!strict

type Function = (...any) -> ...any

--[=[
	A JavaScript-style error object.

	```lua
	local function UsingConstructor()
		-- You can use `Error.new`.
		error(Error.new("Something went wrong!"))
	end
	local function UsingCall()
		-- It supports `__call`.
		error(Error("Something went wrong!"))
	end
	local function WithStackTrace()
		-- You can capture a stack trace!
		local exception = Error.new("Something went wrong!")
		Error.captureStackTrace(exception, WithStackTrace)
		error(exception)
	end
	local function WithName()
		-- You can also set the name!
		local exception = Error.new("Something went wrong!")
		exception.name = "UnknownError"
		Error.captureStackTrace(exception, WithName)
		error(exception)
	end
	```

	@tag Supports __tostring

	@class Error
]=]

--[=[
	@prop message string -- The error's message.
	@within Error
]=]
--[=[
	@prop name string -- The error's name.
	@within Error
]=]
--[=[
	@readonly
	@prop stack string? -- The error's stack trace.
	@within Error
]=]

export type Error = {
	message: string,
	name: string,
	stack: string?,
}
type Private = Error & {__stack: string?}

local Error = {}

local DEFAULT_NAME = "Error"
Error.__index = Error
Error.__tostring = function(self)
	-- Luau FIXME: I can't cast to Error or Object here: Type 'Object' could not be converted into '{ @metatable *unknown*, {|  |} }'
	return getmetatable(Error :: never).__tostring(self)
end

local function RecalculateStacktrace(self: Error)
	local exception = self :: Private
	local message = exception.message
	local name = exception.name or DEFAULT_NAME

	local errorName = name .. (if message and message ~= "" then ": " .. message else "")
	local stack = exception.__stack or ""

	local newStackString = string.split(stack, "\n")
	local length = #newStackString
	if newStackString[length] == "" then
		newStackString[length] = nil
	end

	for index, stackLine in newStackString do
		newStackString[index] = "\tat " .. stackLine
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
		local start = string.find(stack, escapedSourceFilePath .. ":%d* function " .. functionName)
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
		message = message or "";
		name = DEFAULT_NAME;
	}, Error) :: never

	CaptureStackTrace(self, 4)
	return self
end

--[=[
	Creates a new Error.

	@param message? unknown -- The message of the error. Defaults to an empty string.
	@return Error
]=]
function Error.new(message: unknown?): Error
	return CreateError(if message then tostring(message) else "")
end

--[=[
	Captures the stack trace of the exception.

	@param exception Error -- The exception to capture the stack trace of.
	@param options? (...any) -> ...any -- The function to use as the stack trace source.
]=]
function Error.captureStackTrace(exception: Error, options: Function?)
	CaptureStackTrace(exception, 3, options)
end
--[=[
	Captures the stack trace of the exception. An alias to
	[Error.captureStackTrace].

	@function CaptureStackTrace
	@within Error

	@param exception Error -- The exception to capture the stack trace of.
	@param options? (...any) -> ...any -- The function to use as the stack trace source.
]=]
Error.CaptureStackTrace = Error.captureStackTrace

return setmetatable(Error, {
	__call = function(_, message: string?)
		return CreateError(message)
	end;
	__tostring = function(self: Error)
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

		return DEFAULT_NAME
	end;
}) :: typeof(setmetatable(
	{} :: {
		new: (message: string?) -> Error,
		captureStackTrace: (exception: Error, options: Function?) -> (),
		CaptureStackTrace: (exception: Error, options: Function?) -> (),
	},
	{} :: {
		__call: (_: any, message: string?) -> Error,
		__tostring: (self: Error) -> string,
	}
))
