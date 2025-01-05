--!optimize 2
--!strict

local StringUtilities = {}

function StringUtilities.ToPascalCase(value: string): string
	return (
		string.gsub(
			string.gsub(string.gsub(string.lower(value), "[ _-](%a)", string.upper), "^%a", string.upper),
			"%p",
			""
		)
	)
end

function StringUtilities.GetNumberFromString(value: nil | number | string, defaultValue: number?): number
	local trueDefaultValue: number = if defaultValue then defaultValue else 0

	if value == nil or type(value) ~= "string" then
		return if value ~= nil and type(value) == "number" then value else trueDefaultValue
	end

	local number = tonumber(value)
	if number then
		return number
	end

	local match = string.match(value, "%-?%d+%.?%d*")
	return if match then tonumber(match) or trueDefaultValue else trueDefaultValue
end

return table.freeze(StringUtilities)
