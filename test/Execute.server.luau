--!optimize 2
--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local Jest = (require :: any)(ReplicatedStorage.rbxts_include.node_modules:FindFirstChild("@rbxts").JestLua.Jest)

-- print("Checking for ProcessService...")
local processServiceExists, ProcessService = pcall(function()
	local processServiceName = "ProcessService"
	return game:GetService(processServiceName)
end)
-- print(`ProcessService {processServiceExists and "exists" or "does not exist"}`)

local roots: {Instance} = {}
local function AddRoot(parent: Instance, name: string): ()
	local child = parent:FindFirstChild(name)
	if child then
		table.insert(roots, child)
	end
end
AddRoot(ReplicatedStorage, "TS")
AddRoot(ServerScriptService, "TS")
AddRoot(StarterPlayer.StarterPlayerScripts, "TS")

if #roots == 0 then
	warn("No test roots found. Please ensure the script is running in a valid environment.")
	ProcessService:ExitAsync(0)
	return
end

-- print("Running jest tests cli...")
local status, result = Jest.runCLI(script, {
	all = true;
	ci = false;
	verbose = true;
}, roots):awaitStatus()
-- print(`Jest tests completed with status {status}`)

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
	return
end

if processServiceExists then
	ProcessService:ExitAsync(1)
	return
end

return false
