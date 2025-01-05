--!optimize 2
--!strict

local LunePolyfill = require("@packages/LunePolyfill")

local Utf8 = setmetatable({
	graphemes = LunePolyfill.Utf8.Graphemes;
}, {__index = utf8})

return Utf8
