--!optimize 2
local Set = require("../Set")
local instanceOf = require("../../InstanceOf")
local types = require("../../ES7Types")
type Array<T> = types.Array<T>
type Set<T> = types.Set<T>
type Table = {[any]: any}

return function(value: Set<any> | Table | string): Array<string>
	if value == nil then
		error("cannot extract keys from a nil value")
	end

	local valueType = type(value)

	local keys
	if valueType == "table" then
		keys = {}
		if instanceOf(value, Set) then
			return keys
		end

		for key in pairs(value :: Table) do
			table.insert(keys, key)
		end
	elseif valueType == "string" then
		local length = #(value :: string)
		keys = table.create(length)
		for i = 1, length do
			keys[i] = tostring(i)
		end
	end

	return keys
end
