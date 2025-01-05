--!optimize 2
--!strict
--[=[ lunar
	about = "Removes zone identifier files."
	args = "<targets...>"
]=]

local ArgParse = require("@packages/ArgParse")
local LuauPolyfill = require("@packages/LuauPolyfill")
local PathFileSystem = require("@packages/PathFileSystem")

local Path = PathFileSystem.Path
local console = LuauPolyfill.console

type Path = PathFileSystem.Path

local parser = ArgParse("remove-identifiers", "Removes zone identifier files.")

parser:argument("targets", "The target folders to remove the files from.", nil, nil, "+")

local arguments: {targets: {string}} = parser:parse()

for _, target in arguments.targets do
	local success, path = pcall(Path.from, target)
	if not success then
		console.error("Could not parse path %*", target)
		continue
	end

	if not PathFileSystem.IsDirectorySafe(path) then
		continue
	end

	for _, descendant in PathFileSystem.GetDescendants(path) do
		if not PathFileSystem.IsFileSafeSilent(descendant) then
			continue
		end

		if descendant:extension() == "Identifier" then
			PathFileSystem.RemoveFile(descendant)
		end
	end
end
