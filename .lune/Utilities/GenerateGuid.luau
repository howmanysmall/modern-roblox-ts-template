--!optimize 2
--!strict

local function GenerateGuid(hardwareAddress: string?)
	local bytes = {
		math.random(0, 255);
		math.random(0, 255);
		math.random(0, 255);
		math.random(0, 255);
		math.random(0, 255);
		math.random(0, 255);
		math.random(0, 255);
		math.random(0, 255);
		math.random(0, 255);
		math.random(0, 255);
		math.random(0, 255);
		math.random(0, 255);
		math.random(0, 255);
		math.random(0, 255);
		math.random(0, 255);
		math.random(0, 255);
	}

	if hardwareAddress then
		local index = #hardwareAddress
		local before = hardwareAddress
		hardwareAddress = ""

		while index > 0 and #hardwareAddress < 12 do
			local character = string.lower(string.sub(before, index, index))
			if string.match(character, "%x") then
				hardwareAddress = `{character}{hardwareAddress}`
			end
			index -= 1
		end

		assert(
			#hardwareAddress == 12,
			`Provided string did not contain at least 12 hex characters, retrieved '{hardwareAddress}' from '{before}`
		)

		bytes[11] = tonumber(string.sub(hardwareAddress, 1, 2), 16) or 0
		bytes[12] = tonumber(string.sub(hardwareAddress, 3, 4), 16) or 0
		bytes[13] = tonumber(string.sub(hardwareAddress, 5, 6), 16) or 0
		bytes[14] = tonumber(string.sub(hardwareAddress, 7, 8), 16) or 0
		bytes[15] = tonumber(string.sub(hardwareAddress, 9, 10), 16) or 0
		bytes[16] = tonumber(string.sub(hardwareAddress, 11, 12), 16) or 0
	end

	bytes[7] = bit32.bor(bit32.band(bytes[7], 0x0f), 0x40)
	bytes[9] = bit32.bor(bit32.band(bytes[9], 0x3f), 0x80)

	return string.format(
		"%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
		bytes[1],
		bytes[2],
		bytes[3],
		bytes[4],
		bytes[5],
		bytes[6],
		bytes[7],
		bytes[8],
		bytes[9],
		bytes[10],
		bytes[11],
		bytes[12],
		bytes[13],
		bytes[14],
		bytes[15],
		bytes[16]
	)
end

return GenerateGuid
