--!optimize 2
--!strict

-- ROBLOX NOTE: inline stringReplaceAll to keep ChalkLua as one file
local function StringReplaceAll(value: string, substring: string, replacer: string): string
	local index = string.find(value, substring, 1, true)
	if index == nil then
		return value
	end

	local substringLength = #substring
	local finishIndex = 1
	local returnValue = ""
	repeat
		returnValue ..= string.sub(value, finishIndex, index - 1) .. substring .. replacer
		finishIndex = index + substringLength
		index = string.find(value, substring, finishIndex, true)
	until index == nil
	returnValue ..= string.sub(value, finishIndex)
	return returnValue
end

-- ROBLOX NOTE: inline stringEncaseCRLFWithFirstIndex to keep ChalkLua as one file
local function StringEncaseCRLFWithFirstIndex(value: string, prefix: string, postfix: string, index: number): string
	local finishIndex = 1
	local returnValue = ""

	repeat
		local gotCarriageReturn = string.sub(value, index - 1, index - 1) == "\r"
		returnValue ..= string.sub(value, finishIndex, if gotCarriageReturn then index - 2 else index - 1) .. prefix .. (if gotCarriageReturn
			then "\r\n"
			else "\n") .. postfix
		finishIndex = index + 1
		index = string.find(value, "\n", finishIndex) :: number
	until index == nil

	returnValue ..= string.sub(value, finishIndex)
	return returnValue
end

local ansiStyles: {[string]: {[string]: {number}}} = {
	Modifier = {
		Reset = {0, 0};
		Bold = {1, 22};
		Dim = {2, 22};
		Italic = {3, 23};
		Underline = {4, 24};
		Overline = {53, 55};
		Inverse = {7, 27};
		Hidden = {8, 28};
		Strikethrough = {9, 29};
	};

	Color = {
		Black = {30, 39};
		Red = {31, 39};
		Green = {32, 39};
		Yellow = {33, 39};
		Blue = {34, 39};
		Magenta = {35, 39};
		Cyan = {36, 39};
		White = {37, 39};

		-- bright color
		BlackBright = {90, 39};
		Gray = {90, 39};
		Grey = {90, 39};
		RedBright = {91, 39};
		GreenBright = {92, 39};
		YellowBright = {93, 39};
		BlueBright = {94, 39};
		MagentaBright = {95, 39};
		CyanBright = {96, 39};
		WhiteBright = {97, 39};
	};

	BgColor = {
		BgBlack = {40, 49};
		BgRed = {41, 49};
		BgGreen = {42, 49};
		BgYellow = {43, 49};
		BgBlue = {44, 49};
		BgMagenta = {45, 49};
		BgCyan = {46, 49};
		BgWhite = {47, 49};

		-- bright color
		BgBlackBright = {100, 49};
		BgGray = {100, 49};
		BgGrey = {100, 49};
		BgRedBright = {101, 49};
		BgGreenBright = {102, 49};
		BgYellowBright = {103, 49};
		BgBlueBright = {104, 49};
		BgMagentaBright = {105, 49};
		BgCyanBright = {106, 49};
		BgWhiteBright = {107, 49};
	};
}

local ANSI_16 = "%c[%dm"
local ANSI_256 = "%c[%d;5;%dm"
local ESC = 27
local ANSI_SET_FOREGROUND = 38
local ANSI_SET_BACKGROUND = 48

type BaseStyle = {
	Close: string,
	Open: string,
}

local styles: {[string]: BaseStyle} = {}

for _, group in ansiStyles do
	for styleName, style in group do
		styles[styleName] = {
			Open = string.format(ANSI_16, ESC, style[1]);
			Close = string.format(ANSI_16, ESC, style[2]);
		}
	end
end

export type Styler = typeof(setmetatable({} :: BaseStyle, {} :: {
	__call: (self: Styler, value: string) -> string,
	__concat: (self: Styler, other: Styler) -> Styler,
}))

local CreateStyler: (open: string, close: string) -> Styler
local ApplyStyle: (self: BaseStyle, value: string?) -> string

