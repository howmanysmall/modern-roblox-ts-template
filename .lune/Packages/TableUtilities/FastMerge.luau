--!optimize 2
--!strict

--[=[
	A fast merge function that doesn't support a `None` value. Uses if branches
	to avoid iteration. Does NOT do any type validation, be aware of what you
	pass to it.

	@function FastMerge
	@within TableUtilities

	@param ... ...{[unknown]: unknown} -- The tables to merge.
	@return T -- The merged table.
]=]
local function FastMerge<T>(...: any): T
	local length = select("#", ...)
	if length == 0 then
		return {} :: never
	end

	if length == 1 then
		local dictionary0 = ...
		return (if dictionary0 then table.clone(dictionary0) else {}) :: never
	end

	if length == 2 then
		local dictionary0, dictionary1 = ...

		local result = (if dictionary0 then table.clone(dictionary0) else {}) :: never
		if dictionary1 then
			for key, value in pairs(dictionary1) do
				result[key] = value
			end
		end

		return result
	end

	if length == 3 then
		local dictionary0, dictionary1, dictionary2 = ...

		local result = (if dictionary0 then table.clone(dictionary0) else {}) :: never
		if dictionary1 then
			for key, value in pairs(dictionary1) do
				result[key] = value
			end
		end
		if dictionary2 then
			for key, value in pairs(dictionary2) do
				result[key] = value
			end
		end

		return result
	end

	if length == 4 then
		local dictionary0, dictionary1, dictionary2, dictionary3 = ...

		local result = (if dictionary0 then table.clone(dictionary0) else {}) :: never
		if dictionary1 then
			for key, value in pairs(dictionary1) do
				result[key] = value
			end
		end
		if dictionary2 then
			for key, value in pairs(dictionary2) do
				result[key] = value
			end
		end
		if dictionary3 then
			for key, value in pairs(dictionary3) do
				result[key] = value
			end
		end

		return result
	end

	local result = {}
	for dictionaryIndex = 1, length do
		local dictionary = select(dictionaryIndex, ...)
		if dictionary ~= nil then
			for key, value in pairs(dictionary) do
				result[key] = value
			end
		end
	end

	return result :: never
end

return FastMerge
