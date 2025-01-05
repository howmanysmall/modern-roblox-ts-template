--!optimize 2
--!strict

local GreenTea = require("@packages/GreenTea")
local GreenTeaUtilities = require("@packages/GreenTeaUtilities")
local LuauPolyfill = require("@packages/LuauPolyfill")
local process = require("@lune/process")

local Error = LuauPolyfill.Error
local console = LuauPolyfill.console

export type AssertableResult = process.SpawnResult & {
	Assert: (self: AssertableResult, onFail: nil | (code: number) -> ()) -> AssertableResult,
}

local AssertableResult = {} :: AssertableResult;
(AssertableResult :: any).__index = AssertableResult

function AssertableResult:Assert(onFail)
	if not self.ok then
		console.warn(`Command failed:\n{self.stderr}\n{self.stdout}`)
		if onFail then
			onFail(self.code)
		end
	end

	return self
end

local isSpawnOptionsStdioKindRaw = GreenTeaUtilities.EasyLiteral("default", "inherit", "forward", "none")

local isStringArray = GreenTea.build(GreenTea.array(GreenTea.string()))
local isMaybeSpawnOptions = GreenTea.build(GreenTea.optional({
	cwd = GreenTea.opt(GreenTea.string());
	env = GreenTea.optional({[GreenTea.string()] = GreenTea.string()});
	shell = GreenTea.optional(GreenTea.union(GreenTea.boolean(), GreenTea.string()));
	stdio = GreenTea.optional(GreenTea.union(isSpawnOptionsStdioKindRaw, {
		stdout = GreenTea.optional(isSpawnOptionsStdioKindRaw);
		stderr = GreenTea.optional(isSpawnOptionsStdioKindRaw);
		stdin = GreenTea.optional(GreenTea.string());
	}));
	stdin = GreenTea.optional(GreenTea.string());
}))

local function SafeExecute(command: {string}, options: process.SpawnOptions?): AssertableResult
	do
		local typeSuccess0, typeError0 = isStringArray:matches(command)
		if not typeSuccess0 then
			local exception = Error.new(tostring(typeError0))
			exception.name = "TypeError"
			Error.captureStackTrace(exception, SafeExecute)
			error(exception)
		end
		local typeSuccess1, typeError1 = isMaybeSpawnOptions:matches(options)
		if not typeSuccess1 then
			local exception = Error.new(tostring(typeError1))
			exception.name = "TypeError"
			Error.captureStackTrace(exception, SafeExecute)
			error(exception)
		end
	end

	local binary = command[1]

	local arguments = table.clone(command)
	table.remove(arguments, 1)

	local spawnOptions: process.SpawnOptions = if options then table.clone(options) else {}
	if spawnOptions.shell == false then
		spawnOptions.shell = nil
	elseif spawnOptions.shell == nil then
		spawnOptions.shell = true
	end

	local result = process.spawn(binary, arguments, spawnOptions)
	return setmetatable(table.clone(result), AssertableResult) :: never
end

return SafeExecute
