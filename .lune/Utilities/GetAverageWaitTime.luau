--!optimize 2
--!strict

local task = require("@lune/task")

local function GetAverageWaitTime(runs: number, duration: number?): number
	local total = 0
	for _ = 1, runs do
		total += task.wait(duration)
	end
	return total / runs
end

return GetAverageWaitTime
