--!optimize 2
--!strict

type Metatable = {
	__eq: (self: PolyfillOverlapParams, other: PolyfillOverlapParams) -> boolean,
	__tostring: (self: PolyfillOverlapParams) -> string,
	__type: "OverlapParams",
}
export type PolyfillOverlapParams = typeof(setmetatable({} :: {}, {} :: Metatable))
type Static = {new: ((value: number) -> PolyfillOverlapParams) & ((...any) -> PolyfillOverlapParams)}

local metatable = {} :: Metatable

do
	function metatable:__eq(_other: PolyfillOverlapParams): boolean
		return true
	end
	function metatable:__tostring(): string
		return "OverlapParams"
	end
	metatable.__type = "OverlapParams"
end

local OverlapParams = {} :: Static

function OverlapParams.new(...: any): PolyfillOverlapParams
	local _ = ...
	return setmetatable({}, metatable)
end

return table.freeze(OverlapParams)
