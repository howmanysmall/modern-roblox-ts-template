--!optimize 2
--!strict

local ES7Types = require("@packages/ES7Types")
type Object = ES7Types.Object

type FromStringFunction<T, U> = (element: T, index: number) -> U
type FromStringThisFunction<T, U> = (thisArg: any, element: T, index: number) -> U

local function FromString<T, U>(
	value: string,
	callback: FromStringFunction<T, U> | FromStringThisFunction<T, U> | nil,
	thisArg: Object?
): {U} | {T} | {string}
	local valueStringLength = #value
	if callback then
		local array = table.create(valueStringLength)
		for index = 1, valueStringLength do
			if thisArg ~= nil then
				array[index] = (callback :: FromStringThisFunction<T, U>)(
					thisArg,
					string.sub(value, index, index) :: any,
					index
				)
			else
				array[index] = (callback :: FromStringFunction<T, U>)(string.sub(value, index, index) :: any, index)
			end
		end
		return array
	end

	local array = table.create(valueStringLength)
	for index = 1, valueStringLength do
		array[index] = string.sub(value, index, index)
	end
	return array
end

return FromString
