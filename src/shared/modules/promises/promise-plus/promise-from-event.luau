--!nonstrict
--!optimize 2

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TS = require(ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Promise = TS.Promise

local function Pack(...)
	return {...}
end

local function disconnectIt(connection)
	if type(connection) == "function" then
		connection()
	elseif type(connection) == "table" then
		if type(connection.Disconnect) == "function" then
			connection:Disconnect()
		elseif type(connection.disconnect) == "function" then
			connection:disconnect()
		end
	elseif typeof(connection) == "RBXScriptConnection" then
		connection:Disconnect()
	end
end

local BASIC_CONNECTION = {
	Disconnect = function() end;
}

local function connectIt(event, callback)
	local pascalConnect = event.Connect
	if pascalConnect then
		assert(type(pascalConnect) == "function", "not a function")
		return pascalConnect(event, callback)
	end

	local camelConnect = event.connect
	if camelConnect then
		assert(type(camelConnect) == "function", "not a function")
		return camelConnect(event, callback)
	end

	return BASIC_CONNECTION
end

local function fromEvent(event, predicate)
	predicate = predicate or function()
		return true
	end

	return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)
		local connection
		local shouldDisconnect = false

		local function disconnect()
			disconnectIt(connection)
			connection = nil
		end

		-- We use shouldDisconnect because if the callback given to Connect is called before
		-- Connect returns, connection will still be nil. This happens with events that queue up
		-- events when there's nothing connected, such as RemoteEvents

		connection = connectIt(event, function(...)
			local callbackValue = predicate(...)

			if callbackValue == true then
				resolve(...)

				if connection then
					disconnect()
				else
					shouldDisconnect = true
				end
			elseif type(callbackValue) ~= "boolean" then
				error("Promise.fromEvent predicate should always return a boolean")
			end
		end)

		if shouldDisconnect and connection then
			disconnect()
			return
		end

		onCancel(disconnect)
	end)
end

return function(...)
	return fromEvent(...):andThen(Pack)
end
