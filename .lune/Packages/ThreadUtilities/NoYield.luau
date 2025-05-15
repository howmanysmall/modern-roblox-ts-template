--!optimize 2
--!strict

--@native
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

--[=[
	Executes a function and throws an error if yields at all.

	```lua
	print(ThreadUtilities.NoYield(function()
		return "This", "doesn't", "yield"
	end)) -- This doesn't yield

	print(ThreadUtilities.NoYield(function()
		task.wait()
		return "Errors!!!"
	end)) -- Throws an error!
	```

	```ts
	print(NoYield(() => $tuple("This", "doesn't", "yield"))) // This doesn't yield;
	print(
		NoYield(() => {
			task.wait();
			return "Errors!!!";
		}),
	); // Throws an error!
	```

	@function NoYield
	@within ThreadUtilities

	@param callback (Arguments...) -> Returns... -- The function to execute.
	@param ... Arguments... -- The arguments to the function.
	@return Returns...
]=]
local function NoYield<Arguments..., Returns...>(callback: (Arguments...) -> Returns..., ...: Arguments...): Returns...
	local thread = coroutine.create(callback)
	return ThreadHandler(thread, coroutine.resume(thread, ...))
end

return NoYield
