--!optimize 2
--!strict

type Metatable = {
	__eq: (self: PolyfillNumberRange, other: PolyfillNumberRange) -> boolean,
	__tostring: (self: PolyfillNumberRange) -> string,
	__type: "NumberRange",
}
export type PolyfillNumberRange = typeof(setmetatable({} :: {Max: number, Min: number}, {} :: Metatable))
type Static = {new: ((value: number) -> PolyfillNumberRange) & ((min: number, max: number) -> PolyfillNumberRange)}

local metatable = {} :: Metatable

do
	local function GetFloat(number: number): string
		local asString = tostring(number)
		if tonumber(asString) == number then
			return asString
		end

		for index = 15, 99 do
			asString = string.format("%." .. index .. "f", number)
			if tonumber(asString) == number then
				return asString
			end
		end

		error(`Couldn't convert {number} to a float?`, 2)
	end
	local function FormatNumber(number: number | string): string
		local trueNumber = tonumber(number) or 0
		return if trueNumber ~= trueNumber
			then "0 / 0"
			elseif trueNumber % 1 == 0 then string.format("%d", trueNumber)
			else GetFloat(trueNumber)
	end

	function metatable:__eq(other: PolyfillNumberRange): boolean
		return self.Min == other.Min and self.Max == other.Max
	end
	function metatable:__tostring(): string
		return string.format("%* %*", FormatNumber(self.Min), FormatNumber(self.Max))
	end
	metatable.__type = "NumberRange"
end

local NumberRange = {} :: Static

function NumberRange.new(minimum: number, maximum: number?): PolyfillNumberRange
	return setmetatable({Min = minimum, Max = maximum or minimum}, metatable)
end

return table.freeze(NumberRange)