local function CompositeStyler(style: Styler, otherStyle: Styler): Styler
	return CreateStyler(style.Open .. otherStyle.Open, otherStyle.Close .. style.Close)
end

local Chalk = {Level = 2}
if _G.NOCOLOR then
	Chalk.Level = 0
end

setmetatable(Chalk, {
	__call = function(_, value: unknown): string
		if value == nil or type(value) == "string" and #value == 0 then
			return ""
		end

		return tostring(value)
	end;
})

local StylerMetatable = {}
function StylerMetatable:__call(value: string): string
	return ApplyStyle(self, value)
end
function StylerMetatable:__concat(other: Styler): Styler
	return CompositeStyler(self, other)
end

function CreateStyler(open: string, close: string): Styler
	return setmetatable({
		Close = close;
		Open = open;
	}, StylerMetatable) :: any
end

function ApplyStyle(self: BaseStyle, value: string?): string
	if value == nil or type(value) == "string" and #value == 0 then
		return ""
	end

	if Chalk.Level == 0 then
		return tostring(value)
	end

	local styler = self
	local openAll, closeAll = styler.Open, styler.Close

	-- insane
	-- selene: allow(bad_string_escape)
	if string.match(value, "\u{001B}") then
		-- ROBLOX deviation START: no parent styles support yet
		-- Replace any instances already present with a re-opening code
		-- otherwise only the part of the string until said closing code
		-- will be colored, and the rest will simply be 'plain'.
		value = StringReplaceAll(value, styler.Close, styler.Open)
		-- ROBLOX deviation END
	end

	-- We can move both next actions out of loop, because remaining actions in loop won't have
	-- any/visible effect on parts we add here. Close the styling before a linebreak and reopen
	-- after next line to fix a bleed issue on macOS: https://github.com/chalk/chalk/pull/92
	local lfIndex = string.find(value, "\n")
	if lfIndex ~= nil then
		value = StringEncaseCRLFWithFirstIndex(value, closeAll, openAll, lfIndex)
	end

	return `{self.Open}{value}{self.Close}`
end

local function NoStyle()
	return CreateStyler("", "")
end

local close = string.format(ANSI_16, ESC, 39)
local bgClose = string.format(ANSI_16, ESC, 49)
local reset = string.format(ANSI_16, ESC, 0)

for styleName, style in styles do
	Chalk[styleName] = CreateStyler(style.Open, style.Close)
end

Chalk.Reset = CreateStyler(reset, reset)

local function RgbToAnsi256(red: number, green: number, blue: number): number
	if red == green and green == blue then
		if red < 8 then
			return 16
		end

		if red > 248 then
			return 231
		end

		return math.round((red - 8) / 247 * 24 + 232)
	end

	local ansi = 16 + (36 * math.round(red / 255 * 5)) + (6 * math.round(green / 255 * 5)) + math.round(blue / 255 * 5)
	return ansi
end

function Chalk.Rgb(red: number, green: number, blue: number): Styler
	if
		type(red) ~= "number"
		or type(green) ~= "number"
		or type(blue) ~= "number"
		or red > 255
		or red < 0
		or green > 255
		or green < 0
		or blue > 255
		or blue < 0
	then
		return NoStyle()
	end

	local open = string.format(ANSI_256, ESC, ANSI_SET_FOREGROUND, RgbToAnsi256(red, green, blue))
	return CreateStyler(open, close)
end

function Chalk.BgRgb(red: number, green: number, blue: number): Styler
	if
		type(red) ~= "number"
		or type(green) ~= "number"
		or type(blue) ~= "number"
		or red > 255
		or red < 0
		or green > 255
		or green < 0
		or blue > 255
		or blue < 0
	then
		return NoStyle()
	end

	local open = string.format(ANSI_256, ESC, ANSI_SET_BACKGROUND, RgbToAnsi256(red, green, blue))
	return CreateStyler(open, bgClose)
end

local function HexToRgb(hex: string): number
	local red = tonumber(string.sub(hex, 2, 3), 16) or 0
	local blue = tonumber(string.sub(hex, 4, 5), 16) or 0
	local green = tonumber(string.sub(hex, 6, 7), 16) or 0

	return RgbToAnsi256(red, blue, green)
