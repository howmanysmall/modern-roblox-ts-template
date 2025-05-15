--!optimize 2
--!strict

local function FastLockDeep<T>(object: T): T
	local newObject = table.clone(object :: never)
	for key, value in pairs(object :: never) do
		if type(value) == "table" then
			newObject[key] = FastLockDeep(value)
		end
	end
	return table.freeze(newObject) :: never
end

--[=[
	Does a deep copy and lock of an object. If it is not a table, it
	just returns the object.

	```lua
	local dictionary = {hello = {world = "goodbye"}}

	local new = LockDeep(dictionary) -- {hello = {world = "goodbye"}}
	new.hello.world = "yeah" -- this will error
	```

	@function LockDeep
	@within TableUtilities

	@param object T -- The object to copy and lock.
	@return T -- The copied object.
]=]
local function LockDeep<T>(object: T): T
	if type(object) ~= "table" then
		return object
	end

	local newObject = table.clone(object)
	for key, value in pairs(object) do
		if type(value) == "table" then
			newObject[key] = FastLockDeep(value)
		end
	end
	return table.freeze(newObject) :: never
end

return LockDeep
