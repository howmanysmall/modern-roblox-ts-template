--!optimize 2
--!strict

export type PolyfillRandom = {
	NextInteger: (self: PolyfillRandom, minimum: number, maximum: number) -> number,
	NextNumber: ((self: PolyfillRandom, minimum: number, maximum: number) -> number)
		& ((self: PolyfillRandom) -> number),
	Shuffle: (self: PolyfillRandom, array: {any}) -> (),
}
type Static = {new: (seed: number?) -> PolyfillRandom}

local Random = {} :: PolyfillRandom & Static;
(Random :: any).__index = Random;
(Random :: any).__type = "Random"

function Random.new(seed: number?): PolyfillRandom
	math.randomseed(seed or (os.clock() % 1 * 1E7))
	return setmetatable({}, Random) :: never
end

local function NextInteger(_: PolyfillRandom, minimum: number, maximum: number): number
	return math.random(minimum, maximum)
end
Random.NextInteger = NextInteger

local function NextNumber(_: PolyfillRandom, minimum: number?, maximum: number?): number
	local value = math.random()
	return if minimum and maximum then value * (maximum - minimum) + minimum else value
end
Random.NextNumber = NextNumber

function Random:Shuffle(array: {unknown}): ()
	for index = #array, 2, -1 do
		local jndex = NextInteger(self, 1, index)
		array[index], array[jndex] = array[jndex], array[index]
	end
end

return table.freeze(Random :: Static)
