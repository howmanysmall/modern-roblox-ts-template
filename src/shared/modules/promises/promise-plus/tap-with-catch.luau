--!nonstrict
--!optimize 2

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TS = require(ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Promise = TS.Promise

local ERROR_NON_FUNCTION = "Please pass a handler function to %*!"

local function isCallable(value)
	if type(value) == "function" then
		return true
	end

	if type(value) == "table" then
		local metatable = getmetatable(value)
		if metatable and type(rawget(metatable, "__call")) == "function" then
			return true
		end
	end

	return false
end

local function createTapper(callback, isError)
	return if isError
		then function(...)
			local callbackReturn = callback(...)

			if Promise.is(callbackReturn) then
				local values = table.pack(...)
				return callbackReturn:andThen(function()
					return Promise.reject(table.unpack(values, 1, values.n))
				end)
			end

			return Promise.reject(...)
		end
		else function(...)
			local callbackReturn = callback(...)

			if Promise.is(callbackReturn) then
				local values = table.pack(...)
				return callbackReturn:andThen(function()
					return table.unpack(values, 1, values.n)
				end)
			end

			return ...
		end
end

local function tapWithCatch(self, tapCallback, tapCatch)
	assert(isCallable(tapCallback), string.format(ERROR_NON_FUNCTION, "tapWithCatch"))
	assert(tapCatch == nil or isCallable(tapCatch), string.format(ERROR_NON_FUNCTION, "tapWithCatch"))
	tapCallback = createTapper(tapCallback, false)

	if tapCatch then
		return self:_andThen(debug.traceback(nil :: any, 2), tapCallback, createTapper(tapCatch, true))
	end

	return self:_andThen(debug.traceback(nil :: any, 2), tapCallback)
end

return tapWithCatch
