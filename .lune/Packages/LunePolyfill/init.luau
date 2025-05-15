--!optimize 2
--!strict

local Utf8 = require("@self/Utf8")

local LunePolyfill = table.freeze({
	Utf8 = Utf8;
})

return LunePolyfill
