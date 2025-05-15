--!optimize 2
--!strict

local Chalk = require("@packages/Chalk")
local ChalkUtilities = require("@utilities/ChalkUtilities")
local Debug = require("@packages/Debug")
local GreenTea = require("@packages/GreenTea")
local GreenTeaAssert = require("@functions/GreenTeaAssert")
local GreenTeaUtilities = require("@packages/GreenTeaUtilities")
local LuauPolyfill = require("@packages/LuauPolyfill")
local TypeError = require("@errors/TypeError")
local process = require("@lune/process")

local console = LuauPolyfill.console

local ExecuteUtilities = {}

export type ExecResult = process.ExecResult

export type AssertableResult = ExecResult & {
	Assert: (self: AssertableResult) -> AssertableResult,
}
export type SafeAssertableResult = ExecResult & {
	Assert: (self: SafeAssertableResult, onFail: nil | (code: number) -> ()) -> SafeAssertableResult,
	AssertWithResult: (self: SafeAssertableResult, onFail: (result: ExecResult) -> ()) -> SafeAssertableResult,
	AssertWithMessage: (
		self: SafeAssertableResult,
		onFail: nil | (onMessage: string, code: number) -> ()
	) -> SafeAssertableResult,
}

local function CreateToString(className: string): (self: AssertableResult | SafeAssertableResult) -> string
	local function toString(self: AssertableResult | SafeAssertableResult): string
		local array = {`{Chalk.Magenta(`{className}<`)}{Chalk.Gray("{")}`}
		local length = 1

		for key, value in Debug.AlphabeticalOrder(self) do
			length += 1
			array[length] = `\t{key} {Chalk.Gray("=")} {ChalkUtilities.FormatValue(value)}{Chalk.Gray(",")}`
		end

		array[length + 1] = Chalk.Gray("}") .. Chalk.Magenta(">")
		return table.concat(array, "\n")
	end
	return toString
end

local AssertableResult = {} :: AssertableResult
do
	(AssertableResult :: any).__index = AssertableResult;
	(AssertableResult :: any).__tostring = CreateToString("AssertableResult")
	function AssertableResult:Assert(): AssertableResult
		if not self.ok then
			console.warn(`Command failed:\n{self.stderr}\n{self.stdout}`)
			process.exit(self.code)
		end

		return self
	end
end

local SafeAssertableResult = {} :: SafeAssertableResult
do
	(SafeAssertableResult :: any).__index = SafeAssertableResult;
	(SafeAssertableResult :: any).__tostring = CreateToString("SafeAssertableResult")
	function SafeAssertableResult:Assert(onFail: nil | (code: number) -> ()): SafeAssertableResult
		if not self.ok then
			console.warn(`Command failed:\n{self.stderr}\n{self.stdout}`)
			if onFail then
				onFail(self.code)
			end
		end

		return self
	end
	function SafeAssertableResult:AssertWithResult(onFail: (result: ExecResult) -> ()): SafeAssertableResult
		if not self.ok then
			onFail({
				code = self.code;
				ok = self.ok;
				stderr = self.stderr;
				stdout = self.stdout;
			})
		end

		return self
	end
	function SafeAssertableResult:AssertWithMessage(
		onFail: nil | (onMessage: string, code: number) -> ()
	): SafeAssertableResult
		if not self.ok and onFail then
			onFail(`{self.stderr}\n{self.stdout}`, self.code)
		end

		return self
	end
end

type ExecOptions = process.ExecOptions
type ExecStdioKind = process.ExecStdioKind

local IsExecStdioKindRaw = GreenTeaUtilities.SmartLiteral("default", "inherit", "forward", "none") :: ExecStdioKind
local IsExecStdioOptionsRaw = {
	stderr = GreenTea.optional(IsExecStdioKindRaw) :: ExecStdioKind?;
	stdin = GreenTea.optional(GreenTea.union(GreenTea.string(), GreenTea.buffer()));
	stdout = GreenTea.optional(IsExecStdioKindRaw) :: ExecStdioKind?;
}
local IsExecOptionsRaw = {
	cwd = GreenTea.optional(GreenTea.string());
	env = GreenTea.optional({[GreenTea.string()] = GreenTea.string()});
	shell = GreenTea.optional(GreenTea.union(GreenTea.boolean(), GreenTea.string()));
	stdio = GreenTea.optional(GreenTea.union(IsExecStdioKindRaw, IsExecStdioOptionsRaw));
	[GreenTea.any()] = GreenTea.never();
}
type ExecOptionsGreenTea = typeof(IsExecOptionsRaw)
local function AsExecOptionsGreenTea(execOptions: ExecOptions): ExecOptionsGreenTea
	return execOptions
end
local function AsExecOptions(execOptions: ExecOptionsGreenTea): ExecOptions
	-- sure why ot
	local replacementCauseLuauSucks = {} :: ExecOptions
	for key, value in execOptions do
		replacementCauseLuauSucks[key] = value
	end
	return replacementCauseLuauSucks
end

local IsStringArray = GreenTea.build(GreenTea.array(GreenTea.string()))
local IsMaybeExecOptions = GreenTea.build(GreenTea.optional(IsExecOptionsRaw))

local function Execute(command: {string}, options: ExecOptions?): AssertableResult
	GreenTeaAssert(IsStringArray, command, Execute, TypeError)
	GreenTeaAssert(IsMaybeExecOptions, options, Execute, TypeError)

	local binaryName = command[1]

	local arguments = table.clone(command)
	table.remove(arguments, 1)

	local execOptions = AsExecOptionsGreenTea(if options then table.clone(options) else {})
	if execOptions.shell == false then
		execOptions.shell = nil
	elseif execOptions.shell == nil then
		execOptions.shell = true
	end

	local self = table.clone(process.exec(binaryName, arguments, AsExecOptions(execOptions)))
	return (setmetatable(self, AssertableResult) :: unknown) :: AssertableResult
end
ExecuteUtilities.Execute = Execute

local function SafeExecute(command: {string}, options: ExecOptions?): SafeAssertableResult
	GreenTeaAssert(IsStringArray, command, SafeExecute, TypeError)
	GreenTeaAssert(IsMaybeExecOptions, options, SafeExecute, TypeError)

	local binaryName = command[1]

	local arguments = table.clone(command)
	table.remove(arguments, 1)

	local execOptions = AsExecOptionsGreenTea(if options then table.clone(options) else {})
	if execOptions.shell == false then
		execOptions.shell = nil
	elseif execOptions.shell == nil then
		execOptions.shell = true
	end

	local self = table.clone(process.exec(binaryName, arguments, AsExecOptions(execOptions)))
	return (setmetatable(self, SafeAssertableResult) :: unknown) :: SafeAssertableResult
end
ExecuteUtilities.SafeExecute = SafeExecute

return table.freeze(ExecuteUtilities)
