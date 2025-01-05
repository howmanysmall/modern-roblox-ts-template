--!optimize 2
--!strict
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/isNaN

return function(value: unknown)
	return type(value) == "number" and value ~= value
end
