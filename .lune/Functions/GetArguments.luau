--!optimize 2
--!strict

local process = require("@lune/process")

local function GetArguments(): {string}
	local arguments = process.args

	local fixedArguments = table.create(#arguments - 1)
	local length = 0

	for index, value in arguments do
		if index == 0 then
			continue
		end

		length += 1
		fixedArguments[length] = value
	end

	return fixedArguments
end

return GetArguments
