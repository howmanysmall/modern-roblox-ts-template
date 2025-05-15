--!optimize 2
--!strict

local FastDefer = require("@self/FastDefer")
local FastDeferSafe = require("@self/FastDeferSafe")
local FastDelay = require("@self/FastDelay")
local FastSpawn = require("@self/FastSpawn")
local NoYield = require("@self/NoYield")
local SafeThreadCancel = require("@self/SafeThreadCancel")

--[=[
	Provides utilities for working with threads.

	@class ThreadUtilities
]=]
local ThreadUtilities = table.freeze({
	FastDefer = FastDefer;
	FastDeferSafe = FastDeferSafe;
	FastDelay = FastDelay;
	FastSpawn = FastSpawn;
	NoYield = NoYield;
	SafeThreadCancel = SafeThreadCancel;
})

return ThreadUtilities
