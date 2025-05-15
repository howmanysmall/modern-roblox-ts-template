--!optimize 2
--!strict
--[=[ lunar
	about = "Enables FFlagEnableLoadModule in ClientAppSettings.json for Jest testing."
]=]

local DotEnv = require("@packages/DotEnv")
local ExecuteUtilities = require("@utilities/ExecuteUtilities")
local LuauPolyfill = require("@packages/LuauPolyfill")
local PathFileSystem = require("@packages/PathFileSystem")
local process = require("@lune/process")
local serde = require("@lune/serde")
DotEnv.Load()

local Path = PathFileSystem.Path
local console = LuauPolyfill.console

local environment = process.env
local operatingSystem: process.OS = process.os

local function ExhaustiveMatch(value: never): never
	error(`Unknown value in exhaustive match: {value}`)
end

if operatingSystem == "windows" then
	local appDataPath = environment.LOCALAPPDATA
	local robloxVersionsPath = Path.new(appDataPath):join("Roblox"):join("Versions")

	if not PathFileSystem.IsDirectory(robloxVersionsPath) then
		error(`Roblox versions folder not found. Please install Roblox. Checked here: {robloxVersionsPath}`)
	end

	local mostRecentStudioVersionPath: PathFileSystem.Path? = nil
	for _, versionDirectoryPath in PathFileSystem.GetChildren(robloxVersionsPath) do
		if not PathFileSystem.IsDirectory(versionDirectoryPath) then
			console.log(`Skipping {versionDirectoryPath} because it is not a directory`)
			continue
		end

		if not PathFileSystem.IsFile(versionDirectoryPath:join("RobloxStudioBeta.exe")) then
			console.log(`Skipping {versionDirectoryPath} because it does not contain RobloxStudioBeta.exe`)
			continue
		end

		mostRecentStudioVersionPath = versionDirectoryPath
		break
	end

	if mostRecentStudioVersionPath == nil then
		error(`Roblox Studio not found. Please install Roblox. Checked here: {robloxVersionsPath}`)
	end

	local clientSettingsDirectory = mostRecentStudioVersionPath:join("ClientSettings")
	if not PathFileSystem.IsDirectory(clientSettingsDirectory) then
		PathFileSystem.WriteDirectory(clientSettingsDirectory)
	end

	local clientAppSettingsPath = clientSettingsDirectory:join("ClientAppSettings.json")
	local clientAppSettings

	if PathFileSystem.IsFile(clientAppSettingsPath) then
		clientAppSettings = serde.decode("json", PathFileSystem.ReadFile(clientAppSettingsPath))

		local metadata = PathFileSystem.Metadata(clientAppSettingsPath)
		if metadata.permissions and metadata.permissions.readOnly then
			local result = process.exec("attrib", {"-r", clientAppSettingsPath:toString()})
			assert(result.ok, `Failed to remove read-only attribute:\n{result.stderr}`)
		end
	else
		clientAppSettings = {}
	end

	clientAppSettings.FFlagEnableLoadModule = true
	PathFileSystem.WriteFile(clientAppSettingsPath, serde.encode("json", clientAppSettings))

	local result = process.exec("attrib", {"+r", clientAppSettingsPath:toString()})
	assert(result.ok, `Failed to add read-only attribute:\n{result.stderr}`)

	console.log(`Wrote FFlagEnableLoadModule to ClientAppSettings.json at {clientAppSettingsPath}`)
	process.exit(0)
elseif operatingSystem == "macos" then
	ExecuteUtilities.Execute({"./scripts/enable-loadmodule.sh"}):Assert()
elseif operatingSystem == "linux" then
	console.warn(`No support for le reddit {process.os}!`)
	process.exit(1)
else
	ExhaustiveMatch(operatingSystem)
end
