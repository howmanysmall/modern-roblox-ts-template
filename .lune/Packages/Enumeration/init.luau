--!nonstrict
--!optimize 2

local Enumeration = require("@self/Enumeration")

type SimpleResult<T, E> = {
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
	CastResult: (self: EnumerationObject<Values, ArrayValues>, check: unknown) -> SimpleResult<ArrayValues, string>,
	GetEnumerationItems: (self: EnumerationObject<Values, ArrayValues>) -> {ArrayValues},
} & Values

type Enumerations<Values, ArrayValues> = {
	GetEnumerations: (self: Enumerations<Values, ArrayValues>) -> {ArrayValues},
} & Values

export type PublishVersionTypeItem =
	EnumerationItem<number, PublishVersionType, "Saved">
	| EnumerationItem<number, PublishVersionType, "Published">
export type PublishVersionType = EnumerationObject<{
	Saved: EnumerationItem<number, PublishVersionType, "Saved">,
	Published: EnumerationItem<number, PublishVersionType, "Published">,
}, PublishVersionTypeItem>
Enumeration.PublishVersionType = {"Saved", "Published"}

return Enumeration :: Enumerations<{
	PublishVersionType: PublishVersionType,
}, PublishVersionType>
