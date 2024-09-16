--!optimize 2
--!strict

local FileSystemUtilities = require("./Utilities/FileSystemUtilities")
local GenerateGuid = require("./Utilities/GenerateGuid")

local process = require("@lune/process")
local stdio = require("@lune/stdio")

local fileName = stdio.prompt("text", "What do you want to call this benchmark?")
if fileName == "" then
	process.exit(0)
end

local shouldBeNative = stdio.prompt("confirm", "Do you want the code to be native?", true)
local shouldBeFolder = stdio.prompt("confirm", "Do you want this to be the the init format?", false)

if shouldBeFolder then
	FileSystemUtilities.SafeCreate(`{process.cwd}src/server/benchmarks/{fileName}.bench`, "Directory")
	FileSystemUtilities.SafeCreate(
		`{process.cwd}src/server/benchmarks/{fileName}.bench/index.ts`,
		"File",
		string.format([[%*//!nonstrict
//!optimize 2

import type { Benchmark, Profiler } from "../types";
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
]], if shouldBeNative then "//!native" else "")
	)
	FileSystemUtilities.SafeCreate(
		`{process.cwd}src/server/benchmarks/{fileName}.bench/init.meta.json`,
		"File",
		string.format(
			[[{
	"properties": {
		"Attributes": {
			"BenchId": { "String": "%*" }
		}
	}
}
]],
			string.upper(GenerateGuid())
		)
	)

	process.exit(0)
end

FileSystemUtilities.SafeCreate(
	`{process.cwd}src/server/benchmarks/{fileName}.bench.ts`,
	"File",
	string.format([[%*//!nonstrict
//!optimize 2

import type { Benchmark, Profiler } from "./types";
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
]], if shouldBeNative then "//!native" else "")
)
FileSystemUtilities.SafeCreate(
	`{process.cwd}src/server/benchmarks/{fileName}.bench.meta.json`,
	"File",
	string.format(
		[[{
	"properties": {
		"Attributes": {
			"BenchId": { "String": "%*" }
		}
	}
}
]],
		string.upper(GenerateGuid())
	)
)
