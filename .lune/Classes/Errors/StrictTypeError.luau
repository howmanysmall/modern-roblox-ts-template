--!optimize 2
--!strict

local Error = require("@packages/Error")

export type StrictTypeError = {
	name: "StrictTypeError",
	message: string,
	stack: string?,
}
type Static = typeof(Error) & {
	new: (message: string) -> StrictTypeError,
}

local StrictTypeError: StrictTypeError & Static = setmetatable({}, {__index = Error}) :: any
(StrictTypeError :: any).__index = StrictTypeError;
(StrictTypeError :: any).__tostring = function(self: StrictTypeError): string
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

(StrictTypeError :: any).new = function(message: string): StrictTypeError
	local self = Error.new(message)
	self.name = "StrictTypeError"
	return (setmetatable(self, StrictTypeError) :: unknown) :: StrictTypeError
end

return StrictTypeError
