--!optimize 2
--!strict

local Enum = require("@packages/Enum")

export type PolyfillVector3 = typeof(setmetatable(
	{} :: {
		X: number,
		Y: number,
		Z: number,

		Magnitude: number,
		Unit: PolyfillVector3,

		Dot: (self: PolyfillVector3, other: PolyfillVector3) -> number,
		Cross: (self: PolyfillVector3, other: PolyfillVector3) -> PolyfillVector3,
		Lerp: (self: PolyfillVector3, goal: PolyfillVector3, alpha: number) -> PolyfillVector3,
		Abs: (self: PolyfillVector3) -> PolyfillVector3,
		Max: (self: PolyfillVector3, vector3: PolyfillVector3, ...PolyfillVector3) -> PolyfillVector3,
		Min: (self: PolyfillVector3, vector3: PolyfillVector3, ...PolyfillVector3) -> PolyfillVector3,
		Ceil: (self: PolyfillVector3) -> PolyfillVector3,
		Floor: (self: PolyfillVector3) -> PolyfillVector3,
		Sign: (self: PolyfillVector3) -> PolyfillVector3,
		Angle: (self: PolyfillVector3, other: PolyfillVector3, axis: PolyfillVector3?) -> number,
		FuzzyEq: (self: PolyfillVector3, other: PolyfillVector3, epsilon: number?) -> boolean,
	},
	{} :: {
		__add: (self: PolyfillVector3, other: PolyfillVector3) -> PolyfillVector3,
		__sub: (self: PolyfillVector3, other: PolyfillVector3) -> PolyfillVector3,
		__mul: (self: PolyfillVector3, other: PolyfillVector3 | number) -> PolyfillVector3,
		__div: (self: PolyfillVector3, other: PolyfillVector3 | number) -> PolyfillVector3,
		__idiv: (self: PolyfillVector3, other: PolyfillVector3 | number) -> PolyfillVector3,
		__unm: (self: PolyfillVector3) -> PolyfillVector3,

		__eq: (self: PolyfillVector3, other: PolyfillVector3) -> boolean,
		__tostring: (self: PolyfillVector3) -> string,
	}
))
type Private = typeof(setmetatable(
	{} :: {
		X: number,
		Y: number,
		Z: number,
		Vector: vector,

		Magnitude: number,
		Unit: Private,

		Dot: (self: Private, other: Private) -> number,
		Cross: (self: Private, other: Private) -> Private,
		Lerp: (self: Private, goal: Private, alpha: number) -> Private,
		Abs: (self: Private) -> Private,
		Max: (self: Private, vector3: Private, ...Private) -> Private,
		Min: (self: Private, vector3: Private, ...Private) -> Private,
		Ceil: (self: Private) -> Private,
		Floor: (self: Private) -> Private,
		Sign: (self: Private) -> Private,
		Angle: (self: Private, other: Private, axis: Private?) -> number,
		FuzzyEq: (self: Private, other: Private, epsilon: number?) -> boolean,
	},
	{} :: {
		__add: (self: Private, other: Private) -> Private,
		__sub: (self: Private, other: Private) -> Private,
		__mul: (self: Private, other: Private | number) -> Private,
		__div: (self: Private, other: Private | number) -> Private,
		__idiv: (self: Private, other: Private | number) -> Private,
		__unm: (self: Private) -> Private,

		__eq: (self: Private, other: Private) -> boolean,
		__tostring: (self: Private) -> string,
	}
))
type Static = {
	one: PolyfillVector3,
	xAxis: PolyfillVector3,
	yAxis: PolyfillVector3,
	zAxis: PolyfillVector3,
	zero: PolyfillVector3,

	new: (x: number?, y: number?, z: number?) -> PolyfillVector3,
	fromNormalId: (normalId: Enum.NormalId) -> PolyfillVector3,
	FromNormalId: (normalId: Enum.NormalId) -> PolyfillVector3,
}
type PrivateStatic = Static & {
	__index: (self: Private, key: unknown) -> any,
	__newindex: (self: Private, key: unknown) -> never,

	__add: (self: Private, other: Private) -> Private,
	__div: (self: Private, other: Private | number) -> Private,
	__idiv: (self: Private, other: Private | number) -> Private,
	__mul: (self: Private, other: Private | number) -> Private,
	__sub: (self: Private, other: Private) -> Private,
	__unm: (self: Private) -> Private,

	__eq: (self: Private, other: Private) -> boolean,
	__tostring: (self: Private) -> string,
}

local Vector3 = {} :: PolyfillVector3 & Static
local Private = Vector3 :: Private & PrivateStatic

local function FromVector(vector3: vector): Private
	return table.freeze(setmetatable({
		X = vector3.x;
		Y = vector3.y;
		Z = vector3.z;
		Vector = vector3;
		Magnitude = vector.magnitude(vector3);
	}, Vector3) :: any)
