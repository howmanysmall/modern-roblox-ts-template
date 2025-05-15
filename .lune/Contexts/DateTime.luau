--!optimize 2
--!strict

--[[
MIT License

Copyright (c) 2024 BusyCityGuy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

--[[
	Lune's `datetime` module uses lowerCamelCase, whereas Roblox's `DateTime` module uses UpperCamelCase.
	To allow for Roblox-style usage of DateTime objects, this module wraps Lune's `datetime` module to add
	Roblox-style properties and methods through the use of metatables.

	This module may need to be updated as different properties and methods are needed.
--]]

local LuneDateTime = require("@lune/datetime")

local DateTime = setmetatable({
	now = function()
		local self = LuneDateTime.now()
		return setmetatable({
			UnixTimestampMillis = self.unixTimestampMillis;
			UnixTimestamp = self.unixTimestamp;
		}, {__index = self})
	end;
}, {__index = LuneDateTime})

return DateTime
