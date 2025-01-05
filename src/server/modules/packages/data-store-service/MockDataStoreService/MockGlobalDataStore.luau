--[[
	MockGlobalDataStore.lua
	This module implements the API and functionality of Roblox's GlobalDataStore class.

	This module is licensed under APLv2, refer to the LICENSE file or:
	https://github.com/buildthomas/MockDataStoreService/blob/master/LICENSE
]]

local HttpService = game:GetService("HttpService") -- for json encode/decode
local Constants = require(script.Parent.MockDataStoreConstants)
local MockDataStoreManager = require(script.Parent.MockDataStoreManager)
local Utils = require(script.Parent.MockDataStoreUtils)

local MockGlobalDataStore = {}
MockGlobalDataStore.__index = MockGlobalDataStore

local rand = Random.new()

function MockGlobalDataStore:OnUpdate(key, callback)
	key = Utils.preprocessKey(key)
	if type(key) ~= "string" then
		error(string.format("bad argument #1 to 'OnUpdate' (string expected, got %s)", typeof(key)), 2)
	elseif type(callback) ~= "function" then
		error(string.format("bad argument #2 to 'OnUpdate' (function expected, got %s)", typeof(callback)), 2)
	elseif #key == 0 then
		error("bad argument #1 to 'OnUpdate' (key name can't be empty)", 2)
	elseif #key > Constants.MAX_LENGTH_KEY then
		error(
			string.format(
				"bad argument #1 to 'OnUpdate' (key name exceeds %d character limit)",
				Constants.MAX_LENGTH_KEY
			),
			2
		)
	end

	Utils.simulateErrorCheck("OnUpdate")
	local success = MockDataStoreManager.YieldForBudget(function()
		warn(
			string.format(
				"OnUpdate request was throttled due to lack of budget. Try sending fewer requests. Key = %s",
				key
			)
		)
	end, table.create(1, Enum.DataStoreRequestType.OnUpdate))

	if not success then
		error("OnUpdate rejected with error (request was throttled, but throttled queue was full)", 2)
	end

	Utils.logMethod(self, "OnUpdate", key)
	return self.__event.Event:Connect(function(k, v)
		if k == key then
			if Constants.YIELD_TIME_UPDATE_MAX > 0 then
				Utils.accurateWait(rand:NextNumber(Constants.YIELD_TIME_UPDATE_MIN, Constants.YIELD_TIME_UPDATE_MAX))
			end

			callback(v) -- v was implicitly deep-copied
		end
	end)
end

function MockGlobalDataStore:GetAsync(key)
	key = Utils.preprocessKey(key)
	if type(key) ~= "string" then
		error(string.format("bad argument #1 to 'GetAsync' (string expected, got %s)", typeof(key)), 2)
	elseif #key == 0 then
		error("bad argument #1 to 'GetAsync' (key name can't be empty)", 2)
	elseif #key > Constants.MAX_LENGTH_KEY then
		error(
			string.format(
				"bad argument #1 to 'GetAsync' (key name exceeds %d character limit)",
				Constants.MAX_LENGTH_KEY
			),
			2
		)
	end

	if self.__getCache[key] and tick() - self.__getCache[key] < Constants.GET_COOLDOWN then
		return Utils.deepcopy(self.__data[key])
	end

	Utils.simulateErrorCheck("GetAsync")
	local success = MockDataStoreManager.YieldForBudget(function()
		warn(
			string.format(
				"GetAsync request was throttled due to lack of budget. Try sending fewer requests. Key = %s",
				key
			)
		)
	end, table.create(1, Enum.DataStoreRequestType.GetAsync))

	if not success then
		error("GetAsync rejected with error (request was throttled, but throttled queue was full)", 2)
	end

	self.__getCache[key] = tick()
	local retValue = Utils.deepcopy(self.__data[key])
	Utils.simulateYield()
	Utils.logMethod(self, "GetAsync", key)
	return retValue
end

