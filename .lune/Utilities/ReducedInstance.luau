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
	Lune instances are tables containing a reference to the instance, but Lune creates
	different tables even for the same instance. Jest's caching behavior depends
	on the instance always being the same to look it up by key, so this function serves to
	always return the same "wrapped" instance when given the same instance. It has to also
	override the FindFirstChild, WaitForChild, and Instance property getter to ensure they
	also return a "wrapped" instance.
--]]

local roblox = require("@lune/roblox")

local ReducedInstance = {}
local cache = {}

local function Once(instance: roblox.Instance): roblox.Instance
	assert(instance, "Instance is nil")

	local debugId = instance:GetDebugId()
	if cache[debugId] then
		return cache[debugId]
	end

	local self = setmetatable({
		instance = instance;
	}, {
		-- selene: allow(shadowing)
		__index = function(self, key): any?
			local value = self.instance[key]
			if type(value) == "function" then
				if key == "FindFirstChild" then
					return function(self, ...): roblox.Instance?
						local child = self.instance:FindFirstChild(...)
						if child then
							return Once(child :: roblox.Instance)
						end
						return
					end
				elseif key == "WaitForChild" then
					return function(self, ...)
						return Once(self.instance:WaitForChild(...) :: roblox.Instance)
					end
				else
					return function(self, ...)
						return value(self.instance, ...)
					end
				end
			elseif typeof(value) == "Instance" then
				return Once((value :: never) :: roblox.Instance)
			end

			return value
		end;
		-- selene: allow(shadowing)
		__newindex = function(self, key, value)
			self.instance[key] = value
		end;
		__metatable = false;
	})

	cache[debugId] = self

	return (self :: any) :: roblox.Instance
end
ReducedInstance.Once = Once

return table.freeze(ReducedInstance)