end

local function Vector3_new(x: number?, y: number?, z: number?): PolyfillVector3
	return FromVector(vector.create(x or 0, y or 0, z or 0))
end
Vector3.new = Vector3_new
Vector3.zero = Vector3_new()
Vector3.one = Vector3_new(1, 1, 1)
Vector3.xAxis = Vector3_new(1, 0, 0)
Vector3.yAxis = Vector3_new(0, 1, 0)
Vector3.zAxis = Vector3_new(0, 0, 1)

local NORMAL_ID_TO_VECTOR: {[Enum.NormalId]: PolyfillVector3} = {
	[Enum.NormalId.Right] = Vector3.xAxis;
	[Enum.NormalId.Top] = Vector3.yAxis;
	[Enum.NormalId.Back] = Vector3.zAxis;
	[Enum.NormalId.Left] = Vector3_new(-1, 0, 0);
	[Enum.NormalId.Bottom] = Vector3_new(0, -1, 0);
	[Enum.NormalId.Front] = Vector3_new(0, 0, -1);
}

type NormalId = Enum.NormalId | "Right" | "Top" | "Back" | "Left" | "Bottom" | "Front" | number
local function Vector3_fromNormalId(normalId: NormalId): PolyfillVector3
	local castResult = Enum.NormalId:CastResult(normalId)
	if not castResult.Success then
		error(castResult.Error, 2)
	end

	return NORMAL_ID_TO_VECTOR[castResult.Value]
end
Vector3.FromNormalId = Vector3_fromNormalId
Vector3.fromNormalId = Vector3_fromNormalId

function Private:Dot(other: Private): number
	return vector.dot(self.Vector, other.Vector)
end
function Private:Cross(other: Private): Private
	return FromVector(vector.cross(self.Vector, other.Vector))
end
function Vector3:Lerp(goal: PolyfillVector3, alpha: number): PolyfillVector3
	return (1 - alpha) * self + alpha * goal
end

function Private:Abs(): Private
	return FromVector(vector.abs(self.Vector))
end

function Private:Max(...: Private): Private
	local maximum = self.Vector
	for index = 1, select("#", ...) do
		maximum = vector.max(maximum, select(index, ...).Vector)
	end
	return FromVector(maximum)
end
function Private:Min(...: Private): Private
	local minimum = self.Vector
	for index = 1, select("#", ...) do
		minimum = vector.min(minimum, select(index, ...).Vector)
	end
	return FromVector(minimum)
end

function Private:Ceil(): Private
	return FromVector(vector.ceil(self.Vector))
end
function Private:Floor(): Private
	return FromVector(vector.floor(self.Vector))
end

function Private:Sign(): Private
	return FromVector(vector.sign(self.Vector))
end

function Private:Angle(other: Private, axis: Private?): number
	return vector.angle(self.Vector, other.Vector, axis and axis.Vector)
end

local function FuzzyEq(a: number, b: number, epsilon: number?): boolean
	local trueEpsilon = epsilon or 1E-4
	return a - trueEpsilon <= b and b <= a + trueEpsilon
end
function Vector3:FuzzyEq(other: PolyfillVector3, epsilon: number?): boolean
	return FuzzyEq(self.X, other.X, epsilon) and FuzzyEq(self.Y, other.Y, epsilon) and FuzzyEq(self.Z, other.Z, epsilon)
end

function Private:__index(key: unknown): unknown
	if Vector3[key] then
		return Vector3[key]
	end

	if key == "Unit" then
		local unit = FromVector(vector.normalize(self.Vector))
		rawset(self :: any, "Unit", unit)
		return unit
	end

	error(`{key} is not a valid member of Vector3`, 2)
end
function Private:__newindex(key: unknown): never
	error(`{key} cannot be assigned to`, 2)
end

function Private:__add(other: Private): Private
	return FromVector(self.Vector + other.Vector)
end
function Private:__sub(other: Private): Private
	return FromVector(self.Vector - other.Vector)
end
function Private:__mul(other: Private | number): Private
	return FromVector(-self.Vector * (if type(other) == "number" then other else other.Vector))
end
function Private:__div(other: Private | number): Private
	return FromVector(-self.Vector / (if type(other) == "number" then other else other.Vector))
end
function Private:__idiv(other: Private | number): Private
	return FromVector(-self.Vector // (if type(other) == "number" then other else other.Vector))
end
function Private:__unm(): Private
	return FromVector(-self.Vector)
end

function Private:__eq(other: Private): boolean
	return self.Vector == other.Vector
end
function Private:__tostring(): string
	return string.format("%*, %*, %*", self.X, self.Y, self.Z)
end

return table.freeze(Vector3 :: Static)
