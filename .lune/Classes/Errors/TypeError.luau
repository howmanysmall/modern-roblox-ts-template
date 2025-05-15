--!optimize 2
--!strict

local Error = require("@packages/Error")

export type TypeError = {
	name: "TypeError",
	message: string,
	stack: string?,
}
type Static = typeof(Error) & {
	new: (message: string) -> TypeError,
}

local TypeError: TypeError & Static = setmetatable({}, {__index = Error}) :: any;
(TypeError :: any).__index = TypeError;
(TypeError :: any).__tostring = function(self: TypeError): string
	local stack = self.stack
	if stack ~= nil and stack ~= "" then
		return stack
	end

	local message = self.message
	if message then
		return string.format("%*: %*", self.name, tostring(message))
	end

	return self.name
end;

(TypeError :: any).new = function(message: string): TypeError
	local self: TypeError = Error.new(message) :: never
	self.name = "TypeError"
	return setmetatable(self, TypeError) :: never
end

return TypeError
