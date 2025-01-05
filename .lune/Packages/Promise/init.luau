--!optimize 2
--!strict

local Promise: any = require("./Promise")

export type Status = "Started" | "Resolved" | "Rejected" | "Cancelled"
export type ErrorKind = "ExecutionError" | "AlreadyCancelled" | "NotResolvedInTime" | "TimedOut"

type ErrorStaticAndShared = {
	Kind: {
		ExecutionError: "ExecutionError",
		AlreadyCancelled: "AlreadyCancelled",
		NotResolvedInTime: "NotResolvedInTime",
		TimedOut: "TimedOut",
	},
}
type ErrorOptions = {
	error: string,
	trace: string?,
	context: string?,
	kind: ErrorKind,
}

export type Error = typeof(setmetatable({} :: ErrorStaticAndShared & {
	error: string,
	trace: string?,
	context: string?,
	kind: ErrorKind,
	parent: Error?,
	createdTick: number,
	createdTrace: string,

	extend: (self: Error, options: ErrorOptions?) -> Error,
	getErrorChain: (self: Error) -> {Error},
}, {} :: {__tostring: (self: Error) -> string}))
type ErrorStatic = ErrorStaticAndShared & {
	new: (options: ErrorOptions?, parent: Error?) -> Error,
	is: (anything: any) -> boolean,
	isKind: (anything: any, kind: ErrorKind) -> boolean,
}

export type VoidPromise = {
	Status: Status,
	Then: (self: VoidPromise, successHandler: (...any) -> ...any, failureHandler: ((...any) -> ...any)?) -> VoidPromise,
	ThenCall: <TArgs...>(self: VoidPromise, callback: (TArgs...) -> ...any, TArgs...) -> any,
	ThenReturn: (self: VoidPromise, ...any) -> VoidPromise,

	Wait: (self: VoidPromise) -> (boolean, ...any),
	WaitStatus: (self: VoidPromise) -> (Status, ...any),

	Cancel: (self: VoidPromise) -> (),
	Catch: (self: VoidPromise, failureHandler: (...any) -> ...any) -> VoidPromise,
	Expect: (self: VoidPromise) -> ...any,

	Finally: (self: VoidPromise, finallyHandler: (status: Status) -> ...any) -> VoidPromise,
	FinallyCall: <TArgs...>(self: VoidPromise, callback: (TArgs...) -> ...any, TArgs...) -> VoidPromise,
	FinallyReturn: (self: VoidPromise, ...any) -> VoidPromise,

	GetStatus: (self: VoidPromise) -> Status,
	Now: (self: VoidPromise, rejectionValue: any?) -> VoidPromise,
	Tap: (self: VoidPromise, onSuccess: (...any) -> ...any, onError: nil | (...any) -> ...any) -> VoidPromise,
	Timeout: (self: VoidPromise, seconds: number, rejectionValue: any?) -> VoidPromise,
}

export type Promise<T...> = {
	Status: Status,
	Then: (self: VoidPromise, successHandler: (T...) -> ...any, failureHandler: ((...any) -> ...any)?) -> VoidPromise,
	ThenCall: <TArgs...>(self: VoidPromise, callback: (TArgs...) -> ...any, TArgs...) -> VoidPromise,
	ThenReturn: (self: VoidPromise, ...any) -> VoidPromise,

	Wait: (self: VoidPromise) -> (boolean, T...),
	WaitStatus: (self: VoidPromise) -> (Status, T...),

	Cancel: (self: VoidPromise) -> (),
	Catch: (self: VoidPromise, failureHandler: (...any) -> ...any) -> VoidPromise,
	Expect: (self: VoidPromise) -> T...,

	Finally: (self: VoidPromise, finallyHandler: (status: Status) -> ...any) -> VoidPromise,
	FinallyCall: <TArgs...>(self: VoidPromise, callback: (TArgs...) -> ...any, TArgs...) -> VoidPromise,
	FinallyReturn: (self: VoidPromise, ...any) -> VoidPromise,

	GetStatus: (self: VoidPromise) -> Status,
	Now: (self: VoidPromise, rejectionValue: any?) -> VoidPromise,
	Tap: (self: VoidPromise, onSuccess: (T...) -> ...any, onError: nil | (...any) -> ...any) -> Promise<T...>,
	Timeout: (self: VoidPromise, seconds: number, rejectionValue: any?) -> Promise<T...>,
}
export type TypedPromise<T...> = Promise<T...>

type Signal<T...> = {
	Connect: (self: Signal<T...>, callback: (T...) -> ...any) -> SignalConnection,
}

type SignalConnection = {
	Disconnect: (self: SignalConnection) -> ...any,
	[any]: any,
}

return Promise :: {
	Error: ErrorStatic,
	Status: {
		Started: "Started",
		Resolved: "Resolved",
		Rejected: "Rejected",
		Cancelled: "Cancelled",
	},

	All: <T>(promises: {Promise<T>}) -> Promise<{T}>,
	AllSettled: <T>(promise: {Promise<T>}) -> Promise<{Status}>,
	Any: <T>(promise: {Promise<T>}) -> Promise<T>,
	Defer: <TReturn...>(
		executor: (
			resolve: (TReturn...) -> (),
			reject: (...any) -> (),
			onCancel: (abortHandler: (() -> ())?) -> boolean
		) -> ()
	) -> Promise<TReturn...>,
	Delay: (seconds: number) -> Promise<number>,
	Each: <T, TReturn>(
		list: {T | Promise<T>},
		predicate: (value: T, index: number) -> TReturn | Promise<TReturn>
	) -> Promise<{TReturn}>,
	Fold: <T, TReturn>(
		list: {T | Promise<T>},
		reducer: (accumulator: TReturn, value: T, index: number) -> TReturn | Promise<TReturn>
	) -> Promise<TReturn>,
	FromEvent: <TReturn...>(
		event: Signal<TReturn...>,
		predicate: ((TReturn...) -> boolean)?
	) -> Promise<TReturn...>,
	Is: (object: any) -> boolean,
	new: <TReturn...>(
		executor: (
			resolve: (TReturn...) -> (),
			reject: (...any) -> (),
			onCancel: (abortHandler: (() -> ())?) -> boolean
		) -> ()
	) -> Promise<TReturn...>,
	OnUnhandledRejection: (callback: (promise: Promise<any>, ...any) -> ()) -> () -> (),
	Promisify: <TArgs..., TReturn...>(callback: (TArgs...) -> TReturn...) -> (TArgs...) -> Promise<TReturn...>,
	Race: <T>(promises: {Promise<T>}) -> Promise<T>,
	Reject: (...any) -> Promise<...any>,
	Resolve: <TReturn...>(TReturn...) -> Promise<TReturn...>,
	Retry: <TArgs..., TReturn...>(
		callback: (TArgs...) -> Promise<TReturn...>,
		times: number,
		TArgs...
	) -> Promise<TReturn...>,
	RetryWithDelay: <TArgs..., TReturn...>(
		callback: (TArgs...) -> Promise<TReturn...>,
		times: number,
		seconds: number,
		TArgs...
	) -> Promise<TReturn...>,
	Some: <T>(promise: {Promise<T>}, count: number) -> Promise<{T}>,
	Try: <TArgs..., TReturn...>(callback: (TArgs...) -> TReturn..., TArgs...) -> Promise<TReturn...>,
}
