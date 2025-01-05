--!optimize 2
--!strict

local Color3 = require("@contexts/Color3")
local LuauPolyfill = require("@packages/LuauPolyfill")
local TypeOf = require("@packages/TypeOf")

local Colors = require("./Colors")

local Error = LuauPolyfill.Error

local ColorData = Colors.ColorData
local SortedByName = Colors.SortedByName
local SortedByNumber = Colors.SortedByNumber

export type Color3 = Color3.PolyfillColor3
export type PolyfillBrickColor = typeof(setmetatable(
	{} :: {
		Color: Color3,
		Name: string,
		Number: number,

		r: number,
		g: number,
		b: number,
	},
	{} :: {
		__eq: (self: PolyfillBrickColor, other: PolyfillBrickColor) -> boolean,
		__tostring: (self: PolyfillBrickColor) -> string,
	}
))
type Static = {
	new: ((number: number) -> PolyfillBrickColor)
		& ((red: number, green: number, blue: number?) -> PolyfillBrickColor)
		& ((name: string) -> PolyfillBrickColor)
		& ((color: Color3) -> PolyfillBrickColor),
	random: () -> PolyfillBrickColor,
	palette: (number: number) -> PolyfillBrickColor,

	White: () -> PolyfillBrickColor,
	Gray: () -> PolyfillBrickColor,
	DarkGray: () -> PolyfillBrickColor,
	Black: () -> PolyfillBrickColor,
	Red: () -> PolyfillBrickColor,
	Yellow: () -> PolyfillBrickColor,
	Green: () -> PolyfillBrickColor,
	Blue: () -> PolyfillBrickColor,
}
type PrivateStatic = Static & {
	__eq: (self: PolyfillBrickColor, other: PolyfillBrickColor) -> boolean,
	__tostring: (self: PolyfillBrickColor) -> string,
}

local BrickColor = {} :: PolyfillBrickColor & Static
local Private = BrickColor :: PolyfillBrickColor & PrivateStatic;
(BrickColor :: any).__index = BrickColor;
(BrickColor :: any).ClassName = "BrickColor"

local function ToBrickColor(colorData: Colors.ColorData): PolyfillBrickColor
	local color3 = colorData.Color3
	return setmetatable({
		Color = color3;
		Name = colorData.Name;
		Number = colorData.Number;

		r = color3.R / 255;
		g = color3.G / 255;
		b = color3.B / 255;
	}, BrickColor) :: never
end
local function EqualNumbers(a: Colors.ColorData, b: Colors.ColorData): boolean
	return a.Number == b.Number
end
local function EqualNames(a: Colors.ColorData, b: Colors.ColorData): boolean
	return a.Name == b.Name
end

local MEDIUM_STONE_GREY: PolyfillBrickColor = nil
local function Difference(a: Colors.ColorData, red: number, green: number, blue: number): number
	local colorA = a.Color3
	return math.abs(colorA.R - red) + math.abs(colorA.G - green) + math.abs(colorA.B - blue)
end

function BrickColor.new(...)
	local sizeOf = select("#", ...)
	if sizeOf == 2 or sizeOf == 3 then
		local red, green, maybeBlue = ...
		local blue = maybeBlue or 0

		local bestEntry: Colors.ColorData? = nil
		local bestScore = math.huge

		for _, colorData in ColorData do
			local difference = Difference(colorData, red, green, blue)
			if difference < bestScore then
				bestScore = difference
				bestEntry = colorData
			end
		end

		if not bestEntry then
			if not MEDIUM_STONE_GREY then
				MEDIUM_STONE_GREY = BrickColor.new("Medium stone grey")
			end
			return MEDIUM_STONE_GREY
		end

		return ToBrickColor(bestEntry)
	end

	local value = ...
	if type(value) == "number" then
		local index = SortedByNumber:Find({Number = value} :: never, EqualNumbers)
		if not index then
			if not MEDIUM_STONE_GREY then
				MEDIUM_STONE_GREY = BrickColor.new("Medium stone grey")
			end
			return MEDIUM_STONE_GREY
		end

		local entry = SortedByNumber.Array[index]
		if not entry then
			if not MEDIUM_STONE_GREY then
				MEDIUM_STONE_GREY = BrickColor.new("Medium stone grey")
			end
			return MEDIUM_STONE_GREY
		end

		return ToBrickColor(entry)
	end

	if type(value) == "string" then
		local index = SortedByName:Find({Name = value} :: never, EqualNames)
		if not index then
			if not MEDIUM_STONE_GREY then
				MEDIUM_STONE_GREY = BrickColor.new("Medium stone grey")
			end
			return MEDIUM_STONE_GREY
		end

		local entry = SortedByName.Array[index]
		if not entry then
			if not MEDIUM_STONE_GREY then
				MEDIUM_STONE_GREY = BrickColor.new("Medium stone grey")
			end
			return MEDIUM_STONE_GREY
		end

		return ToBrickColor(entry)
	end

	if TypeOf(value) == "Color3" then
		return BrickColor.new(value.R, value.G, value.B)
	end

	local exception = Error.new("Unknown type")
	exception.name = "UnknownTypeError"
	Error.captureStackTrace(exception, BrickColor.new)
	error(exception)
end

function BrickColor.palette()
	local exception = Error.new("No idea how this is implemented.")
	exception.name = "NotImplementedError"
	Error.captureStackTrace(exception, BrickColor.palette)
	error(exception)
end

function BrickColor.random()
	return BrickColor.new(ColorData[math.random(#ColorData)].Number)
end

function BrickColor.White()
	return BrickColor.new("White")
end

function BrickColor.Gray()
	if not MEDIUM_STONE_GREY then
		MEDIUM_STONE_GREY = BrickColor.new("Medium stone grey")
	end
	return MEDIUM_STONE_GREY
end
function BrickColor.DarkGray()
	return BrickColor.new("Dark stone grey")
end
function BrickColor.Black()
	return BrickColor.new("Black")
end
function BrickColor.Red()
	return BrickColor.new("Bright Red")
end
function BrickColor.Yellow()
	return BrickColor.new("Bright Yellow")
end
function BrickColor.Green()
	return BrickColor.new("Dark Green")
end
function BrickColor.Blue()
	return BrickColor.new("Bright Blue")
end

function Private:__eq(other)
	return self.Number == other.Number
end
function Private:__tostring()
	return self.Name
end

return table.freeze(BrickColor :: Static)
