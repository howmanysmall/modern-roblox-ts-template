--!optimize 2
--!strict

type Metatable = {
	__eq: (self: PolyfillPath2DControlPoint, other: PolyfillPath2DControlPoint) -> boolean,
	__tostring: (self: PolyfillPath2DControlPoint) -> string,
	__type: "Path2DControlPoint",
}
export type PolyfillPath2DControlPoint = typeof(setmetatable({} :: {}, {} :: Metatable))
type Static = {new: ((value: number) -> PolyfillPath2DControlPoint) & ((...any) -> PolyfillPath2DControlPoint)}

local metatable = {} :: Metatable

do
	function metatable:__eq(_other: PolyfillPath2DControlPoint): boolean
		return true
	end
	function metatable:__tostring(): string
		return "Path2DControlPoint"
	end
	metatable.__type = "Path2DControlPoint"
end

local Path2DControlPoint = {} :: Static

function Path2DControlPoint.new(...: any): PolyfillPath2DControlPoint
	local _ = ...
	return setmetatable({}, metatable)
end

return table.freeze(Path2DControlPoint)
