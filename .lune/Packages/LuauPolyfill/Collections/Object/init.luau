--!optimize 2
--!strict

return table.freeze({
	assign = require("@self/assign");
	entries = require("@self/entries");
	freeze = require("@self/freeze");
	is = require("@self/is");
	isFrozen = require("@self/isFrozen");
	keys = require("@self/keys");
	preventExtensions = require("@self/preventExtensions");
	seal = require("@self/seal");
	values = require("@self/values");
	-- Special marker type used in conjunction with `assign` to remove values
	-- from tables, since nil cannot be stored in a table
	None = require("@self/None");
})
