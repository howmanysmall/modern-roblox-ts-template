--!optimize 2
--!strict

local map = require("./map")
type Array<T> = {T}

return function<T>(arr: {T}, separator: string?): string
	if #arr == 0 then
		return ""
	end

	-- JS does tostring conversion implicitely but in Lua we need to do that explicitely
	return table.concat(map(arr, tostring), separator or ",")
end
