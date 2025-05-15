--!optimize 2
--!strict

local Error = require("@packages/Error")
local GreenTea = require("@packages/GreenTea")

export type Type = GreenTea.Type
export type ErrorLike = {
	name: string,
	message: string,
	stack: string?,
	[any]: any,
}
export type ErrorClassLike = typeof(setmetatable(
	{} :: {
		new: (message: string) -> ErrorLike,
		[any]: any,
	},
	{} :: {}
))

type Function = (...any) -> ...any

local function GreenTeaAssert(greenTeaType: Type, value: unknown, callback: Function?, errorClass: ErrorClassLike?): ()
	local typeSuccess, typeError = greenTeaType:matches(value)
	if not typeSuccess then
		local trueErrorClass: ErrorClassLike = errorClass or (Error :: unknown) :: ErrorClassLike
		local exception = trueErrorClass.new(tostring(typeError))
		Error.captureStackTrace(exception, callback)
		error(exception, 2)
	end
end

return GreenTeaAssert
