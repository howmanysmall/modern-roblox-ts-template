--!optimize 2
--!strict
--[=[ lunar
	about = "Builds and runs the unit tests place file."
]=]

local Chalk = require("@packages/Chalk")
local Enum = require("@packages/Enum")
local GetRojoLocation = require("@utilities/GetRojoLocation")
local LuauPolyfill = require("@packages/LuauPolyfill")
local Option = require("@packages/Option")
local PathFileSystem = require("@packages/PathFileSystem")
local ReducedInstance = require("@utilities/ReducedInstance")
local Runtime = require("@utilities/Runtime")

local BrickColor = require("@contexts/BrickColor")
local Color3 = require("@contexts/Color3")
local DateTime = require("@contexts/DateTime")
local Debug = require("@contexts/Debug")
local Instance = require("@contexts/Instance")
local Random = require("@contexts/Random")
local Utf8 = require("@contexts/Utf8")
local Vector3 = require("@contexts/Vector3")

local luau = require("@lune/luau")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")
local task = require("@lune/task")

local Path = PathFileSystem.Path
local console = LuauPolyfill.console

local WARN_COLOR = Chalk.Rgb(226, 124, 21)

local function MakeJsonSafeForSerde(jsonString: string): string
	return (string.gsub(string.gsub(string.gsub(jsonString, "/%*.-%*/", ""), "//[^\n]*", ""), ",%s*([}%]])", "%1"))
end
local function Warn(...: unknown): ()
	local length = select("#", ...)
	local arguments = table.create(length)
	for index = 1, length do
		arguments[index] = tostring(select(index, ...))
	end
	warn(WARN_COLOR(table.concat(arguments, " ")))
end

type Path = PathFileSystem.Path
type RojoProject = {
	name: string,
	tree: any,
}

local DEFAULT_PROJECT_FILE_PATH = Path.new("test.project.json")

local function ReadRojoProject(filePath: PathFileSystem.Path): RojoProject
	assert(
		PathFileSystem.IsFile(filePath),
		`Rojo project file {filePath} not found. Please create it or specify a different file as an argument.`
	)

	local success, value =
		pcall(serde.decode, "json" :: "json", MakeJsonSafeForSerde(PathFileSystem.ReadFile(filePath)))
	assert(success, `Failed to read Rojo project file {filePath}: {value}`)
	assert(value.name, "Rojo project name is required in the project file")
	return value
end
local function BuildProject(rojoProjectFilePath: PathFileSystem.Path)
	local rojoProject = ReadRojoProject(rojoProjectFilePath)
	local builtProjectFilePath = `{rojoProject.name}.rbxl`

	return GetRojoLocation():AndThen(function(rojoPath)
		-- console.log(`Building project {rojoProjectFilePath} into {builtProjectFilePath} with Rojo...\n`)
		local spawnResult = process.spawn(
			rojoPath:toString(),
			{"build", rojoProjectFilePath:toString(), "--output", builtProjectFilePath}
		)
		assert(spawnResult.ok, `Failed to build project [{builtProjectFilePath}]: {spawnResult.stderr}`)

		-- console.log(`Deserializing {builtProjectFilePath}...`)
		local success, result = pcall(roblox.deserializePlace, PathFileSystem.ReadFile(builtProjectFilePath))
		assert(success, `Failed to deserialize built project [{builtProjectFilePath}]: {result}`)

		return Option.Wrap(result)
	end)
end

