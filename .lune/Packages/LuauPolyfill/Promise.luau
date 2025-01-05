--!optimize 2
-- this maps onto community promise libraries which won't support Luau, so we inline

local Promise = require("@packages/Promise")

export type PromiseLike<T> = {
	Then: (
		self: PromiseLike<T>,
		resolve: ((T) -> ...(nil | T | PromiseLike<T>))?,
		reject: ((any) -> ...(nil | T | PromiseLike<T>))?
	) -> PromiseLike<T>,
}

export type Promise<T...> = Promise.TypedPromise<T...>

return {}
