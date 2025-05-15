--!optimize 2
--!strict

type Metatable = {
	__eq: (self: PolyfillNumberSequence, other: PolyfillNumberSequence) -> boolean,
	__tostring: (self: PolyfillNumberSequence) -> string,
	__type: "NumberSequence",
}
export type PolyfillNumberSequence = typeof(setmetatable({} :: {}, {} :: Metatable))
type Static = {new: ((value: number) -> PolyfillNumberSequence) & ((...any) -> PolyfillNumberSequence)}

local metatable = {} :: Metatable

do
	function metatable:__eq(_other: PolyfillNumberSequence): boolean
		return true
	end
	function metatable:__tostring(): string
		return "Bruh"
	end
	metatable.__type = "NumberSequence"
end

local NumberSequence = {} :: Static

function NumberSequence.new(...: any): PolyfillNumberSequence
	local _ = ...
	return setmetatable({}, metatable)
end

return table.freeze(NumberSequence)
