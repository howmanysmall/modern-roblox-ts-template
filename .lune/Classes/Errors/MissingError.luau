--!optimize 2
--!strict

local Error = require("@packages/Error")

export type MissingError = {
	name: "MissingError",
	message: string,
	stack: string?,
}
type Static = typeof(Error) & {
	new: (message: string) -> MissingError,
}

local MissingError: MissingError & Static = setmetatable({}, {__index = Error}) :: any
(MissingError :: any).__index = MissingError;
(MissingError :: any).__tostring = function(self: MissingError): string
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

(MissingError :: any).new = function(message: string): MissingError
	local self = Error.new(message)
	self.name = "MissingError"
	return (setmetatable(self, MissingError) :: unknown) :: MissingError
end

return MissingError
