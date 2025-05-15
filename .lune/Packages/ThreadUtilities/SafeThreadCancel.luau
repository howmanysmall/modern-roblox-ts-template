--!optimize 2
--!strict

local task = require("@lune/task")

--[=[
	Cancelling threads can sometimes cause weird issues that throw errors. This
	function is a workaround for that to make sure your threads are always
	cancelled in a safe manner.

	@function SafeThreadCancel
	@within ThreadUtilities

	@param thread thread -- The thread to cancel.
]=]
local function SafeThreadCancel(thread: thread)
	local cancelled: boolean?
	if coroutine.running() ~= thread then
		cancelled = pcall(function()
			return task.cancel(thread)
		end)
	end

	if not cancelled then
		local toCancel = thread
		thread = nil :: never

		-- Could probably convert this to use FastDefer?
		task.defer(function()
			task.cancel(toCancel)
		end)
	end
end

return SafeThreadCancel
