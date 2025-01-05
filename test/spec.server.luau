--!optimize 2

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local Jest = require(ReplicatedStorage.rbxts_include.node_modules["@rbxts"].jest.src)

local processServiceExists, ProcessService = pcall(function()
	local processServiceName = "ProcessService"
	return game:GetService(processServiceName)
end)

local status, result = Jest.runCLI(script, {
	all = true;
	ci = false;
	setupFiles = {script.Parent.setup};
	verbose = true;
}, {
	ReplicatedStorage.TS;
	ServerScriptService.TS;
	StarterPlayer.StarterPlayerScripts.TS;
}):awaitStatus()

if status == "Rejected" then
	warn(result)
end

if
	status == "Resolved"
	and result.results.numFailedTestSuites == 0
	and result.results.numFailedTests == 0
	and processServiceExists
then
	ProcessService:ExitAsync(0)
end

if processServiceExists then
	ProcessService:ExitAsync(1)
end

return false
