--!optimize 2
--!strict

local LuauPolyfill = require("@packages/LuauPolyfill")
local Promise = require("@packages/Promise")
local PromiseUtilities = require("@promises/PromiseUtilities")
local TryUtilities = require("@utilities/TryUtilities")

local Map = LuauPolyfill.Map
local WeakMap = LuauPolyfill.WeakMap

type Map<K, V> = LuauPolyfill.Map<K, V>
type Promise<T...> = Promise.TypedPromise<T...>
type WeakMap<K, V> = LuauPolyfill.WeakMap<K, V>

export type AnyAsyncFunction = (...any) -> Promise<...any>
export type AsyncFunction<A..., R...> = (A...) -> Promise<R...>

export type CacheStorage<KeyType, ValueType> = {
	clear: nil | (self: CacheStorage<KeyType, ValueType>) -> unknown,
	delete: (self: CacheStorage<KeyType, ValueType>, key: KeyType) -> unknown,
	get: (self: CacheStorage<KeyType, ValueType>, key: KeyType) -> Promise<ValueType?> | ValueType | nil,
	has: (self: CacheStorage<KeyType, ValueType>, key: KeyType) -> Promise<boolean> | boolean,
	set: (self: CacheStorage<KeyType, ValueType>, key: KeyType, value: ValueType) -> Promise<unknown> | unknown,
}

local cacheStore: WeakMap<AnyAsyncFunction, CacheStorage<any, any> | false> = WeakMap.new()

export type Options<CacheKeyType, Arguments..., Returns...> = {
	CacheKey: nil | (Arguments...) -> CacheKeyType,
	Cache: nil | CacheStorage<CacheKeyType, Promise<Returns...>> | false,
}

local function Pack(...)
	-- selene: allow(mixed_table)
	return {
		n = select("#", ...);
		select(1, ...);
	}
end

local function PromiseMemoize<CacheKeyType, Arguments..., Returns...>(
	callback: AsyncFunction<Arguments..., Returns...>,
	options: Options<
		CacheKeyType,
		Arguments...,
		Returns...
	>?
): AsyncFunction<Arguments..., Returns...>
	local trueOptions: Options<CacheKeyType, Arguments..., Returns...> = options or {}

	local cacheKey: (Arguments...) -> CacheKeyType = trueOptions.CacheKey
		or function(...: Arguments...)
			local firstArgument = (select(1, ...))
			return firstArgument :: CacheKeyType
		end
	local cache: CacheStorage<CacheKeyType, Promise<Returns...>> = trueOptions.Cache or Map.new()
	local promiseCache: Map<CacheKeyType, Promise<Returns...>> = Map.new()

	local function memoized(...: Arguments...): Promise<Returns...>
		local key = cacheKey(...)
		if promiseCache:has(key) then
			return promiseCache:get(key) :: Promise<Returns...>
		end

		local arguments = Pack(...)

		local promise = (
			(PromiseUtilities.AsyncFast(function()
				local exitType, returns = TryUtilities.Try(
					function()
						if cache and PromiseUtilities.Await(cache:has(key)) then
							return TryUtilities.TRY_RETURN, PromiseUtilities.Await(cache:get(key))
						end

						local internalPromise = callback(table.unpack(arguments, 1, arguments.n))
						local result = PromiseUtilities.Await(internalPromise)

						local internalExitType, internalReturns = TryUtilities.Try(
							function()
								return TryUtilities.TRY_RETURN, result
							end,
							nil,
							function()
								if cache then
									PromiseUtilities.Await(cache:set(key, result))
								end
							end
						)

						if internalExitType then
							return internalExitType, internalReturns
						end

						return nil, nil
					end,
					nil,
					function()
						promiseCache:delete(key)
					end
				)

				if exitType then
					return returns
				end

				return nil
			end))() :: never
		) :: Promise<Returns...>
		promiseCache:set(key, promise)
		return promise
	end

	cacheStore:set(memoized, cache)
	return memoized
end

return PromiseMemoize
