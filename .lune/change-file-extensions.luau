--!optimize 2
--!strict
--[=[ lunar
	about = "Changes the file extensions of files in a directory."
	args = "<from-extension> <to-extension> <targets...>"
]=]

local LuauPolyfill = require("@packages/LuauPolyfill")
local PathFileSystem = require("@packages/PathFileSystem")
local process = require("@lune/process")

local Path = PathFileSystem.Path
local console = LuauPolyfill.console
type Path = PathFileSystem.Path

local arguments = table.clone(process.args)
if #arguments < 3 then
	console.warn("You must pass in at least three arguments.")
	console.log("Usage: lunar change-file-extensions <from-extension> <to-extension> <targets...>")
	process.exit(1)
end

local function Extensionify(value: string): string
	return if string.byte(value) == 46 then string.sub(value, 2) else value
end
local function Matchify(value: string): string
	return "%." .. value .. "$"
end

local fromExtension = Extensionify(table.remove(arguments, 1) :: string)
local toExtension = Extensionify(table.remove(arguments, 1) :: string)

local FixFile: (path: Path) -> ()
local FixDirectory: (path: Path) -> ()

local function FixUnknown(path: Path)
	if PathFileSystem.IsFileSafeSilent(path) then
		FixFile(path)
	else
		FixDirectory(path)
	end
end

function FixFile(path: Path): ()
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

function FixDirectory(path: Path): ()
	for _, file in PathFileSystem.ReadDirectory(path) do
		FixUnknown(path:join(file))
	end
end

for _, argument in arguments do
	FixUnknown(Path.new(argument))
end
