--!optimize 2
--!strict

export type PolyfillColor3 = {
	R: number,
	G: number,
	B: number,

	Lerp: (self: PolyfillColor3, color: PolyfillColor3, alpha: number) -> PolyfillColor3,
	ToHSV: (self: PolyfillColor3) -> (number, number, number),
	ToHex: (self: PolyfillColor3) -> string,

	r: number,
	g: number,
	b: number,
}

type Static = {
	new: (red: number?, green: number?, blue: number?) -> PolyfillColor3,
	fromRGB: (red: number?, green: number?, blue: number?) -> PolyfillColor3,
	fromHex: (hex: string) -> PolyfillColor3,
	fromHSV: (hue: number, saturation: number, value: number) -> PolyfillColor3,
}
type PrivateStatic = Static & {
	__eq: (self: PolyfillColor3, other: PolyfillColor3) -> boolean,
	__newindex: (self: PolyfillColor3, key: unknown) -> never,
	__tostring: (self: PolyfillColor3) -> string,
}

local Color3 = {} :: PolyfillColor3 & Static
local Private = Color3 :: PolyfillColor3 & PrivateStatic;
(Color3 :: any).__index = Color3;
(Color3 :: any).ClassName = "Color3"

-- local function Lerp(start: number, finish: number, alpha: number)
-- 	return start + (finish - start) * alpha
-- end
local function StableLerp(start: number, finish: number, alpha: number)
	return if alpha < 0.5 then start + (finish - start) * alpha else finish - (finish - start) * (1 - alpha)
end

local function Color3_new(red: number?, green: number?, blue: number?): PolyfillColor3
	return setmetatable({
		R = red or 0;
		G = green or 0;
		B = blue or 0;

		r = red or 0;
		g = green or 0;
		b = blue or 0;
	}, Color3) :: never
end
Color3.new = Color3_new

local function Color3_fromRGB(red: number?, green: number?, blue: number?): PolyfillColor3
	return Color3_new((red or 0) / 255, (green or 0) / 255, (blue or 0) / 255)
end
Color3.fromRGB = Color3_fromRGB

function Color3.fromHex(hex)
	if string.byte(hex) == 35 then
		hex = string.sub(hex, 2)
	end

	local digits = #hex
	local hexValue = tonumber(hex, 16) :: number

	if digits == 6 then
		local red = (hexValue - hexValue % 0x010000) / 0x010000
		hexValue -= red * 0x010000
		local green = (hexValue - hexValue % 0x000100) / 0x000100
		return Color3_fromRGB(red, green, hexValue - green * 0x000100)
	end

	if digits == 3 then
		local red = (hexValue - hexValue % 0x100) / 0x100
		hexValue -= red * 0x100
		local green = (hexValue - hexValue % 0x10) / 0x10
		return Color3_fromRGB(red * 0x11, green * 0x11, (hexValue - green * 0x10) * 0x11)
	end

	error("unknown hex?")
end

-- Creates a Color3 with the given hue, saturation, and value.
-- The parameters should be within the range of 0 to 1.
-- local red = Color3.fromHSV(1, 1, 1)
-- local green = Color3.fromHSV(1/3, 1, 1)
-- local white = Color3.fromHSV(0, 0, 1)
function Color3.fromHSV(hue, saturation, value)
	local h = (hue % 1) * 6
	local s = saturation
	local v = value

	local i = math.floor(h)
	local f = h - i
	local p = v * (1 - s)
	local q = v * (1 - s * f)
	local t = v * (1 - s * (1 - f))

	local r, g, b
	if i == 0 then
		r, g, b = v, t, p
	elseif i == 1 then
		r, g, b = q, v, p
	elseif i == 2 then
		r, g, b = p, v, t
	elseif i == 3 then
		r, g, b = p, q, v
	elseif i == 4 then
		r, g, b = t, p, v
	else -- i == 5
		r, g, b = v, p, q
	end

	return Color3_new(r, g, b)
end

function Color3:Lerp(color, alpha)
	return Color3_new(
		StableLerp(self.R, color.R, alpha),
		StableLerp(self.G, color.G, alpha),
		StableLerp(self.B, color.B, alpha)
	)
end

function Color3:ToHex()
	local red = self.R * 255 + 0.5
	local green = self.G * 255 + 0.5
	local blue = self.B * 255 + 0.5

	return string.format("%x%x%x", red, green, blue)
end

-- Returns the hue, saturation, and value of a Color3.
-- This function is the inverse operation of the Color3.fromHSV() constructor.
function Color3:ToHSV()
	local r, g, b = self.R, self.G, self.B
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local delta = max - min

	local h = 0
	local s = 0
	local v = max

	if max ~= 0 then
		s = delta / max
	else
		return 0, 0, v
	end

	if delta == 0 then
		h = 0
	elseif max == r then
		h = ((g - b) / delta) % 6
	elseif max == g then
		h = ((b - r) / delta) + 2
	elseif max == b then
		h = ((r - g) / delta) + 4
	end

	h = (h / 6) % 1

	return h, s, v
end

function Private:__eq(other)
	return self.R == other.R and self.G == other.G and self.B == other.B
end
function Private:__newindex(key)
	error(`{key} cannot be assigned to`, 2)
end
function Private:__tostring()
	return string.format("%.6f, %.6f, %.6f", self.R, self.G, self.B)
end

return table.freeze(Color3 :: Static)
