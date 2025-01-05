--[[
	DataStoreService.lua
	This module decides whether to use actual datastores or mock datastores depending on the environment.

	This module is licensed under APLv2, refer to the LICENSE file or:
	https://github.com/buildthomas/MockDataStoreService/blob/master/LICENSE
]]

local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local MockDataStoreServiceModule = script:WaitForChild("MockDataStoreService")

local shouldUseMock = false
if game.GameId == 0 then -- Local place file
	shouldUseMock = true
elseif RunService:IsStudio() then -- Published file in Studio
	local status, message = pcall(function()
		-- This will error if current instance has no Studio API access:
		DataStoreService:GetDataStore("__TEST"):SetAsync("__TEST", "__TEST_" .. os.time())
	end)

	if not status and string.find(message, "403", 1, true) then -- HACK
		-- Can connect to datastores, but no API access
		shouldUseMock = true
	end
end

local Result: DataStoreService
if shouldUseMock then
	warn("INFO: Using MockDataStoreService instead of DataStoreService")
	Result = require(MockDataStoreServiceModule) :: DataStoreService
else
	Result = DataStoreService
end

-- Return the mock or actual service depending on environment:
return Result
