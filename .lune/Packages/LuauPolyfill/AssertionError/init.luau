--!optimize 2
--!strict

local AssertionErrorModule = require("@self/AssertionErrorGlobal")
export type AssertionError = AssertionErrorModule.AssertionError
return AssertionErrorModule.AssertionError
