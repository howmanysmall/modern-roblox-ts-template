--!optimize 2
--!strict
local types = require("../../ES7Types")
type Array<T> = types.Array<T>
type Object = types.Object

-- FIXME: This should be updated to be closer to the actual
-- `Object.preventExtensions` functionality in JS. This requires additional
-- support from the VM
local function preventExtensions<T>(t: T & (Object | Array<any>)): T
	local name = tostring(t)

	return (
		setmetatable(t :: any, {
			__newindex = function(_, key)
				error(string.format(`%q ({typeof(key)}) is not a valid member of {name}`, tostring(key)), 2)
			end;
			__metatable = false;
		}) :: any
	) :: T
end

return preventExtensions
