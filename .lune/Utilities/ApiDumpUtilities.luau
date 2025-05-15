--!optimize 2
--!strict

local GreenTea = require("@packages/GreenTea")
local HttpPromise = require("@promises/HttpPromise")
local PromiseUtilities = require("@packages/PromiseUtilities")

local Await = PromiseUtilities.Await

local ApiDumpUtilities = {}
local IsValidApiDumpRaw = {
	Enums = GreenTea.array({
		Items = GreenTea.array({
			Name = GreenTea.string();
			Value = GreenTea.number({integer = true});
		});
		Name = GreenTea.string();
	});
	Version = GreenTea.number({integer = true});
}

export type ApiDump = typeof(IsValidApiDumpRaw)
ApiDumpUtilities.IsValidApiDumpRaw = IsValidApiDumpRaw

local dumpCache: ApiDump? = nil

local function GetEnumsFromDump(): ApiDump
	if dumpCache then
		return dumpCache
	end

	local apiDumpString = Await(
		HttpPromise.PromiseGet(
			"https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/refs/heads/roblox/API-Dump.json",
			true
		)
	)

	local apiDump = Await(HttpPromise.PromiseDecodeCached(apiDumpString, IsValidApiDumpRaw))
	dumpCache = apiDump
	return apiDump
end
ApiDumpUtilities.GetEnumsFromDumpAsync = PromiseUtilities.FastAsync(GetEnumsFromDump)

return table.freeze(ApiDumpUtilities)
