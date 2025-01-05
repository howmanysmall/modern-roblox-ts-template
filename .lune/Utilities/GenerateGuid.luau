--!optimize 2
--!strict

local function GenerateGuid(): string
	return string.format(
		"%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
		math.random(0, 255),
		math.random(0, 255),
		math.random(0, 255),
		math.random(0, 255),
		math.random(0, 255),
		math.random(0, 255),
		bit32.bor(bit32.band(math.random(0, 255), 0x0F), 0x40),
		bit32.bor(bit32.band(math.random(0, 255), 0x3F), 0x80),
		math.random(0, 255),
		math.random(0, 255),
		math.random(0, 255),
		math.random(0, 255),
		math.random(0, 255),
		math.random(0, 255),
		math.random(0, 255),
		math.random(0, 255)
	)
end

return GenerateGuid
