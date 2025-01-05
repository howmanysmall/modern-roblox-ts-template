--!optimize 2
--!strict

local FileSystemUtilities = require("@utilities/FileSystemUtilities")
local Option = require("@packages/Option")
local PathFileSystem = require("@packages/PathFileSystem")
local serde = require("@lune/serde")

local Path = PathFileSystem.Path

type VsCodeSettings = {["luau-lsp.sourcemap.rojoProjectFile"]: string?}
type CodeWorkspaceData = {settings: VsCodeSettings?}

local VSCODE_SETTINGS = Path.new(".vscode"):join("settings.json")

type PathOption = Option.Option<PathFileSystem.Path>

local function MakeJsonSafeForSerde(jsonString: string): string
	return (string.gsub(string.gsub(string.gsub(jsonString, "/%*.-%*/", ""), "//[^\n]*", ""), ",%s*([}%]])", "%1"))
end

local function GetVsCodeSettings(): PathOption
	if not PathFileSystem.IsFile(VSCODE_SETTINGS) then
		return Option.None
	end

	local vsCodeSettings: VsCodeSettings? = nil
	pcall(function()
		vsCodeSettings = serde.decode("json", MakeJsonSafeForSerde(PathFileSystem.ReadFile(VSCODE_SETTINGS)))
	end)

	if not vsCodeSettings then
		return Option.None
	end

	local rojoProjectFile = vsCodeSettings["luau-lsp.sourcemap.rojoProjectFile"]
	if not rojoProjectFile then
		return Option.None
	end

	return Option.Some(Path.new(rojoProjectFile))
end
local function ThenMutate(projectFile: PathFileSystem.Path): PathOption
	if not PathFileSystem.IsFile(projectFile) then
		return Option.None
	end

	return Option.Some(projectFile)
end

local DEFAULT_PROJECT_FILE = Option.Some(Path.new("default.project.json"))

local function GetProjectFile(): PathOption
	local projectFileOption: PathOption = Option.None

	local codeWorkspace = FileSystemUtilities.FindFirstFileOfExtensionPath(PathFileSystem.CWD, "code-workspace")
	if codeWorkspace then
		local codeWorkspaceData: CodeWorkspaceData? = nil
		pcall(function()
			codeWorkspaceData = serde.decode("json", MakeJsonSafeForSerde(PathFileSystem.ReadFile(codeWorkspace)))
		end)

		if codeWorkspaceData then
			local settings = codeWorkspaceData.settings
			if settings then
				local rojoProjectFile = settings["luau-lsp.sourcemap.rojoProjectFile"]
				if rojoProjectFile then
					projectFileOption = Option.Some(Path.new(rojoProjectFile))
				end
			end
		end
	end

	return projectFileOption:OrElse(GetVsCodeSettings):Or(DEFAULT_PROJECT_FILE):AndThen(ThenMutate)
end

return GetProjectFile
