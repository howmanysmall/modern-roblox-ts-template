--!optimize 2
--!strict

local function ThreadHandler(thread: thread, success: boolean, ...)
	if not success then
		local exception = (...)
		if type(exception) == "string" then
			error(debug.traceback(thread, exception), 2)
		else
			error(tostring(exception), 2)
		end
	end

	if coroutine.status(thread) ~= "dead" then
		error(debug.traceback(thread, "Attempted to yield inside NoYield!"), 2)
	end

	return ...
end

local function NoYield<Arguments..., Returns...>(callback: (Arguments...) -> Returns..., ...: Arguments...): Returns...
	local thread = coroutine.create(callback)
	return ThreadHandler(thread, coroutine.resume(thread, ...))
end

return NoYield
