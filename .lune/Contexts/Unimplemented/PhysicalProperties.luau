--!optimize 2
--!strict

type Metatable = {
	__eq: (self: PolyfillPhysicalProperties, other: PolyfillPhysicalProperties) -> boolean,
	__tostring: (self: PolyfillPhysicalProperties) -> string,
	__type: "PhysicalProperties",
}
export type PolyfillPhysicalProperties = typeof(setmetatable({} :: {}, {} :: Metatable))
type Static = {new: ((value: number) -> PolyfillPhysicalProperties) & ((...any) -> PolyfillPhysicalProperties)}

local metatable = {} :: Metatable

do
	function metatable:__eq(_other: PolyfillPhysicalProperties): boolean
		return true
	end
	function metatable:__tostring(): string
		return "Bruh"
	end
	metatable.__type = "PhysicalProperties"
end

local PhysicalProperties = {} :: Static

function PhysicalProperties.new(...: any): PolyfillPhysicalProperties
	local _ = ...
	return setmetatable({}, metatable)
end

return table.freeze(PhysicalProperties)
