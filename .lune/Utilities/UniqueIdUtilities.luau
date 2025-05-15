--!optimize 2
--!strict

local GreenTea = require("@packages/GreenTea")
local GreenTeaAssert = require("@functions/GreenTeaAssert")
local TypeError = require("@errors/TypeError")

local UniqueIdUtilities = {}

-- Int64 implementation for maximum speed (library slow)
local ONE = vector.create(0, 0, 1)
local ZERO = vector.create(0, 0, 0)
local Y_AXIS = vector.create(0, 1, 0)
local X_AXIS = vector.create(1, 0, 0)

local function FromPair(most: number, least: number): vector
	return vector.create(
		bit32.rshift(most, 10),
		bit32.bor(bit32.extract(least, 22, 10), bit32.lshift(bit32.band(most, 0b1111_1111_11), 10)),
		bit32.band(least, 0b1111_1111_1111_1111_1111_11)
	)
end
local function FromF64(f64: number): vector
	return FromPair(bit32.bor(f64 // 2 ^ 32), bit32.bor(f64 % 2 ^ 32))
end
local function FromU32(u32: number): vector
	return vector.create(0, bit32.rshift(u32, 22), bit32.band(u32, 0b1111_1111_1111_1111_1111_11))
end
local function And(lhs: vector, rhs: vector): vector
	return vector.create(bit32.band(lhs.x, rhs.x), bit32.band(lhs.y, rhs.y), bit32.band(lhs.z, rhs.z))
end
local function Or(lhs: vector, rhs: vector): vector
	return vector.create(bit32.bor(lhs.x, rhs.x), bit32.bor(lhs.y, rhs.y), bit32.bor(lhs.z, rhs.z))
end
local function Normalize(u64: vector): vector
	return vector.create(
		bit32.band(u64.x, 0b1111_1111_1111_1111_1111_11),
		bit32.band(u64.y, 0b1111_1111_1111_1111_1111),
		bit32.band(u64.z, 0b1111_1111_1111_1111_1111_11)
	)
end
local function Add(augend: vector, addend: vector): vector
	local prime = augend + addend
	prime += if prime.z > (2 ^ 22 - 1) then Y_AXIS else ZERO
	prime += if prime.y > (2 ^ 20 - 1) then X_AXIS else ZERO
	return Normalize(prime)
end
local function ToPair(u64: vector): (number, number)
	local y = u64.y
	local most = bit32.bor(bit32.lshift(u64.x, 10), bit32.rshift(y, 10))
	local least = bit32.bor(bit32.lshift(y, 22), u64.z)
	return most, least
end
local function LeftShift(u64: vector, shift: number): vector
	if shift >= 64 then
		return ZERO
	end

	if shift == 0 then
		return u64
	end

	local most, least = ToPair(u64)
	if shift < 32 then
		local remainder = 32 - shift
		return FromPair(
			bit32.replace(bit32.rshift(least, remainder), most, shift, remainder),
			bit32.lshift(least, shift)
		)
	end

	return FromPair(bit32.lshift(least, shift - 32), 0)
end
local function ToF64(u64: vector): number
	local most, least = ToPair(u64)
	return most * 2 ^ 32 + least
end
local function Subtract(minuend: vector, subtrahend: vector): vector
	local prime = minuend - subtrahend

	local adjustZ = prime.z
	local adjustY = prime.y
	local adjustX = prime.x

	local borrowZ = adjustZ < 0
	if borrowZ then
		adjustZ += 2 ^ 22
	end

	if borrowZ then
		adjustY -= 1
	end
	local borrowY = adjustY < 0
	if borrowY then
		adjustY += 2 ^ 20
	end

	if borrowY then
		adjustX -= 1
	end
	local borrowX = adjustX < 0
	if borrowX then
		adjustX += 2 ^ 22
	end

	return vector.create(adjustX, adjustY, adjustZ)
end
local function ToQuartet(u64: vector): (number, number, number, number)
	local most, least = ToPair(u64)
	local q1, q2 = bit32.rshift(most, 16), bit32.band(most, 0xffff)
	local q3, q4 = bit32.rshift(least, 16), bit32.band(least, 0xffff)
	return q1, q2, q3, q4
end
local function GreaterThan(lhs: vector, rhs: vector): boolean
	local mostLeft, leastLeft = ToPair(lhs)
	local rightMost, rightLeast = ToPair(rhs)
	return if mostLeft == rightMost then leastLeft > rightLeast else mostLeft > rightMost
end
local function GreaterThanEqualTo(lhs: vector, rhs: vector): boolean
	return lhs == rhs or GreaterThan(lhs, rhs)
end
local function CountLeftZeroes(u64: vector): number
	local most, least = ToPair(u64)
	return if most == 0 then bit32.countlz(least) + 32 else bit32.countlz(most)
end

local CHARACTERS = string.split("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", "")
local CHARACTERS_LENGTH = FromU32(#CHARACTERS)
local LARGE_VALUE = FromU32(0xFFFFFF)

local CHARACTERS_LEFT_ZEROES = CountLeftZeroes(CHARACTERS_LENGTH)
local CHARACTERS_LENGTH_64 = ToF64(CHARACTERS_LENGTH)
local CHARACTERS_MOST, CHARACTERS_LEAST = ToPair(CHARACTERS_LENGTH)
local CHARACTERS_E, CHARACTERS_F, CHARACTERS_G, CHARACTERS_H = ToQuartet(CHARACTERS_LENGTH)
local ONE_MOST, ONE_LEAST = ToPair(ONE)

local IsMaybeNumber = GreenTea.build(GreenTea.optional(GreenTea.number()))

local function GetRandomSeed(): number
	return math.floor((os.clock() % 1 * 1E7) * 1000000)
end
UniqueIdUtilities.GetRandomSeed = GetRandomSeed

function UniqueIdUtilities.NextUniqueId(timestamp: number?): string
	GreenTeaAssert(IsMaybeNumber, timestamp, UniqueIdUtilities.NextUniqueId, TypeError)

	local timePart = And(FromF64(timestamp or GetRandomSeed()), LARGE_VALUE)
	local randomPart = FromU32(math.random(0, 0xFFFFFF))
	local saferId = Or(LeftShift(randomPart, 24), timePart)

	local result = ""
	while GreaterThan(saferId, ZERO) do
		local moduloDivideResult = ZERO
		if CountLeftZeroes(saferId) >= 11 and CHARACTERS_LEFT_ZEROES >= 11 then
			moduloDivideResult = FromF64(ToF64(saferId) // CHARACTERS_LENGTH_64)
		else
			local divideRemainder = saferId

			-- Doing extra iterations of this is very bad!
			for index = math.abs(CountLeftZeroes(saferId) - CHARACTERS_LEFT_ZEROES), 0, -1 do
				local shiftedDivisor: vector = nil
				if index >= 64 then
					shiftedDivisor = ZERO
				elseif index == 0 then
					shiftedDivisor = CHARACTERS_LENGTH
				elseif index < 32 then
					local shiftRemainder = 32 - index
					shiftedDivisor = FromPair(
						bit32.replace(
							bit32.rshift(CHARACTERS_LEAST, shiftRemainder),
							CHARACTERS_MOST,
							index,
							shiftRemainder
						),
						bit32.lshift(CHARACTERS_LEAST, index)
					)
				else
					shiftedDivisor = FromPair(bit32.lshift(CHARACTERS_LEAST, index - 32), 0)
				end

				if GreaterThanEqualTo(divideRemainder, shiftedDivisor) then
					divideRemainder = Subtract(divideRemainder, shiftedDivisor)
					if index >= 64 then
						moduloDivideResult = Or(moduloDivideResult, ZERO)
					elseif index == 0 then
						moduloDivideResult = Or(moduloDivideResult, ONE)
					elseif index < 32 then
						local shiftRemainder = 32 - index
						moduloDivideResult = Or(
							moduloDivideResult,
							FromPair(
								bit32.replace(bit32.rshift(ONE_LEAST, shiftRemainder), ONE_MOST, index, shiftRemainder),
								bit32.lshift(ONE_LEAST, index)
							)
						)
					else
						moduloDivideResult = Or(moduloDivideResult, FromPair(bit32.lshift(ONE_LEAST, index - 32), 0))
					end
				end
			end
		end

		local a, b, c, d = ToQuartet(moduloDivideResult)
		local product4 = d * CHARACTERS_H
		local product3 = bit32.rshift(product4, 16) + c * CHARACTERS_H
		local product2 = bit32.rshift(product3, 16)
		product3 = bit32.band(product3, 0xFFFF) + d * CHARACTERS_G

		product2 += bit32.rshift(product3, 16) + b * CHARACTERS_H
		local product1 = bit32.rshift(product2, 16)

		product2 = bit32.band(product2, 0xFFFF) + c * CHARACTERS_G
		product1 += bit32.rshift(product2, 16)
		product2 = bit32.band(product2, 0xFFFF) + d * CHARACTERS_F
		product1 += bit32.rshift(product2, 16) + a * CHARACTERS_H + b * CHARACTERS_G + c * CHARACTERS_F + d * CHARACTERS_E

		local subtractBy =
			FromPair(bit32.replace(product2, product1, 16, 16), bit32.replace(product4, product3, 16, 16))
		local moduloResult = Subtract(saferId, subtractBy)

		local added = Add(moduloResult, ONE)
		local remainder = ToF64(added)
		result = CHARACTERS[remainder] .. result

		local divideResult = ZERO
		if CountLeftZeroes(saferId) >= 11 and CHARACTERS_LEFT_ZEROES >= 11 then
			divideResult = FromF64(ToF64(saferId) // CHARACTERS_LENGTH_64)
		else
			local divideRemainder = saferId

			-- Doing extra iterations of this is very bad!
			for index = math.abs(CountLeftZeroes(saferId) - CHARACTERS_LEFT_ZEROES), 0, -1 do
				local shiftedDivisor: vector = nil
				if index >= 64 then
					shiftedDivisor = ZERO
				elseif index == 0 then
					shiftedDivisor = CHARACTERS_LENGTH
				elseif index < 32 then
					local shiftRemainder = 32 - index
					shiftedDivisor = FromPair(
						bit32.replace(
							bit32.rshift(CHARACTERS_LEAST, shiftRemainder),
							CHARACTERS_MOST,
							index,
							shiftRemainder
						),
						bit32.lshift(CHARACTERS_LEAST, index)
					)
				else
					shiftedDivisor = FromPair(bit32.lshift(CHARACTERS_LEAST, index - 32), 0)
				end

				if GreaterThanEqualTo(divideRemainder, shiftedDivisor) then
					divideRemainder = Subtract(divideRemainder, shiftedDivisor)
					if index >= 64 then
						divideResult = Or(divideResult, ZERO)
					elseif index == 0 then
						divideResult = Or(divideResult, ONE)
					elseif index < 32 then
						local shiftRemainder = 32 - index
						divideResult = Or(
							divideResult,
							FromPair(
								bit32.replace(bit32.rshift(ONE_LEAST, shiftRemainder), ONE_MOST, index, shiftRemainder),
								bit32.lshift(ONE_LEAST, index)
							)
						)
					else
						divideResult = Or(divideResult, FromPair(bit32.lshift(ONE_LEAST, index - 32), 0))
					end
				end
			end
		end
		saferId = divideResult
	end

	return result
end

local function GetResult(result: {string}): string
	return string.reverse(table.concat(result))
end

function UniqueIdUtilities.NextUniqueIdGuarantee8(timestamp: number?): string
	GreenTeaAssert(IsMaybeNumber, timestamp, UniqueIdUtilities.NextUniqueIdGuarantee8, TypeError)

	local timePart = And(FromF64(timestamp or GetRandomSeed()), LARGE_VALUE)
	local randomPart = FromU32(math.random(0, 0xFFFFFF))
	local saferId = Or(LeftShift(randomPart, 24), timePart)

	local result = table.create(8)
	local length = 0
	while GreaterThan(saferId, ZERO) do
		local moduloDivideResult = ZERO
		if CountLeftZeroes(saferId) >= 11 and CHARACTERS_LEFT_ZEROES >= 11 then
			moduloDivideResult = FromF64(ToF64(saferId) // CHARACTERS_LENGTH_64)
		else
			local divideRemainder = saferId

			-- Doing extra iterations of this is very bad!
			for index = math.abs(CountLeftZeroes(saferId) - CHARACTERS_LEFT_ZEROES), 0, -1 do
				local shiftedDivisor: vector = nil
				if index >= 64 then
					shiftedDivisor = ZERO
				elseif index == 0 then
					shiftedDivisor = CHARACTERS_LENGTH
				elseif index < 32 then
					local shiftRemainder = 32 - index
					shiftedDivisor = FromPair(
						bit32.replace(
							bit32.rshift(CHARACTERS_LEAST, shiftRemainder),
							CHARACTERS_MOST,
							index,
							shiftRemainder
						),
						bit32.lshift(CHARACTERS_LEAST, index)
					)
				else
					shiftedDivisor = FromPair(bit32.lshift(CHARACTERS_LEAST, index - 32), 0)
				end

				if GreaterThanEqualTo(divideRemainder, shiftedDivisor) then
					divideRemainder = Subtract(divideRemainder, shiftedDivisor)
					if index >= 64 then
						moduloDivideResult = Or(moduloDivideResult, ZERO)
					elseif index == 0 then
						moduloDivideResult = Or(moduloDivideResult, ONE)
					elseif index < 32 then
						local shiftRemainder = 32 - index
						moduloDivideResult = Or(
							moduloDivideResult,
							FromPair(
								bit32.replace(bit32.rshift(ONE_LEAST, shiftRemainder), ONE_MOST, index, shiftRemainder),
								bit32.lshift(ONE_LEAST, index)
							)
						)
					else
						moduloDivideResult = Or(moduloDivideResult, FromPair(bit32.lshift(ONE_LEAST, index - 32), 0))
					end
				end
			end
		end

		local a, b, c, d = ToQuartet(moduloDivideResult)
		local product4 = d * CHARACTERS_H
		local product3 = bit32.rshift(product4, 16) + c * CHARACTERS_H
		local product2 = bit32.rshift(product3, 16)
		product3 = bit32.band(product3, 0xFFFF) + d * CHARACTERS_G

		product2 += bit32.rshift(product3, 16) + b * CHARACTERS_H
		local product1 = bit32.rshift(product2, 16)

		product2 = bit32.band(product2, 0xFFFF) + c * CHARACTERS_G
		product1 += bit32.rshift(product2, 16)
		product2 = bit32.band(product2, 0xFFFF) + d * CHARACTERS_F
		product1 += bit32.rshift(product2, 16) + a * CHARACTERS_H + b * CHARACTERS_G + c * CHARACTERS_F + d * CHARACTERS_E

		local subtractBy =
			FromPair(bit32.replace(product2, product1, 16, 16), bit32.replace(product4, product3, 16, 16))
		local moduloResult = Subtract(saferId, subtractBy)

		local added = Add(moduloResult, ONE)
		local remainder = ToF64(added)
		length += 1
		result[length] = CHARACTERS[remainder]
		-- result = CHARACTERS[remainder] .. result

		if length == 8 then
			return GetResult(result)
		end

		local divideResult = ZERO
		if CountLeftZeroes(saferId) >= 11 and CHARACTERS_LEFT_ZEROES >= 11 then
			divideResult = FromF64(ToF64(saferId) // CHARACTERS_LENGTH_64)
		else
			local divideRemainder = saferId

			-- Doing extra iterations of this is very bad!
			for index = math.abs(CountLeftZeroes(saferId) - CHARACTERS_LEFT_ZEROES), 0, -1 do
				local shiftedDivisor: vector = nil
				if index >= 64 then
					shiftedDivisor = ZERO
				elseif index == 0 then
					shiftedDivisor = CHARACTERS_LENGTH
				elseif index < 32 then
					local shiftRemainder = 32 - index
					shiftedDivisor = FromPair(
						bit32.replace(
							bit32.rshift(CHARACTERS_LEAST, shiftRemainder),
							CHARACTERS_MOST,
							index,
							shiftRemainder
						),
						bit32.lshift(CHARACTERS_LEAST, index)
					)
				else
					shiftedDivisor = FromPair(bit32.lshift(CHARACTERS_LEAST, index - 32), 0)
				end

				if GreaterThanEqualTo(divideRemainder, shiftedDivisor) then
					divideRemainder = Subtract(divideRemainder, shiftedDivisor)
					if index >= 64 then
						divideResult = Or(divideResult, ZERO)
					elseif index == 0 then
						divideResult = Or(divideResult, ONE)
					elseif index < 32 then
						local shiftRemainder = 32 - index
						divideResult = Or(
							divideResult,
							FromPair(
								bit32.replace(bit32.rshift(ONE_LEAST, shiftRemainder), ONE_MOST, index, shiftRemainder),
								bit32.lshift(ONE_LEAST, index)
							)
						)
					else
						divideResult = Or(divideResult, FromPair(bit32.lshift(ONE_LEAST, index - 32), 0))
					end
				end
			end
		end
		saferId = divideResult
	end

	if length < 8 then
		-- local deltaAmount = 8 - #result
		-- local newResult = ""
		while true do
			saferId = Or(LeftShift(randomPart, 24), timePart)
			while GreaterThan(saferId, ZERO) do
				local moduloDivideResult = ZERO
				if CountLeftZeroes(saferId) >= 11 and CHARACTERS_LEFT_ZEROES >= 11 then
					moduloDivideResult = FromF64(ToF64(saferId) // CHARACTERS_LENGTH_64)
				else
					local divideRemainder = saferId

					-- Doing extra iterations of this is very bad!
					for index = math.abs(CountLeftZeroes(saferId) - CHARACTERS_LEFT_ZEROES), 0, -1 do
						local shiftedDivisor: vector = nil
						if index >= 64 then
							shiftedDivisor = ZERO
						elseif index == 0 then
							shiftedDivisor = CHARACTERS_LENGTH
						elseif index < 32 then
							local shiftRemainder = 32 - index
							shiftedDivisor = FromPair(
								bit32.replace(
									bit32.rshift(CHARACTERS_LEAST, shiftRemainder),
									CHARACTERS_MOST,
									index,
									shiftRemainder
								),
								bit32.lshift(CHARACTERS_LEAST, index)
							)
						else
							shiftedDivisor = FromPair(bit32.lshift(CHARACTERS_LEAST, index - 32), 0)
						end

						if GreaterThanEqualTo(divideRemainder, shiftedDivisor) then
							divideRemainder = Subtract(divideRemainder, shiftedDivisor)
							if index >= 64 then
								moduloDivideResult = Or(moduloDivideResult, ZERO)
							elseif index == 0 then
								moduloDivideResult = Or(moduloDivideResult, ONE)
							elseif index < 32 then
								local shiftRemainder = 32 - index
								moduloDivideResult = Or(
									moduloDivideResult,
									FromPair(
										bit32.replace(
											bit32.rshift(ONE_LEAST, shiftRemainder),
											ONE_MOST,
											index,
											shiftRemainder
										),
										bit32.lshift(ONE_LEAST, index)
									)
								)
							else
								moduloDivideResult =
									Or(moduloDivideResult, FromPair(bit32.lshift(ONE_LEAST, index - 32), 0))
							end
						end
					end
				end

				local a, b, c, d = ToQuartet(moduloDivideResult)
				local product4 = d * CHARACTERS_H
				local product3 = bit32.rshift(product4, 16) + c * CHARACTERS_H
				local product2 = bit32.rshift(product3, 16)
				product3 = bit32.band(product3, 0xFFFF) + d * CHARACTERS_G

				product2 += bit32.rshift(product3, 16) + b * CHARACTERS_H
				local product1 = bit32.rshift(product2, 16)

				product2 = bit32.band(product2, 0xFFFF) + c * CHARACTERS_G
				product1 += bit32.rshift(product2, 16)
				product2 = bit32.band(product2, 0xFFFF) + d * CHARACTERS_F
				product1 += bit32.rshift(product2, 16) + a * CHARACTERS_H + b * CHARACTERS_G + c * CHARACTERS_F + d * CHARACTERS_E

				local subtractBy =
					FromPair(bit32.replace(product2, product1, 16, 16), bit32.replace(product4, product3, 16, 16))
				local moduloResult = Subtract(saferId, subtractBy)

				local added = Add(moduloResult, ONE)
				local remainder = ToF64(added)
				length += 1
				result[length] = CHARACTERS[remainder]
				-- result = CHARACTERS[remainder] .. result

				if length == 8 then
					return GetResult(result)
				end

				local divideResult = ZERO
				if CountLeftZeroes(saferId) >= 11 and CHARACTERS_LEFT_ZEROES >= 11 then
					divideResult = FromF64(ToF64(saferId) // CHARACTERS_LENGTH_64)
				else
					local divideRemainder = saferId

					-- Doing extra iterations of this is very bad!
					for index = math.abs(CountLeftZeroes(saferId) - CHARACTERS_LEFT_ZEROES), 0, -1 do
						local shiftedDivisor: vector = nil
						if index >= 64 then
							shiftedDivisor = ZERO
						elseif index == 0 then
							shiftedDivisor = CHARACTERS_LENGTH
						elseif index < 32 then
							local shiftRemainder = 32 - index
							shiftedDivisor = FromPair(
								bit32.replace(
									bit32.rshift(CHARACTERS_LEAST, shiftRemainder),
									CHARACTERS_MOST,
									index,
									shiftRemainder
								),
								bit32.lshift(CHARACTERS_LEAST, index)
							)
						else
							shiftedDivisor = FromPair(bit32.lshift(CHARACTERS_LEAST, index - 32), 0)
						end

						if GreaterThanEqualTo(divideRemainder, shiftedDivisor) then
							divideRemainder = Subtract(divideRemainder, shiftedDivisor)
							if index >= 64 then
								divideResult = Or(divideResult, ZERO)
							elseif index == 0 then
								divideResult = Or(divideResult, ONE)
							elseif index < 32 then
								local shiftRemainder = 32 - index
								divideResult = Or(
									divideResult,
									FromPair(
										bit32.replace(
											bit32.rshift(ONE_LEAST, shiftRemainder),
											ONE_MOST,
											index,
											shiftRemainder
										),
										bit32.lshift(ONE_LEAST, index)
									)
								)
							else
								divideResult = Or(divideResult, FromPair(bit32.lshift(ONE_LEAST, index - 32), 0))
							end
						end
					end
				end
				saferId = divideResult
			end
		end

		-- result ..= newResult
	end

	return GetResult(result)
end

return table.freeze(UniqueIdUtilities)
