--!optimize 2
--!strict
--[=[ lunar
	about = "Builds and runs the unit tests place file."
	args = "[--dev] [<project>]"
]=]

local ArgParse = require("@packages/ArgParse")
local Chalk = require("@packages/Chalk")
local Enum = require("@packages/Enum")
local LuauPolyfill = require("@packages/LuauPolyfill")
local PathFileSystem = require("@packages/PathFileSystem")
local ReducedInstance = require("@utilities/ReducedInstance")
local Runtime = require("@utilities/Runtime")

local BrickColor = require("@contexts/BrickColor")
local Color3 = require("@contexts/Color3")
local DateTime = require("@contexts/DateTime")
local Debug = require("@contexts/Debug")
local Instance = require("@contexts/Instance")
local NumberRange = require("@contexts/NumberRange")
local Random = require("@contexts/Random")
local RaycastParams = require("@contexts/RaycastParams")
local Vector3 = require("@contexts/Vector3")

local TypeOf = require("@packages/TypeOf")

local luau = require("@lune/luau")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")
local task = require("@lune/task")

local Path = PathFileSystem.Path
local console = LuauPolyfill.console

local NULL_MARKER = `__NULL_MARKER-{math.random()}-{math.random()}-NULL_MARKER__`

local DEFAULT_PROJECT_FILE_PATH = Path.new("test.project.json")
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

local parser =
	ArgParse("run-unit-tests-local", "Runs the Jest unit tests within Lune. Faster, but not fully implemented.")
parser:flag("--dev", "Sets __DEV__ to true.")
parser:argument(
	"project",
	"The Rojo project file to build and run.",
	DEFAULT_PROJECT_FILE_PATH:toString(),
	function(value: string): string?
		return if PathFileSystem.IsFileSafeSilent(value) then value else nil
	end
)

local arguments: {
	dev: boolean,
	project: string?,
} = parser:parse()

if arguments.dev then
	_G.__DEV__ = true
end

type Path = PathFileSystem.Path
type RojoProject = {
	name: string,
	tree: any,
}

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
	local root = process.env.HOME or process.env.USERPROFILE

	local rojoPath = Path.new(root):join(".rokit"):join("bin"):join("rojo")

	-- console.log(`Building project {rojoProjectFilePath} into {builtProjectFilePath} with Rojo...\n`)
	local spawnResult =
		process.exec(rojoPath:toString(), {"build", rojoProjectFilePath:toString(), "--output", builtProjectFilePath})
	assert(spawnResult.ok, `Failed to build project [{builtProjectFilePath}]: {spawnResult.stderr}`)

	-- console.log(`Deserializing {builtProjectFilePath}...`)
	local success, result = pcall(roblox.deserializePlace, PathFileSystem.ReadFile(builtProjectFilePath))
	assert(success, `Failed to deserialize built project [{builtProjectFilePath}]: {result}`)

	return result
end

local function ImplementRobloxMethods(): ()
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

local rojoProjectFilePath = Path.from(arguments.project or DEFAULT_PROJECT_FILE_PATH)

local game = BuildProject(rojoProjectFilePath)
ImplementRobloxMethods()

-- Declaring because it's needed by `loadScript`, but `loadScript` is also needed in `requireModule`. Defined later.
local RequireModule

local BAD_TYPES = {
	["function"] = true;
	thread = true;
	userdata = true;
}

local function DeshitifyJsonTable(object: {[any]: any}): {[any]: any}
	local newObject = table.clone(object)
	for key, value in newObject do
		local typeOf = type(value)
		if typeOf == "table" then
			newObject[key] = DeshitifyJsonTable(value)
		elseif BAD_TYPES[typeOf] then
			newObject[key] = NULL_MARKER
		end
	end
	return newObject
end

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

		if serviceName == "HttpService" then
			return {
				JSONEncode = function(_, data: any): string
					if type(data) == "table" then
						data = DeshitifyJsonTable(data)
					end

					return (string.gsub(serde.encode("json", data, false), string.format("%q", NULL_MARKER), "null"))
				end;
				JSONDecode = function(_, data: string): unknown
					return serde.decode("json", data)
				end;
			}
		end

		if serviceName == "CoreScriptSyncService" then
			return nil
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
			Enum = Enum;
			Instance = Instance;
			NumberRange = NumberRange;
			Random = Random;
			RaycastParams = RaycastParams;
			Vector3 = Vector3;

			Axes = require("@contexts/Unimplemented/Axes");
			CatalogSearchParams = require("@contexts/Unimplemented/CatalogSearchParams");
			ColorSequence = require("@contexts/Unimplemented/ColorSequence");
			Faces = require("@contexts/Unimplemented/Faces");
			NumberSequence = require("@contexts/Unimplemented/NumberSequence");
			OverlapParams = require("@contexts/Unimplemented/OverlapParams");
			Path2DControlPoint = require("@contexts/Unimplemented/Path2DControlPoint");
			PhysicalProperties = require("@contexts/Unimplemented/PhysicalProperties");

			debug = Debug;
			task = task;

			require = RequireModule;
			tick = os.clock;
			typeof = TypeOf;
			warn = Warn;

			game = gameWithContext;
			script = script;

			-- idiot garbage
			fs = require("@lune/fs");
			LuneDateTime = require("@lune/datetime");
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

local execute = TestService:FindFirstChild("Execute")
assert(execute, "game.TestService.Execute not found")

local callback, exception = LoadScript(ReducedInstance.Once(execute))
assert(callback, exception)

_G.__UNIT_TEST_CLEANUP__ = function(): ()
	local withBenchmarks = PathFileSystem.CWD:join("WithBenchmarks.rbxl")
	if PathFileSystem.IsFileSafe(withBenchmarks) then
		PathFileSystem.RemoveFile(withBenchmarks)
	end
end

-- console.log("Running tests from game.TestService.Execute...\n")
callback()
