--!optimize 2
--!strict

local Error = require("@packages/Error")
local GreenTea = require("@packages/GreenTea")
local GreenTeaUtilities = require("@packages/GreenTeaUtilities")
local HttpPromise = require("@promises/HttpPromise")
local MissingError = require("@errors/MissingError")
local PathFileSystem = require("@packages/PathFileSystem")
local PromiseUtilities = require("@packages/PromiseUtilities")

local Await = PromiseUtilities.Await

local LUAURC_PATH = PathFileSystem.CWD:join(".luaurc")

local LuauConfigurationUtilities = {}
LuauConfigurationUtilities.LUAURC_PATH = LUAURC_PATH

export type LanguageMode = "strict" | "nonstrict" | "nocheck"

local IsLuauConfigurationRaw = {
	aliases = GreenTea.optional({[GreenTea.string()] = GreenTea.string()});
	globals = GreenTea.optional(GreenTea.array(GreenTea.string()));
	languageMode = GreenTea.optional(GreenTeaUtilities.EasyLiteral("strict", "nonstrict", "nocheck")) :: LanguageMode?;
	lint = GreenTea.optional({[GreenTea.string()] = GreenTea.boolean()});
	lintErrors = GreenTea.optional(GreenTea.boolean());
	typeErrors = GreenTea.optional(GreenTea.boolean());
}
export type LuauConfiguration = typeof(IsLuauConfigurationRaw)

local function DoesConfigurationExist(): boolean
	return PathFileSystem.IsFile(LUAURC_PATH)
end
LuauConfigurationUtilities.DoesConfigurationExist = DoesConfigurationExist

local function GetConfiguration(): LuauConfiguration
	if not DoesConfigurationExist() then
		local exception = MissingError.new("No .luaurc file found.")
		Error.captureStackTrace(exception, GetConfiguration)
		error(exception)
	end

	return Await(HttpPromise.PromiseDecode(PathFileSystem.ReadFile(LUAURC_PATH), IsLuauConfigurationRaw))
end
LuauConfigurationUtilities.GetConfigurationAsync = PromiseUtilities.FastAsync(GetConfiguration)

return table.freeze(LuauConfigurationUtilities)