local function ImplementRobloxMethods()
	roblox.implementMethod("Instance", "WaitForChild", function(self, ...)
		local child = self:FindFirstChild(...)
		assert(
			child,
			`WaitForChild is not implemented in Lune, so FindFirstChild was substituted but {self:GetFullName()} does not contain child {(...)} at the time of calling.`
		)
		return child
	end)
	roblox.implementMethod("Instance", "isA", function(self, className: string)
		return self:IsA(className)
	end)

	roblox.implementMethod("Instance", "GetActor", function()
		return nil
	end)
	roblox.implementMethod("Instance", "GetAttributeChangedSignal", function()
		return {
			Connect = function()
				return {
					Connected = true;
					Disconnect = function(self)
						self.Connected = false
					end;
				}
			end;
			Wait = function() end;
		}
	end)

	-- RunService
	do
		local function postSimulation()
			return {
				Connect = Runtime.Connect;
				Wait = function()
					local thread = coroutine.running()
					local connection: Runtime.Connection = nil
					connection = Runtime:Connect(function(deltaTime)
						connection:Disconnect()
						coroutine.resume(thread, deltaTime)
					end)
					return coroutine.yield()
				end;
			}
		end
		roblox.implementProperty("RunService", "Heartbeat", postSimulation)
		roblox.implementProperty("RunService", "PostSimulation", postSimulation)
		roblox.implementMethod("RunService", "IsStudio", function()
			return true
		end)
		roblox.implementMethod("RunService", "IsServer", function()
			return true
		end)
	end

	-- do
	-- 	roblox.implementMethod("Players", "GetFriendsAsync", function(_, userId: number)
	-- 		--
	-- 	end)
	-- end

	-- HttpService
	do
		roblox.implementMethod("HttpService", "JSONEncode", function(_, data: unknown)
			return serde.encode("json", data, false)
		end)
		roblox.implementMethod("HttpService", "JSONDecode", function(_, jsonString: string)
			assert(type(jsonString) == "string", "HttpService.JSONDecode expects a string")
			return serde.decode("json", jsonString)
		end)
	end
end

local rojoProjectFilePath = Path.from(process.args[1] or DEFAULT_PROJECT_FILE_PATH)

local game = BuildProject(rojoProjectFilePath):Unwrap()
ImplementRobloxMethods()

-- Declaring because it's needed by `loadScript`, but `loadScript` is also needed in `requireModule`. Defined later.
local RequireModule

-- DEPENDENTS: [TestService/Source/run.server.luau]
-- ProcessService isn't implemented in Lune, so this creates a workable implementation of it by mapping it to process.exit
local gameWithContext = setmetatable({
	GetService = function(_self, serviceName: string)
		if serviceName == "ProcessService" then
			return {
				ExitAsync = function(_, code: number)
					process.exit(code)
				end;
			} :: any
		end

		return game:GetService(serviceName)
	end;
}, {__index = game})

local function LoadScript(script: roblox.Instance): (((...any) -> ...any)?, string?)
	script = ReducedInstance.Once(script)
	if not script:IsA("LuaSourceContainer") then
		return nil, "Attempt to load a non LuaSourceContainer"
	end

	local bytecodeSuccess, bytecode = pcall(luau.compile, (script :: any).Source)
	if not bytecodeSuccess then
		return nil, bytecode
	end

	local callableFunction = luau.load(bytecode, {
		debugName = script:GetFullName();
		environment = setmetatable({
			BrickColor = BrickColor;
			Color3 = Color3;
			DateTime = DateTime;
			debug = Debug;
			Enum = Enum;
			game = gameWithContext;
			Instance = Instance;
			Random = Random;
			require = RequireModule;
			script = script;
			task = task;
			tick = os.clock;
			utf8 = Utf8;
			Vector3 = Vector3;
			warn = Warn;
			fs = require("@lune/fs");
		}, {__index = roblox}) :: any;
	})

	return callableFunction
end

-- Override the unimplemented _loader function with the above implementation
Debug._loader = LoadScript

local MODULE_REGISTRY = {}

function RequireModule(moduleScript: roblox.Instance)
	assert(moduleScript and moduleScript:IsA("ModuleScript"), `Attempt to require a non ModuleScript {moduleScript}`)

	local cached = MODULE_REGISTRY[moduleScript]
	if cached then
		return cached
	end

	local callback, exception = LoadScript(moduleScript)
	assert(callback, exception)

	local result = callback()
	MODULE_REGISTRY[moduleScript] = result
	return result
end

console.log("\n")
-- console.log("Starting main...\n")
local TestService = game:GetService("TestService")

local execute: roblox.Instance? = TestService:FindFirstChild("Execute")

if not execute then
	for _, child in TestService:GetChildren() do
		if child:IsA("Script") and string.find(child.Source, "runCLI") then
			execute = child
			break
		end
	end
end

assert(execute, "game.TestService.Execute not found")

local callback, exception = LoadScript(ReducedInstance.Once(execute))
assert(callback, exception)

-- console.log("Running tests from game.TestService.Execute...\n")
callback()
