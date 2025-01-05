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
	Provides a connection to a loop that runs every frame. This is used
	in the custom Heartbeat implementation in lune/test.luau
--]]

local ThreadUtilities = require("@utilities/ThreadUtilities")
local task = require("@lune/task")

type Subscription = {
	Connected: boolean,
	Function: (deltaTime: number) -> (),
}
export type Connection = {
	Connected: boolean,
	Disconnect: (self: Connection) -> (),
}

local Runtime = {}

local isRunning = false
local subscriptions: {Subscription} = {}

local function Loop()
	if isRunning then
		return
	end

	isRunning = true
	while #subscriptions > 0 do
		local deltaTime = task.wait()
		for _, subscription in subscriptions do
			if subscription.Connected then
				subscription.Function(deltaTime)
			end
		end

		for index = #subscriptions, 1, -1 do
			if not subscriptions[index].Connected then
				table.remove(subscriptions, index)
			end
		end
	end
	isRunning = false
end

function Runtime.Connect(_: unknown, callback: (deltaTime: number) -> ()): Connection
	local subscription: Subscription = {
		Connected = true;
		Function = callback;
	}
	table.insert(subscriptions, subscription)
	ThreadUtilities.FastSpawn(Loop)

	return {
		Connected = true;
		Disconnect = function(self)
			self.Connected = false
			subscription.Connected = false
		end;
	}
end

return table.freeze(Runtime)
