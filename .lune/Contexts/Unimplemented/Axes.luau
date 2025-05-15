--!optimize 2
--!strict

type Metatable = {
	__eq: (self: PolyfillAxes, other: PolyfillAxes) -> boolean,
	__tostring: (self: PolyfillAxes) -> string,
	__type: "Axes",
}
export type PolyfillAxes = typeof(setmetatable({} :: {}, {} :: Metatable))
type Static = {new: ((value: number) -> PolyfillAxes) & ((...any) -> PolyfillAxes)}

local metatable = {} :: Metatable

do
	function metatable:__eq(_other: PolyfillAxes): boolean
		return true
	end
	function metatable:__tostring(): string
		return "Bruh"
	end
	metatable.__type = "Axes"
end

local Axes = {} :: Static

function Axes.new(...: any): PolyfillAxes
	local _ = ...
	return setmetatable({}, metatable)
end

return table.freeze(Axes)
