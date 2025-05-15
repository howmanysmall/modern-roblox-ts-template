--!optimize 2
--!strict

local Promise = require("@packages/Promise")

--[=[
	The functionality of this is meant to be the same as the `await` keyword in
	ECMAScript.

	```ts
	async function promiseGet(url: string) {
		return HttpService.GetAsync(url);
	}

	const result = await promiseGet("https://example.com");
	```

	```lua
	-- This is good practice - you don't really lose debug info this way.
	local function GetAsync(url: string)
		return HttpService:GetAsync(url)
	end

	local PromiseGet = PromiseUtilities.FastAsync(GetAsync)
	local result = PromiseUtilities.Await(PromiseGet("https://example.com"))
	```

	:::tip Behavior
	This function is almost entirely identical to `Promise.expect`. You can
	probably just use that instead!
	:::

	@function Await
	@within PromiseUtilities

	@error CancelledError -- Thrown if the Promise was cancelled.
	@error RejectedError -- Thrown if the Promise was rejected.

	@yields
	@param promiseOrValue Promise<T> | T
	@return T
]=]
local function Await<T>(promiseOrValue: Promise.Promise<T> | T): T
	if not Promise.Is(promiseOrValue) then
		return promiseOrValue :: T
	end

	local status, value = (promiseOrValue :: Promise.Promise<T>):WaitStatus()
	if status == Promise.Status.Resolved then
		return value
	end

	if status == Promise.Status.Rejected then
		error(value, 2)
	end

	error("The awaited Promise was cancelled", 2)
end

return Await
