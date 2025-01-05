--!optimize 2
--!strict

local Utf8 = require("./Utf8")

local LunePolyfill = table.freeze({
	Utf8 = Utf8;
})

return LunePolyfill
