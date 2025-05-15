--!optimize 2
--!strict

local Promise = require("@packages/Promise")

local Async = require("@self/Async")
local AsyncMulti = require("@self/AsyncMulti")
local Await = require("@self/Await")
local AwaitMulti = require("@self/AwaitMulti")
local FastAsync = require("@self/FastAsync")
local FastAsyncMulti = require("@self/FastAsyncMulti")

export type Error = Promise.Error
export type ErrorKind = Promise.ErrorKind
export type Status = Promise.Status

export type Promise<T...> = Promise.Promise<T...>
export type VoidPromise = Promise.VoidPromise

type VoidedAsync = <Arguments...>(callback: (Arguments...) -> ()) -> (Arguments...) -> VoidPromise

--[=[
	Utilities for working with Promises.
	@class PromiseUtilities
]=]
local PromiseUtilities = table.freeze({
	Async = Async;
	AsyncVoid = (Async :: never) :: VoidedAsync;
	AsyncMulti = AsyncMulti;
	Await = Await;
	AwaitMulti = AwaitMulti;
	FastAsync = FastAsync;
	FastAsyncVoid = (FastAsync :: never) :: VoidedAsync;
	FastAsyncMulti = FastAsyncMulti;

	Promise = Promise;
})

return PromiseUtilities
