--!optimize 2
--!strict

local ES7Types = require("@packages/ES7Types")
local InstanceOf = require("@packages/InstanceOf")
local Set = require("../Set")

type Array<T> = ES7Types.Array<T>
type Set<T> = ES7Types.Set<T>
type Table = {[any]: any}

return function(value: Set<any> | Table | string): Array<string>
	if value == nil then
		error("cannot extract keys from a nil value")
	end

	local valueType = type(value)

	local keys
	if valueType == "table" then
		keys = {}
		if InstanceOf(value, Set) then
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
