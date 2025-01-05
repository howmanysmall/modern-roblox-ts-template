--!optimize 2
--!strict

local LuauPolyfill = require("@packages/LuauPolyfill")
local Option = require("@packages/Option")
local PathFileSystem = require("@packages/PathFileSystem")
local process = require("@lune/process")

local Path = PathFileSystem.Path
local String = LuauPolyfill.String
local console = LuauPolyfill.console

type PathOption = Option.Option<PathFileSystem.Path>

local IS_WINDOWS = process.os == "windows"

local function MutatePath(path: PathFileSystem.Path): PathOption
	if not PathFileSystem.IsFileSafe(path) then
		return Option.None
	end

	local result = process.spawn(path:toString(), {"-V"})
	if not result.ok then
		console.warn(`Command failed:\n{result.stderr}\n{result.stdout}`)
		process.exit(result.code)
	end

	if string.sub(result.stdout, 1, 4) ~= "Rojo" then
		return Option.None
	end

	return Option.Some(path)
end

local function GetRojoLocation(): PathOption
	if IS_WINDOWS then
		local result = process.spawn("where", {"rojo"})
		if not result.ok then
			console.warn(`Command failed:\n{result.stderr}\n{result.stdout}`)
			process.exit(result.code)
		end

		return Option.Wrap(Path.from(String.trim(result.stdout))):AndThen(MutatePath)
	end

	local result = process.spawn("whereis", {"rojo"})
	if not result.ok then
		console.warn(`Command failed:\n{result.stderr}\n{result.stdout}`)
		process.exit(result.code)
	end

	local path = string.match(String.trim(result.stdout), "^%w+:%s*(.+)$")
	return if path then Option.Wrap(Path.from(path)):AndThen(MutatePath) else Option.None
end

return GetRojoLocation
