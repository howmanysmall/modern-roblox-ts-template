--!optimize 2
--!strict

local Enum = require("@packages/Enum")
local GreenTea = require("@packages/GreenTea")
local GreenTeaAssert = require("@functions/GreenTeaAssert")
local LRUCache = require("@classes/LRUCache")
local Promise = require("@packages/Promise")
local PromiseUtilities = require("@packages/PromiseUtilities")
local TableUtilities = require("@packages/TableUtilities")
local TypeError = require("@errors/TypeError")
local net = require("@lune/net")
local serde = require("@lune/serde")

--[=[
	Utility for HttpService related methods.
	@class HttpPromise
]=]
local HttpPromise = {}
export type Promise<T...> = Promise.TypedPromise<T...>

export type HttpHeaders = net.HttpHeaderMap
export type HttpMethod = net.HttpMethod

export type RequestAsyncRequest = {
	Body: buffer | nil | string,
	Compress: Enum.HttpCompression?,
	Headers: HttpHeaders?,
	Method: HttpMethod?,
	Options: net.FetchParamsOptions?,
	Query: net.HttpQueryMap?,
	Url: string,
}

--[=[
	A response dictionary.
	@interface RequestAsyncResponse
	@field Body string
	@field Headers HttpHeaders
	@field StatusCode number
	@field StatusMessage string
	@field Success boolean
	@within HttpPromise
]=]
export type RequestAsyncResponse = {
	Body: string,
	Headers: HttpHeaders,
	StatusCode: number,
	StatusMessage: string,
	Success: boolean,
}

local function ToRequestAsyncResponse(fetchResponse: net.FetchResponse): RequestAsyncResponse
	return {
		Body = fetchResponse.body;
		Headers = fetchResponse.headers;
		StatusCode = fetchResponse.statusCode;
		StatusMessage = fetchResponse.statusMessage;
		Success = fetchResponse.ok;
	}
end

--[=[
	A guaranteed successful response dictionary.
	@interface GuaranteedRequestAsyncResponse
	@field Body string
	@field Headers HttpHeaders
	@field StatusCode number
	@field StatusMessage string
	@field Success true
	@within HttpPromise
]=]
export type GuaranteedRequestAsyncResponse = RequestAsyncResponse & {
	Success: true,
}

--[=[
	Returns the body of the response dictionary.

	@function ReturnBody
	@within HttpPromise

	@param responseDictionary RequestAsyncResponse -- The response dictionary.
	@return string -- The body of the response dictionary.
]=]
local function ReturnBody(responseDictionary: RequestAsyncResponse): string
	return responseDictionary.Body
end
HttpPromise.ReturnBody = ReturnBody

--[=[
	This method calls [HttpService.RequestAsync] inside of a Promise.

	The **RequestAsync()** function sends an HTTP request using a dictionary to
	specify the request data, such as the target URL, method, headers and
	request body data. It returns a dictionary that describes the response data
	received.

	@function PromiseRequest
	@within HttpPromise

	@param requestDictionary RequestAsyncRequest -- A dictionary containing information to be requested from the server specified.
	@return Promise<GuaranteedRequestAsyncResponse> -- A promise that resolves with the response dictionary if the request was successful, or rejects with the response dictionary if the request failed.
]=]
local function PromiseRequest(requestDictionary: RequestAsyncRequest): Promise<GuaranteedRequestAsyncResponse>
	return Promise.new(function(resolve, reject)
		local body = requestDictionary.Body
		local compress = requestDictionary.Compress

		if body and compress then
			if compress == Enum.HttpCompression.Gzip then
				body = serde.compress("gzip", body)
			end
		end

		local success, value = pcall(net.request, {
			body = body;
			headers = requestDictionary.Headers;
			method = requestDictionary.Method;
			options = requestDictionary.Options;
			query = requestDictionary.Query;
			url = requestDictionary.Url;
		})

		if success then
			local modifiedValue = ToRequestAsyncResponse(value)
			if modifiedValue.Success then
				resolve(modifiedValue :: GuaranteedRequestAsyncResponse)
			else
				reject(TableUtilities.Repr(modifiedValue))
			end
		else
			reject(value)
		end
	end)
end
HttpPromise.PromiseRequest = PromiseRequest

local function PromiseSimpleRequest(requestDictionary: RequestAsyncRequest): Promise<RequestAsyncResponse>
	return Promise.new(function(resolve, reject)
		local body = requestDictionary.Body
		local compress = requestDictionary.Compress

		if body and compress then
			if compress == Enum.HttpCompression.Gzip then
				body = serde.compress("gzip", body)
			end
		end

		local success, value = pcall(net.request, {
			body = body;
			headers = requestDictionary.Headers;
			method = requestDictionary.Method;
			options = requestDictionary.Options;
			query = requestDictionary.Query;
			url = requestDictionary.Url;
		})

		if success then
			resolve(ToRequestAsyncResponse(value))
		else
			reject(value)
		end
	end)
end
HttpPromise.PromiseSimpleRequest = PromiseSimpleRequest

