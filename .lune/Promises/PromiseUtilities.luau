--!optimize 2
--!strict

local Promise = require("@packages/Promise")
local ThreadUtilities = require("@utilities/ThreadUtilities")
local task = require("@lune/task")

local PromiseUtilities = {}

export type Promise<T...> = Promise.Promise<T...>
export type AsyncFunction<Returns, Arguments...> = (Arguments...) -> Promise<Returns>
export type MultiAsyncFunction<Arguments..., Returns...> = (Arguments...) -> Promise<Returns...>

local function PackRest<S, T...>(statusOrSuccess: S, ...: T...)
	-- table.pack cringes with typed varargs, so we do this instead.
	-- selene: allow(mixed_table)
	return statusOrSuccess, {
		n = select("#", ...);
		select(1, ...);
	}
end

function PromiseUtilities.Async<Returns, Arguments...>(callback: (Arguments...) -> Returns): AsyncFunction<Returns, Arguments...>
	local function asyncFunction(...: Arguments...): Promise<Returns>
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
function PromiseUtilities.AsyncFast<Returns, Arguments...>(callback: (Arguments...) -> Returns): AsyncFunction<Returns, Arguments...>
	local function asyncFunction(...: Arguments...): Promise<Returns>
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

	return asyncFunction
end
function PromiseUtilities.AsyncTask<Returns, Arguments...>(callback: (Arguments...) -> Returns): AsyncFunction<Returns, Arguments...>
	local function asyncFunction(...: Arguments...): Promise<Returns>
		local arguments = {select(1, ...)}
		local length = select("#", ...)

		return Promise.new(function(resolve, reject)
			task.spawn(function()
				local success, value = pcall(callback, table.unpack(arguments, 1, length))
				if success then
					resolve(value)
				else
					reject(value)
				end
			end)
		end)
	end

	return asyncFunction
end

function PromiseUtilities.AsyncMulti<Arguments..., Returns...>(
	callback: (Arguments...) -> Returns...
): MultiAsyncFunction<Arguments..., Returns...>
	local function asyncFunction(...: Arguments...): Promise<Returns...>
		local arguments = {select(1, ...)}
		local length = select("#", ...)

		return Promise.new(function(resolve, reject)
			coroutine.wrap(function()
				local success, values = PackRest(pcall(callback, table.unpack(arguments, 1, length)))
				if success then
					resolve(table.unpack(values, 1, values.n))
				else
					reject(table.unpack(values, 1, values.n))
				end
			end)()
		end)
	end

	return asyncFunction
end
function PromiseUtilities.AsyncMultiFast<Arguments..., Returns...>(
	callback: (Arguments...) -> Returns...
): MultiAsyncFunction<Arguments..., Returns...>
	local function asyncFunction(...: Arguments...): Promise<Returns...>
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
function PromiseUtilities.AsyncMultiTask<Arguments..., Returns...>(
	callback: (Arguments...) -> Returns...
): MultiAsyncFunction<Arguments..., Returns...>
	local function asyncFunction(...: Arguments...): Promise<Returns...>
		local arguments = {select(1, ...)}
		local length = select("#", ...)

		return Promise.new(function(resolve, reject)
			task.spawn(function()
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

function PromiseUtilities.Await<T>(promiseOrValue: Promise<T> | T): T
	if not Promise.Is(promiseOrValue) then
		return promiseOrValue :: T
	end

	local status, value = (promiseOrValue :: Promise<T>):WaitStatus()
	if status == Promise.Status.Resolved then
		return value
	end

	if status == Promise.Status.Rejected then
		error(tostring(value), 2)
	end

	error("The awaited Promise was cancelled", 2)
end

local function AwaitMulti<T...>(...: any): T...
	local promise: Promise<T...> = ...
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
type AwaitPromise = <T...>(promise: Promise<T...>) -> T...
type AwaitVariadic = <T...>(T...) -> T...
PromiseUtilities.AwaitMulti = AwaitMulti :: AwaitPromise & AwaitVariadic

return table.freeze(PromiseUtilities)
