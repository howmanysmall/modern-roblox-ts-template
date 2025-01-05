--!optimize 2
--!strict

local Number = require("../Number")
local NaN = Number.NaN

-- js  https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/charCodeAt
-- lua http://www.lua.org/manual/5.4/manual.html#pdf-utf8.codepoint
return function(value: string, index: number): number
	if type(index) ~= "number" then
		index = 1
	end

	--[[
		Initial bounds check. Checking string.len is not an exhaustive upper bound,
		but it is cheaper to check string.len and handle utf8.offset than to check
		utf.len, which iterates over all codepoints.
	]]
	local length = #value
	if index < 1 or index > length then
		return NaN
	end

	-- utf8.offset returns nil for out of bounds
	local offset = utf8.offset(value, index)

	-- check that offset is not greater than the length of the string
	if offset == nil or offset > length then
		return NaN
	end

	return utf8.codepoint(value, offset, offset) or NaN
end
