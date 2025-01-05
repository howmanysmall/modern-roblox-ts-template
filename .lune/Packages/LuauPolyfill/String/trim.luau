--!optimize 2
--!strict

local trimEnd = require("./trimEnd")
local trimStart = require("./trimStart")

return function(source: string): string
	return trimStart(trimEnd(source))
end
