--!optimize 2
--!strict

local GreenTea = require("./GreenTea")

local t = {}

type Typechecker = (...any) -> (boolean, any?)

type TypecheckerConstr<T... = ()> = (T...) -> Typechecker

local function asPlainFn(fn: (...any) -> ...any): Typechecker
	return function()
		return fn()
	end
end

local function asGreenTeaType(thing: any): any
	if GreenTea.isGtType(thing) then
		return thing
	end

	if type(thing) == "function" then
		return GreenTea.custom(thing)
	end

	if thing == nil then
		return GreenTea.none()
	end

	return GreenTea.typeof(thing)
end

local implicitConstructors = {
	boolean = GreenTea.boolean :: Typechecker;
	buffer = (GreenTea.buffer :: any) :: Typechecker;
	callback = (GreenTea.anyfn :: any) :: Typechecker;
	["function"] = (GreenTea.anyfn :: any) :: Typechecker;
	none = (GreenTea.none :: any) :: Typechecker;
	["nil"] = (GreenTea.none :: any) :: Typechecker;
	string = asPlainFn(GreenTea.string);
	table = asPlainFn(GreenTea.anyTable);
	userdata = asPlainFn(GreenTea.userdata);
	number = asPlainFn(GreenTea.number);
	thread = asPlainFn(GreenTea.coroutine);
	any = function()
		return GreenTea.any()
	end :: Typechecker;
	nan = function()
		return GreenTea.withCustom(GreenTea.number({nan = true}), function(item)
			return item ~= item
		end) :: any
	end :: Typechecker;
	integer = function()
		return GreenTea.number({integer = true}) :: any
	end :: Typechecker;
	numberPositive = function()
		return GreenTea.number({range = "(0, inf]"}) :: any
	end :: Typechecker;
	numberNegative = function()
		return GreenTea.number({range = "[-inf, 0)"}) :: any
	end :: Typechecker;
}

t.type = function(typename: string): any
	return GreenTea.isType(typename)
end :: TypecheckerConstr<string>

t.typeof = function(typename: string): any
	return GreenTea.isTypeof(typename)
end :: TypecheckerConstr<string>

t.literal = function(...: any): any
	local count = select("#", ...)
	if count == 0 then
		return GreenTea.any()
	end

	if count == 1 then
		return GreenTea.literal(...)
	end

	local literals = {}
	for index = 1, count do
		table.insert(literals, GreenTea.literal(select(index, ...)))
	end

	return GreenTea.union(table.unpack(literals))
end :: TypecheckerConstr<...any>

t.exactly = t.literal

t.keyOf = function(keyType: {[any]: any}): any
	local union = {}
	for key in next, keyType do
		table.insert(union, GreenTea.literal(key))
	end
	return GreenTea.union(table.unpack(union))
end :: TypecheckerConstr<{[any]: any}>

t.valueOf = function(valueType: {[any]: any}): any
	local union = {}
	for _, value in next, valueType do
		table.insert(union, GreenTea.typeof(value))
	end
	return GreenTea.union(table.unpack(union))
end :: TypecheckerConstr<{[any]: any}>

t.optional = function(thins: any): any
	return GreenTea.optional(asGreenTeaType(thins))
end :: TypecheckerConstr<any>

t.tuple = function(...: any): any
	local tupleArgs = table.pack(...)
	for index = 1, tupleArgs.n do
		tupleArgs[index] = asGreenTeaType(tupleArgs[index])
	end

	return GreenTea.tuple(table.unpack(tupleArgs))
end :: TypecheckerConstr<...any>

t.union = function(...: any)
	local unionArgs = table.pack(...)
	for index = 1, unionArgs.n do
		unionArgs[index] = asGreenTeaType(unionArgs[index])
	end
	return GreenTea.union(table.unpack(unionArgs))
end :: TypecheckerConstr<...any>

t.some = t.union

