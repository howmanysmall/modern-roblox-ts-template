--!optimize 2
--!strict

local FileSystemUtilities = require("@utilities/FileSystemUtilities")
local GenerateGuid = require("@utilities/GenerateGuid")
local PathFileSystem = require("@packages/PathFileSystem")

local BenchmarkCreators = {}

local BENCHMARKS_FOLDER = PathFileSystem.CWD:join("src"):join("server"):join("benchmarks")

local META_SOURCE = [[{
	"properties": {
		"Attributes": {
			"BenchId": { "String": "%*" }
		}
	}
}
]]
local TYPESCRIPT_SOURCE = [[%*//!nonstrict
//!optimize 2

import type { Benchmark, Profiler } from "%*./types";

function createBenchmark<Arguments extends Array<undefined> | Array<unknown> = Array<unknown>>(
	parameterGenerator: () => LuaTuple<Arguments extends void ? Array<undefined> : Arguments>,
	functions: Record<
		string,
		(profiler: Profiler, ...benchmarkArguments: Arguments extends void ? Array<undefined> : Arguments) => void
	>,
): Benchmark<Arguments> {
	return {
		Functions: functions,
		ParameterGenerator: parameterGenerator,
	};
}

export = createBenchmark(() => $tuple(), {
	"A": (profiler) => {},
	"B": (profiler) => {},
});
]]

function BenchmarkCreators.TypeScript(fileName: string, shouldBeNative: boolean, shouldBeFolder: boolean): ()
	if shouldBeFolder then
		local folderPath = BENCHMARKS_FOLDER:join(`{fileName}.bench`)

		FileSystemUtilities.SafeCreate(folderPath, "Directory")
		FileSystemUtilities.SafeCreate(
			folderPath:join("index.ts"),
			"File",
			string.format(TYPESCRIPT_SOURCE, if shouldBeNative then "//!native\n" else "", ".")
		)
		FileSystemUtilities.SafeCreate(
			folderPath:join("init.meta.json"),
			"File",
			string.format(META_SOURCE, string.upper(GenerateGuid()))
		)
		return
	end

	FileSystemUtilities.SafeCreate(
		BENCHMARKS_FOLDER:join(`{fileName}.bench.ts`),
		"File",
		string.format(TYPESCRIPT_SOURCE, if shouldBeNative then "//!native\n" else "", "")
	)
	FileSystemUtilities.SafeCreate(
		BENCHMARKS_FOLDER:join(`{fileName}.bench.meta.json`),
		"File",
		string.format(META_SOURCE, string.upper(GenerateGuid()))
	)
end

local LUAU_SOURCE = [[%*--!nonstrict
--!optimize 2

type Profiler = {
	Begin: (label: string) -> (),
	End: () -> (),

	Start: (label: string) -> (),
	Stop: () -> (),

	Open: (label: string) -> (),
	Close: () -> (),

	Enter: (label: string) -> (),
	Exit: () -> (),

	begin: (label: string) -> (),
	["end"]: () -> (),

	start: (label: string) -> (),
	stop: () -> (),

	open: (label: string) -> (),
	close: () -> (),

	enter: (label: string) -> (),
	exit: () -> (),
}
type Benchmark<T...> = {
	ParameterGenerator: () -> T...?,
	Functions: {[string]: (profiler: Profiler, T...) -> ()},
}

local function CreateBenchmark<T...>(
	parameterGenerator: () -> T...?,
	functions: {[string]: (profiler: Profiler, T...) -> ()}
): Benchmark<T...>
	return {
		ParameterGenerator = parameterGenerator;
		Functions = functions;
	}
end

return CreateBenchmark(function()
	return
end, {
	["A"] = function(profiler) end;
	["B"] = function(profiler) end;
})
]]

function BenchmarkCreators.Luau(fileName: string, shouldBeNative: boolean, shouldBeFolder: boolean): ()
	if shouldBeFolder then
		local folderPath = BENCHMARKS_FOLDER:join(`{fileName}.bench`)
		FileSystemUtilities.SafeCreate(folderPath, "Directory")
		FileSystemUtilities.SafeCreate(
			folderPath:join("init.luau"),
			"File",
			string.format(LUAU_SOURCE, if shouldBeNative then "--!native\n" else "")
		)
		FileSystemUtilities.SafeCreate(
			folderPath:join("init.meta.json"),
			"File",
			string.format(META_SOURCE, string.upper(GenerateGuid()))
		)
		return
	end

	FileSystemUtilities.SafeCreate(
		BENCHMARKS_FOLDER:join(`{fileName}.bench.luau`),
		"File",
		string.format(LUAU_SOURCE, if shouldBeNative then "--!native\n" else "")
	)
	FileSystemUtilities.SafeCreate(
		BENCHMARKS_FOLDER:join(`{fileName}.bench.meta.json`),
		"File",
		string.format(META_SOURCE, string.upper(GenerateGuid()))
	)
end

return table.freeze(BenchmarkCreators)
