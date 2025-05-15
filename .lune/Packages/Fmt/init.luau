--!optimize 2
--!strict

local CreateFormatter = require("@self/CreateFormatter")

type Static = typeof(setmetatable(
	{} :: {
		CreateFormatter: typeof(CreateFormatter),
		Debugify: <T>(object: T, fmtFunction: (object: T, ...unknown) -> unknown) -> {[any]: any},
		Fmt: (templateString: string, ...unknown) -> string,
		Format: (templateString: string, ...unknown) -> string,
		Output: (templateString: string, ...unknown) -> ...unknown,
	},
	{} :: {__call: (self: any, templateString: string, ...unknown) -> string}
))

--[=[
	This is a reimplementation of Rust's fmt system.

	```lua
	print(Fmt("{}", "Hi"))
	print(Fmt("{}", {A = 1, B = 1}))
	print(Fmt("{:?}", {A = 1, B = 1}))
	print(Fmt("{:#?}", {A = 1, B = 1}))
	```

	@class Fmt
]=]
local Fmt = {}
Fmt.CreateFormatter = CreateFormatter

--[=[
	Wrap the given object in a type that implements the given function as its
	debug implementation, and forwards __tostring to the type's underlying
	tostring implementation.

	@param object T -- The object to debugify.
	@param fmtFunction (object: T, ...: unknown) -> unknown -- The fmt function.
	@return DebugObject
]=]
function Fmt.Debugify<T>(object: T, fmtFunction: (object: T, ...unknown) -> unknown)
	return setmetatable({}, {
		__FmtDebug = function(_, ...)
			return fmtFunction(object, ...)
		end;

		__tostring = function()
			return tostring(object)
		end;
	})
end

--[=[
	Formats the given TemplateString. This also works with `__call`.

	```lua
	print(Fmt("{}", "Hi")) -- Hi
	print(Fmt("{}", {A = 1, B = 1})) -- table: 0x3911424e137a940d
	print(Fmt("{:?}", {A = 1, B = 1})) -- {["A"] = 1, ["B"] = 2}
	print(Fmt("{:#?}", {A = 1, B = 1}))
	--[[
	{
		["A"] = 1,
		["B"] = 2
	}
	--]]

	print(Fmt("Hello, {Value}!", {
		Value = "world";
	})) -- Hello, world!

	print(Fmt("{1} {} {0} {}", 1, 2)) -- 2 1 1 2
	```

	@param templateString string -- The template string to format with.
	@param ...unknown -- The arguments to format with.
	@return string -- The formatted string.
]=]
function Fmt.Fmt(templateString: string, ...: unknown)
	local formatter = CreateFormatter()
	formatter("Write", templateString, ...)
	return formatter("AsString")
end

Fmt.Format = Fmt.Fmt

--[=[
	Returns a tuple of the formatted output.

	@param TemplateString string -- The template string to format with.
	@param ...unknown -- The arguments to format with.
	@return ...unknown -- The tuple.
]=]
function Fmt.Output(templateString: string, ...: unknown): ...unknown
	local formatter = CreateFormatter()
	formatter("Write", templateString, ...)
	return formatter("AsTuple")
end

local Metatable = {}
function Metatable:__call(templateString: string, ...: unknown)
	local formatter = CreateFormatter()
	formatter("Write", templateString, ...)
	return formatter("AsString")
end

return (table.freeze(setmetatable(Fmt, Metatable)) :: never) :: Static
