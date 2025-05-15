--!optimize 2
--!strict

local RaycastParams = {}
RaycastParams.__index = RaycastParams
RaycastParams.__type = "RaycastParams"

function RaycastParams.new()
	return setmetatable({}, RaycastParams)
end

return table.freeze(RaycastParams)
