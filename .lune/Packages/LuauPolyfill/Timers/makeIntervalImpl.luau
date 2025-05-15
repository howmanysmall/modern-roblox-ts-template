--!optimize 2
--!strict

local Status = newproxy(false)

type TaskStatus = number
export type Interval = {[typeof(Status)]: TaskStatus}

local SCHEDULED = 1
local CANCELLED = 3

return function(taskDelay)
	local function setInterval(callback, intervalTime: number?, ...): Interval
		local arguments = {...}
		local interval = {
			[Status] = SCHEDULED;
		}

		-- intervalTime is an optional parameter
		-- To mimic the JS interface, we're expecting delayTime to be in ms
		local intervalTimeMs = (intervalTime or 0) / 1000
		local function execute(): ()
			taskDelay(intervalTimeMs, function()
				if interval[Status] == SCHEDULED then
					callback(table.unpack(arguments))
					execute()
				end
			end)
		end

		execute()

		return interval
	end

	local function clearInterval(interval: Interval)
		if interval == nil then
			return
		end

		if interval[Status] == SCHEDULED then
			interval[Status] = CANCELLED
		end
	end

	return table.freeze({
		clearInterval = clearInterval;
		setInterval = setInterval;
	})
end