t.intersection = function(...: any): any
	local intersectionArgs = table.pack(...)
	for index = 1, intersectionArgs.n do
		intersectionArgs[index] = asGreenTeaType(intersectionArgs[index])
	end
	return GreenTea.intersection(table.unpack(intersectionArgs))
end :: TypecheckerConstr<...any>

t.every = t.intersection

t.keys = function(check: any): any
	return GreenTea.dictionary(asGreenTeaType(check), GreenTea.any())
end :: TypecheckerConstr<any>

t.values = function(check: any): any
	return GreenTea.dictionary(GreenTea.any(), asGreenTeaType(check))
end :: TypecheckerConstr<any>

t.map = function(key: any, value: any): any
	return GreenTea.dictionary(asGreenTeaType(key), asGreenTeaType(value))
end :: TypecheckerConstr<any, any>

t.set = function(key: any): any
	return GreenTea.dictionary(asGreenTeaType(key), GreenTea.literal(true))
end :: TypecheckerConstr<any>

t.numberMin = function(min: number): any
	return GreenTea.number({range = `[{min}, inf]`})
end :: TypecheckerConstr<number>
t.numberMax = function(max: number): any
	return GreenTea.number({range = `[-inf, {max}]`})
end :: TypecheckerConstr<number>
t.numberConstrained = function(min: number, max: number): any
	return GreenTea.number({range = `[{min}, {max}]`})
end :: TypecheckerConstr<number, number>
t.numberMinExclusive = function(min: number): any
	return GreenTea.number({range = `({min}, inf]`})
end :: TypecheckerConstr<number>
t.numberMaxExclusive = function(max: number): any
	return GreenTea.number({range = `[-inf, {max})`})
end :: TypecheckerConstr<number>
t.numberConstrainedExclusive = function(min: number, max: number): any
	return GreenTea.number({range = `({min}, {max})`})
end :: TypecheckerConstr<number, number>

t.match = function(pattern: string): any
	return GreenTea.string({pattern = pattern})
end :: TypecheckerConstr<string>

t.array = function(typechecker): any
	return GreenTea.array(asGreenTeaType(typechecker))
end :: TypecheckerConstr<any>

t.strictArray = function(...: any): any
	local arrayTypes = {...}
	arrayTypes[GreenTea.any()] = GreenTea.never()

	local count = select("#", ...)
	for index = 1, count do
		arrayTypes[index] = asGreenTeaType(arrayTypes[index])
	end

	return GreenTea.table(arrayTypes, {raw = true, count = {min = 0, max = count}})
end :: TypecheckerConstr<...any>

t.interface = function(interface: {[any]: any}): any
	local interfaceCleaned = {}
	for key, value in next, interface do
		interfaceCleaned[key] = asGreenTeaType(value)
	end

	return GreenTea.table(interfaceCleaned, {raw = true})
end :: TypecheckerConstr<{[any]: any}>

t.strictInterface = function(interface: {[string]: any}): any
	local interfaceCleaned = {}
	for key, value in next, interface do
		interfaceCleaned[key] = asGreenTeaType(value)
	end

	interfaceCleaned[GreenTea.any()] = GreenTea.never()

	return GreenTea.table(interfaceCleaned, {raw = true})
end :: TypecheckerConstr<{[string]: any}>

t.wrap = function<Args..., Returns...>(fn: (Args...) -> Returns..., argsCheck: any): (Args...) -> Returns...
	local argsChecker: GreenTea.Type = asGreenTeaType(argsCheck)
	return function(...: any)
		argsChecker:assert(...)

		return fn(...)
	end
end

t.strict = function<T>(typechecker: T): T
	local castTypechecker = asGreenTeaType(typechecker)
	return function(...)
		castTypechecker:assert(...)
	end :: any
end

type exportedTypes = typeof(t) & typeof(implicitConstructors)

local exportedRuntime = setmetatable(t :: any, {
	__index = function(_self, key)
		if implicitConstructors[key] then
			return implicitConstructors[key]()
		else
			return nil
		end
	end;
})

return exportedRuntime :: exportedTypes
