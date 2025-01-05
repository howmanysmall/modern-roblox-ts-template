--!optimize 2
--!strict

--[[
MIT License

Copyright (c) 2024 BusyCityGuy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

--[[
	Lune's `datetime` module uses lowerCamelCase, whereas Roblox's `DateTime` module uses UpperCamelCase.
	To allow for Roblox-style usage of DateTime objects, this module wraps Lune's `datetime` module to add
	Roblox-style properties and methods through the use of metatables.

	This module may need to be updated as different properties and methods are needed.
--]]

local LuneDateTime = require("@lune/datetime")

export type TimeTable = {
	Day: number,
	Hour: number,
	Millisecond: number,
	Minute: number,
	Month: number,
	Second: number,
	Year: number,
	[any]: never,
}

export type PolyfillDateTime = {
	UnixTimestamp: number,
	UnixTimestampMillis: number,

	ToUniversalTime: (self: PolyfillDateTime) -> TimeTable,
	ToLocalTime: (self: PolyfillDateTime) -> TimeTable,
	ToIsoDate: (self: PolyfillDateTime) -> string,
	FormatUniversalTime: (self: PolyfillDateTime, format: string, locale: string) -> string,
	FormatLocalTime: (self: PolyfillDateTime, format: string, locale: string) -> string,
}
type Private = {
	Lune: LuneDateTime.DateTime,

	UnixTimestamp: number,
	UnixTimestampMillis: number,

	ToUniversalTime: (self: Private) -> TimeTable,
	ToLocalTime: (self: Private) -> TimeTable,
	ToIsoDate: (self: Private) -> string,
	FormatUniversalTime: (self: Private, format: string, locale: string) -> string,
	FormatLocalTime: (self: Private, format: string, locale: string) -> string,
}

type Static = {
	now: () -> PolyfillDateTime,
	fromUnixTimestamp: (unixTimestamp: number) -> PolyfillDateTime,
	fromUnixTimestampMillis: (unixTimestampMillis: number) -> PolyfillDateTime,
	fromUniversalTime: (
		year: number?,
		month: number?,
		day: number?,
		hour: number?,
		minute: number?,
		second: number?,
		millisecond: number?
	) -> PolyfillDateTime,
	fromLocalTime: (
		year: number?,
		month: number?,
		day: number?,
		hour: number?,
		minute: number?,
		second: number?,
		millisecond: number?
	) -> PolyfillDateTime,
	fromIsoDate: (isoDate: string) -> PolyfillDateTime?,
}
type PrivateStatic = Static & {}

local DateTime = {} :: PolyfillDateTime & Static
local Private = DateTime :: Private & PrivateStatic;
(DateTime :: any).__type = "DateTime";
(DateTime :: any).__index = DateTime

function DateTime.now()
	local lune = LuneDateTime.now()
	return setmetatable({
		Lune = lune;
		UnixTimestamp = lune.unixTimestamp;
		UnixTimestampMillis = lune.unixTimestampMillis;
	}, DateTime) :: never
end

function DateTime.fromUnixTimestamp(unixTimestamp: number)
	local lune = LuneDateTime.fromUnixTimestamp(unixTimestamp)
	return setmetatable({
		Lune = lune;
		UnixTimestamp = lune.unixTimestamp;
		UnixTimestampMillis = lune.unixTimestampMillis;
	}, DateTime) :: never
end
function DateTime.fromUnixTimestampMillis(unixTimestamp: number)
	local lune = LuneDateTime.fromUnixTimestamp(unixTimestamp / 1000)
	return setmetatable({
		Lune = lune;
		UnixTimestamp = lune.unixTimestamp;
		UnixTimestampMillis = lune.unixTimestampMillis;
	}, DateTime) :: never
end

function DateTime.fromUniversalTime(
	year: number?,
	month: number?,
	day: number?,
	hour: number?,
	minute: number?,
	second: number?,
	millisecond: number?
)
	local lune = LuneDateTime.fromUniversalTime({
		year = year or 1970;
		month = month or 1;
		day = day or 1;
		hour = hour or 0;
		minute = minute or 0;
		second = second or 0;
		millisecond = millisecond;
	})
	return setmetatable({
		Lune = lune;
		UnixTimestamp = lune.unixTimestamp;
		UnixTimestampMillis = lune.unixTimestampMillis;
	}, DateTime) :: never
end
function DateTime.fromLocalTime(
	year: number?,
	month: number?,
	day: number?,
	hour: number?,
	minute: number?,
	second: number?,
	millisecond: number?
)
	local lune = LuneDateTime.fromLocalTime({
		year = year or 1970;
		month = month or 1;
		day = day or 1;
		hour = hour or 0;
		minute = minute or 0;
		second = second or 0;
		millisecond = millisecond;
	})
	return setmetatable({
		Lune = lune;
		UnixTimestamp = lune.unixTimestamp;
		UnixTimestampMillis = lune.unixTimestampMillis;
	}, DateTime) :: never
end

function DateTime.fromIsoDate(isoDate)
	local lune = LuneDateTime.fromIsoDate(isoDate)
	return if lune
		then setmetatable({
			Lune = lune;
			UnixTimestamp = lune.unixTimestamp;
			UnixTimestampMillis = lune.unixTimestampMillis;
		}, DateTime) :: never
		else nil
end

function Private:ToUniversalTime(): TimeTable
	local timeTable = self.Lune:toUniversalTime()
	return {
		Day = timeTable.day;
		Hour = timeTable.hour;
		Millisecond = timeTable.millisecond;
		Minute = timeTable.minute;
		Month = timeTable.month;
		Second = timeTable.second;
		Year = timeTable.year;
	}
end
function Private:ToLocalTime(): TimeTable
	local timeTable = self.Lune:toLocalTime()
	return {
		Day = timeTable.day;
		Hour = timeTable.hour;
		Millisecond = timeTable.millisecond;
		Minute = timeTable.minute;
		Month = timeTable.month;
		Second = timeTable.second;
		Year = timeTable.year;
	}
end

function Private:ToIsoDate(): string
	return self.Lune:toIsoDate()
end

local ROBLOX_LOCALE_TO_LUNE = setmetatable(
	{
		["en-us"] = "en";
		["en-gb"] = "en";
		["en-au"] = "en";
		["en-ca"] = "en";
		["en-in"] = "en";
		["en-ie"] = "en";
		["en-jm"] = "en";
		["en-nz"] = "en";
		["en-za"] = "en";
		["en-tt"] = "en";
		["en-zw"] = "en";

		["de-de"] = "de";
		["de-at"] = "de";
		["de-ch"] = "de";
		["de-li"] = "de";
		["de-lu"] = "de";

		["es-es"] = "es";
		["es-ar"] = "es";
		["es-bo"] = "es";
		["es-cl"] = "es";
		["es-co"] = "es";
		["es-cr"] = "es";
		["es-do"] = "es";
		["es-ec"] = "es";
		["es-sv"] = "es";
		["es-gt"] = "es";
		["es-hn"] = "es";
		["es-mx"] = "es";
		["es-ni"] = "es";
		["es-pa"] = "es";
		["es-py"] = "es";
		["es-pe"] = "es";
		["es-pr"] = "es";
		["es-uy"] = "es";
		["es-ve"] = "es";

		["fr-fr"] = "fr";
		["fr-be"] = "fr";
		["fr-ca"] = "fr";
		["fr-ch"] = "fr";
		["fr-lu"] = "fr";

		["it-it"] = "it";
		["it-ch"] = "it";

		["ja-jp"] = "ja";

		["pl-pl"] = "pl";
		["pl-pl-pl"] = "pl";

		["pt-br"] = "pt-br";
		["pt-pt"] = "pt";

		["tr-tr"] = "tr";
	} :: {[string]: LuneDateTime.Locale},
	{
		__index = function(self, index: string): string
			self[index] = "en"
			return "en"
		end;
	}
)

function Private:FormatUniversalTime(format: string, locale: string): string
	return self.Lune:formatUniversalTime(format, ROBLOX_LOCALE_TO_LUNE[locale])
end

function Private:FormatLocalTime(format: string, locale: string): string
	return self.Lune:formatLocalTime(format, ROBLOX_LOCALE_TO_LUNE[locale])
end

return DateTime
