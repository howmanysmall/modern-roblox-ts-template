--!optimize 2
--!strict

local ExecuteUtilities = require("@utilities/ExecuteUtilities")
local GreenTea = require("@packages/GreenTea")
local GreenTeaAssert = require("@functions/GreenTeaAssert")
local GreenTeaUtilities = require("@packages/GreenTeaUtilities")
local LuauPolyfill = require("@packages/LuauPolyfill")
local OperatingSystemUtilities = require("@utilities/OperatingSystemUtilities")
local Option = require("@packages/Option")
local PathFileSystem = require("@packages/PathFileSystem")
local PromiseUtilities = require("@packages/PromiseUtilities")
local RegEx = require("@lune/RegEx")
local ThreadUtilities = require("@packages/ThreadUtilities")
local TypeError = require("@errors/TypeError")
local UniqueIdUtilities = require("@utilities/UniqueIdUtilities")
-- local process = require("@lune/process")

local console = LuauPolyfill.console
type Option<T> = Option.Option<T>
type Path = PathFileSystem.Path

local FormatUtilities = {}

local StyLuaType = table.freeze({
	Standard = "Standard" :: "Standard",
	React = "React" :: "React",
	Roact = "React" :: "React",
})
FormatUtilities.StyLuaType = StyLuaType
export type StyLuaType = "Standard" | "React"

local IsFormatOptionsRaw = {
	FormatAmount = GreenTea.optional(GreenTea.number({
		integer = true,
		range = "[1, inf]",
	})),
	FormatWith = GreenTea.optional(GreenTea.string()),
}

local IsMaybeFormatOptions = GreenTea.build(GreenTea.optional(IsFormatOptionsRaw))
local IsString = GreenTea.build(GreenTea.string())
local IsStyLuaType = GreenTea.build(GreenTeaUtilities.SmartLiteralValues(StyLuaType))

local TYPE_TO_EXECUTABLE_NAMES: {[StyLuaType]: {string}} = {
	[StyLuaType.Standard] = {"stylua2", "stylua2-dg", "stylua"},
	[StyLuaType.React] = {"stylua2React", "stylua2React-dg", "stylua2Roact", "stylua2Roact-dg", "stylua"},
}
local styluaTypeToExecutable: {[StyLuaType]: Option<string>} = {}

type ExecResult = ExecuteUtilities.ExecResult
local function DoesExecutableExist(executableName: string): boolean
	local result = ExecuteUtilities.Execute({executableName, "--version"})
	return result.ok and result.code == 0
end

local function GetExecutableName(styluaType: StyLuaType): Option<string>
	GreenTeaAssert(IsStyLuaType, styluaType, GetExecutableName, TypeError)
	local cached = styluaTypeToExecutable[styluaType]
	if cached then
		return cached
	end

	local executableNames = TYPE_TO_EXECUTABLE_NAMES[styluaType]
	if not executableNames then
		styluaTypeToExecutable[styluaType] = Option.None
		return Option.None
	end

	for _, executableName in executableNames do
		if DoesExecutableExist(executableName) then
			local option = Option.Some(executableName)
			styluaTypeToExecutable[styluaType] = option
			return option
		end
	end

	return Option.None
end
FormatUtilities.GetExecutableName = GetExecutableName

export type FormatOptions = typeof(IsFormatOptionsRaw)
local function AsFormatOptions(formatOptions: FormatOptions): FormatOptions
	return formatOptions
end

local REACT_REGEXP = RegEx.new(
	"(createElement|createContext|oneChild|createBinding|createFragment|useBinding|useCallback|useContext|useDebugValue|useEffect|useImperativeHandle|useLayoutEffect|useMemo|useReducer|useRef|useState)\\("
)

local function GetStyLuaType(source: string): StyLuaType
	GreenTeaAssert(IsString, source, GetStyLuaType, TypeError)
	return if REACT_REGEXP:isMatch(source) then StyLuaType.React else StyLuaType.Standard
end
FormatUtilities.GetStyLuaType = GetStyLuaType

local function Format(code: string, options: FormatOptions?): (boolean, string)
	GreenTeaAssert(IsString, code, Format, TypeError)
	GreenTeaAssert(IsMaybeFormatOptions, options, Format, TypeError)

	local formatOptions = AsFormatOptions(options or {})
	local formatAmount = formatOptions.FormatAmount or 1
	local formatWith = formatOptions.FormatWith or GetStyLuaType(code) or "stylua2"

	-- write file

	local temporaryFile = OperatingSystemUtilities.TemporaryDirectory():join(`{UniqueIdUtilities.NextUniqueId()}.luau`)
	PathFileSystem.WriteFile(temporaryFile, code)

	console.log(`Formatting {formatAmount}`)

	local shouldKill = false

	local arguments = {formatWith, "-f", "stylua.toml", "--verify", temporaryFile:toString()}
	if formatAmount == 1 then
		ExecuteUtilities.SafeExecute(arguments):AssertWithMessage(function(message: string): ()
			shouldKill = true
			console.warn(`Failed to format - {message}`)
		end)
	else
		for _ = 1, formatAmount do
			if shouldKill then
				return false, code
			end

			ExecuteUtilities.SafeExecute(arguments):AssertWithMessage(function(message: string): ()
				shouldKill = true
				console.warn(`Failed to format - {message}`)
			end)
		end
	end

	if shouldKill then
		return false, code
	end

	local formatted = PathFileSystem.ReadFile(temporaryFile)
	ThreadUtilities.FastSpawn(function(): ()
		ThreadUtilities.FastDelay(0.2, function(): ()
			PathFileSystem.RemoveFile(temporaryFile)
		end)
	end)

	return true, formatted
end
FormatUtilities.Format = Format
FormatUtilities.FormatAsync = PromiseUtilities.FastAsyncMulti(Format)

return table.freeze(FormatUtilities)
