_G.NOCOLOR = true

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")

local Jest = require(ReplicatedStorage.rbxts_include.node_modules["@rbxts"].jest.src)

local function GetTestFolders(...: Instance)
	local folders = {}
	local length = 0

	for index = 1, select("#", ...) do
		local parent = select(index, ...)
		if typeof(parent) ~= "Instance" then
			continue
		end

		for _, descendant in parent:GetDescendants() do
			if descendant:IsA("Folder") and descendant.Name == "__tests__" then
				if not descendant:FindFirstChild("jest.config") then
					continue
				end

				length += 1
				folders[length] = descendant
			end
		end
	end

	return folders
end

local status, result = Jest.runCLI(script, {
	verbose = false;
	ci = false;
	setupFiles = {script.Parent.setup};
}, GetTestFolders(ReplicatedStorage, ServerScriptService, StarterPlayer)):awaitStatus()

if status == "Rejected" then
	print(result)
	error("Tests failed")
end
