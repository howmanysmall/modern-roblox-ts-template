--!optimize 2

--# selene: allow(bad_string_escape)

-- ROBLOX upstream: https://github.com/nodejs/node/blob/v18.1.0/lib/internal/assert/assertion_error.js
local Boolean = require("../Boolean")

local Collections = require("../Collections")
local Error = require("../Error")
local String = require("../String")
local instanceof = require("../InstanceOf")
local types = require("../ES7Types")

local Array = Collections.Array
local Object = Collections.Object
local inspect = Collections.inspect

type Error = Error.Error
type Array<T> = types.Array<T>
type Object = types.Object
type Function = types.Function

-- ROBLOX deviation START: mock process to not change AssertionError internals
local process = {
	stderr = {
		isTTY = false;
		columns = 0;
		hasColors = function(...)
			local _ = ...
			return true
		end;
	};
}

-- ROBLOX deviation END
-- ROBLOX TODO START: implement ErrorCaptureStackTrace correctly
local function ErrorCaptureStackTrace(err, ...)
	Error.captureStackTrace(err, ...)
end

-- ROBLOX TODO END
-- ROBLOX TODO START: use real remove colors
local function removeColors(str)
	return str
end

-- local removeColors = require_("internal/util").removeColors
-- ROBLOX TODO END
-- local validateObject = require_("internal/validators").validateObject
-- ROBLOX deviation START: isErrorStackTraceLimitWritable is not necessary ATM
-- local isErrorStackTraceLimitWritable = require_("internal/errors").isErrorStackTraceLimitWritable
-- ROBLOX deviation END
local blue = ""
local green = ""
local red = ""
local white = ""
local kReadableOperator = {
	deepStrictEqual = "Expected values to be strictly deep-equal:";
	strictEqual = "Expected values to be strictly equal:";
	strictEqualObject = "Expected \"actual\" to be reference-equal to \"expected\":";
	deepEqual = "Expected values to be loosely deep-equal:";
	notDeepStrictEqual = "Expected \"actual\" not to be strictly deep-equal to:";
	notStrictEqual = "Expected \"actual\" to be strictly unequal to:";
	notStrictEqualObject = "Expected \"actual\" not to be reference-equal to \"expected\":";
	notDeepEqual = "Expected \"actual\" not to be loosely deep-equal to:";
	notIdentical = "Values have same structure but are not reference-equal:";
	notDeepEqualUnequal = "Expected values not to be loosely deep-equal:";
}

-- Comparing short primitives should just show === / !== instead of using the
-- diff.
local kMaxShortLength = 12
local function copyError(source: Object)
	local keys = Object.keys(source)
	-- ROBLOX TODO:
	local target = {} -- ObjectCreate(ObjectGetPrototypeOf(source))
	for _, key in keys do
		target[key] = source[key]
	end

	target.message = source.message
	return target
end

local function inspectValue(val)
	-- The util.inspect default values could be changed. This makes sure the
	-- error messages contain the necessary information nevertheless.
	return inspect(val, {
		compact = false;
		customInspect = false;
		depth = 1000;
		maxArrayLength = math.huge; -- Assert compares only enumerable properties (with a few exceptions).
		showHidden = false; -- Assert does not detect proxies currently.
		showProxy = false;
		sorted = true; -- Inspect getters as we also check them when comparing entries.
		getters = true;
	})
end

