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
	Defers a function call in a much more performant manner than `task.defer`.
	This version is safer than [ThreadUtilities.FastDefer] as I think the use
	of varargs can cause some issues.

	@function FastDeferSafe
	@within ThreadUtilities
	@since v1.1.0

	@param callback (Arguments...) -> () -- The function to spawn.
	@param ... Arguments... -- The arguments to the function.
	@return thread
]=]
local function FastDeferSafe<Arguments...>(callback: (Arguments...) -> (), ...: Arguments...)
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
		return task.defer(thread, callback, thread)
	end

	local arguments = {select(1, ...)}
	return task.defer(thread, function()
		callback(table.unpack(arguments, 1, length))
	end, thread)
end

return FastDeferSafe
