--!optimize 2
--!strict

type Metatable = {
	__eq: (self: PolyfillCatalogSearchParams, other: PolyfillCatalogSearchParams) -> boolean,
	__tostring: (self: PolyfillCatalogSearchParams) -> string,
	__type: "CatalogSearchParams",
}
export type PolyfillCatalogSearchParams = typeof(setmetatable({} :: {}, {} :: Metatable))
type Static = {new: ((value: number) -> PolyfillCatalogSearchParams) & ((...any) -> PolyfillCatalogSearchParams)}

local metatable = {} :: Metatable

do
	function metatable:__eq(_other: PolyfillCatalogSearchParams): boolean
		return true
	end
	function metatable:__tostring(): string
		return "CatalogSearchParams"
	end
	metatable.__type = "CatalogSearchParams"
end

local CatalogSearchParams = {} :: Static

function CatalogSearchParams.new(...: any): PolyfillCatalogSearchParams
	local _ = ...
	return setmetatable({}, metatable)
end

return table.freeze(CatalogSearchParams)
