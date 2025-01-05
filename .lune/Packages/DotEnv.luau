--!optimize 2
--!strict

local PathFileSystem = require("@packages/PathFileSystem")
local process = require("@lune/process")

local Path = PathFileSystem.Path

local DotEnv = {}

function DotEnv.Parse(source: string): {[string]: string}
	local environment = {}

	local multiline = false
	local multilineKey = ""
	local multilineValue = ""

	local byLines = string.split(source, "\n")
	do
		local length = #byLines
		if byLines[length] == "" then
			byLines[length] = nil
		end
	end

	for _, line in byLines do
		local key, value = string.match(line, "(.+)=(.+)")
		if key and value then
			if string.byte(value) == 34 and string.byte(value, -1) ~= 34 or #value == 1 then
				multiline = true
			end

			if multiline then
				value = string.gsub(value, "^\"(.*)", "%1")
				multilineKey = key
				multilineValue = value
			else
				value = string.gsub(value, "^\"(.*)\"$", "%1")
				value = string.gsub(value, "^'(.*)'$", "%1")

				environment[key] = value
			end
		elseif multiline then
			if string.byte(line, -1) == 34 and string.byte(line, -2) ~= 92 then
				line = string.gsub(line, "(.*)\"$", "%1")
				multilineValue ..= "\n" .. line

				environment[multilineKey] = multilineValue

				multiline = false
				multilineKey = ""
				multilineValue = ""
				continue
			end
			multilineValue ..= "\n" .. line
		end
	end

	return environment
end

function DotEnv.Load(overwrite: boolean?, target: PathFileSystem.AsPath?)
	local trueTarget = Path.from(target or ".env")
	if not PathFileSystem.IsFileSafe(trueTarget) then
		error(`No .env file found at {trueTarget}?`)
	end

	local environment = process.env
	for key, value in DotEnv.Parse(PathFileSystem.ReadFile(trueTarget)) do
		if not environment[key] or overwrite then
			environment[key] = value
		end
	end
end

return table.freeze(DotEnv)
