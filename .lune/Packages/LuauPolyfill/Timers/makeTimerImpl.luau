--!optimize 2
local Status = newproxy(false)

type TaskStatus = number
export type Timeout = {[typeof(Status)]: TaskStatus}

local SCHEDULED = 1
local DONE = 2
local CANCELLED = 3

return function(taskDelay)
	local function setTimeout(callback, delayTime: number?, ...): Timeout
		local arguments = {...}
		local timeout = {
			[Status] = SCHEDULED;
		}

		-- delayTime is an optional parameter
		-- To mimic the JS interface, we're expecting delayTime to be in ms

		local delayTimeMs = (delayTime or 0) / 1000
		taskDelay(delayTimeMs, function()
			if timeout[Status] == SCHEDULED then
				callback(table.unpack(arguments))
				timeout[Status] = DONE
			end
		end)

		return timeout
	end

	local function clearTimeout(timeout: Timeout)
		if timeout == nil then
			return
		end

		if timeout[Status] == SCHEDULED then
			timeout[Status] = CANCELLED
		end
	end

	return table.freeze({
		clearTimeout = clearTimeout;
		setTimeout = setTimeout;
	})
end
