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

local IsBenchmark = GreenTea.build({
	BarGraphMultiplier = GreenTea.number({integer = true});
	TimeThreshold = GreenTea.number();
	Configure = GreenTea.optional(GreenTea.anyfn());
	Run = GreenTea.anyfn();
})

type Benchmark = typeof(IsBenchmark:type())

type BenchmarkEntry = {
	Benchmark: Benchmark,
	Name: string,
}

local benchmarks: {BenchmarkEntry} = {}
local length = 0
do
	local BASE_PATH = PathFileSystem.CWD:join(".lune"):join("benchmarks")
	if not PathFileSystem.IsDirectory(BASE_PATH) then
		console.warn("No benchmarks directory found!")
		process.exit(1)
	end

	local function GetPath(filePath: PathFileSystem.Path, isFolder: boolean): Path
		return if isFolder then filePath:join("init") else filePath
	end

	for _, file in PathFileSystem.GetChildren(BASE_PATH) do
		local fileName = file:fileName()
		if not fileName then
			console.warn(`File name not found for {file}?`)
			continue
		end

		if not string.match(string.lower(fileName), "^benchmark") then
			continue
		end

		-- local file = BASE_PATH:join(potentialBenchmark)
		local filePath = GetPath(file, PathFileSystem.IsDirectory(file))
		local requirePath = filePath:stripPrefix(BASE_PATH)
		if not requirePath then
			console.warn(`{filePath} could not be stripped of the prefix.`)
			continue
		end

		local success, value = pcall(function(): any
			return require(`./{requirePath:toString()}`) :: any
		end)

		if not success then
			console.warn(`{file} failed to load - {value}`)
			continue
		end

		local typeSuccess, typeError = IsBenchmark:matches(value)
		if not typeSuccess then
			console.warn(`{filePath} failed to check - {typeError}`)
			continue
		end

		length += 1
		benchmarks[length] = {
			Benchmark = value;
			Name = string.gsub(fileName, "%.luau?$", "");
		}
	end

	table.sort(benchmarks, function(a: BenchmarkEntry, b: BenchmarkEntry): boolean
		return a.Name < b.Name
	end)
end

local names: {string} = table.create(length)
for index, benchmark in benchmarks do
	names[index] = benchmark.Name
end

local index = stdio.prompt("select", "Which benchmark do you want to run?", names)
if not index then
	process.exit(1)
end

local benchmarkEntry = benchmarks[index]
if not benchmarkEntry then
	console.warn("Invalid benchmark")
	process.exit(1)
end

local benchmark = benchmarkEntry.Benchmark
local configure = benchmark.Configure
if configure then
	configure(benchmark)
end

benchmark.Run()
