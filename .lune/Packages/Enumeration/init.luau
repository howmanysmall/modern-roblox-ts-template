--!optimize 2
--!strict

local Enumeration = require("./Enumeration")

type Result<T, E> = {
	Success: true,
	Value: T,
} | {
	Success: false,
	Error: E,
}

type EnumerationItem<Value, Type, Name = string> = {
	EnumerationType: Type,
	Name: Name,
	Value: Value,
}
type EnumerationObject<Values, ArrayValues> = {
	Cast: ((self: EnumerationObject<Values, ArrayValues>, check: unknown) -> ArrayValues)
		& ((self: EnumerationObject<Values, ArrayValues>, check: unknown) -> (false, string)),
	CastResult: (self: EnumerationObject<Values, ArrayValues>, check: unknown) -> Result<ArrayValues, string>,
	GetEnumerationItems: (self: EnumerationObject<Values, ArrayValues>) -> {ArrayValues},
} & Values

type Enumerations<Values, ArrayValues> = {
	GetEnumerations: (self: Enumerations<Values, ArrayValues>) -> {ArrayValues},
} & Values

export type StyluaType =
	EnumerationItem<number, StyluaTypeRoot, "Standard">
	| EnumerationItem<number, StyluaTypeRoot, "React">
export type StyluaTypeRoot = EnumerationObject<{
	Standard: EnumerationItem<number, StyluaTypeRoot, "Standard">,
	React: EnumerationItem<number, StyluaTypeRoot, "React">,
}, StyluaType>
Enumeration.StyluaType = {"Standard", "React"}

return Enumeration :: Enumerations<{
	StyluaType: StyluaTypeRoot,
}, StyluaTypeRoot>
