--!optimize 2
--!strict
-- polyfill for https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/instanceof
local __DEV__ = _G.__DEV__

-- FIXME Luau: typing class as Object gives: Type '{ @metatable {| __call: <a>(a, ...any) -> Error, __tostring: <b, c>({+ message: b, name: c +}) -> string |}, Error }' could not be converted into 'table'
local function instanceof(object: any, class: any): boolean
	if __DEV__ then
		assert(type(class) == "table", "Received a non-table as the second argument for instanceof")
	end

	if type(object) ~= "table" then
		return false
	end

	if type(class) == "table" and type(class.instanceof) == "function" then
		return class.instanceof(object)
	end

	local success, hasNew = pcall(function()
		return class.new ~= nil and object.new == class.new
	end)

	if success and hasNew then
		return true
	end

	local seen = {[object] = true}

	while object and type(object) == "table" do
		object = getmetatable(object)
		if type(object) == "table" then
			object = object.__index

			if object == class then
				return true
			end
		end

		-- if we still have a valid table then check against seen
		if type(object) == "table" then
			if seen[object] then
				return false
			end

			seen[object] = true
		end
	end

	return false
end

return instanceof
