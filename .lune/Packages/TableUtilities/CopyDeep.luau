--!optimize 2
--!strict

-- types are wonky here, but it's cause i can assure
-- that i am right
local function FastCopyDeep<T>(object: T): T
	local newObject = table.clone(object :: never)
	for key, value in pairs(object :: never) do
		if type(value) == "table" then
			newObject[key] = FastCopyDeep(value)
		end
	end
	return newObject :: never
end

--[=[
	Does a deep copy of an object. If it is not a table, it just returns the object.

	```lua
	local dictionary = {hello = {world = "goodbye"}}

	local new = CopyDeep(dictionary) -- {hello = {world = "goodbye"}}

	print(new == dictionary) -- false
	print(new.hello == dictionary.hello) -- false
	print(new.hello.world == dictionary.hello.world) -- true
	```

	@function CopyDeep
	@within TableUtilities

	@param object T -- The object to copy.
	@return T -- The copied object.
]=]
local function CopyDeep<T>(object: T): T
	if type(object) ~= "table" then
		return object
	end

	local newObject = table.clone(object)
	for key, value in pairs(object) do
		if type(value) == "table" then
			newObject[key] = FastCopyDeep(value)
		end
	end
	return newObject :: never
end

return CopyDeep
