--!optimize 2
--!strict

local Utf8 = {}

function Utf8.Graphemes(value: string, start: number?, finish: number?): () -> (number, number)
	local trueStart = start or 1
	local trueFinish = finish or #value

	local codePoints = {}
	local length = 0
	for point in utf8.codes(value) do
		if point >= trueStart and point <= trueFinish then
			length += 1
			codePoints[length] = point
		end
	end

	codePoints[length + 1] = trueFinish + 1

	local index = 1
	local function iterate(): ()
		if index > length then
			return nil
		end

		local first = codePoints[index]
		local last = codePoints[index + 1] - 1
		index += 1
		return first, last
	end

	return iterate :: never
end

return table.freeze(Utf8)
