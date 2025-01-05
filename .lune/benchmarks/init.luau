--!optimize 2
--!strict
--[=[ lunar
	about = "Allows you to create and run benchmarks for Lune specific code."
]=]

local GreenTea = require("@packages/GreenTea")
local LuauPolyfill = require("@packages/LuauPolyfill")
local PathFileSystem = require("@packages/PathFileSystem")
local process = require("@lune/process")
local stdio = require("@lune/stdio")

local console = LuauPolyfill.console

type Path = PathFileSystem.Path

local isFunctionRaw = GreenTea.fn(GreenTea.args(), GreenTea.returns())
local isBenchmark = GreenTea.build({
	BarGraphMultiplier = GreenTea.number({integer = true});
	TimeThreshold = GreenTea.number();

	Configure = GreenTea.optional(isFunctionRaw);
	Run = isFunctionRaw;
})
type Benchmark = typeof(isBenchmark:type())

type BenchmarkEntry = {
	Benchmark: Benchmark,
	Name: string,
}

local benchmarks: {BenchmarkEntry} = {}
local length = 0
do
	local BASE_PATH = PathFileSystem.CWD:join(".lune"):join("benchmarks")

	local function GetPath(filePath: PathFileSystem.Path, isFolder: boolean): Path
		return if isFolder then filePath:join("init") else filePath
	end

	for _, potentialBenchmark in PathFileSystem.ReadDirectory(BASE_PATH) do
		-- all benchmarks should start with "Benchmark" so that way we don't include `init.luau` or `SpeedTester.luau`.
		if not string.match(string.lower(potentialBenchmark), "^benchmark") then
			continue
		end

		local file = BASE_PATH:join(potentialBenchmark)
		local filePath = GetPath(file, PathFileSystem.IsDirectory(file))

		local success, value = pcall(function()
			return require(filePath:toString()) :: never
		end)

		if not success then
			console.warn(`{file} failed to load - {value}`)
			continue
		end

		local typeSuccess, typeError = isBenchmark:matches(value)
		if not typeSuccess then
			console.warn(`{filePath} failed to check - {typeError}`)
			continue
		end

		length += 1
		benchmarks[length] = {
			Benchmark = value;
			Name = string.gsub(potentialBenchmark, "%.luau?$", "");
		}
	end

	table.sort(benchmarks, function(a, b)
		return a.Name < b.Name
	end)
end

local names: {string} = table.create(length)
for index, benchmark in benchmarks do
	names[index] = benchmark.Name
end

local benchmark = stdio.prompt("select", "Which benchmark do you want to run?", names)
if not benchmark then
	process.exit(1)
end

local benchmarkEntry = benchmarks[benchmark]
if not benchmarkEntry then
	console.warn("Invalid benchmark")
	process.exit(1)
end

local configure = benchmarkEntry.Benchmark.Configure
if configure then
	configure()
end

benchmarkEntry.Benchmark.Run()
