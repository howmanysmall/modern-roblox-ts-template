--!optimize 2
--!strict

return function(value: string, startIndex: number, numberOfCharacters: number?): string
	if numberOfCharacters and numberOfCharacters <= 0 then
		return ""
	end

	return string.sub(value, startIndex, numberOfCharacters and startIndex + numberOfCharacters - 1 or nil)
end
