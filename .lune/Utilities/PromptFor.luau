--!optimize 2
--!strict

local Debug = require("@packages/Debug")
local StringUtilities = require("@utilities/StringUtilities")
local stdio = require("@lune/stdio")

export type CanPromptFor = boolean | number | string
type Types = "boolean" | "number" | "string"
local CAN_PROMPT_FOR = {
	boolean = true;
	number = true;
	string = true;
}

local function CreatePrompt<T>(key: string, value: unknown, setter: (newValue: unknown) -> ()): () -> ()
	if type(value) == "number" then
		return function(): ()
			local newValue = stdio.prompt("text", `What should the {key} be?`, tostring(value))
			setter(StringUtilities.GetNumberFromString(newValue, value))
		end
	end

	if type(value) == "boolean" then
		return function(): ()
			local newValue = stdio.prompt("confirm", `Do you want to enable {key}?`, not not value)
			setter(newValue)
		end
	end

	if type(value) == "string" then
		return function(): ()
			setter(stdio.prompt("text", `What should the {key} be?`, tostring(value)))
		end
	end

	error(`Unknown value in exhaustive match: {Debug.Inspect(value)}`)
end

local function PromptFor(object: {[string]: unknown}): ()
	local prompts = {}
	local length = 0

	for key, value in Debug.AlphabeticalOrder(object) do
		local typeOf = type(value)
		if CAN_PROMPT_FOR[typeOf] then
			length += 1
			prompts[length] = CreatePrompt(key, value, function(newValue: unknown): ()
				object[key] = newValue
			end)
		end
	end

	for _, callback in prompts do
		callback()
	end
end

return PromptFor
