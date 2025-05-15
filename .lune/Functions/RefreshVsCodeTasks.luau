--!optimize 2
--!strict

local Error = require("@packages/Error")
local ExecuteUtilities = require("@utilities/ExecuteUtilities")
local GreenTea = require("@packages/GreenTea")
local GreenTeaAssert = require("@functions/GreenTeaAssert")
local GreenTeaUtilities = require("@packages/GreenTeaUtilities")
local LuauPolyfill = require("@packages/LuauPolyfill")
local PathFileSystem = require("@packages/PathFileSystem")
local TypeError = require("@errors/TypeError")
local serde = require("@lune/serde")

local Path = PathFileSystem.Path
local console = LuauPolyfill.console

type Path = PathFileSystem.Path

local VSCODE_TASKS = Path.new(".vscode"):join("tasks.json")

local IsKindBuildRaw = {
	isDefault = GreenTea.optional(GreenTea.boolean());
	kind = GreenTea.literal("build") :: "build";
}
local IsKindTestRaw = {
	isDefault = GreenTea.optional(GreenTea.boolean());
	kind = GreenTea.literal("test") :: "test";
}
type GroupString = "build" | "test" | "none"
local IsGroupRaw: GroupString | typeof(IsKindBuildRaw) | typeof(IsKindTestRaw) = GreenTeaUtilities.Union(
	GreenTea.literal("build") :: any,
	GreenTea.literal("test") :: any,
	GreenTea.literal("none") :: any,
	IsKindBuildRaw,
	IsKindTestRaw
)

local IsCommandInputRaw = {
	args = GreenTea.optional(GreenTea.array(GreenTea.string()));
	command = GreenTea.string();
	id = GreenTea.string();
	type = GreenTea.literal("command") :: "command";
}
local IsPickStringRaw = {
	default = GreenTea.optional(GreenTea.string());
	description = GreenTea.string();
	id = GreenTea.string();
	options = GreenTea.array(GreenTea.string());
	type = GreenTea.literal("pickString") :: "pickString";
}
local IsPromptStringRaw = {
	default = GreenTea.optional(GreenTea.string());
	description = GreenTea.string();
	id = GreenTea.string();
	password = GreenTea.optional(GreenTea.boolean());
	type = GreenTea.literal("promptString") :: "promptString";
}
type Inputs = {typeof(IsCommandInputRaw) | typeof(IsPickStringRaw) | typeof(IsPromptStringRaw)}

type TaskType = "grunt" | "gulp" | "jake" | "markdownlint" | "npm" | "process" | "shell" | "typescript"
type PresentationReveal = "always" | "never" | "silent"
type PresentationPanel = "dedicated" | "shared" | "new"
type PresentationRevealProblems = "always" | "never" | "onProblem"

local IsTasksFile = GreenTea.build({
	args = GreenTea.optional(GreenTea.array(GreenTea.string()));
	command = GreenTea.optional(GreenTea.string());
	echoCommand = GreenTea.optional(GreenTea.boolean());
	group = GreenTea.optional(IsGroupRaw) :: typeof(IsGroupRaw)?;
	inputs = GreenTea.optional(GreenTea.array(GreenTea.union(IsCommandInputRaw, IsPickStringRaw, IsPromptStringRaw))) :: Inputs?;
	isBackground = GreenTea.optional(GreenTea.boolean());
	tasks = GreenTea.optional(GreenTea.array({
		isLunarTask = GreenTea.optional(GreenTea.boolean());
		label = GreenTea.string();
		type = GreenTea.optional(
			GreenTeaUtilities.SmartLiteral(
				"grunt",
				"gulp",
				"jake",
				"markdownlint",
				"npm",
				"process",
				"shell",
				"typescript"
			)
		) :: TaskType?;
		presentation = GreenTea.optional({
			clear = GreenTea.optional(GreenTea.boolean());
			close = GreenTea.optional(GreenTea.boolean());
			echo = GreenTea.optional(GreenTea.boolean());
			focus = GreenTea.optional(GreenTea.boolean());
			group = GreenTea.optional(GreenTea.string());
			panel = GreenTea.optional(GreenTeaUtilities.SmartLiteral("dedicated", "shared", "new")) :: PresentationPanel?;
			reveal = GreenTea.optional(GreenTeaUtilities.SmartLiteral("always", "never", "silent")) :: PresentationReveal?;
			revealProblems = GreenTea.optional(GreenTeaUtilities.SmartLiteral("always", "never", "onProblem")) :: PresentationRevealProblems?;
			showReuseMessage = GreenTea.optional(GreenTea.boolean());
		});
	}));
	version = GreenTea.string();
})
export type TasksFile = typeof(IsTasksFile:type())

