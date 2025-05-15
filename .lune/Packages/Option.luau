--!nonstrict
--!optimize 2

-- Option
-- Stephen Leitnick
-- August 28, 2020

--[[
	MatchTable {
		Some: (value: any) -> any
		None: () -> any
	}

	CONSTRUCTORS:
		Option.Some(anyNonNilValue): Option<any>
		Option.Wrap(anyValue): Option<any>

	STATIC FIELDS:
		Option.None: Option<None>

	STATIC METHODS:
		Option.Is(obj): boolean

	METHODS:
		opt:Match(): (matches: MatchTable) -> any
		opt:IsSome(): boolean
		opt:IsNone(): boolean
		opt:Unwrap(): any
		opt:Expect(errMsg: string): any
		opt:ExpectNone(errMsg: string): void
		opt:UnwrapOr(default: any): any
		opt:UnwrapOrElse(default: () -> any): any
		opt:And(opt2: Option<any>): Option<any>
		opt:AndThen(predicate: (unwrapped: any) -> Option<any>): Option<any>
		opt:Or(opt2: Option<any>): Option<any>
		opt:OrElse(orElseFunc: () -> Option<any>): Option<any>
		opt:XOr(opt2: Option<any>): Option<any>
		opt:Contains(value: any): boolean

	--------------------------------------------------------------------

	Options are useful for handling nil-value cases. Any time that an
	operation might return nil, it is useful to instead return an
	Option, which will indicate that the value might be nil, and should
	be explicitly checked before using the value. This will help
	prevent common bugs caused by nil values that can fail silently.

	Example:

	local result1 = Option.Some(32)
	local result2 = Option.Some(nil)
	local result3 = Option.Some("Hi")
	local result4 = Option.Some(nil)
	local result5 = Option.None

	-- Use 'Match' to match if the value is Some or None:
	result1:Match {
		Some = function(value) print(value) end;
		None = function() print("No value") end;
	}

	-- Raw check:
	if result2:IsSome() then
		local value = result2:Unwrap() -- Explicitly call Unwrap
		print("Value of result2:", value)
	end

	if result3:IsNone() then
		print("No result for result3")
	end

	-- Bad, will throw error bc result4 is none:
	local value = result4:Unwrap()
--]]

--[=[
	Represents an optional value in Lua. This is useful to avoid `nil` bugs, which can
	go silently undetected within code and cause hidden or hard-to-find bugs.
	@class Option
]=]
local Option = {}
Option.ClassName = "Option"
Option.__index = Option

type Matches<T = unknown, V = unknown> = {
	Some: (value: T) -> V,
	None: () -> V,
}
type VoidMatches<T = unknown> = {
	Some: (value: T) -> (),
	None: () -> (),
}

type Serialized<T = unknown> = {
	ClassName: number,
	Value: T | T?,
}

export type VoidOption = {
	IsNotNull: boolean,
	Value: any | any?,

	Match: <V>(self: VoidOption, matches: Matches<any, any>) -> any,
	FastMatch: <V>(self: VoidOption, onSome: (value: any) -> any, onNone: () -> any) -> any,
	FastMatchVoid: (self: VoidOption, onSome: (value: any) -> (), onNone: () -> ()) -> (),

	IsSome: (self: VoidOption) -> boolean,
	IsNone: (self: VoidOption) -> boolean,

	Expect: (self: VoidOption, message: string) -> any,
	ExpectNone: (self: VoidOption, message: string) -> (),

	Unwrap: (self: VoidOption) -> any,
	UnwrapOr: (self: VoidOption, defaultValue: any) -> any,
	UnwrapOrElse: (self: VoidOption, getDefault: () -> any) -> any,

	And: (self: VoidOption, otherOption: VoidOption) -> VoidOption,
	AndThen: (self: VoidOption, getOther: (value: any) -> VoidOption) -> VoidOption,
	Or: (self: VoidOption, otherOption: VoidOption) -> VoidOption,
	OrElse: (self: VoidOption, getOther: () -> VoidOption) -> VoidOption,

	AsPointer: (self: VoidOption) -> any?,
}

export type Option<T> = {
	IsNotNull: boolean,
	Value: T | T?,

	-- Match: (<V>(self: Option<T>, Matches: Matches<T, V>) -> V) & ((self: Option<T>, Matches: VoidMatches<T>) -> ()),
	-- FastMatch: (<V>(self: Option<T>, OnSome: (Value: T) -> V, OnNone: () -> V) -> V)
	-- 	& ((self: Option<T>, OnSome: (Value: T) -> (), OnNone: () -> ()) -> ()),
	Match: <V>(self: VoidOption, matches: Matches<T, V>) -> V,
	FastMatch: <V>(self: VoidOption, onSome: (value: T) -> V, onNone: () -> V) -> V,
	FastMatchVoid: (self: VoidOption, onSome: (value: T) -> (), onNone: () -> ()) -> (),

	IsSome: (self: VoidOption) -> boolean,
	IsNone: (self: VoidOption) -> boolean,

	Expect: (self: VoidOption, message: string) -> T,
	ExpectNone: (self: VoidOption, message: string) -> (),

	Unwrap: (self: VoidOption) -> T,
	UnwrapOr: (self: VoidOption, defaultValue: T) -> T,
	UnwrapOrElse: (self: VoidOption, getDefault: () -> T) -> T,

	And: (self: VoidOption, otherOption: VoidOption) -> VoidOption,
	AndThen: (self: VoidOption, getOther: (value: T) -> VoidOption) -> VoidOption,
	Or: (self: VoidOption, otherOption: VoidOption) -> VoidOption,
	OrElse: (self: VoidOption, getOther: () -> VoidOption) -> VoidOption,

	AsPointer: (self: VoidOption) -> T?,
}