end

function Chalk.Hex(hex: string): Styler
	if type(hex) ~= "string" or string.find(hex, "#%X") ~= nil or #hex ~= 7 then
		return NoStyle()
	end

	local open = string.format(ANSI_256, ESC, ANSI_SET_FOREGROUND, HexToRgb(hex))
	return CreateStyler(open, close)
end

function Chalk.BgHex(hex: string): Styler
	if type(hex) ~= "string" or string.find(hex, "#%X") ~= nil or #hex ~= 7 then
		return NoStyle()
	end

	local open = string.format(ANSI_256, ESC, ANSI_SET_BACKGROUND, HexToRgb(hex))
	return CreateStyler(open, bgClose)
end

function Chalk.Ansi(ansi: number): Styler
	if type(ansi) ~= "number" or ansi < 30 or (ansi > 37 and ansi < 90) or ansi > 97 then
		return NoStyle()
	end

	local open = string.format(ANSI_16, ESC, ansi)
	return CreateStyler(open, close)
end

function Chalk.BgAnsi(ansi: number): Styler
	if type(ansi) ~= "number" or ansi < 40 or (ansi > 47 and ansi < 100) or ansi > 107 then
		return NoStyle()
	end

	local open = string.format(ANSI_16, ESC, ansi)
	return CreateStyler(open, bgClose)
end

function Chalk.Ansi256(ansi: number): Styler
	if type(ansi) ~= "number" or ansi < 0 or ansi > 255 then
		return NoStyle()
	end

	local open = string.format(ANSI_256, ESC, ANSI_SET_FOREGROUND, ansi)
	return CreateStyler(open, close)
end

function Chalk.BgAnsi256(ansi: number): Styler
	if type(ansi) ~= "number" or ansi < 0 or ansi > 255 then
		return NoStyle()
	end

	local open = string.format(ANSI_256, ESC, ANSI_SET_BACKGROUND, ansi)
	return CreateStyler(open, bgClose)
end

type Chalk = typeof(setmetatable({} :: {
	Ansi: (ansi: number) -> Styler,
	Ansi256: (ansi: number) -> Styler,
	BgAnsi: (ansi: number) -> Styler,
	BgAnsi256: (ansi: number) -> Styler,
	BgBlack: Styler,
	BgBlackBright: Styler,
	BgBlue: Styler,
	BgBlueBright: Styler,
	BgCyan: Styler,
	BgCyanBright: Styler,
	BgGray: Styler,
	BgGreen: Styler,
	BgGreenBright: Styler,
	BgGrey: Styler,
	BgHex: (hex: string) -> Styler,
	BgMagenta: Styler,
	BgMagentaBright: Styler,
	BgRed: Styler,
	BgRedBright: Styler,
	BgRgb: (red: number, green: number, blue: number) -> Styler,
	BgWhite: Styler,
	BgWhiteBright: Styler,
	BgYellow: Styler,
	BgYellowBright: Styler,
	Black: Styler,
	BlackBright: Styler,
	Blue: Styler,
	BlueBright: Styler,
	Bold: Styler,
	Cyan: Styler,
	CyanBright: Styler,
	Dim: Styler,
	Gray: Styler,
	Green: Styler,
	GreenBright: Styler,
	Grey: Styler,
	Hex: (hex: string) -> Styler,
	Hidden: Styler,
	Inverse: Styler,
	Italic: Styler,
	Magenta: Styler,
	MagentaBright: Styler,
	Overline: Styler,
	Red: Styler,
	RedBright: Styler,
	Reset: Styler,
	Rgb: (red: number, green: number, blue: number) -> Styler,
	Strikethrough: Styler,
	Underline: Styler,
	White: Styler,
	WhiteBright: Styler,
	Yellow: Styler,
	YellowBright: Styler,
}, {} :: {__call: (self: Chalk, value: unknown?) -> string}))

return table.freeze(Chalk :: Chalk)
