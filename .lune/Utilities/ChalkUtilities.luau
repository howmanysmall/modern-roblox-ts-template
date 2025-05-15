--!optimize 2
--!strict

local Chalk = require("@packages/Chalk")
local GreenTea = require("@packages/GreenTea")
local GreenTeaAssert = require("@functions/GreenTeaAssert")
local MissingTypes = require("@types/MissingTypes")
local TypeError = require("@errors/TypeError")

local ChalkUtilities = {}

local IsUnknownRaw = GreenTea.unknown({allowNil = true})

local IsCheckableTypes = GreenTea.build(MissingTypes.CheckableTypes)
local IsColorFormatter = GreenTea.build(GreenTea.fn(GreenTea.args(IsUnknownRaw), GreenTea.returns(GreenTea.string())))
local IsUnknown = GreenTea.build(IsUnknownRaw)

export type CheckableTypes = MissingTypes.CheckableTypes
export type ColorFormatter = typeof(IsColorFormatter:type())

local function AsCheckableTypes(checkableType: CheckableTypes): CheckableTypes
	return checkableType
end
ChalkUtilities.AsCheckableType = AsCheckableTypes
ChalkUtilities.AsCheckableTypes = AsCheckableTypes

type ColorFormatters = {[CheckableTypes]: ColorFormatter}
local colorFormatters: ColorFormatters = {
	[AsCheckableTypes("boolean")] = function(value: unknown): string
		return Chalk.Yellow(tostring(value))
	end;
	[AsCheckableTypes("number")] = function(value: unknown): string
		return Chalk.Cyan(tostring(value))
	end;
	[AsCheckableTypes("string")] = function(value: unknown): string
		return Chalk.Green(`"{value}"`)
	end;
}
setmetatable(colorFormatters, {
	__index = function(self: ColorFormatters, index: MissingTypes.CheckableTypes): ColorFormatter
		self[index] = tostring
		return tostring
	end;
})
local colorFormattersCast = (colorFormatters :: unknown) :: ColorFormatters

local TypeOf = (typeof :: unknown) :: (value: unknown) -> CheckableTypes

local function FormatValue(value: unknown): string
	GreenTeaAssert(IsUnknown, value, FormatValue, TypeError)
	return colorFormatters[TypeOf(value)](value)
end
ChalkUtilities.FormatValue = FormatValue

local function Add(checkableTypes: CheckableTypes, colorFormatter: ColorFormatter): ()
	GreenTeaAssert(IsCheckableTypes, checkableTypes, Add, TypeError)
	GreenTeaAssert(IsColorFormatter, colorFormatter, Add, TypeError)

	rawset(colorFormattersCast, checkableTypes, colorFormatter)
end
ChalkUtilities.Add = Add

local function Has(checkableTypes: CheckableTypes): boolean
	GreenTeaAssert(IsCheckableTypes, checkableTypes, Has, TypeError)
	return rawget(colorFormattersCast, checkableTypes) ~= nil
end
ChalkUtilities.Has = Has

local function Remove(checkableTypes: CheckableTypes): ()
	GreenTeaAssert(IsCheckableTypes, checkableTypes, Remove, TypeError)
	rawset(colorFormattersCast, checkableTypes, (nil :: unknown) :: ColorFormatter)
end
ChalkUtilities.Remove = Remove

local function SafeAdd(checkableTypes: CheckableTypes, colorFormatter: ColorFormatter): boolean
	GreenTeaAssert(IsCheckableTypes, checkableTypes, SafeAdd, TypeError)
	GreenTeaAssert(IsColorFormatter, colorFormatter, SafeAdd, TypeError)

	if Has(checkableTypes) then
		return false
	end

	Add(checkableTypes, colorFormatter)
	return true
end
ChalkUtilities.SafeAdd = SafeAdd

return table.freeze(ChalkUtilities)
