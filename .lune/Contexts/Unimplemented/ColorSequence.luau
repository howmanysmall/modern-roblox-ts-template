--!optimize 2
--!strict

type Metatable = {
	__eq: (self: PolyfillColorSequence, other: PolyfillColorSequence) -> boolean,
	__tostring: (self: PolyfillColorSequence) -> string,
	__type: "ColorSequence",
}
export type PolyfillColorSequence = typeof(setmetatable({} :: {}, {} :: Metatable))
type Static = {new: ((value: number) -> PolyfillColorSequence) & ((...any) -> PolyfillColorSequence)}

local metatable = {} :: Metatable

do
	function metatable:__eq(_other: PolyfillColorSequence): boolean
		return true
	end
	function metatable:__tostring(): string
		return "Bruh"
	end
	metatable.__type = "ColorSequence"
end

local ColorSequence = {} :: Static

function ColorSequence.new(...: any): PolyfillColorSequence
	local _ = ...
	return setmetatable({}, metatable)
end

return table.freeze(ColorSequence)
