--!optimize 2
--!strict

type Metatable = {
	__eq: (self: PolyfillFaces, other: PolyfillFaces) -> boolean,
	__tostring: (self: PolyfillFaces) -> string,
	__type: "Faces",
}
export type PolyfillFaces = typeof(setmetatable({} :: {}, {} :: Metatable))
type Static = {new: ((value: number) -> PolyfillFaces) & ((...any) -> PolyfillFaces)}

local metatable = {} :: Metatable

do
	function metatable:__eq(_other: PolyfillFaces): boolean
		return true
	end
	function metatable:__tostring(): string
		return "Bruh"
	end
	metatable.__type = "Faces"
end

local Faces = {} :: Static

function Faces.new(...: any): PolyfillFaces
	local _ = ...
	return setmetatable({}, metatable)
end

return table.freeze(Faces)