local function MakeJsonSafeForSerde(jsonString: string): string
	return (string.gsub(string.gsub(string.gsub(jsonString, "/%*.-%*/", ""), "//[^\n]*", ""), ",%s*([}%]])", "%1"))
end

local function RefreshVsCodeTasks(): ()
	console.log("Reading tasks file...")
	if not PathFileSystem.IsFile(VSCODE_TASKS) then
		console.warn("No tasks file found.")
		return
	end

	local tasksFile: TasksFile = serde.decode("json", MakeJsonSafeForSerde(PathFileSystem.ReadFile(VSCODE_TASKS)))
	GreenTeaAssert(IsTasksFile, tasksFile, RefreshVsCodeTasks, TypeError)

	if not tasksFile.tasks then
		console.warn("No tasks found in tasks file.")
		return
	end

	for index, task in tasksFile.tasks do
		if task.isLunarTask or string.match(task.label, "lunar[ %-]") then
			tasksFile.tasks[index] = nil
		end
	end

	console.log("Reading `lunar help` output...")
	local lunarOutput = ExecuteUtilities.Execute({"lunar", "help"}, {stdio = "default"}):Assert().stdout

	local commandsMatch = string.match(lunarOutput, "\nCommands:\r*\n([%s%S]-)%s*\r*\nOptions:")
	if not commandsMatch then
		local exception = TypeError.new("Failed to parse `lunar help` output")
		Error.captureStackTrace(exception, RefreshVsCodeTasks)
		error(exception)
	end

	local commandSection = `\n{commandsMatch}`
	console.log("Collecting tasks...")

	local startIndex = 1
	while true do
		local matchStart, matchFinish = string.find(commandSection, "\n  %S+[^%S\r\n]*", startIndex)
		if not matchStart or not matchFinish then
			break
		end
		startIndex = matchFinish

		local prefixSpaces = matchFinish - matchStart
		local command = string.match(string.sub(commandSection, matchStart, matchFinish), "%s+(%S+)%s*")
		if not command then
			local exception = TypeError.new("Failed to parse command from `lunar help` output")
			Error.captureStackTrace(exception, RefreshVsCodeTasks)
			error(exception)
		end

		if command == "help" then
			continue
		end

		local nextMatchStart = string.find(commandSection, "\n  %S+%s*", matchFinish + 1)
		local about = string.gsub(
			if nextMatchStart
				then string.sub(commandSection, matchFinish + 1, nextMatchStart - 1)
				else string.sub(commandSection, matchFinish + 1),
			"\r*\n([^\r\n]*)",
			function(line: string): string
				return `\n{string.sub(line, prefixSpaces)}`
			end
		)

		local matchedAbout = string.match(about, "^[\r\n]*(.*)[\r\n]*$")
		if not matchedAbout then
			local exception = TypeError.new("Failed to parse about from `lunar help` output")
			Error.captureStackTrace(exception, RefreshVsCodeTasks)
			error(exception)
		end

		table.insert(tasksFile.tasks, {
			command = `lunar {command}`;
			isLunarTask = true;
			label = command;
			presentation = {
				clear = true;
				panel = "dedicated";
				reveal = "always";
			};
			type = "shell";
		})

		console.log("  collected", command)
	end

	console.log("Writing tasks file...")
	PathFileSystem.WriteFile(VSCODE_TASKS, serde.encode("json", tasksFile, true))
	console.log("Done.")
end

return RefreshVsCodeTasks
