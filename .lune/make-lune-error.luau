--!optimize 2
--!strict

local ArgParse = require("@packages/ArgParse")
local LuauPolyfill = require("@packages/LuauPolyfill")
local PathFileSystem = require("@packages/PathFileSystem")
local process = require("@lune/process")

local console = LuauPolyfill.console

local parser = ArgParse("make-lune-error", "Makes Lune Error classes.")
parser:argument("names", "The names of the Error classes.", nil, nil, "+")

local arguments: {names: {string}} = parser:parse()

local ERRORS_FOLDER = PathFileSystem.CWD:join(".lune"):join("Classes"):join("Errors")
if not PathFileSystem.IsDirectory(ERRORS_FOLDER) then
	console.error(`Missing folder at {ERRORS_FOLDER}!`)
	process.exit(1)
end

local BASE_STRING = [==[--!optimize 2
--!strict

local Error = require("@packages/Error")

export type __ERROR_NAME__ = {
	name: "__ERROR_NAME__",
	message: string,
	stack: string?,
}
type Static = typeof(Error) & {
	new: (message: string) -> __ERROR_NAME__,
}

local __ERROR_NAME__: __ERROR_NAME__ & Static = setmetatable({}, {__index = Error}) :: any
(__ERROR_NAME__ :: any).__index = __ERROR_NAME__;
(__ERROR_NAME__ :: any).__tostring = function(self: __ERROR_NAME__): string
	local stack = self.stack
	if stack ~= nil and stack ~= "" then
		return stack
	end

	local message = self.message
	if message then
		return string.format("%*: %*", self.name, tostring(message))
	end

	return self.name
end

(__ERROR_NAME__ :: any).new = function(message: string): __ERROR_NAME__
	local self = Error.new(message)
	self.name = "__ERROR_NAME__"
	return (setmetatable(self, __ERROR_NAME__) :: unknown) :: __ERROR_NAME__
end

return __ERROR_NAME__
]==]

for _, errorName in arguments.names do
	if string.sub(errorName, -5) ~= "Error" then
		errorName ..= "Error"
	end

	local fileName = ERRORS_FOLDER:join(`{errorName}.luau`)
	if PathFileSystem.IsFile(fileName) then
		continue
	end

	PathFileSystem.WriteFile(fileName, (string.gsub(BASE_STRING, "__ERROR_NAME__", errorName)))
end
