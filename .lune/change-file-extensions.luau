--!optimize 2
--!strict
--[=[ lunar
	about = "Changes the file extensions of files in a directory."
	args = "<from-extension> <to-extension> <targets...>"
]=]

local ArgParse = require("@packages/ArgParse")
local LuauPolyfill = require("@packages/LuauPolyfill")
local PathFileSystem = require("@packages/PathFileSystem")

local Path = PathFileSystem.Path
local console = LuauPolyfill.console

type Path = PathFileSystem.Path

local parser = ArgParse("change-file-extensions", "Changes the file extensions of files in a directory.")

parser:argument("from-extension", "The extension to change from.")
parser:argument("to-extension", "The extension to change to.")
parser:argument("targets", "The targets to change the extensions of.", nil, nil, "+")

local arguments: {
	["from-extension"]: string,
	targets: {string},
	["to-extension"]: string,
} = parser:parse()

local function Extensionify(value: string): string
	return if string.byte(value) == 46 then string.sub(value, 2) else value
end
local function Matchify(value: string): string
	return "%." .. value .. "$"
end

local fromExtension = Extensionify(arguments["from-extension"])
local toExtension = Extensionify(arguments["to-extension"])

local FixFile: (path: Path) -> ()
local FixDirectory: (path: Path) -> ()

local function FixUnknown(path: Path): ()
	if PathFileSystem.IsFileSafeSilent(path) then
		FixFile(path)
	else
		FixDirectory(path)
	end
end

function FixFile(path): ()
	local extension = path:extension()
	if not extension or extension ~= fromExtension then
		return
	end

	local fileName = path:fileName()
	if not fileName then
		console.warn("Janky garbage library failure for fileName? %*", path:toString())
		return
	end

	local parent = path:parent()
	if not parent then
		console.warn("Janky garbage library failure for parent? %*", path:toString())
		return
	end

	PathFileSystem.Move(path, parent:join((string.gsub(fileName, Matchify(fromExtension), "." .. toExtension))))
end

function FixDirectory(path): ()
	for _, file in PathFileSystem.ReadDirectory(path) do
		FixUnknown(path:join(file))
	end
end

for _, target in arguments.targets do
	FixUnknown(Path.new(target))
end
