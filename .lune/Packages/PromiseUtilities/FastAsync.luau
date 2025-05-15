--!optimize 2
--!strict

local Promise = require("@packages/Promise")
local ThreadUtilities = require("@packages/ThreadUtilities")

--[=[
	A function that turns another function into the same as an async function
	in ECMAScript. This uses a thread recycling "fast spawn" function instead
	of `coroutine.wrap`.

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

	local PromiseGet = PromiseUtilities.FastAsync(GetAsync)
	```

	@function FastAsync
	@within PromiseUtilities

	@param callback (Arguments...) -> Returns
	@return (Arguments...) -> Promise<Returns>
]=]
local function FastAsync<Returns, Arguments...>(callback: (Arguments...) -> Returns)
	local function fastAsyncFunction(...: Arguments...)
		local arguments = {select(1, ...)}
		local length = select("#", ...)

		return Promise.new(function(resolve, reject)
			ThreadUtilities.FastSpawn(function()
				local success, value = pcall(callback, table.unpack(arguments, 1, length))
				if success then
					resolve(value)
				else
					reject(value)
				end
			end)
		end)
	end

	return fastAsyncFunction
end

--[=[
	Basically equivalent to [PromiseUtilities.FastAsync], except you are not
	expected to have any return. This only exists because Luau's type system
	is not the greatest at handling this.

	@function FastAsyncVoid
	@within PromiseUtilities

	@param callback (Arguments...) -> void
	@return (Arguments...) -> Promise<void>
]=]

return FastAsync
