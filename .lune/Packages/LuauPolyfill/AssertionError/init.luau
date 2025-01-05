--!optimize 2
--!strict

local AssertionErrorModule = require("./AssertionErrorGlobal")
export type AssertionError = AssertionErrorModule.AssertionError
return AssertionErrorModule.AssertionError
