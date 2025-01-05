--!optimize 2
--!strict

local cached: boolean = nil

local function IsDeferred(): boolean
	if cached ~= nil then
		return cached
	end

	local success, value = pcall(function(): boolean
		return game:GetService("Workspace").SignalBehavior.Name == "Deferred"
	end)

	if not success then
		cached = false
		return cached
	end

	cached = not not value
	return cached
end

return IsDeferred
