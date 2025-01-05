--!optimize 2
--!strict

local Enumeration = require("@packages/Enumeration")
local LuauPolyfill = require("@packages/LuauPolyfill")
local Option = require("@packages/Option")
local PathFileSystem = require("@packages/PathFileSystem")
local RegEx = require("@lune/regex")
local SafeExecute = require("@utilities/SafeExecute")
local process = require("@lune/process")

local Path = PathFileSystem.Path
local console = LuauPolyfill.console

export type StyluaType = Enumeration.StyluaType
type Option<T> = Option.Option<T>

local function AsPathToString(asPath: PathFileSystem.AsPath): string
	return if type(asPath) == "string" then asPath else Path.from(asPath):toString()
end

local StyluaUtilities = {}

local TYPE_TO_EXECUTABLE_NAMES: {[Enumeration.StyluaType]: {string}} = {
	[Enumeration.StyluaType.Standard] = {"stylua2", "stylua"},
	[Enumeration.StyluaType.React] = {"stylua2Roact", "stylua"},
}
local styluaTypeToExecutable: {[Enumeration.StyluaType]: Option<string>} = {}

local function DoesExecutableExist(executableName: string): boolean
	local success, result = pcall(function()
		return process.spawn(executableName, {"--version"})
	end)

	return success and result.ok and result.code == 0
end

local function GetExecutableName(styluaType: Enumeration.StyluaType): Option<string>
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
StyluaUtilities.GetExecutableName = GetExecutableName

local REACT_REGEXP = RegEx.new(
	"(createElement|createContext|oneChild|createBinding|createFragment|useBinding|useCallback|useContext|useDebugValue|useEffect|useImperativeHandle|useLayoutEffect|useMemo|useReducer|useRef|useState)\\("
)

local function GetStyluaType(source: string): Enumeration.StyluaType
	return if REACT_REGEXP:isMatch(source) then Enumeration.StyluaType.React else Enumeration.StyluaType.Standard
end
StyluaUtilities.GetStyluaType = GetStyluaType

function StyluaUtilities.FormatFile(asPath: PathFileSystem.AsPath): ()
	if not PathFileSystem.IsFile(asPath) then
		return
	end

	local fileSource = PathFileSystem.ReadFile(asPath)

	GetExecutableName(GetStyluaType(fileSource)):MatchVoid(function(executableName)
		SafeExecute({executableName, AsPathToString(asPath)}):Assert(function()
			console.error(`Failed to format {asPath}?`)
		end)
	end, function()
		console.warn(`Failed to find an executable for {asPath}?`)
	end)
end

return table.freeze(StyluaUtilities)
