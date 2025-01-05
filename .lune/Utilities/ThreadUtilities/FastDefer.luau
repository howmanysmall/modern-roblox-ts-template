--!optimize 2
--!strict

local task = require("@lune/task")

local freeThreads: {thread} = table.create(500)
local freeAmount = 0

local function RunFunction<Arguments...>(callback: (Arguments...) -> (), thread: thread, ...: Arguments...): ()
	callback(...)
	freeAmount += 1
	freeThreads[freeAmount] = thread
end

local function Yield(): ()
	while true do
		RunFunction(coroutine.yield())
	end
end

local function FastDefer<Arguments...>(callback: (Arguments...) -> (), ...: Arguments...): thread
	local thread: thread

	if freeAmount > 0 then
		thread = freeThreads[freeAmount]
		freeThreads[freeAmount] = nil
		freeAmount -= 1
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

return FastDefer
