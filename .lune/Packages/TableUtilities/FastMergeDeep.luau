--!optimize 2
--!strict

local CopyDeep = require("./CopyDeep")

--[=[
	Merges the given dictionaries into a single dictionary. This is recursive.
	The parameters may be any number of dictionaries or `nil`. Non-dictionaries
	will be ignored. Uses if branches to avoid iteration as much as possible.

	@function FastMergeDeep
	@within TableUtilities

	@since v1.2.0

	@param ... ...{[unknown]: unknown} -- The tables to merge.
	@return T -- The merged table.
]=]
local function FastMergeDeep<T>(...: any): T
	local length = select("#", ...)
	if length == 0 then
		return {} :: never
	end

	if length == 1 then
		local dictionary0 = ...
		return (if dictionary0 then CopyDeep(dictionary0) else {}) :: never
	end

	if length == 2 then
		local dictionary0, dictionary1 = ...

		local result = (if dictionary0 then CopyDeep(dictionary0) else {}) :: never
		if dictionary1 and type(dictionary1) == "table" then
			for key, value in pairs(dictionary1) do
				if type(value) == "table" then
					if result[key] == nil or type(result[key]) ~= "table" then
						result[key] = CopyDeep(value)
					else
						result[key] = FastMergeDeep(result[key], value)
					end
				else
					result[key] = value
				end
			end
		end

		return result
	end

	if length == 3 then
		local dictionary0, dictionary1, dictionary2 = ...

		local result = (if dictionary0 then CopyDeep(dictionary0) else {}) :: never
		if dictionary1 and type(dictionary1) == "table" then
			for key, value in pairs(dictionary1) do
				if type(value) == "table" then
					if result[key] == nil or type(result[key]) ~= "table" then
						result[key] = CopyDeep(value)
					else
						result[key] = FastMergeDeep(result[key], value)
					end
				else
					result[key] = value
				end
			end
		end
		if dictionary2 and type(dictionary2) == "table" then
			for key, value in pairs(dictionary2) do
				if type(value) == "table" then
					if result[key] == nil or type(result[key]) ~= "table" then
						result[key] = CopyDeep(value)
					else
						result[key] = FastMergeDeep(result[key], value)
					end
				else
					result[key] = value
				end
			end
		end

		return result
	end

	local result = {}
	for index = 1, length do
		local dictionary = select(index, ...)
		if not dictionary or type(dictionary) ~= "table" then
			continue
		end

		for key, value in pairs(dictionary) do
			if type(value) == "table" then
				if result[key] == nil or type(result[key]) ~= "table" then
					result[key] = CopyDeep(value)
				else
					result[key] = FastMergeDeep(result[key], value)
				end
			else
				result[key] = value
			end
		end
	end

	return result :: never
end

return FastMergeDeep
