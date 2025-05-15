--!optimize 2
--!strict

return table.freeze({
	isFinite = require("@self/isFinite");
	isInteger = require("@self/isInteger");
	isNaN = require("@self/isNaN");
	isSafeInteger = require("@self/isSafeInteger");
	MAX_SAFE_INTEGER = require("@self/MAX_SAFE_INTEGER");
	MIN_SAFE_INTEGER = require("@self/MIN_SAFE_INTEGER");
	NaN = 0 / 0;
	toExponential = require("@self/toExponential");
})