function MockGlobalDataStore:IncrementAsync(key, delta)
	key = Utils.preprocessKey(key)
	if type(key) ~= "string" then
		error(string.format("bad argument #1 to 'IncrementAsync' (string expected, got %s)", typeof(key)), 2)
	elseif delta ~= nil and type(delta) ~= "number" then
		error(string.format("bad argument #2 to 'IncrementAsync' (number expected, got %s)", typeof(delta)), 2)
	elseif #key == 0 then
		error("bad argument #1 to 'IncrementAsync' (key name can't be empty)", 2)
	elseif #key > Constants.MAX_LENGTH_KEY then
		error(
			string.format(
				"bad argument #1 to 'IncrementAsync' (key name exceeds %d character limit)",
				Constants.MAX_LENGTH_KEY
			),
			2
		)
	end

	Utils.simulateErrorCheck("IncrementAsync")
	local success
	if self.__writeLock[key] or tick() - (self.__writeCache[key] or 0) < Constants.WRITE_COOLDOWN then
		success = MockDataStoreManager.YieldForWriteLockAndBudget(function()
			warn(
				string.format(
					"IncrementAsync request was throttled, a key can only be written to once every %d seconds. Key = %s",
					Constants.WRITE_COOLDOWN,
					key
				)
			)
		end, key, self.__writeLock, self.__writeCache, table.create(1, Enum.DataStoreRequestType.SetIncrementAsync))
	else
		self.__writeLock[key] = true
		success = MockDataStoreManager.YieldForBudget(function()
			warn(
				string.format(
					"IncrementAsync request was throttled due to lack of budget. Try sending fewer requests. Key = %s",
					key
				)
			)
		end, table.create(1, Enum.DataStoreRequestType.SetIncrementAsync))

		self.__writeLock[key] = nil
	end

	if not success then
		error("IncrementAsync rejected with error (request was throttled, but throttled queue was full)", 2)
	end

	local old = self.__data[key]
	if old ~= nil and (type(old) ~= "number" or old % 1 ~= 0) then
		Utils.simulateYield()
		error("IncrementAsync rejected with error (cannot increment non-integer value)", 2)
	end

	self.__writeLock[key] = true
	delta = delta and math.floor(delta + 0.5) or 1
	self.__data[key] = (old or 0) + delta
	if old == nil or delta ~= 0 then
		self.__event:Fire(key, self.__data[key])
	end

	local retValue = self.__data[key]
	Utils.simulateYield()

	self.__writeLock[key] = nil
	self.__writeCache[key] = tick()
	self.__getCache[key] = tick()

	Utils.logMethod(self, "IncrementAsync", key, retValue, delta)
	return retValue
end

function MockGlobalDataStore:RemoveAsync(key)
	key = Utils.preprocessKey(key)
	if type(key) ~= "string" then
		error(string.format("bad argument #1 to 'RemoveAsync' (string expected, got %s)", typeof(key)), 2)
	elseif #key == 0 then
		error("bad argument #1 to 'RemoveAsync' (key name can't be empty)", 2)
	elseif #key > Constants.MAX_LENGTH_KEY then
		error(
			string.format(
				"bad argument #1 to 'RemoveAsync' (key name exceeds %d character limit)",
				Constants.MAX_LENGTH_KEY
			),
			2
		)
	end

	Utils.simulateErrorCheck("RemoveAsync")
	local success
	if self.__writeLock[key] or tick() - (self.__writeCache[key] or 0) < Constants.WRITE_COOLDOWN then
		success = MockDataStoreManager.YieldForWriteLockAndBudget(function()
			warn(
				string.format(
					"RemoveAsync request was throttled, a key can only be written to once every %d seconds. Key = %s",
					Constants.WRITE_COOLDOWN,
					key
				)
			)
		end, key, self.__writeLock, self.__writeCache, table.create(1, Enum.DataStoreRequestType.SetIncrementAsync))
	else
		self.__writeLock[key] = true
		success = MockDataStoreManager.YieldForBudget(function()
			warn(
				string.format(
					"RemoveAsync request was throttled due to lack of budget. Try sending fewer requests. Key = %s",
					key
				)
			)
		end, table.create(1, Enum.DataStoreRequestType.SetIncrementAsync))

		self.__writeLock[key] = nil
	end

	if not success then
		error("RemoveAsync rejected with error (request was throttled, but throttled queue was full)", 2)
	end

	self.__writeLock[key] = true
	local value = Utils.deepcopy(self.__data[key])
	self.__data[key] = nil
	if value ~= nil then
		self.__event:Fire(key, nil)
	end

	Utils.simulateYield()
	self.__writeLock[key] = nil
	self.__writeCache[key] = tick()

	Utils.logMethod(self, "RemoveAsync", key, value)
	return value
end

local function JsonEncode(Data)
	return HttpService:JSONEncode(Data)
end

local function JsonDecode(JsonString)
	return HttpService:JSONDecode(JsonString)
end

