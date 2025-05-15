--!optimize 2
--!strict

export type Formatter =
	& ((method: "AsString") -> string)
	& ((method: "AsTuple") -> ...unknown)
	& ((method: "AddTable", object: unknown) -> ())
	& ((method: "Lock") -> ())
	& ((method: "Unlock") -> ())
	& ((method: "AddToBuffer", value: unknown) -> ())
	& ((method: "Indent") -> ())
	& ((method: "NextLine") -> ())
	& ((method: "Unindent") -> ())
	& ((method: "Write", value: string, ...unknown) -> string)
	& ((method: "WriteLine", value: string, ...unknown) -> string)
	& ((method: "WriteLineRaw", value: string) -> string)
	& ((method: "WriteRaw", value: string) -> string)

return false