local function Option_new<T>(value: T?): Option<T>
	return setmetatable({
		IsNotNull = value ~= nil;
		Value = value;
	}, Option) :: never
end

--[=[
	Creates an Option instance with the given value. Throws an error
	if the given value is `nil`.

	@function Some
	@within Option

	@param value T
	@return Option<T>
]=]
local function Option_Some<T>(value: T)
	assert(value ~= nil, "Option.Some() value cannot be nil")
	return Option_new(value)
end
Option.Some = Option_Some

--[=[
	Safely wraps the given value as an option. If the
	value is `nil`, returns `Option.None`, otherwise
	returns `Option.Some(value)`.

	@param value T
	@return Option<T> | Option<None>
]=]
function Option.Wrap<T>(value: T?): Option<T>
	return if value == nil then Option.None else Option_Some(value)
end

--[=[
	Returns `true` if `obj` is an Option.

	@function Is
	@within Option

	@param value any
	@return boolean
]=]
local function Option_Is(value)
	return type(value) == "table" and getmetatable(value) == Option
end
Option.Is = Option_Is

--[=[
	Throws an error if `obj` is not an Option.

	@function Assert
	@within Option

	@param object unknown
	return Option<T>
]=]
local function Option_Assert<T>(object: unknown): Option<T>
	assert(Option_Is(object), "Result was not of type Option")
	return object :: never
end
Option.Assert = Option_Assert

--[=[
	Matches against the option.

	```lua
	local opt = Option.Some(32)
	opt:Match {
		Some = function(num) print("Number", num) end,
		None = function() print("No value") end,
	}
	```

	@param matches {Some: (value: any) -> any, None: () -> any}
	@return any
]=]
function Option:Match(matches: Matches)
	local onSome = matches.Some
	local onNone = matches.None
	assert(type(onSome) == "function", "Missing 'Some' match")
	assert(type(onNone) == "function", "Missing 'None' match")

	if self.IsNotNull then
		return onSome(self:Expect("Cannot unwrap option of None type"))
	end

	return onNone()
end

--[=[
	Matches against the option.

	```lua
	Option.Some(32):FastMatch(function(Number)
		print("Number", Number)
	end, function()
		print("No value.")
	end)
	```

	@param onSome (value: T) -> U -- The OnSome function.
	@param onNone () -> U -- The OnNone function.
	@return U
]=]
function Option:FastMatch(onSome, onNone)
	assert(type(onSome) == "function", "Missing 'Some' match")
	assert(type(onNone) == "function", "Missing 'None' match")

	if self.IsNotNull then
		return onSome(self:Expect("Cannot unwrap option of None type"))
	end

	return onNone()
end
function Option:FastMatchVoid(onSome, onNone)
	assert(type(onSome) == "function", "Missing 'Some' match")
	assert(type(onNone) == "function", "Missing 'None' match")

	if self.IsNotNull then
		onSome(self:Expect("Cannot unwrap option of None type"))
	else
		onNone()
	end
end

--[=[
	Returns `true` if the option has a value.
	@return boolean
]=]
function Option:IsSome()
	return self.IsNotNull
end

--[=[
	Returns `true` if the option is None.
	@return boolean
]=]
function Option:IsNone()
	return not self.IsNotNull
end

--[=[
	Unwraps the value in the option, otherwise throws an error with `message` as the error message.

	```lua
	local opt = Option.Some(10)
	print(opt:Expect("No number")) -> 10
	print(Option.None:Expect("No number")) -- Throws an error "No number"
	```

	@param message string
	@return T
]=]
function Option:Expect(message: string)
	assert(self.IsNotNull, message)
	return self.Value
end

--[=[
	Throws an error with `message` as the error message if the value is _not_ None.
	@param message string
]=]
function Option:ExpectNone(message: string)
	assert(not self.IsNotNull, message)
end

--[=[
	Returns the value in the option, or throws an error if the option is None.
	@return T
]=]
function Option:Unwrap()
	assert(self.IsNotNull, "Cannot unwrap option of None type")
	return self.Value
end