function MockGlobalDataStore:SetAsync(key, value)
	key = Utils.preprocessKey(key)
	if type(key) ~= "string" then
		error(string.format("bad argument #1 to 'SetAsync' (string expected, got %s)", typeof(key)), 2)
	elseif #key == 0 then
		error("bad argument #1 to 'SetAsync' (key name can't be empty)", 2)
	elseif #key > Constants.MAX_LENGTH_KEY then
		error(
			string.format(
				"bad argument #1 to 'SetAsync' (key name exceeds %d character limit)",
				Constants.MAX_LENGTH_KEY
			),
			2
		)
	elseif value == nil or type(value) == "function" or type(value) == "userdata" or type(value) == "thread" then
		error(
			string.format(
				"bad argument #2 to 'SetAsync' (cannot store value '%s' of type %s)",
				tostring(value),
				typeof(value)
			),
			2
		)
	end

	if type(value) == "table" then
		local isValid, keyPath, reason = Utils.scanValidity(value)
		if not isValid then
			error(
				string.format(
					"bad argument #2 to 'SetAsync' (table has invalid entry at <%s>: %s)",
					Utils.getStringPath(keyPath),
					reason
				),
				2
			)
		end

		local pass, content = pcall(JsonEncode, value)
		if not pass then
			error("bad argument #2 to 'SetAsync' (table could not be encoded to json)", 2)
		elseif #content > Constants.MAX_LENGTH_DATA then
			error(
				string.format(
					"bad argument #2 to 'SetAsync' (encoded data length exceeds %d character limit)",
					Constants.MAX_LENGTH_DATA
				),
				2
			)
		end
	elseif type(value) == "string" then
		if #value > Constants.MAX_LENGTH_DATA then
			error(
				string.format(
					"bad argument #2 to 'SetAsync' (data length exceeds %d character limit)",
					Constants.MAX_LENGTH_DATA
				),
				2
			)
		elseif not utf8.len(value) then
			error("bad argument #2 to 'SetAsync' (string value is not valid UTF-8)", 2)
		end
	end

	Utils.simulateErrorCheck("SetAsync")
	local success
	if self.__writeLock[key] or tick() - (self.__writeCache[key] or 0) < Constants.WRITE_COOLDOWN then
		success = MockDataStoreManager.YieldForWriteLockAndBudget(function()
			warn(
				string.format(
					"SetAsync request was throttled, a key can only be written to once every %d seconds. Key = %s",
					Constants.WRITE_COOLDOWN,
					key
				)
			)
		end, key, self.__writeLock, self.__writeCache, table.create(1, Enum.DataStoreRequestType.SetIncrementAsync))
	else
		self.__writeLock[key] = true
		success = MockDataStoreManager.YieldForBudget(function()
			warn(
				string.format(
					"SetAsync request was throttled due to lack of budget. Try sending fewer requests. Key = %s",
					key
				)
			)
		end, table.create(1, Enum.DataStoreRequestType.SetIncrementAsync))

		self.__writeLock[key] = nil
	end

	if not success then
		error("SetAsync rejected with error (request was throttled, but throttled queue was full)", 2)
	end

	self.__writeLock[key] = true
	if type(value) == "table" or value ~= self.__data[key] then
		self.__data[key] = Utils.deepcopy(value)
		self.__event:Fire(key, self.__data[key])
	end

	Utils.simulateYield()
	self.__writeLock[key] = nil
	self.__writeCache[key] = tick()
	Utils.logMethod(self, "SetAsync", key, self.__data[key])
end

