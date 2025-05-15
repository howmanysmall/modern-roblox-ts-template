--!optimize 2
--!strict

-- Marker used to specify that the value is nothing, because nil cannot be
-- stored in tables.

local None = newproxy(true)
local metatable = getmetatable(None)
metatable.__tostring = function()
	return "Object.None"
end

return None
