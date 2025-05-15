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
export type Contents = string | buffer
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

local function IsFile(path: AsPath): boolean
	return fs.isFile(AsPathToString(path))
end
PathFileSystem.IsFile = IsFile
PathFileSystem.isFile = IsFile
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

local function Metadata(path: AsPath): Metadata
	return fs.metadata(AsPathToString(path))
end
PathFileSystem.Metadata = Metadata
PathFileSystem.metadata = Metadata

local function Move(from: AsPath, to: AsPath, overwriteOrOptions: boolean | WriteOptions | nil): ()
	return fs.move(AsPathToString(from), AsPathToString(to), overwriteOrOptions)
end
PathFileSystem.Move = Move
PathFileSystem.move = Move

function PathFileSystem.ReadDirectory(path: AsPath): {string}
	return fs.readDir(AsPathToString(path))
end
PathFileSystem.readDir = PathFileSystem.ReadDirectory

function PathFileSystem.ReadFile(path: AsPath): string
	return fs.readFile(AsPathToString(path))
end
PathFileSystem.readFile = PathFileSystem.ReadFile

local function RemoveDirectory(path: AsPath): ()
	return fs.removeDir(AsPathToString(path))
end
PathFileSystem.RemoveDirectory = RemoveDirectory
PathFileSystem.removeDir = RemoveDirectory

local function RemoveFile(path: AsPath): ()
	return fs.removeFile(AsPathToString(path))
end
PathFileSystem.RemoveFile = RemoveFile
PathFileSystem.removeFile = RemoveFile

local function WriteFile(path: AsPath, contents: Contents): ()
	return fs.writeFile(AsPathToString(path), contents)
end
PathFileSystem.WriteFile = WriteFile
PathFileSystem.writeFile = WriteFile

local function WriteDirectory(path: AsPath): ()
	return fs.writeDir(AsPathToString(path))
end
PathFileSystem.WriteDirectory = WriteDirectory
PathFileSystem.writeDir = WriteDirectory

-- custom

local function Exists(path: AsPath): boolean
	return Metadata(path).exists
end
PathFileSystem.Exists = Exists

function PathFileSystem.Rename(from: AsPath, to: AsPath): ()
	return if Exists(from) and not Exists(to) then pcall(Move, from, to, false) else false
end

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
function PathFileSystem.FastExists(path: AsPath): boolean
	return fs.metadata(AsPathToString(path)).exists
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

local function TrimArray(array: {string}): {string}
	local newArray: {string} = array
	if array[1] == "" then
		newArray = table.clone(array)
		table.remove(newArray, 1)
	end

	local length = #array
	if array[length] == "" then
		if newArray == array then
			newArray = table.clone(array)
		end
		newArray[length] = nil
	end

	return newArray
end

local function GetPathSegments(asPath: AsPath): {Path}
	local split = TrimArray(string.split(NormalizePath(AsPathToPath(asPath)):toString(), "/"))
	local length = #split
	local segments: {Path} = table.create(length)
	for index, value in split do
		segments[index] = Path.new(value)
	end
	return segments
end
PathFileSystem.GetPathSegments = GetPathSegments

local function GetPathSegmentsEasy(asPath: AsPath): {string}
	return TrimArray(string.split(NormalizePath(AsPathToPath(asPath)):toString(), "/"))
end
PathFileSystem.GetPathSegmentsEasy = GetPathSegmentsEasy

-- local function AsArrayToPath(array: {string}): Path
-- 	local path = Path.new(array[1])
-- 	for index = 2, #array do
-- 		path = path:join(array[index])
-- 	end
-- 	return path
-- end

function PathFileSystem.WriteUfsFile(asPath: AsPath, contents: Contents): Path
	local path = AsPathToPath(asPath)
	local segments = GetPathSegmentsEasy(path)

	local length = #segments
	if length < 2 then
		WriteFile(path, contents)
		return path
	end

	for index = 1, length - 1 do
		local currentPath = Path.new(table.concat(segments, "/", 1, index))
		if not IsDirectory(currentPath) then
			WriteDirectory(currentPath)
		end
	end

	WriteFile(path, contents)
	return path
end
function PathFileSystem.UfsUnlink(...: AsPath): ()
	for index = 1, select("#", ...) do
		local path = select(index, ...)
		if IsDirectory(path) then
			RemoveDirectory(path)
		elseif IsFile(path) then
			RemoveFile(path)
		end
	end
end

return table.freeze(PathFileSystem)
