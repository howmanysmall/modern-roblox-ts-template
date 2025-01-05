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
	Jest depends on `loadmodule` existing on the `debug` api.
	On Roblox, it's locked behind a feature flag FFlagDebugLoadModule, which is not enabled by default.
	In Lune, it doesn't exist at all, so this module creates the interface for it but is not implemented.
	The _loader function needs to be overridden to be usable.
	In this project, the `lune/test.luau` script implements and sets the _loader function.
--]]

local Debug

Debug = setmetatable({
	_loader = function(_moduleScript: any)
		error("The loader for Debug.loadmodule is not implemented")
	end;

	loadmodule = function(moduleScript)
		return Debug._loader(moduleScript)
	end;

	getmemorycategory = function() end;
	profilebegin = function() end;
	profileend = function() end;
	resetmemorycategory = function() end;
	setmemorycategory = function() end;
}, {__index = debug})

return Debug
