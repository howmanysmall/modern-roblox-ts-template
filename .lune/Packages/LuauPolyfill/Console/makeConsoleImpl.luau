--!optimize 2
--!strict

local Chalk = require("@packages/Chalk")
local Collections = require("../Collections")

local Map = Collections.Map
local inspect = Collections.inspect

local INDENT = "  "

local YELLOW = Chalk.Rgb(243, 174, 53)

local function Concat(...: unknown)
	local length = select("#", ...)
	if length == 0 then
		return ""
	end

	if length == 1 then
		return tostring(...)
	end

	if length == 2 then
		local a, b = ...
		return tostring(a) .. " " .. tostring(b)
	end

	if length == 3 then
		local a, b, c = ...
		return tostring(a) .. " " .. tostring(b) .. tostring(c)
	end

	local array = table.create(length)
	for index = 1, length do
		array[index] = tostring(select(index, ...))
	end
	return table.concat(array, " ")
end

local function Warn(...)
	warn(YELLOW(Concat(...)))
end

return function()
	local console = {}
	local indentDepth = 0

	local function indent()
		return string.rep(INDENT, indentDepth)
	end

	function console.log(content, ...)
		local message
		if type(content) == "string" then
			message = string.format(content, ...)
		else
			message = inspect(content)
		end
		print(indent() .. message)
	end

	function console.debug(content, ...)
		local message
		if type(content) == "string" then
			message = string.format(content, ...)
		else
			message = inspect(content)
		end
		print(indent() .. message)
	end

	function console.info(content, ...)
		local message
		if type(content) == "string" then
			message = string.format(content, ...)
		else
			message = inspect(content)
		end
		print(indent() .. message)
	end

	function console.warn(content, ...)
		local message
		if type(content) == "string" then
			message = string.format(content, ...)
		else
			message = inspect(content)
		end
		Warn(indent() .. message)
	end

	function console.error(content, ...)
		-- JS' `console.error` doesn't interrupt execution like Lua's `error`,
		-- which is more similar to throwing an exception in JS.
		local message
		if type(content) == "string" then
			message = string.format(content, ...)
		else
			message = inspect(content)
		end
		Warn(indent() .. message)
	end

	function console.group(content, ...)
		local message
		if type(content) == "string" then
			message = string.format(content, ...)
		else
			message = inspect(content)
		end
		print(indent() .. message)
		indentDepth += 1
	end

	function console.groupCollapsed(content, ...)
		-- There's no smart console, so this is equivalent to `console.group`
		local message
		if type(content) == "string" then
			message = string.format(content, ...)
		else
			message = inspect(content)
		end
		print(indent() .. message)
		indentDepth += 1
	end

	function console.groupEnd()
		if indentDepth > 0 then
			indentDepth -= 1
		end
	end

	local startTimes: Collections.Map<string, number> = Map.new()
	function console.time(label: string?)
		local trueLabel = label or "default"
		if startTimes:has(trueLabel) then
			console.warn(`Timer '{trueLabel}' already exists`)
			return
		end

		startTimes:set(trueLabel, os.clock())
	end
	function console.timeEnd(label: string?)
		local finishTime = os.clock()
		local trueLabel = label or "default"
		local startTime = startTimes:get(trueLabel)
		if startTime == nil then
			console.warn(`Timer '{trueLabel}' does not exist`)
			return
		end

		console.log(`{trueLabel}: {(finishTime - startTime) * 1000} ms`)
		startTimes:delete(trueLabel)
	end

	return table.freeze(console)
end
