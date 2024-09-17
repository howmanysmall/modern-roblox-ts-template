//!optimize 2

export interface Profiler {
	readonly Begin: (label: string) => void;
	readonly Close: () => void;

	readonly End: () => void;
	readonly Enter: (label: string) => void;

	readonly Exit: () => void;
	readonly Open: (label: string) => void;

	readonly Start: (label: string) => void;
	readonly Stop: () => void;
}

export interface Benchmark<Arguments extends Array<unknown> | void = Array<unknown>> {
	readonly Functions: Record<
		string,
		(profiler: Profiler, ...benchmarkArguments: Arguments extends void ? Array<undefined> : Arguments) => void
	>;
	readonly ParameterGenerator: () => LuaTuple<Arguments extends void ? Array<undefined> : Arguments>;
}
