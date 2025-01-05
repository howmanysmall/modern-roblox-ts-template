--!optimize 2
--!strict

local FastDefer = require("./FastDefer")
local FastDelay = require("./FastDelay")
local FastSpawn = require("./FastSpawn")
local NoYield = require("./NoYield")
local SafeThreadCancel = require("./SafeThreadCancel")

local ThreadUtilities = table.freeze({
	FastDefer = FastDefer;
	FastDelay = FastDelay;
	FastSpawn = FastSpawn;
	NoYield = NoYield;
	SafeThreadCancel = SafeThreadCancel;
})

return ThreadUtilities
