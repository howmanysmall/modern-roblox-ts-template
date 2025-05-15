--!optimize 2
--!strict

--[=[
	Checks if the given value as an array.

	@function IsArray
	@within TableUtilities

	@param value unknown -- The value to check.
	@return boolean -- Whether the value is an array.
]=]
local function IsArray(value: any): boolean
	if type(value) ~= "table" then
		return false
	end

	if next(value) == nil then
		return true
	end

	if #value == 0 then
		return false
	end

	local count = 0
	-- can't use generalized iteration because of __call
	local sum = 0
	for key in pairs(value) do
		if type(key) ~= "number" or key % 1 ~= 0 or key ~= key or key < 1 then
			return false
		end

		count += 1
		sum += key
	end

	return sum == count * (count + 1) / 2
end

return IsArray
