--!optimize 2
--!strict
local function startsWith(value: string, substring: string, position: number?): boolean
	if #substring == 0 then
		return true
	end
	-- Luau FIXME: we have to use a tmp variable, as Luau doesn't understand the logic below narrow position to `number`
	local position_
	if position == nil or position < 1 then
		position_ = 1
	else
		position_ = position
	end

	if position_ > #value then
		return false
	end

	return string.find(value, substring, position_, true) == position_
end

return startsWith