--[=[
	If the option holds a value, returns the value. Otherwise, returns `default`.
	@param default T
	@return T
]=]
function Option:UnwrapOr(default)
	return if self.IsNotNull then self:Expect("Cannot unwrap option of None type") else default
end

function Option:AsPointer()
	return self.Value
end

--[=[
	If the option holds a value, returns the value. Otherwise, returns the
	result of the `defaultFn` function.

	@param getDefault () -> T
	@return T
]=]
function Option:UnwrapOrElse(getDefault)
	if self.IsNotNull then
		return self:Expect("Cannot unwrap option of None type")
	end

	return getDefault()
end

--[=[
	Returns `OptionB` if the calling option has a value,
	otherwise returns None.

	```lua
	local optionA = Option.Some(32)
	local OptionB = Option.Some(64)
	local opt = optionA:And(OptionB)
	-- opt == OptionB

	local optionA = Option.None
	local OptionB = Option.Some(64)
	local opt = optionA:And(OptionB)
	-- opt == Option.None
	```

	@param otherOption Option
	@return Option
]=]
function Option:And(otherOption)
	return if self.IsNotNull then otherOption else Option.None
end

--[=[
	If the option holds a value, then the `ThenFunction`
	function is called with the held value of the option,
	and then the resultant Option returned by the `ThenFunction`
	is returned. Otherwise, None is returned.

	```lua
	local optA = Option.Some(32)
	local optB = optA:AndThen(function(num)
		return Option.Some(num * 2)
	end)

	print(optB:Expect("Expected number")) --> 64
	```

	@param thenFunction (value: T) -> Option<U>
	@return Option<U>
]=]
function Option:AndThen(thenFunction)
	return if self.IsNotNull
		then Option_Assert(thenFunction(self:Expect("Cannot unwrap option of None type")))
		else Option.None
end

--[=[
	If caller has a value, returns itself. Otherwise, returns `otherOption`.
	@param otherOption Option<T>
	@return Option<U>
]=]
function Option:Or(otherOption)
	return if self.IsNotNull then self else otherOption
end

--[=[
	If caller has a value, returns itself. Otherwise, returns the
	option generated by the `getOther` function.

	@param getOther () -> Option<T>
	@return Option<T>
]=]
function Option:OrElse(getOther)
	return if self.IsNotNull then self else Option_Assert(getOther())
end

--[=[
	If both `self` and `OptionB` have values _or_ both don't have a value,
	then this returns None. Otherwise, it returns the option that does have
	a value.

	@param otherOption Option<T>
	@return Option<T>
]=]
function Option:XOr(otherOption)
	local someSelf = self.IsNotNull
	local someOtherOption = otherOption.IsNotNull
	if someSelf == someOtherOption then
		return Option.None
	end

	if someSelf then
		return self
	end

	return otherOption
end

--[=[
	Returns `self` if this option has a value and the predicate returns `true.
	Otherwise, returns None.

	@param predicate (Value: T) -> boolean
	@return Option<T>
]=]
function Option:Filter(predicate)
	return if not self.IsNotNull or not predicate(self.Value) then Option.None else self
end

--[=[
	Returns `true` if this option contains `value`.
	@param value any
	@return boolean
]=]
function Option:Contains(value)
	return self.IsNotNull and self.Value == value
end

--[=[
	Metamethod to transform the option into a string.

	```lua
	local optA = Option.Some(64)
	local optB = Option.None
	print(optA) --> Option<number>
	print(optB) --> Option<None>
	```

	@return string
]=]
function Option:__tostring()
	if self.IsNotNull then
		local typeOf = typeof(self.Value)
		if typeOf == "table" then
			local asString = tostring(self.Value)
			if string.sub(asString, 1, 7) ~= "table: " then
				return `Option<{asString}>`
			end
		elseif typeOf == "userdata" then
			local asString = tostring(self.Value)
			if string.sub(asString, 1, 10) ~= "userdata: " then
				return `Option<{asString}>`
			end
		end

		return `Option<{typeOf}>`
	end

	return "Option<None>"
end

--[=[
	Metamethod to check equality between two options. Returns `true` if both
	options hold the same value _or_ both options are None.

	```lua
	local o1 = Option.Some(32)
	local o2 = Option.Some(32)
	local o3 = Option.Some(64)
	local o4 = Option.None
	local o5 = Option.None

	print(o1 == o2) --> true
	print(o1 == o3) --> false
	print(o1 == o4) --> false
	print(o4 == o5) --> true
	```

	@param optionB Option
	@return boolean
]=]
function Option:__eq(optionB)
	if Option_Is(optionB) then
		if self.IsNotNull and optionB.IsNotNull then
			return self:Expect("Cannot unwrap option of None type")
				== optionB:Expect("Cannot unwrap option of None type")
		end

		if not self.IsNotNull and not optionB.IsNotNull then
			return true
		end
	end

	return false
end

--[=[
	Represents no value.
	@prop None Option<None>
	@within Option
]=]
Option.None = Option_new()

--export type Option<T = any> = typeof(Option._new())

return table.freeze(Option)
