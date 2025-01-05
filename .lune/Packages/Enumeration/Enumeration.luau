--!nonstrict
--!optimize 2

local Debug = require("@packages/Debug")
local GreenTea = require("@packages/GreenTea")
local SortedArray = require("@packages/SortedArray")

local ErrorIndex = {}
function ErrorIndex:__index(index)
	Debug.Error(`{index} is not a valid EnumerationItem`)
end

local ErrorIndex2 = {}
function ErrorIndex2:__index(index)
	Debug.Error(`{index} is not a valid member`)
end

local EnumerationsArray = SortedArray.new(nil, function(left, right)
	return tostring(left) < tostring(right)
end)

local Enumerations = setmetatable({}, ErrorIndex)
function Enumerations:GetEnumerations()
	return EnumerationsArray:Copy()
end

local function ReadOnlyNewIndex(_, index)
	Debug.Error("Cannot write to index [%q]", index)
end

local function CompareEnumTypes(enumItem1, enumItem2)
	return enumItem1.Value < enumItem2.Value
end

local Casts = {}
local EnumContainerTemplate = {}
EnumContainerTemplate.__index = setmetatable({}, ErrorIndex)

function EnumContainerTemplate.__index:GetEnumerationItems()
	local array = {}
	local length = 0

	for _, item in EnumContainerTemplate[self] do
		length += 1
		array[length] = item
	end

	table.sort(array, CompareEnumTypes)
	return array
end

function EnumContainerTemplate.__index:Cast(value)
	local castables = Casts[self]
	local cast = castables[value]
	if cast then
		return cast
	end

	return false, `[{Debug.Inspect(value)}] is not a valid {self}`
end

function EnumContainerTemplate.__index:CastResult(value)
	local castables = Casts[self]
	local cast = castables[value]
	if cast then
		return {
			Success = true;
			Value = cast;
		}
	end

	return {
		Success = false;
		Error = `[{Debug.Inspect(value)}] is not a valid {self}`;
	}
end

local function ConstructUserdata(__index, __newindex, __tostring)
	local enum = newproxy(true)

	local enumMetatable = getmetatable(enum)
	enumMetatable.__index = __index
	enumMetatable.__metatable = "[Enumeration] Requested metatable is locked"
	enumMetatable.__newindex = __newindex
	function enumMetatable:__tostring()
		return __tostring
	end

	return enum
end

local function ConstructEnumerationItem(
	name: string,
	value: number,
	enumContainer,
	lockedEnumContainer,
	enumerationStringStub: string,
	castables
)
	local item = ConstructUserdata(setmetatable({
		EnumerationType = lockedEnumContainer;
		Name = name;
		Value = value;
	}, ErrorIndex2), ReadOnlyNewIndex, enumerationStringStub .. name)

	castables[name] = item
	castables[value] = item
	castables[item] = item

	enumContainer[name] = item
end

local IsString = GreenTea.build(GreenTea.string())
local IsEnumTypes = GreenTea.build(GreenTea.union(GreenTea.array(GreenTea.string()), {
	[GreenTea.string()] = GreenTea.number();
}))

local function MakeEnumeration(_, enumType: string, enumTypes: typeof(IsEnumTypes:type())): ()
	do
		local typeSuccess0, typeError0 = IsString:matches(enumType)
		if not typeSuccess0 then
			Debug.Error(tostring(typeError0))
			error(typeError0)
		end
		local typeSuccess1, typeError1 = IsEnumTypes:matches(enumTypes)
		if not typeSuccess1 then
			Debug.Error(tostring(typeError1))
			error(typeError1)
		end
	end

	if rawget(Enumerations, enumType) then
		Debug.Error("Enum of EnumType " .. enumType .. " already exists")
	end

	local castables = {}
	local enumContainer = setmetatable({}, EnumContainerTemplate)
	local lockedEnumContainer = ConstructUserdata(enumContainer, ReadOnlyNewIndex, enumType)
	local enumStringStub = "Enumeration." .. enumType .. "."

	if #enumTypes > 0 then
		for index, typeOf in enumTypes do
			ConstructEnumerationItem(typeOf, index - 1, enumContainer, lockedEnumContainer, enumStringStub, castables)
		end
	else
		for name, value in enumTypes do
			ConstructEnumerationItem(name, value, enumContainer, lockedEnumContainer, enumStringStub, castables)
		end
	end

	Casts[lockedEnumContainer] = castables
	EnumContainerTemplate[lockedEnumContainer] = enumContainer
	EnumerationsArray:Insert(lockedEnumContainer)
	Enumerations[enumType] = lockedEnumContainer
end

return ConstructUserdata(Enumerations, MakeEnumeration, "Enums")
