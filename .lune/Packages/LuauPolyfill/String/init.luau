--!optimize 2
--!strict

return table.freeze({
	charCodeAt = require("@self/charCodeAt");
	endsWith = require("@self/endsWith");
	findOr = require("@self/findOr");
	includes = require("@self/includes");
	indexOf = require("@self/indexOf");
	lastIndexOf = require("@self/lastIndexOf");
	slice = require("@self/slice");
	split = require("@self/split");
	startsWith = require("@self/startsWith");
	substr = require("@self/substr");
	trim = require("@self/trim");
	trimEnd = require("@self/trimEnd");
	trimStart = require("@self/trimStart");
	-- aliases for trimEnd and trimStart
	trimRight = require("@self/trimEnd");
	trimLeft = require("@self/trimStart");
})
