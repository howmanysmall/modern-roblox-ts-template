--!optimize 2
--!strict
local types = require("../../ES7Types")
type Array<T> = types.Array<T>
type PredicateFunction<T> = (T, number, Array<T>) -> boolean

return function<T>(array: Array<T>, predicate: PredicateFunction<T>): number
	-- for i = 1, #array do
	-- 	local element = array[i]
	-- 	if predicate(element, i, array) then
	-- 		return i
	-- 	end
	-- end

	for i, element in array do
		if predicate(element, i, array) then
			return i
		end
	end

	return -1
end
