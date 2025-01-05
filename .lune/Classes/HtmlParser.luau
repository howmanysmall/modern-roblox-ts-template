--!optimize 2
--!strict

local RegEx = require("@lune/regex")

local IS_WHITESPACE = RegEx.new("\\s+")
local BETWEEN = RegEx.new("> <")
local BEFORE = RegEx.new(" >")
local AFTER = RegEx.new("< ")

export type HtmlParser = typeof(setmetatable(
	{} :: {
		Data: string,
		Position: number,
		Html: string,
		Tag: string,

		Next: (self: HtmlParser) -> HtmlParser,
	},
	{} :: {__iter: (self: HtmlParser) -> () -> (string, string)}
))

type Static = {
	ClassName: "HtmlParser",

	new: (html: string) -> HtmlParser,
	Is: (value: any) -> boolean,
	instanceof: (value: any) -> boolean,
}
type StaticPrivate = Static & {
	__iter: (self: HtmlParser) -> () -> (string, string),
	__tostring: (self: HtmlParser) -> string,
}

local HtmlParser = {} :: HtmlParser & Static
local Private = HtmlParser :: HtmlParser & StaticPrivate
HtmlParser.ClassName = "HtmlParser";
(HtmlParser :: any).__index = HtmlParser

function HtmlParser.new(html)
	return setmetatable({
		Html = AFTER:replaceAll(
			BEFORE:replaceAll(BETWEEN:replaceAll(IS_WHITESPACE:replaceAll(html, " "), "><"), ">"),
			"<"
		);
		Position = 0;
	}, HtmlParser) :: never
end

function HtmlParser.Is(value)
	return type(value) == "table" and getmetatable(value) == HtmlParser
end
HtmlParser.instanceof = HtmlParser.Is

local function Find(html: string, position: number): (number?, number)
	local startPosition, newPosition = string.find(html, "<([^>]+)>([^<]*)", position + 1)
	return startPosition, newPosition or 0
end

function HtmlParser:Next()
	local html = self.Html
	local startPosition, position = Find(html, self.Position)
	self.Position = position

	if startPosition then
		local tag, data = string.match(string.sub(html, position), "<([^>]+)>([^<]*)")
		self.Tag = tag :: string
		self.Data = data :: string
	else
		self.Tag = nil :: never
		self.Data = nil :: never
	end

	return self
end

function Private:__iter()
	return coroutine.wrap(function()
		while self:Next().Tag do
			coroutine.yield(self.Tag, self.Data)
		end
	end)
end

function Private:__tostring()
	return "HtmlParser"
end

return table.freeze(HtmlParser :: Static)
