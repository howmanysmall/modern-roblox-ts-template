--!optimize 2
--!strict

local LuauPath = require("@packages/LuauPath")
local LuauPolyfill = require("@packages/LuauPolyfill")

local fs = require("@lune/fs")
local process = require("@lune/process")

local PathFileSystem = {}

local Path = LuauPath.Path
local console = LuauPolyfill.console

export type AsPath = LuauPath.AsPath
export type Contents = buffer | string
export type Metadata = fs.Metadata
export type MetadataKind = fs.MetadataKind
export type MetadataPermissions = fs.MetadataPermissions
export type Path = LuauPath.Path
export type WriteOptions = fs.WriteOptions

PathFileSystem.Path = Path

local function AsPathToString(asPath: AsPath): string
	if type(asPath) == "string" then
		return asPath
	end

	return Path.from(asPath):toString()
end

local function AsPathToPath(asPath: AsPath): Path
	if Path.is(asPath) then
		return asPath :: Path
	end

	return Path.from(asPath)
end

function PathFileSystem.Copy(from: AsPath, to: AsPath, overwriteOrOptions: boolean | WriteOptions | nil): ()
	return fs.copy(AsPathToString(from), AsPathToString(to), overwriteOrOptions)
end
PathFileSystem.copy = PathFileSystem.Copy

local function IsDirectory(path: AsPath): boolean
	return fs.isDir(AsPathToString(path))
end
PathFileSystem.IsDirectory = IsDirectory
PathFileSystem.isDir = IsDirectory

function PathFileSystem.IsDirectorySafe(path: AsPath): boolean
	local success, value = pcall(fs.isDir, AsPathToString(path))
	if not success then
		console.warn(`Failed to check if '{path}' is a directory - {value}`)
		return false
	end
	return value
end
function PathFileSystem.IsDirectorySafeSilent(path: AsPath): boolean
	local success, value = pcall(fs.isDir, AsPathToString(path))
	return if success then value else false
end

function PathFileSystem.IsFile(path: AsPath): boolean
	return fs.isFile(AsPathToString(path))
end
PathFileSystem.isFile = PathFileSystem.IsFile
function PathFileSystem.IsFileSafe(path: AsPath): boolean
	local success, value = pcall(fs.isFile, AsPathToString(path))
	if not success then
		console.warn(`Failed to check if '{path}' is a file - {value}`)
		return false
	end
	return value
end
function PathFileSystem.IsFileSafeSilent(path: AsPath): boolean
	local success, value = pcall(fs.isFile, AsPathToString(path))
	return if success then value else value
end

function PathFileSystem.Metadata(path: AsPath): Metadata
	return fs.metadata(AsPathToString(path))
end
PathFileSystem.metadata = PathFileSystem.Metadata

function PathFileSystem.Move(from: AsPath, to: AsPath, overwriteOrOptions: boolean | WriteOptions | nil): ()
	return fs.move(AsPathToString(from), AsPathToString(to), overwriteOrOptions)
end
PathFileSystem.move = PathFileSystem.Move

function PathFileSystem.ReadDirectory(path: AsPath): {string}
	return fs.readDir(AsPathToString(path))
end
PathFileSystem.readDir = PathFileSystem.ReadDirectory

function PathFileSystem.ReadFile(path: AsPath): string
	return fs.readFile(AsPathToString(path))
end
PathFileSystem.readFile = PathFileSystem.ReadFile

function PathFileSystem.RemoveDirectory(path: AsPath): ()
	return fs.removeDir(AsPathToString(path))
end
PathFileSystem.removeDir = PathFileSystem.RemoveDirectory

function PathFileSystem.RemoveFile(path: AsPath): ()
	return fs.removeFile(AsPathToString(path))
end
PathFileSystem.removeFile = PathFileSystem.RemoveFile

function PathFileSystem.WriteFile(path: AsPath, contents: Contents): ()
	return fs.writeFile(AsPathToString(path), contents)
end
PathFileSystem.writeFile = PathFileSystem.WriteFile

function PathFileSystem.WriteDirectory(path: AsPath): ()
	return fs.writeDir(AsPathToString(path))
end
PathFileSystem.writeDir = PathFileSystem.WriteDirectory

-- function PathFileSystem.Join(...: Path.AsPath) end

function PathFileSystem.GetScriptPath(): Path
	local path = string.match(debug.info(2, "s"), "%[string \"([^\"]*)\"%]")
	if not path then
		error("Failed to get script path")
	end

	local luauPath = path .. ".luau"
	if fs.isFile(luauPath) then
		return Path.new(luauPath)
	end

	local luaPath = path .. ".lua"
	if fs.isFile(luaPath) then
		return Path.new(luaPath)
	end

	if fs.isFile(path) then
		return Path.new(path)
	end

	error("Failed to get script path")
end

local function NormalizePath(path: Path): Path
	return Path.new(path:components():asPathString())
end
PathFileSystem.NormalizePath = NormalizePath

function PathFileSystem.GetAbsolutePathOf(path: Path): Path
	return NormalizePath(PathFileSystem.CWD:join(path))
end

function PathFileSystem.Exists(path: AsPath): boolean
	return fs.isDir(AsPathToString(path)) or fs.isFile(AsPathToString(path))
end

function PathFileSystem.GetNoCurrentDirectoryPathOf(path: Path): Path
	local components = path:components()
	local firstComponent = components:next()
	if not firstComponent then
		return path
	end

	if firstComponent.type == "curDir" then
		return Path.new(components:asPathString())
	end

	return path
end

local function GetChildren(asPath: AsPath): {Path}
	if not PathFileSystem.IsDirectory(asPath) then
		return {}
	end

	local path = AsPathToPath(asPath)
	local inDirectory = PathFileSystem.ReadDirectory(asPath)
	local children = table.create(#inDirectory)
	for index, child in inDirectory do
		children[index] = path:join(child)
	end
	return children
end
PathFileSystem.GetChildren = GetChildren

function PathFileSystem.GetDescendants(asPath: AsPath): {Path}
	local descendants = GetChildren(asPath)
	local totalDescendants = #descendants
	local length = 0

	if totalDescendants > 0 then
		repeat
			length += 1
			local grandChildren = GetChildren(descendants[length])
			for index, grandChild in grandChildren do
				descendants[totalDescendants + index] = grandChild
			end
			totalDescendants += #grandChildren
		until length == totalDescendants
	end

	return descendants
end

PathFileSystem.PathSeparator = if process.os == "windows" then "\\" else "/"
-- selene: allow(global_usage)
_G.SYS_PATH_SEPARATOR = PathFileSystem.PathSeparator

PathFileSystem.CWD = NormalizePath(Path.new(process.cwd))

return table.freeze(PathFileSystem)
