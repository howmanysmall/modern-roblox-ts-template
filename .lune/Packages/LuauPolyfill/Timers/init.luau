--!optimize 2
--!strict

local task = require("@lune/task")

local MakeInterval = require("@self/makeIntervalImpl")
local MakeTimer = require("@self/makeTimerImpl")

export type Timeout = MakeTimer.Timeout
export type Interval = MakeInterval.Interval

local Interval = MakeInterval(task.delay)
local Timer = MakeTimer(task.delay)

local Timers = table.freeze({
	clearInterval = Interval.clearInterval;
	setInterval = Interval.setInterval;

	clearTimeout = Timer.clearTimeout;
	setTimeout = Timer.setTimeout;
})

return Timers