--[=[
	This method calls [HttpService.RequestAsync] to send an HTTP GET request.

	The GetAsync function sends an HTTP GET request. It functions similarly to
	[HttpService.RequestAsync] except that it accepts HTTP request parameters
	as method parameters instead of a single dictionary and returns only the
	body of the HTTP response. Generally, this method is useful only as a
	shorthand and [HttpService.RequestAsync] should to be used in most cases.

	When true, the [noCache] parameter prevents this function from caching
	results from previous calls with the same [url].

	```lua
	type Person = {
		craft: string,
		name: string,
	}

	type ResponseData = {
		message: "success",
		number: number,
		people: {Person},
	}

	HttpPromise.PromiseGet("http://api.open-notify.org/astros.json", true):andThen(function(body: string)
		return HttpPromise.PromiseDecode(body):andThen(function(responseData: ResponseData)
			if responseData.message == "success" then
				print("There are currently", responseData.number, "astronauts in space:")
				for _, person in responseData.people do
					print(`{person.name} is on {person.craft}`);
				end
			end
		end)
	end, warn)
	```

	@function PromiseGet
	@within HttpPromise

	@param url string -- The web address you are requesting data from.
	@param noCache? boolean -- Whether the request stores (caches) the response.
	@param headers? HttpHeaders -- Used to specify some HTTP request headers.
	@return Promise<string>
]=]
local function Get(url: string, noCache: boolean?, headers: HttpHeaders?): string
	local trueHeaders: HttpHeaders = headers or {}
	if noCache then
		trueHeaders["Cache-Control"] = "no-cache"
	end

	local response = PromiseUtilities.Await(PromiseRequest({
		Headers = trueHeaders;
		Method = "GET";
		Url = url;
	}))

	return response.Body
end
HttpPromise.PromiseGet =
	PromiseUtilities.FastAsync(Get) :: (url: string, noCache: boolean?, headers: HttpHeaders?) -> Promise<string>

local TO_HEADER: {[Enum.HttpContentType]: string} = {
	[Enum.HttpContentType.ApplicationJson] = "application/json";
	[Enum.HttpContentType.ApplicationUrlEncoded] = "application/x-www-form-urlencoded";
	[Enum.HttpContentType.ApplicationXml] = "application/xml";
	[Enum.HttpContentType.TextPlain] = "text/plain";
	[Enum.HttpContentType.TextXml] = "text/xml";
}

--[=[
	Returns a Promise that calls [HttpService.RequestAsync].

	The PostAsync function sends an HTTP POST request. It functions similarly
	to [HttpService.RequestAsync] except that it accepts HTTP request
	parameters as method parameters instead of a single dictionary and returns
	only the body of the HTTP response. Generally, this method is useful only
	as a shorthand and [HttpService.RequestAsync] should to be used in most
	cases.

	```lua
	HttpPromise.PromisePost("http://httpbin.org/post", "{\"hello\":\"world\"}", Enum.HttpContentType.ApplicationJson, false):andThen(print, warn)
	```

	@function PromisePost
	@within HttpPromise

	@param url string -- The destination address for the data.
	@param data unknown -- The data being sent.
	@param httpContentType? Enum.HttpContentType -- Modifies the value in the Content-Type header sent with the request.
	@param compress? boolean -- Determines whether the data is compressed (gzipped) when sent.
	@param headers? HttpHeaders -- Used to specify some HTTP request headers.
	@return Promise<string>
]=]
local function Post(
	url: string,
	data: string,
	httpContentType: Enum.HttpContentType?,
	compress: boolean?,
	headers: HttpHeaders?
): string
	local trueHeaders: HttpHeaders = headers or {}
	trueHeaders["Content-Type"] = TO_HEADER[httpContentType or Enum.HttpContentType.ApplicationJson]

	local response = PromiseUtilities.Await(PromiseRequest({
		Body = data;
		Compress = if compress then Enum.HttpCompression.Gzip else nil;
		Headers = trueHeaders;
		Method = "POST";
		Url = url;
	}))

	return response.Body
end
HttpPromise.PromisePost = PromiseUtilities.FastAsync(Post) :: (
	url: string,
	data: string,
	httpContentType: Enum.HttpContentType?,
	compress: boolean?,
	headers: HttpHeaders?
) -> Promise<string>

local function PromiseEncode(format: serde.EncodeDecodeFormat, data: unknown, pretty: boolean?): Promise<string>
	return Promise.new(function(resolve, reject)
		local success, value = pcall(serde.encode, format, data, pretty)
		if success then
			resolve(value)
		else
			reject(value)
		end
	end)
end
HttpPromise.PromiseEncode = PromiseEncode

--[=[
	Returns a Promise that calls [HttpService.JSONDecode].
	@param jsonString string -- The JSON string to decode.
	@return Promise<T>
]=]
function HttpPromise.PromiseDecodeUntyped<T>(jsonString: string): Promise<T>
	return Promise.new(function(resolve, reject)
		local success, value = pcall(serde.decode, "json" :: "json", jsonString)
		if success then
			resolve(value)
		else
			reject(value)
		end
	end)
end

--[=[
	Returns a Promise that calls [HttpService.JSONEncode].
	@param data unknown -- The data to encode.
	@param pretty? boolean -- Whether the encoded string should be human-readable.
	@return Promise<string>
]=]
function HttpPromise.PromiseJson(data: unknown, pretty: boolean?): Promise<string>
	return PromiseEncode("json", data, pretty)
end

local IsString = GreenTea.build(GreenTea.string())

function HttpPromise.PromiseDecode<T>(input: string, greenTeaType: T): Promise<T>
	local typeChecker = GreenTea.build(greenTeaType)
	GreenTeaAssert(IsString, input, HttpPromise.PromiseDecode, TypeError)

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

	GreenTeaAssert(IsString, input, HttpPromise.PromiseDecodeCached, TypeError)

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

return table.freeze(HttpPromise)
