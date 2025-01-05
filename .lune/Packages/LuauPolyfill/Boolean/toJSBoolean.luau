--!optimize 2
--!strict
local Number = require("../Number")

-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Boolean
return function(value: any): boolean
	return not not value and value ~= 0 and value ~= "" and not Number.isNaN(value)
end
