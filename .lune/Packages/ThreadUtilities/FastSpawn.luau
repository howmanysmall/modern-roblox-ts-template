--!optimize 2
--!strict

local task = require("@lune/task")

local FreeThreads: {thread} = table.create(500)
local function RunFunction<Arguments...>(callback: (Arguments...) -> (), thread: thread, ...: Arguments...)
	callback(...)
	table.insert(FreeThreads, thread)
end

local function Yield()
	while true do
		RunFunction(coroutine.yield())
	end
end

--[=[
	Spawns a function call in a much more performant manner than `task.spawn`
	or the `coroutine` library can provide.

	@function FastSpawn
	@within ThreadUtilities

	@param callback (Arguments...) -> () -- The function to spawn.
	@param ... Arguments... -- The arguments to the function.
	@return thread
]=]
local function FastSpawn<Arguments...>(callback: (Arguments...) -> (), ...: Arguments...)
	local thread: thread
	local freeAmount = #FreeThreads

	if freeAmount > 0 then
		thread = FreeThreads[freeAmount]
		FreeThreads[freeAmount] = nil
	else
		thread = coroutine.create(Yield)
		coroutine.resume(thread)
	end

	return task.spawn(thread, callback, thread, ...)
end

return FastSpawn
