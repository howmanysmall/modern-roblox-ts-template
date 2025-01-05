--!optimize 2
--!strict
local types = require("../../ES7Types")
type Array<T> = types.Array<T>

-- TODO Luau: needs overloads to model this more correctly
return function<T>(value: {[string]: T} | Array<T> | string): Array<T> | Array<string>
	if value == nil then
		error("cannot extract values from a nil value")
	end

	local valueType = type(value)
	local array: Array<T> | Array<string>
	if valueType == "table" then
		array = {} :: Array<T>
		for _, keyValue in pairs(value :: {[string]: T} | Array<T>) do
			table.insert(array, keyValue)
		end
	elseif valueType == "string" then
		-- optimization to avoid rehashing/growth
		local valueStringLength = #(value :: string)
		array = table.create(valueStringLength)
		for i = 1, valueStringLength do
			(array :: Array<string>)[i] = string.sub(value :: string, i, i)
		end
	end

	return array
end
