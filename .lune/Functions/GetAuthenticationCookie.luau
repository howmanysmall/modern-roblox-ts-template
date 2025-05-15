--!optimize 2
--!strict

local DotEnv = require("@packages/DotEnv")
local ExecuteUtilities = require("@utilities/ExecuteUtilities")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
DotEnv.Load()

local function GetAuthenticationCookie(raw: boolean?): string?
	if raw then
		local fromApi = roblox.getAuthCookie(true)
		if fromApi then
			return fromApi
		end

		local fromCli = ExecuteUtilities.Execute({"rbx_cookie", "-f", "value"}):Assert().stdout
		if fromCli and fromCli ~= "" then
			return fromCli
		end

		return nil
	end

	local fromEnv = process.env.DOT_ENV_COOKIE
	if fromEnv and fromEnv ~= "" then
		return fromEnv
	end

	local fromApi = roblox.getAuthCookie(false)
	if fromApi then
		return fromApi
	end

	local fromCli = ExecuteUtilities.Execute({"rbx_cookie", "-f", "cookie"}):Assert().stdout
	if fromCli and fromCli ~= "" then
		return fromCli
	end

	return nil
end

return GetAuthenticationCookie
