--!optimize 2
--!strict

local Promise = require("@packages/Promise")

--[=[
	A function that turns another function into the same as an async function
	in ECMAScript. This was taken from [here](https://github.com/roblox-ts/roblox-ts/blob/master/include/RuntimeLib.lua).

	```ts
	async function promiseGet(url: string) {
		return HttpService.GetAsync(url);
	}
	```

	would basically be equivalent to:

	```lua
	local function GetAsync(url: string)
		return HttpService:GetAsync(url)
	end

	local PromiseGet = PromiseUtilities.Async(GetAsync)
	```

	:::info
	This is meant to be entirely equivalent to the TypeScript version. I would
	recommend using [PromiseUtilities.FastAsync] instead for better
	performance.
	:::

	@function Async
	@within PromiseUtilities

	@param callback (Arguments...) -> Returns
	@return (Arguments...) -> Promise<Returns>
]=]
local function Async<Returns, Arguments...>(callback: (Arguments...) -> Returns)
	local function asyncFunction(...: Arguments...)
		local arguments = {select(1, ...)}
		local length = select("#", ...)

		return Promise.new(function(resolve, reject)
			coroutine.wrap(function()
				local success, value = pcall(callback, table.unpack(arguments, 1, length))
				if success then
					resolve(value)
				else
					reject(value)
				end
			end)()
		end)
	end

	return asyncFunction
end

--[=[
	Basically equivalent to [PromiseUtilities.Async], except you are not
	expected to have any return. This only exists because Luau's type system
	is not the greatest at handling this.

	@function AsyncVoid
	@within PromiseUtilities

	@param callback (Arguments...) -> void
	@return (Arguments...) -> Promise<void>
]=]

return Async
