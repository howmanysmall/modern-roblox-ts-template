--!optimize 2
--!strict

local task = require("@lune/task")

local function SafeThreadCancel(thread: thread): ()
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
