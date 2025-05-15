--!optimize 2
--!strict

export type Array<T> = {T}

return table.freeze({
	concat = require("@self/concat");
	every = require("@self/every");
	filter = require("@self/filter");
	find = require("@self/find");
	findIndex = require("@self/findIndex");
	flat = require("@self/flat");
	flatMap = require("@self/flatMap");
	forEach = require("@self/forEach");
	from = require("@self/from");
	includes = require("@self/includes");
	indexOf = require("@self/indexOf");
	isArray = require("@self/isArray");
	join = require("@self/join");
	map = require("@self/map");
	reduce = require("@self/reduce");
	reverse = require("@self/reverse");
	shift = require("@self/shift");
	slice = require("@self/slice");
	some = require("@self/some");
	sort = require("@self/sort");
	splice = require("@self/splice");
	unshift = require("@self/unshift");
})
