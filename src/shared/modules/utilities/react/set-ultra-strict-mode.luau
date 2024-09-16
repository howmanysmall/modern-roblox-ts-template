--!optimize 2
--!strict

local function setUltraStrictMode(value: boolean)
	_G.__DEV__ = value
end

return setUltraStrictMode
