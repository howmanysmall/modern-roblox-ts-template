--!optimize 2
--!strict
-- https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/toExponential

return function(value: number | string, fractionDigits: number?): string?
	local num = value
	if type(value) == "string" then
		-- ROBLOX FIXME: add parseInt to encapsulate this logic and use it here
		local NaN = 0 / 0
		num = tonumber(value) or NaN -- works because 0 is truthy in Lua
	end

	-- returns nil for invalid input instead of nan to be more lua-native
	if type(num) ~= "number" then
		return "nan"
	end

	if fractionDigits ~= nil then
		if type(fractionDigits) ~= "number" then
			error("TypeError: fractionDigits must be a number between 0 and 100")
		end

		if fractionDigits < 0 or fractionDigits > 100 then
			error("RangeError: fractionDigits must be between 0 and 100")
		end
	end

	local formatString = if fractionDigits == nil then "%e" else `%.{fractionDigits}e`
	return (string.gsub(string.gsub(string.gsub(string.format(formatString, num), "%+0", "+"), "%-0", "-"), "0*e", "e"))
end
