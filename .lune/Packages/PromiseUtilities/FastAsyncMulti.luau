--!optimize 2
--!strict

local Promise = require("@packages/Promise")
local ThreadUtilities = require("@packages/ThreadUtilities")

local function PackRest<S, T...>(statusOrSuccess: S, ...: T...)
	-- table.pack cringes with typed varargs, so we do this instead.
	-- selene: allow(mixed_table)
	return statusOrSuccess, {
		n = select("#", ...);
		select(1, ...);
	}
end

--[=[
	A function that turns another function into the same as an async function
	in ECMAScript. This supports multiple returns however.

	```ts
	async function promiseUpperAndLower(value: string) {
		return [value.toUpperCase(), value.toLowerCase()];
	}
	```

	would basically be equivalent to:

	```lua
	local function GetUpperAndLowerAsync(value: string)
		return string.upper(value), string.lower(value)
	end

	local PromiseUpperAndLower = PromiseUtilities.FastAsyncMulti(GetUpperAndLowerAsync)
	```

	@function FastAsyncMulti
	@within PromiseUtilities

	@param callback (Arguments...) -> Returns...
	@return (Arguments...) -> Promise<Returns...>
]=]
local function FastAsyncMulti<Arguments..., Returns...>(callback: (Arguments...) -> Returns...)
	local function asyncFunction(...: Arguments...): Promise.TypedPromise<Returns...>
		local arguments = {select(1, ...)}
		local length = select("#", ...)

		return Promise.new(function(resolve, reject)
			ThreadUtilities.FastSpawn(function()
				local success, values = PackRest(pcall(callback, table.unpack(arguments, 1, length)))
				if success then
					resolve(table.unpack(values, 1, values.n))
				else
					reject(table.unpack(values, 1, values.n))
				end
			end)
		end)
	end

	return asyncFunction
end

return FastAsyncMulti
