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
	Delays a function call in a much more performant manner than `task.delay`.

	@function FastDelay
	@within ThreadUtilities

	@param delay number -- The delay before the function is executed.
	@param callback (Arguments...) -> () -- The function to spawn.
	@param ... Arguments... -- The arguments to the function.
	@return thread
]=]
local function FastDelay<Arguments...>(delay: number, callback: (Arguments...) -> (), ...: Arguments...)
	local thread: thread
	local freeAmount = #FreeThreads

	if freeAmount > 0 then
		thread = FreeThreads[freeAmount]
		FreeThreads[freeAmount] = nil
	else
		thread = coroutine.create(Yield)
		coroutine.resume(thread)
	end

	local length = select("#", ...)
	if length == 0 then
		return task.delay(delay, thread, callback, thread)
	end

	local arguments = {select(1, ...)}
	return task.delay(delay, thread, function()
		callback(table.unpack(arguments, 1, length))
	end, thread)
end

return FastDelay
