--!optimize 2
--!strict

-- TODO: Reimplement actual Random library

export type PolyfillRandom = {
	NextInteger: (self: PolyfillRandom, minimum: number, maximum: number) -> number,
}
type Static = {
	new: (seed: number?) -> PolyfillRandom,
}

local Random = {} :: PolyfillRandom & Static;
(Random :: any).__index = Random

function Random.new(seed: number?)
	if seed then
		math.randomseed(seed)
	end
	return setmetatable({}, Random) :: never
end

function Random:NextInteger(minimum, maximum)
	return math.random(minimum, maximum)
end

return table.freeze(Random :: Static)