function MockGlobalDataStore:UpdateAsync(key, transformFunction)
	key = Utils.preprocessKey(key)
	if type(key) ~= "string" then
		error(string.format("bad argument #1 to 'UpdateAsync' (string expected, got %s)", typeof(key)), 2)
	elseif type(transformFunction) ~= "function" then
		error(
			string.format("bad argument #2 to 'UpdateAsync' (function expected, got %s)", typeof(transformFunction)),
			2
		)
	elseif #key == 0 then
		error("bad argument #1 to 'UpdateAsync' (key name can't be empty)", 2)
	elseif #key > Constants.MAX_LENGTH_KEY then
		error(
			string.format(
				"bad argument #1 to 'UpdateAsync' (key name exceeds %d character limit)",
				Constants.MAX_LENGTH_KEY
			),
			2
		)
	end

	Utils.simulateErrorCheck("UpdateAsync")
	local success
	if self.__writeLock[key] or tick() - (self.__writeCache[key] or 0) < Constants.WRITE_COOLDOWN then
		success = MockDataStoreManager.YieldForWriteLockAndBudget(function()
			warn(
				string.format(
					"UpdateAsync request was throttled, a key can only be written to once every %d seconds. Key = %s",
					Constants.WRITE_COOLDOWN,
					key
				)
			)
		end, key, self.__writeLock, self.__writeCache, table.create(1, Enum.DataStoreRequestType.SetIncrementAsync))
	else
		self.__writeLock[key] = true
		local budget
		if self.__getCache[key] and tick() - self.__getCache[key] < Constants.GET_COOLDOWN then
			budget = table.create(1, Enum.DataStoreRequestType.SetIncrementAsync)
		else
			budget = {Enum.DataStoreRequestType.GetAsync, Enum.DataStoreRequestType.SetIncrementAsync}
		end

		success = MockDataStoreManager.YieldForBudget(function()
			warn(
				string.format(
					"UpdateAsync request was throttled due to lack of budget. Try sending fewer requests. Key = %s",
					key
				)
			)
		end, budget)

		self.__writeLock[key] = nil
	end

	if not success then
		error("UpdateAsync rejected with error (request was throttled, but throttled queue was full)", 2)
	end

	local value = transformFunction(Utils.deepcopy(self.__data[key]))
	if value == nil then -- cancel update after remote call
		Utils.simulateYield()
		return nil -- this is what datastores do even though it should be old value
	end

	if type(value) == "function" or type(value) == "userdata" or type(value) == "thread" then
		error(
			string.format(
				"UpdateAsync rejected with error (resulting value '%s' is of type %s that cannot be stored)",
				tostring(value),
				typeof(value)
			),
			2
		)
	end

	if type(value) == "table" then
		local isValid, keyPath, reason = Utils.scanValidity(value)
		if not isValid then
			error(
				string.format(
					"UpdateAsync rejected with error (resulting table has invalid entry at <%s>: %s)",
					Utils.getStringPath(keyPath),
					reason
				),
				2
			)
		end

		local pass, content = pcall(JsonEncode, value)
		if not pass then
			error("UpdateAsync rejected with error (resulting table could not be encoded to json)", 2)
		elseif #content > Constants.MAX_LENGTH_DATA then
			error(
				string.format(
					"UpdateAsync rejected with error (resulting encoded data length exceeds %d character limit)",
					Constants.MAX_LENGTH_DATA
				),
				2
			)
		end
	elseif type(value) == "string" then
		if #value > Constants.MAX_LENGTH_DATA then
			error(
				string.format(
					"UpdateAsync rejected with error (resulting data length exceeds %d character limit)",
					Constants.MAX_LENGTH_DATA
				),
				2
			)
		elseif not utf8.len(value) then
			error("UpdateAsync rejected with error (string value is not valid UTF-8)", 2)
		end
	end

	self.__writeLock[key] = true
	if type(value) == "table" or value ~= self.__data[key] then
		self.__data[key] = Utils.deepcopy(value)
		self.__event:Fire(key, self.__data[key])
	end

	local retValue = Utils.deepcopy(value)
	self.__writeLock[key] = nil
	self.__writeCache[key] = tick()
	self.__getCache[key] = tick()
	Utils.logMethod(self, "UpdateAsync", key, retValue)
	return retValue
end

function MockGlobalDataStore:ExportToJSON()
	return HttpService:JSONEncode(self.__data)
end

function MockGlobalDataStore:ImportFromJSON(json, verbose)
	local content
	if type(json) == "string" then
		local parsed, value = pcall(JsonDecode, json)
		if not parsed then
			error("bad argument #1 to 'ImportFromJSON' (string is not valid json)", 2)
		end

		content = value
	elseif type(json) == "table" then
		content = Utils.deepcopy(json)
	else
		error(string.format("bad argument #1 to 'ImportFromJSON' (string or table expected, got %s)", typeof(json)), 2)
	end

	if verbose ~= nil and type(verbose) ~= "boolean" then
		error(string.format("bad argument #2 to 'ImportFromJSON' (boolean expected, got %s)", typeof(verbose)), 2)
	end

	Utils.importPairsFromTable(
		content,
		self.__data,
		MockDataStoreManager.GetDataInterface(self.__data),
		(verbose == false and function() end or warn),
		"ImportFromJSON",
		(
			(type(self.__name) == "string" and type(self.__scope) == "string")
				and string.format("DataStore > %s > %s", self.__name, self.__scope)
			or "GlobalDataStore"
		),
		false
	)
end

return MockGlobalDataStore
