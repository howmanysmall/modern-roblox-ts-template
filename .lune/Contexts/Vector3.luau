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
		Max: (self: PolyfillVector3, vector3: PolyfillVector3, ...Vector3) -> PolyfillVector3,
		Min: (self: PolyfillVector3, vector3: PolyfillVector3, ...Vector3) -> PolyfillVector3,
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
type Static = {
	one: PolyfillVector3,
	xAxis: PolyfillVector3,
	yAxis: PolyfillVector3,
	zAxis: PolyfillVector3,
	zero: PolyfillVector3,

	new: (x: number?, y: number?, z: number?) -> PolyfillVector3,
	fromNormalId: (normalId: Enum.NormalIdItem) -> PolyfillVector3,
	FromNormalId: (normalId: Enum.NormalIdItem) -> PolyfillVector3,
}
type PrivateStatic = Static & {
	__index: (self: PolyfillVector3, key: unknown) -> any,
	__newindex: (self: PolyfillVector3, key: unknown) -> never,

	__add: (self: PolyfillVector3, other: PolyfillVector3) -> PolyfillVector3,
	__div: (self: PolyfillVector3, other: PolyfillVector3 | number) -> PolyfillVector3,
	__idiv: (self: PolyfillVector3, other: PolyfillVector3 | number) -> PolyfillVector3,
	__mul: (self: PolyfillVector3, other: PolyfillVector3 | number) -> PolyfillVector3,
	__sub: (self: PolyfillVector3, other: PolyfillVector3) -> PolyfillVector3,
	__unm: (self: PolyfillVector3) -> PolyfillVector3,

	__eq: (self: PolyfillVector3, other: PolyfillVector3) -> boolean,
	__tostring: (self: PolyfillVector3) -> string,
}

local Vector3 = {} :: PolyfillVector3 & Static
local Private = Vector3 :: PolyfillVector3 & PrivateStatic

local function Vector3_new(x: number?, y: number?, z: number?)
	local trueX = x or 0
	local trueY = y or 0
	local trueZ = z or 0
	return table.freeze(setmetatable({
		Magnitude = math.sqrt(trueX ^ 2 + trueY ^ 2 + trueZ ^ 2);
		X = trueX;
		Y = trueY;
		Z = trueZ;
	}, Vector3)) :: never
end
Vector3.new = Vector3_new
Vector3.zero = Vector3_new()
Vector3.one = Vector3_new(1, 1, 1)
Vector3.xAxis = Vector3_new(1, 0, 0)
Vector3.yAxis = Vector3_new(0, 1, 0)
Vector3.zAxis = Vector3_new(0, 0, 1)

local NORMAL_ID_TO_VECTOR: {[Enum.NormalIdItem]: PolyfillVector3} = {
	[Enum.NormalId.Right] = Vector3.xAxis;
	[Enum.NormalId.Top] = Vector3.yAxis;
	[Enum.NormalId.Back] = Vector3.zAxis;
	[Enum.NormalId.Left] = Vector3_new(-1, 0, 0);
	[Enum.NormalId.Bottom] = Vector3_new(0, -1, 0);
	[Enum.NormalId.Front] = Vector3_new(0, 0, -1);
}

type NormalId = Enum.NormalIdItem | "Right" | "Top" | "Back" | "Left" | "Bottom" | "Front" | number
local function Vector3_fromNormalId(normalId: NormalId): PolyfillVector3
	local castResult = Enum.NormalId:CastResult(normalId)
	if not castResult.Success then
		error(castResult.Error, 2)
	end

	return NORMAL_ID_TO_VECTOR[castResult.Value]
end
Vector3.FromNormalId = Vector3_fromNormalId
Vector3.fromNormalId = Vector3_fromNormalId

function Vector3:Dot(other)
	return self.X * other.X + self.Y * other.Y + self.Z * other.Z
end
function Vector3:Cross(other)
	return Vector3_new(
		self.Y * other.Z - self.Z * other.Y,
		self.Z * other.X - self.X * other.Z,
		self.X * other.Y - self.Y * other.X
	)