local function createErrDiff(actual, expected, operator)
	local other = ""
	local result = ""
	local ending = ""
	local skipped = false
	local actualInspected = inspectValue(actual)
	local actualLines = String.split(actualInspected, "\n")
	local expectedLines = String.split(inspectValue(expected), "\n")

	local index = 0
	local indicator = ""

	-- In case both values are objects or functions explicitly mark them as not
	-- reference equal for the `strictEqual` operator.
	if
		operator == "strictEqual"
		and (
			type(actual) == "table" and actual ~= nil and type(expected) == "table" and expected ~= nil
			or type(actual) == "function" and type(expected) == "function"
		)
	then
		operator = "strictEqualObject"
	end

	-- If "actual" and "expected" fit on a single line and they are not strictly
	-- equal, check further special handling.
	if #actualLines == 1 and #expectedLines == 1 and actualLines[1] ~= expectedLines[1] then
		-- Check for the visible length using the `removeColors()` function, if
		-- appropriate.
		-- ROBLOX TODO START
		local c = false
		-- local c = inspect.defaultOptions.colors
		-- ROBLOX TODO END
		local actualRaw = if c then removeColors(actualLines[1]) else actualLines[1]
		local expectedRaw = if Boolean.toJSBoolean(c) then removeColors(expectedLines[1]) else expectedLines[1]
		local inputLength = #actualRaw + #expectedRaw
		-- If the character length of "actual" and "expected" together is less than
		-- kMaxShortLength and if neither is an object and at least one of them is
		-- not `zero`, use the strict equal comparison to visualize the output.
		if inputLength <= kMaxShortLength then
			if
				(type(actual) ~= "table" or actual == nil)
				and (type(expected) ~= "table" or expected == nil)
				and (actual ~= 0 or expected ~= 0)
			then
				-- -0 === +0
				return `{kReadableOperator[operator]}\n\n{actualLines[1]} !== {expectedLines[1]}\n`
			end
		elseif operator ~= "strictEqualObject" then
			-- If the stderr is a tty and the input length is lower than the current
			-- columns per line, add a mismatch indicator below the output. If it is
			-- not a tty, use a default value of 80 characters.
			local maxLength = if process.stderr.isTTY then process.stderr.columns else 80
			if inputLength < maxLength then
				while string.sub(actualRaw, index + 1, index + 1) == string.sub(expectedRaw, index + 1, index + 1) do
					index += 1
				end
				-- Ignore the first characters.
				if index > 2 then
					-- Add position indicator for the first mismatch in case it is a
					-- single line and the input length is less than the column length.
					indicator = `\n  {string.rep(" ", index)}^`
					index = 0
				end
			end
		end
	end

	-- Remove all ending lines that match (this optimizes the output for
	-- readability by reducing the number of total changed lines).
	local a = actualLines[#actualLines]
	local b = expectedLines[#expectedLines]
	while a == b do
		local i_ = index
		index += 1
		if i_ < 3 then
			ending = `\n  {a}{ending}`
		else
			other = a
		end

		table.remove(actualLines)
		table.remove(expectedLines)
		if #actualLines == 0 or #expectedLines == 0 then
			break
		end

		a = actualLines[#actualLines]
		b = expectedLines[#expectedLines]
	end

	local maxLines = math.max(#actualLines, #expectedLines)
	-- Strict equal with identical objects that are not identical by reference.
	-- E.g., assert.deepStrictEqual({ a: Symbol() }, { a: Symbol() })
	if maxLines == 0 then
		-- We have to get the result again. The lines were all removed before.
		local actualLines_ = String.split(actualInspected, "\n")

		-- Only remove lines in case it makes sense to collapse those.
		-- TODO: Accept env to always show the full error.
		if #actualLines_ > 50 then
			actualLines_[47] = `{blue}...{white}`
			while #actualLines_ > 47 do
				table.remove(actualLines_)
			end
		end

		return `{kReadableOperator.notIdentical}\n\n{Array.join(actualLines_, "\n")}\n`
	end

	-- There were at least five identical lines at the end. Mark a couple of
	-- skipped.
	if index >= 5 then
		ending = `\n{blue}...{white}{ending}`
		skipped = true
	end

	if other ~= "" then
		ending = `\n  {other}{ending}`
		other = ""
	end

	local printedLines = 0
	local identical = 0
	local msg = kReadableOperator[operator] .. `\n{green}+ actual{white} {red}- expected{white}`
	local skippedMsg = ` {blue}...{white} Lines skipped`

	local lines = actualLines
	local plusMinus = `{green}+{white}`
	local maxLength = #expectedLines
	if #actualLines < maxLines then
		lines = expectedLines
		plusMinus = `{red}-{white}`
		maxLength = #actualLines
	end

	for ii = 1, maxLines do
		index = ii
		if maxLength < ii then
			-- If more than two former lines are identical, print them. Collapse them
			-- in case more than five lines were identical.
			if identical > 2 then
				if identical > 3 then
					if identical > 4 then
						if identical == 5 then
							result ..= `\n  {lines[ii - 3]}`
							printedLines += 1
						else
							result ..= `\n{blue}...{white}`
							skipped = true
						end
					end

					result ..= `\n  {lines[ii - 2]}`
					printedLines += 1
				end

				result ..= `\n  {lines[ii - 1]}`
				printedLines += 1
			end

			-- No identical lines before.
			identical = 0
			-- Add the expected line to the cache.
			if lines == actualLines then
				result ..= `\n{plusMinus} {lines[ii]}`
			else
				other ..= `\n{plusMinus} {lines[ii]}`
			end

			printedLines += 1
			-- Only extra actual lines exist
			-- Lines diverge
		else
			local expectedLine = expectedLines[ii]
			local actualLine = actualLines[ii]
			-- If the lines diverge, specifically check for lines that only diverge by
			-- a trailing comma. In that case it is actually identical and we should
			-- mark it as such.
			local divergingLines = actualLine ~= expectedLine
				and (
					not Boolean.toJSBoolean(String.endsWith(actualLine, ","))
					or String.slice(actualLine, 0, -1) ~= expectedLine
				)
			-- If the expected line has a trailing comma but is otherwise identical,
			-- add a comma at the end of the actual line. Otherwise the output could
			-- look weird as in:
			--
			--   [
			--     1         // No comma at the end!
			-- +   2
			--   ]
			--
			if
				divergingLines
				and String.endsWith(expectedLine, ",")
				and String.slice(expectedLine, 0, -1) == actualLine
			then
				divergingLines = false
				actualLine ..= ","
			end

			if divergingLines then
				-- If more than two former lines are identical, print them. Collapse
				-- them in case more than five lines were identical.
				if identical > 2 then
					if identical > 3 then
						if identical > 4 then
							if identical == 5 then
								result ..= `\n  {actualLines[ii - 3]}`
								printedLines += 1
							else
								result ..= `\n{blue}...{white}`
								skipped = true
							end
						end

						result ..= `\n  {actualLines[ii - 2]}`
						printedLines += 1
					end

					result ..= `\n  {actualLines[ii - 1]}`
					printedLines += 1
				end

				-- No identical lines before.
				identical = 0
				-- Add the actual line to the result and cache the expected diverging
				-- line so consecutive diverging lines show up as +++--- and not +-+-+-.
				result ..= `\n{green}+{white} {actualLine}`
				other ..= `\n{red}-{white} {expectedLine}`
				printedLines += 2
				-- Lines are identical
			else
				-- Add all cached information to the result before adding other things
				-- and reset the cache.
				result ..= other
				other = ""
				identical += 1
				-- The very first identical line since the last diverging line is be
				-- added to the result.
				if identical <= 2 then
					result ..= `\n  {actualLine}`
					printedLines += 1
				end
			end
		end

		-- Inspected object to big (Show ~50 rows max)
		if printedLines > 50 and ii < maxLines - 2 then
			return `{msg}{skippedMsg}\n{result}\n{blue}...{white}{other}\n{blue}...{white}`
		end
	end

	return `{msg}{if skipped then skippedMsg else ""}\n{result}{other}{ending}{indicator}`
end

export type AssertionError = Error & {
	actual: any,
	expected: any,
	operator: string?,
	generatedMessage: boolean,
	code: "ERR_ASSERTION",
	toString: (self: AssertionError) -> any,
	-- ROBLOX deviation: skipped [inpect.custom] method
	-- [inspect.custom]: (self: AssertionError, recurseTimes: any, ctx: any) -> any,
}

type AssertionErrorStatics = {
	new: (options: AssertionErrorOptions) -> AssertionError,
	__index: AssertionError,
	__tostring: (self: AssertionError) -> string,
}

local AssertionError: AssertionError & AssertionErrorStatics = (
	setmetatable({}, {__index = Error}) :: any
) :: AssertionError & AssertionErrorStatics
AssertionError.__index = AssertionError
AssertionError.__tostring = function(self: AssertionError)
	return self:toString()
end

type AssertionErrorOptions = {
	message: string?,
	actual: any?,
	expected: any?,
	-- ROBLOX note: this is optional in definitely-typed, but we always use it in Lua and it's only nil when details is non-nil
	operator: string?,
	stackStartFn: Function?,
}

function AssertionError.new(options: AssertionErrorOptions): AssertionError
	local self: AssertionError
	-- validateObject(options, "options")
	-- stylua: ignore
	local message, operator, stackStartFn =
		options.message, options.operator, options.stackStartFn
	local actual, expected = options.actual, options.expected
	-- ROBLOX deviation START: Error.stackTraceLimit not available in Luau port
	-- local limit = Error.stackTraceLimit
	-- if isErrorStackTraceLimitWritable() then
	-- 	Error.stackTraceLimit = 0
	-- end
	-- ROBLOX deviation END
	if message ~= nil then
		self = (setmetatable(Error.new(tostring(message)), AssertionError) :: any) :: AssertionError
	else
		if process.stderr.isTTY then
			-- Reset on each call to make sure we handle dynamically set environment
			-- variables correct.
			if process.stderr:hasColors() then
				blue = "\u{001b}[34m"
				green = "\u{001b}[32m"
				white = "\u{001b}[39m"
				red = "\u{001b}[31m"
			else
				blue = ""
				green = ""
				white = ""
				red = ""
			end
		end
		-- Prevent the error stack from being visible by duplicating the error
		-- in a very close way to the original in case both sides are actually
		-- instances of Error.
		if
			type(actual) == "table"
			and actual ~= nil
			and type(expected) == "table"
			and expected ~= nil
			and Array.indexOf(Object.keys(actual), "stack") ~= -1
			and instanceof(actual, Error)
			and Array.indexOf(Object.keys(expected), "stack") ~= -1
			and instanceof(expected, Error)
		then
			actual = copyError(actual)
			expected = copyError(expected)
		end

		if operator == "deepStrictEqual" or operator == "strictEqual" then
			self = (
				setmetatable(Error.new(createErrDiff(actual, expected, operator)), AssertionError) :: any
			) :: AssertionError
		elseif operator == "notDeepStrictEqual" or operator == "notStrictEqual" then
			-- In case the objects are equal but the operator requires unequal, show
			-- the first object and say A equals B
			local base = kReadableOperator[operator]
			local res = String.split(inspectValue(actual), "\n")

			-- In case "actual" is an object or a function, it should not be
			-- reference equal.
			if
				operator == "notStrictEqual"
				and (type(actual) == "table" and actual ~= nil or type(actual) == "function")
			then
				base = kReadableOperator.notStrictEqualObject
			end

			-- Only remove lines in case it makes sense to collapse those.
			-- TODO: Accept env to always show the full error.
			if #res > 50 then
				res[47] = `{blue}...{white}`
				while #res > 47 do
					table.remove(res)
				end
			end

			-- Only print a single input.
			if #res == 1 then
				self = (
					setmetatable(Error.new(`{base}{if #res[1] > 5 then "\n\n" else " "}{res[1]}`), AssertionError) :: any
				) :: AssertionError
			else
				self = (
					setmetatable(Error.new(`{base}\n\n{Array.join(res, "\n")}\n`), AssertionError) :: any
				) :: AssertionError
			end
		else
			local res = inspectValue(actual)
			local other = inspectValue(expected)
			local knownOperator = kReadableOperator[tostring(operator)]
			if operator == "notDeepEqual" and res == other then
				res = `{knownOperator}\n\n{res}`
				if #res > 1024 then
					res = `{String.slice(res, 0, 1021)}...`
				end
				self = (setmetatable(Error.new(res), AssertionError) :: any) :: AssertionError
			else
				if #res > 512 then
					res = `{String.slice(res, 0, 509)}...`
				end

				if #other > 512 then
					other = `{String.slice(other, 0, 509)}...`
				end

				if operator == "deepEqual" then
					res = `{knownOperator}\n\n{res}should loosely deep-equal\n\n`
				else
					local newOp = kReadableOperator[`{operator}Unequal`]
					if Boolean.toJSBoolean(newOp) then
						res = `{newOp}\n\n{res}\n\nshould not loosely deep-equal\n\n`
					else
						other = `" {operator} {other}"`
					end
				end

				self = (setmetatable(Error.new(`{res}{other}`), AssertionError) :: any) :: AssertionError
			end
		end
	end
	-- ROBLOX deviation START: Error.stackTraceLimit not available in Luau port
	-- if Boolean.toJSBoolean(isErrorStackTraceLimitWritable()) then
	-- 	Error.stackTraceLimit = limit
	-- end
	-- ROBLOX deviation END
	self.generatedMessage = not Boolean.toJSBoolean(message)
	--[[
		ROBLOX deviation: not using ObjectDefineProperty:
		original code:
		ObjectDefineProperty(self, "name", {
			value = "AssertionError [ERR_ASSERTION]",
			enumerable = false,
			writable = true,
			configurable = true,
		})
	]]
	self.name = "AssertionError [ERR_ASSERTION]"
	self.code = "ERR_ASSERTION"
	-- ROBLOX deviation START: details field not in public API docs, nodejs test suite, or in definitely-typed
	-- if details ~= nil then
	-- 	self.actual = nil
	-- 	self.expected = nil
	-- 	self.operator = ""
	-- 	for i = 1, #details do
	-- 		self["message " .. tostring(i)] = details[i].message
	-- 		self["actual " .. tostring(i)] = details[i].actual
	-- 		self["expected " .. tostring(i)] = details[i].expected
	-- 		self["operator " .. tostring(i)] = details[i].operator
	-- 		self["stack trace " .. tostring(i)] = details[i].stack
	-- 	end
	-- else
	self.actual = actual
	self.expected = expected
	self.operator = operator
	-- end
	-- ROBLOX deviation END
	ErrorCaptureStackTrace(self, stackStartFn or AssertionError.new)
	-- Create error message including the error code in the name.
	--[[
		ROBLOX deviation: Lua doesn't support 'LuaMemberExpression' as a standalone type
		original code:
		this.stack
	]]
	-- Reset the name.
	self.name = "AssertionError"
	return (self :: any) :: AssertionError
end

function AssertionError:toString()
	return `{self.name} [{self.code}]: {self.message}`
end

AssertionError.name = "AssertionError"

return {AssertionError = AssertionError}
