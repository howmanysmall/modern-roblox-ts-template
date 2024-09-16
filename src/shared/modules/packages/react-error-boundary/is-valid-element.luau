--!optimize 2
--!strict

return function(object: any)
	return type(object) == "table" and object["$$typeof"] == 0xeac7
end
