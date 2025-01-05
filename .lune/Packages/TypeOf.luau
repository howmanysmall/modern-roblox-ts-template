--!optimize 2
--!strict

local STRING_CASES: {[string]: string} = {}

local function TypeOf(value: any): string
	local typeOf = typeof(value)
	if typeOf == "userdata" or typeOf == "table" then
		local metatable = getmetatable(value)
		if metatable then
			if type(metatable) == "table" then
				local internalType = metatable.__type or metatable.ClassName
				if internalType then
					return internalType
				end
			elseif type(metatable) == "string" then
				return STRING_CASES[metatable] or metatable
			end
		end
	end

	return typeOf
end

return TypeOf
