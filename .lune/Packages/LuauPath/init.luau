--!optimize 2

local Path = require("./Path")

type PrefixEnum =
	{type: "Verbatim", value: string}
	| {type: "VerbatimUNC", hostName: string, shareName: string}
	| {type: "VerbatimDisk", value: string}
	| {type: "DeviceNS", value: string}
	| {type: "UNC", hostName: string, shareName: string}
	| {type: "Disk", value: string}
type Prefix = PrefixEnum & {
	len: (self: Prefix) -> number,
	isVerbatim: (self: Prefix) -> boolean,
	isDrive: (self: Prefix) -> boolean,
	hasImplicitRoot: (self: Prefix) -> boolean,

	clone: (self: Prefix) -> Prefix,
	equal: (self: Prefix, other: Prefix) -> boolean,
}

type PrefixComponent = {
	type: "prefix",
	raw: string,
	parsed: Prefix,
}
type NormalComponent = {type: "normal", value: string}
type ComponentEnum = NormalComponent | {type: "rootDir"} | {type: "curDir"} | {type: "parentDir"} | PrefixComponent
type ComponentCommon = {
	toString: (self: Component) -> string,
	equal: (self: Component, other: Component) -> boolean,
}
type Component = ComponentEnum & ComponentCommon
type Rev<T> = {
	next: (self: Rev<T>) -> T?,
	collect: (self: Rev<T>) -> {T},
	rev: (self: Rev<T>) -> Rev<T>,
	-- DoubleEndedIterator
	nextBack: (self: Rev<T>) -> T?,

	clone: (self: Rev<T>) -> Rev<T>,
}

type Components = {
	-- The prefix as it was originally parsed, if any
	prefix: Prefix?,

	prefixLen: (self: Components) -> number,
	prefixVerbatim: (self: Components) -> boolean,
	-- how much of the prefix is left from the point of view of iteration?
	prefixRemaining: (self: Components) -> number,
	-- Given the iteration so far, how much of the pre-State::Body path is left?
	lenBeforeBody: (self: Components) -> number,
	-- is the iteration complete?
	finished: (self: Components) -> boolean,
	isSepByte: (self: Components, b: string) -> boolean,
	-- asPath: (self: Components) -> Path,
	asPathString: (self: Components) -> string,
	hasRoot: (self: Components) -> boolean,
	includeCurDir: (self: Components) -> boolean,
	parseSingleComponent: (self: Components, comp: string) -> Component?,
	parseNextComponent: (self: Components) -> (number, Component?),
	parseNextComponentBack: (self: Components) -> (number, Component?),
	trimLeft: (self: Components) -> (),
	trimRight: (self: Components) -> (),

	-- Iterator
	next: (self: Components) -> Component?,
	collect: (self: Components) -> {Component},
	rev: (self: Components) -> Rev<Component>,
	-- DoubleEndedIterator
	nextBack: (self: Components) -> Component?,

	-- Clone
	clone: (self: Components) -> Components,
	equal: (self: Components, other: Components) -> boolean,
}

export type AsPath = string | Path | Components

type Ancestors = {
	-- Iterator
	next: (self: Ancestors) -> Path?,
	collect: (self: Ancestors) -> {Path},
}
export type Path = {
	toString: (self: Path) -> string,

	toPathBuf: (self: Path) -> Path,
	isAbsolute: (self: Path) -> boolean,
	isRelative: (self: Path) -> boolean,
	hasRoot: (self: Path) -> boolean,
	parent: (self: Path) -> Path?,
	ancestors: (self: Path) -> Ancestors,
	fileName: (self: Path) -> string?,
	stripPrefix: (self: Path, base: AsPath) -> Path?,
	startsWith: (self: Path, base: AsPath) -> boolean,
	endsWith: (self: Path, child: AsPath) -> boolean,

	fileStem: (self: Path) -> string?,
	filePrefix: (self: Path) -> string?,
	extension: (self: Path) -> string?,
	join: (self: Path, path: AsPath) -> Path,

	withFileName: (self: Path, fileName: string) -> Path,
	withExtension: (self: Path, extension: string) -> Path,
	components: (self: Path) -> Components,

	equal: (self: Path, other: Path) -> boolean,

	-- PathBuf
	push: (self: Path, path: AsPath) -> (),
	pop: (self: Path) -> boolean,
	setFileName: (self: Path, fileName: string) -> (),
	setExtension: (self: Path, extension: string) -> boolean,
	clear: (self: Path) -> (),
}

return {
	Path = (Path :: never) :: {
		new: (path: string) -> Path,
		from: (path: AsPath) -> Path,
		is: (value: unknown) -> boolean,
	};
}
