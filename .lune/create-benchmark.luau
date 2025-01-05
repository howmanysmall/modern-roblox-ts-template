--!optimize 2
--!strict
--[=[ lunar
	about = "Creates a benchmark file."
	args = "[-h] [--luau] [--interp] [--init] <name>"
]=]

local ArgParse = require("@packages/ArgParse")
local BenchmarkCreators = require("@utilities/BenchmarkCreators")

local parser = ArgParse("create-benchmark", "Creates a benchmark file.")

parser:flag("--luau", "Create a Luau benchmark.")
parser:flag("--interp", "Make the benchmark interpreted mode.")
parser:flag("--init", "Make the benchmark use the init format.")
parser:argument("name", "The name of the benchmark", nil, nil)

local arguments: {
	luau: boolean?,
	interp: boolean?,
	init: boolean?,
	name: string,
} = parser:parse()

local creator: typeof(BenchmarkCreators.Luau) = if arguments.luau
	then BenchmarkCreators.Luau
	else BenchmarkCreators.TypeScript

creator(arguments.name, not arguments.interp, not not arguments.init)
