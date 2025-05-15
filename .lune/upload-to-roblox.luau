--!optimize 2
--!strict

local process = require("@lune/process")
local roblox = require("@lune/roblox")

local robloxCookie = roblox.getAuthCookie(true)
if not robloxCookie then
	warn("Failed to get Roblox auth cookie!")
	process.exit(1)
	error("unreachable")
end

local result = process.exec("tarmac", {
	"--auth";
	string.format("%q", robloxCookie);
	"sync";
	"--target";
	"roblox";
})

if not result.ok or result.stderr then
	warn(`Failed to upload to Roblox: ({result.code}) {result.stderr}`)
end
