--!optimize 2
--!strict
--[=[ lunar
	about = "Cleans up any .gitkeeps that we don't need anymore."
]=]

local LuauPolyfill = require("@packages/LuauPolyfill")
local PathFileSystem = require("@packages/PathFileSystem")

local Path = PathFileSystem.Path
local console = LuauPolyfill.console

local allGitKeeps: {PathFileSystem.Path} = {}
local length = 0

do
	for _, descendant in PathFileSystem.GetDescendants(Path.new("src")) do
		if descendant:fileName() == ".gitkeep" then
			length += 1
			allGitKeeps[length] = descendant
		end
	end
	for _, descendant in PathFileSystem.GetDescendants(Path.new("Vendor")) do
		if descendant:fileName() == ".gitkeep" then
			length += 1
			allGitKeeps[length] = descendant
		end
	end
	for _, descendant in PathFileSystem.GetDescendants(Path.new("VendorServer")) do
		if descendant:fileName() == ".gitkeep" then
			length += 1
			allGitKeeps[length] = descendant
		end
	end
	for _, descendant in PathFileSystem.GetDescendants(Path.new(".lune")) do
		if descendant:fileName() == ".gitkeep" then
			length += 1
			allGitKeeps[length] = descendant
		end
	end
end

for _, gitKeepPath in allGitKeeps do
	local parent = gitKeepPath:parent()
	if not parent then
		console.warn(`{gitKeepPath:toString()} has no parent?`)
		continue
	end

	if #PathFileSystem.ReadDirectory(parent) == 1 then
		-- console.log(`Cannot remove {parent:toString()}`)
		continue
	end

	console.log(`Removing {gitKeepPath:toString()}`)
	PathFileSystem.RemoveFile(gitKeepPath)
end
