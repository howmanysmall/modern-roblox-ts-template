--!optimize 2
--!strict
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isSafeInteger

local MAX_SAFE_INTEGER = require("./MAX_SAFE_INTEGER")
local isInteger = require("./isInteger")

return function(value: unknown)
	return isInteger(value) and math.abs(value :: number) <= MAX_SAFE_INTEGER
end
