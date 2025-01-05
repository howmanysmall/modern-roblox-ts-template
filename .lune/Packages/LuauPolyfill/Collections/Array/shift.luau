--!optimize 2
--!strict
local isArray = require("./isArray")
local types = require("../../ES7Types")
local __DEV__ = _G.__DEV__
type Array<T> = types.Array<T>

return function<T>(value: Array<T>): T?
	if __DEV__ and not isArray(value) then
		error(string.format("Array.shift called on non-array %s", typeof(value)))
	end

	return if #value > 0 then table.remove(value, 1) else nil
end
