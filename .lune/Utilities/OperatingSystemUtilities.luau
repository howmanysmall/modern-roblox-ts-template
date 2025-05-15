--!optimize 2
--!strict

local DotEnv = require("@packages/DotEnv")
local ExecuteUtilities = require("@utilities/ExecuteUtilities")
local LuauPolyfill = require("@packages/LuauPolyfill")
local PathFileSystem = require("@packages/PathFileSystem")
local process = require("@lune/process")
DotEnv.Load()

local Boolean = LuauPolyfill.Boolean
local Path = PathFileSystem.Path
local Set = LuauPolyfill.Set
type Path = PathFileSystem.Path
type Set<T> = LuauPolyfill.Set<T>

local OperatingSystemUtilities = {}

local function GetUserAccountName(): string
	local environment = process.env
	local username = environment.USER or environment.USERNAME
	if Boolean.toJSBoolean(username) then
		return username :: string
	end

	local whoAmI = ExecuteUtilities.Execute({"whoami"})
	if not whoAmI.ok then
		return "Unknown"
	end

	local stdout = whoAmI.stdout
	return string.match(stdout, "[^\\]+$") or stdout or "Unknown"
end
OperatingSystemUtilities.GetUserAccountName = GetUserAccountName

local GetHowManySmallAccounts = (function()
	local set: Set<string> = Set.new()

	local function getHowManySmallAccounts(): Set<string>
		local stringValue = process.env.HOWMANYSMALL_ACCOUNTS
		if stringValue then
			for _, username in string.split(stringValue, ",") do
				set:add(username)
			end
		end

		return set
	end

	return getHowManySmallAccounts
end)()

function OperatingSystemUtilities.IsHowManySmall(): boolean
	local accountUser = process.env.ACCOUNT_USER
	local boolean = GetHowManySmallAccounts():has(string.lower(GetUserAccountName()))
	return if accountUser then string.lower(accountUser) == "howmanysmall" or boolean else boolean
end

function OperatingSystemUtilities.TemporaryDirectory(): Path
	local env = process.env
	if process.os == "windows" then
		local tmpValue = env.TMP
		if tmpValue then
			return Path.new(tmpValue)
		end

		local tempValue = env.TEMP
		if tempValue then
			return Path.new(tempValue)
		end

		local userProfileValue = env.USERPROFILE
		if userProfileValue then
			return Path.new(userProfileValue):join("AppData"):join("Local"):join("Temp")
		end

		return Path.new("C:/Windows/Temp")
	end

	local tmpDirValue = env.TMPDIR
	return if tmpDirValue then Path.new(tmpDirValue) else Path.new("/tmp")
end

return table.freeze(OperatingSystemUtilities)
