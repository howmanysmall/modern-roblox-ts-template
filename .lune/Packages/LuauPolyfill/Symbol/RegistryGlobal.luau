--!optimize 2
local Symbol = require("./Symbol")

local GlobalRegistry: {[string]: Symbol.Symbol} = {}

return {
	getOrInit = function(name: string): Symbol.Symbol
		if GlobalRegistry[name] == nil then
			GlobalRegistry[name] = Symbol.new(name)
		end

		return GlobalRegistry[name]
	end;
	-- Used for testing
	__clear = function()
		GlobalRegistry = {}
	end;
}
