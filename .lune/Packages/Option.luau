--!optimize 2
--!strict

-- Option
-- Stephen Leitnick
-- August 28, 2020

local Option = {}
Option.ClassName = "Option"
Option.__index = Option

export type VoidOption = {
	IsNotNull: boolean,
	Value: any | any?,

	Match: <V>(self: VoidOption, onSome: (value: any) -> V, onNone: () -> V) -> V,
	MatchVoid: (self: VoidOption, onSome: (value: any) -> (), onNone: () -> ()) -> (),

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

	Match: <V>(self: VoidOption, onSome: (value: T) -> V, onNone: () -> V) -> V,
	MatchVoid: (self: VoidOption, onSome: (value: T) -> (), onNone: () -> ()) -> (),

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

local function Option_Some<T>(value: T): Option<T>
	assert(value ~= nil, "Option.Some() value cannot be nil")
	return Option_new(value)
end
Option.Some = Option_Some

function Option.Wrap<T>(value: T?): Option<T>
	return if value == nil then Option.None else Option_Some(value)
end

function Option.TypedNone<T>(): Option<T>
	return Option.None :: never
end

local function Option_Is(value: any)
	return type(value) == "table" and getmetatable(value) == Option
end
Option.Is = Option_Is

local function Option_Assert<T>(object: unknown): Option<T>
	assert(Option_Is(object), "Result was not of type Option")
	return object :: never
end
Option.Assert = Option_Assert

function Option:Match(onSome, onNone)
	assert(type(onSome) == "function", "Missing 'Some' match")
	assert(type(onNone) == "function", "Missing 'None' match")

	if self.IsNotNull then
		return onSome(self:Expect("Cannot unwrap option of None type"))
	end

	return onNone()
end
function Option:MatchVoid(onSome, onNone)
	assert(type(onSome) == "function", "Missing 'Some' match")
	assert(type(onNone) == "function", "Missing 'None' match")

	if self.IsNotNull then
		onSome(self:Expect("Cannot unwrap option of None type"))
	else
		onNone()
	end
end

function Option:IsSome()
	return self.IsNotNull
end

function Option:IsNone()
	return not self.IsNotNull
end

function Option:Expect(message: string)
	assert(self.IsNotNull, message)
	return self.Value
end

function Option:ExpectNone(message: string)
	assert(not self.IsNotNull, message)
end

function Option:Unwrap()
	assert(self.IsNotNull, "Cannot unwrap option of None type")
	return self.Value
end

function Option:UnwrapOr(default)
	return if self.IsNotNull then self:Expect("Cannot unwrap option of None type") else default
end

function Option:AsPointer()
	return self.Value
end

function Option:UnwrapOrElse(getDefault)
	if self.IsNotNull then
		return self:Expect("Cannot unwrap option of None type")
	end

	return getDefault()
end

function Option:And(otherOption)
	return if self.IsNotNull then otherOption else Option.None
end

function Option:AndThen(thenFunction)
	return if self.IsNotNull
		then Option_Assert(thenFunction(self:Expect("Cannot unwrap option of None type")))
		else Option.None
end

function Option:Or(otherOption)
	return if self.IsNotNull then self else otherOption
end

function Option:OrElse(getOther)
	return if self.IsNotNull then self else Option_Assert(getOther())
end

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

function Option:Filter(predicate)
	return if not self.IsNotNull or not predicate(self.Value) then Option.None else self
end

function Option:Contains(value)
	return self.IsNotNull and self.Value == value
end

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

Option.None = Option_new() :: Option<any>

return table.freeze(Option)
