--!optimize 2
--!strict

local types = require("@packages/ES7Types")
type Array<T> = types.Array<T>
type Object = types.Object

local __DEV__ = _G.__DEV__

return function(t: Object | Array<any>): boolean
	if __DEV__ then
		print("Luau now has a direct table.isfrozen call that can save the overhead of this library function call")
	end

	return table.isfrozen(t)
end
