--!optimize 2
--!strict

local Signal = require("./Signal")
local roblox = require("@lune/roblox")

local roblox_Instance_new = roblox.Instance.new

local Instance = setmetatable({
	new = function(className: string, parent: roblox.Instance?)
		if className == "BindableEvent" then
			return Signal.new()
		end

		return roblox_Instance_new(className, parent)
	end;
}, {__index = roblox.Instance})

return Instance
