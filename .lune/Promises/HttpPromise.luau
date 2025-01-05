--!optimize 2
--!strict

local GreenTea = require("@packages/GreenTea")
local GreenTeaUtilities = require("@packages/GreenTeaUtilities")
local LRUCache = require("@classes/LRUCache")
local LuauPolyfill = require("@packages/LuauPolyfill")
local Promise = require("@packages/Promise")

local net = require("@lune/net")
local serde = require("@lune/serde")

local Error = LuauPolyfill.Error
local IS_ULTRA_STRICT_MODE = _G.__DEV__

export type Promise<T...> = Promise.TypedPromise<T...>
export type HttpMethod = net.HttpMethod
local IsHttpMethod: HttpMethod =
	GreenTeaUtilities.EasyLiteral("GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS", "PATCH") :: HttpMethod

local HttpPromise = {
	IsHttpMethod = IsHttpMethod :: HttpMethod;
}
HttpPromise.Methods = {
	Get = "GET" :: "GET";
	Post = "POST" :: "POST";
	Put = "PUT" :: "PUT";
	Delete = "DELETE" :: "DELETE";
	Head = "HEAD" :: "HEAD";
	Options = "OPTIONS" :: "OPTIONS";
	Patch = "PATCH" :: "PATCH";

	GET = "GET" :: "GET";
	POST = "POST" :: "POST";
	PUT = "PUT" :: "PUT";
	DELETE = "DELETE" :: "DELETE";
	HEAD = "HEAD" :: "HEAD";
	OPTIONS = "OPTIONS" :: "OPTIONS";
	PATCH = "PATCH" :: "PATCH";
}

HttpPromise.IsHttpQueryMap =
	{[GreenTea.string()] = GreenTea.union(GreenTea.string(), GreenTea.array(GreenTea.string()))}
HttpPromise.IsHttpHeaderMap = HttpPromise.IsHttpQueryMap
export type HttpQueryMap = net.HttpQueryMap
export type HttpHeaderMap = net.HttpHeaderMap

HttpPromise.IsFetchParamsOptions = {
	decompress = GreenTea.optional(GreenTea.boolean());
}
export type FetchParamsOptions = net.FetchParamsOptions
HttpPromise.IsRequestDictionary = {
	Body = GreenTea.optional(GreenTea.union(GreenTea.string(), GreenTea.buffer()));
	Headers = GreenTea.optional(HttpPromise.IsHttpQueryMap);
	Method = GreenTea.optional(IsHttpMethod) :: HttpMethod?;
	Options = GreenTea.optional(HttpPromise.IsFetchParamsOptions);
	Query = GreenTea.optional(HttpPromise.IsHttpQueryMap);
	Url = GreenTea.string();
	[GreenTea.any()] = GreenTea.never();
}
export type RequestDictionary = typeof(HttpPromise.IsRequestDictionary)

HttpPromise.IsResponseDictionary = {
	Body = GreenTea.string();
	Headers = HttpPromise.IsHttpHeaderMap;
	StatusCode = GreenTea.number({integer = true});
	StatusMessage = GreenTea.string();
	Success = GreenTea.boolean();
	[GreenTea.any()] = GreenTea.never();
}
export type ResponseDictionary = typeof(HttpPromise.IsResponseDictionary)

local IsMaybeBoolean = GreenTea.build(GreenTea.optional(GreenTea.boolean()))
local IsRequestDictionary = GreenTea.build(HttpPromise.IsRequestDictionary)

local function ReturnBody(responseDictionary: ResponseDictionary): string
	return responseDictionary.Body
end
HttpPromise.ReturnBody = ReturnBody

function HttpPromise.PromiseRequest(
	requestDictionary: RequestDictionary,
	ignoreStatus: boolean?
): Promise<ResponseDictionary>
	if IS_ULTRA_STRICT_MODE then
		local typeSuccess0, typeError0 = IsRequestDictionary:matches(requestDictionary)
		if not typeSuccess0 then
			local exception = Error.new(tostring(typeError0))
			exception.name = "TypeError"
			Error.captureStackTrace(exception, HttpPromise.PromiseRequest)
			error(exception)
		end
		local typeSuccess1, typeError1 = IsMaybeBoolean:matches(ignoreStatus)
		if not typeSuccess1 then
			local exception = Error.new(tostring(typeError1))
			exception.name = "TypeError"
			Error.captureStackTrace(exception, HttpPromise.PromiseRequest)
			error(exception)
		end
	end

	return Promise.new(function(resolve, reject)
		local success, valueOrError = pcall(net.request, {
			body = requestDictionary.Body;
			headers = requestDictionary.Headers;
			method = requestDictionary.Method;
			options = requestDictionary.Options;
			query = requestDictionary.Query;
			url = requestDictionary.Url;
		})

		if success then
			if ignoreStatus then
				resolve({
					Body = valueOrError.body;
					Headers = valueOrError.headers;
					StatusCode = valueOrError.statusCode;
					StatusMessage = valueOrError.statusMessage;
					Success = valueOrError.ok;
				})
			else
				if valueOrError.ok then
					resolve({
						Body = valueOrError.body;
						Headers = valueOrError.headers;
						StatusCode = valueOrError.statusCode;
						StatusMessage = valueOrError.statusMessage;
						Success = true;
					})
				else
					reject(`HTTP {valueOrError.statusCode}: {valueOrError.statusMessage} ({requestDictionary.Url})`)
				end
			end
		else
			reject(valueOrError)
		end
	end)
