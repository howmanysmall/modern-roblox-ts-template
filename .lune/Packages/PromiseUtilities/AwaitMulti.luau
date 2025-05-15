--!optimize 2
--!strict

local Promise = require("@packages/Promise")

local function PackRest<S, T...>(statusOrSuccess: S, ...: T...)
	-- table.pack cringes with typed varargs, so we do this instead.
	-- selene: allow(mixed_table)
	return statusOrSuccess, {
		n = select("#", ...);
		select(1, ...);
	}
end

--[=[
	The functionality of this is meant to be the same as the `await` keyword in
	ECMAScript. This allows returning multiple values!

	```lua
	local function PromiseUpperAndLower(value: string): Promise<string, string>
		return Promise.new(function(resolve)
			resolve(string.upper(value), string.lower(value))
		end)
	end
	local upper, lower = PromiseUtilities.AwaitMulti(PromiseUpperAndLower("Hello there!"))
	```

	:::tip Behavior
	This function is almost entirely identical to `Promise.expect`. You can
	probably just use that instead!
	:::

	@function AwaitMulti
	@within PromiseUtilities

	@error CancelledError -- Thrown if the Promise was cancelled.
	@error RejectedError -- Thrown if the Promise was rejected.

	@yields
	@param ... T | Promise<T...>
	@return T
]=]
local function AwaitMulti<T...>(...: any): T...
	local promise: Promise.Promise<T...> = ...
	if not Promise.Is(promise) then
		return ...
	end

	local status, values = PackRest(promise:WaitStatus())
	if status == Promise.Status.Resolved then
		return table.unpack(values, 1, values.n)
	end

	if status == Promise.Status.Rejected then
		error(values[1] or "Unknown rejection?", 2)
	end

	error("The awaited Promise was cancelled", 2)
end

type AwaitPromise = <T...>(promise: Promise.Promise<T...>) -> T...
type AwaitVariadic = <T...>(T...) -> T...

return AwaitMulti :: AwaitPromise & AwaitVariadic