end
function Vector3:Lerp(goal, alpha)
	return (1 - alpha) * self + alpha * goal
end

function Vector3:Abs()
	return Vector3_new(math.abs(self.X), math.abs(self.Y), math.abs(self.Z))
end

function Vector3:Max(...)
	local maximumX = self.X
	local maximumY = self.Y
	local maximumZ = self.Z

	for index = 1, select("#", ...) do
		local vector3 = select(index, ...)
		maximumX = math.max(maximumX, vector3.X)
		maximumY = math.max(maximumY, vector3.Y)
		maximumZ = math.max(maximumZ, vector3.Z)
	end

	return Vector3_new(maximumX, maximumY, maximumZ)
end
function Vector3:Min(...)
	local minimumX = self.X
	local minimumY = self.Y
	local minimumZ = self.Z

	for index = 1, select("#", ...) do
		local vector3 = select(index, ...)
		minimumX = math.min(minimumX, vector3.X)
		minimumY = math.min(minimumY, vector3.Y)
		minimumZ = math.min(minimumZ, vector3.Z)
	end

	return Vector3_new(minimumX, minimumY, minimumZ)
end

function Vector3:Ceil()
	return Vector3_new(math.ceil(self.X), math.ceil(self.Y), math.ceil(self.Z))
end
function Vector3:Floor()
	return Vector3_new(math.floor(self.X), math.floor(self.Y), math.floor(self.Z))
end

function Vector3:Sign()
	return Vector3_new(math.sign(self.X), math.sign(self.Y), math.sign(self.Z))
end

function Vector3:Angle(other, axis)
	local selfMagnitude = self.Magnitude
	local otherMagnitude = other.Magnitude

	if selfMagnitude == 0 or otherMagnitude == 0 then
		return 0
	end

	local dot = math.clamp(self:Dot(other) / (selfMagnitude * otherMagnitude), -1, 1)
	local angle = math.acos(dot)

	if axis and axis:Dot(self:Cross(other)) < 0 then
		angle = -angle
	end

	return angle
end

local function FuzzyEq(a: number, b: number, epsilon: number?)
	local trueEpsilon = epsilon or 1E-4
	return a - trueEpsilon <= b and b <= a + trueEpsilon
end
function Vector3:FuzzyEq(other, epsilon)
	return FuzzyEq(self.X, other.X, epsilon) and FuzzyEq(self.Y, other.Y, epsilon) and FuzzyEq(self.Z, other.Z, epsilon)
end

function Private:__index(key)
	if Vector3[key] then
		return Vector3[key]
	end

	if key == "Unit" then
		return self / self.Magnitude
	end

	error(`{key} is not a valid member of Vector3`, 2)
end
function Private:__newindex(key)
	error(`{key} cannot be assigned to`, 2)
end

function Private:__add(other)
	return Vector3_new(self.X + other.X, self.Y + other.Y, self.Z + other.Z)
end
function Private:__sub(other)
	return Vector3_new(self.X - other.X, self.Y - other.Y, self.Z - other.Z)
end
function Private:__mul(other)
	if type(other) == "number" then
		return Vector3_new(self.X * other, self.Y * other, self.Z * other)
	end

	return Vector3_new(self.X * other.X, self.Y * other.Y, self.Z * other.Z)
end
function Private:__div(other)
	if type(other) == "number" then
		return Vector3_new(self.X / other, self.Y / other, self.Z / other)
	end

	return Vector3_new(self.X / other.X, self.Y / other.Y, self.Z / other.Z)
end
function Private:__idiv(other)
	if type(other) == "number" then
		return Vector3_new(self.X // other, self.Y // other, self.Z // other)
	end

	return Vector3_new(self.X // other.X, self.Y // other.Y, self.Z // other.Z)
end
function Private:__unm()
	return Vector3_new(-self.X, -self.Y, -self.Z)
end

function Private:__eq(other)
	return self.X == other.X and self.Y == other.Y and self.Z == other.Z
end
function Private:__tostring()
	return string.format("%*, %*, %*", self.X, self.Y, self.Z)
end

return table.freeze(Vector3 :: Static)