end

local isString = GreenTea.build(GreenTea.string())
local isMaybeHeaders = GreenTea.build(GreenTea.optional(HttpPromise.IsHttpHeaderMap))

function HttpPromise.PromiseGet(url: string, noCache: boolean?, headers: HttpHeaderMap?): Promise<string>
	if IS_ULTRA_STRICT_MODE then
		local typeSuccess0, typeError0 = isString:matches(url)
		if not typeSuccess0 then
			local exception = Error.new(tostring(typeError0))
			exception.name = "TypeError"
			Error.captureStackTrace(exception, HttpPromise.PromiseGet)
			error(exception)
		end
		local typeSuccess1, typeError1 = IsMaybeBoolean:matches(noCache)
		if not typeSuccess1 then
			local exception = Error.new(tostring(typeError1))
			exception.name = "TypeError"
			Error.captureStackTrace(exception, HttpPromise.PromiseGet)
			error(exception)
		end
		local typeSuccess2, typeError2 = isMaybeHeaders:matches(headers)
		if not typeSuccess2 then
			local exception = Error.new(tostring(typeError2))
			exception.name = "TypeError"
			Error.captureStackTrace(exception, HttpPromise.PromiseGet)
			error(exception)
		end
	end

	return HttpPromise.PromiseRequest({
		Method = HttpPromise.Methods.Get;
		Url = url;
	}):Then(ReturnBody)
end

function HttpPromise.PromiseDecode<T>(input: string, greenTeaType: T): Promise<T>
	local typeChecker = GreenTea.build(greenTeaType)
	if IS_ULTRA_STRICT_MODE then
		local typeSuccess, typeError = isString:matches(input)
		if not typeSuccess then
			local exception = Error.new(tostring(typeError))
			exception.name = "TypeError"
			Error.captureStackTrace(exception, HttpPromise.PromiseDecode)
			error(exception)
		end
	end

	return Promise.new(function(resolve, reject)
		local success, valueOrError = pcall(serde.decode, "json" :: "json", input)
		if success then
			local typeSuccess, typeError = typeChecker:matches(valueOrError)
			if typeSuccess then
				resolve(valueOrError)
			else
				reject(typeError)
			end
		else
			reject(valueOrError)
		end
	end)
end

local typeCache: LRUCache.LRUCache<unknown, typeof(GreenTea.build(GreenTea.any()))> = LRUCache.new(20)
local getCached = typeCache.Get
local setCached = typeCache.Set

function HttpPromise.PromiseDecodeCached<T>(input: string, greenTeaType: T): Promise<T>
	local fromCache = getCached(typeCache, greenTeaType) :: typeof(GreenTea.build(greenTeaType))
	if not fromCache then
		fromCache = GreenTea.build(greenTeaType)
		setCached(typeCache, greenTeaType, fromCache :: never)
	end

	if IS_ULTRA_STRICT_MODE then
		local typeSuccess, typeError = isString:matches(input)
		if not typeSuccess then
			local exception = Error.new(tostring(typeError))
			exception.name = "TypeError"
			Error.captureStackTrace(exception, HttpPromise.PromiseDecode)
			error(exception)
		end
	end

	return Promise.new(function(resolve, reject)
		local success, valueOrError = pcall(serde.decode, "json" :: "json", input)
		if success then
			local typeSuccess, typeError = fromCache:matches(valueOrError)
			if typeSuccess then
				resolve(valueOrError)
			else
				reject(typeError)
			end
		else
			reject(valueOrError)
		end
	end)
end

function HttpPromise.PromiseDecodeUntyped(input: string): Promise<any>
	return HttpPromise.PromiseDecode(input, GreenTea.any({allowNil = true}))
end

return table.freeze(HttpPromise)
