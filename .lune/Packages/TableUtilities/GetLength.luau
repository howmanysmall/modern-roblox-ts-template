--!optimize 2
--!strict

--[=[
	Gets the length of any table. This has a really bad time complexity of O(n)
	so I would just not use this unless you absolutely have to. And if you
	absolutely do have to, I'd just suggest inlining.

	This uses `pairs` to avoid weird `__call` issues with generalized
	iteration.

	```lua
	print(GetLength({hello = "world", goodbye = "world"})) -- 2
	print(GetLength({1, 2, 3})) -- 3
	print(GetLength({bad = "practice", true})) -- 2
	```

	@function GetLength
	@within TableUtilities

	@param object {[unknown]: unknown} -- The table to get the length of.
	@return number -- The length of the table.
]=]
local function GetLength(object: {[unknown]: unknown}): number
	local length = 0
	for _ in pairs(object) do
		length += 1
	end
	return length
end

return GetLength
