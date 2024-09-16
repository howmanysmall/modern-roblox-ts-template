--!optimize 2
--!strict

local fs = require("@lune/fs")

local FileSystemUtilities = {}

function FileSystemUtilities.JustFileName(Path: string)
	return string.match(string.match(Path, "^(.+)%..+$") or Path, "([^\\/]+)$") or Path
end
function FileSystemUtilities.JustFileNameWithExtension(Path: string)
	return string.match(Path, "([^\\/]+)$") or Path
end

function FileSystemUtilities.WithoutExtension(Path: string): string
	return string.match(Path, "^(.+)%..+$") or Path
end

function FileSystemUtilities.GetExtension(Path: string)
	return string.match(Path, "%.([^%.]+)$")
end

type CreatorFunction = (Path: string, Contents: string?) -> ()
type SafeCreate = ((Name: string, Type: "File", Contents: string) -> ()) & ((Name: string, Type: "Directory") -> ())

local function SafeCreate(Name: string, Type: "File" | "Directory", Contents: string?)
	local CheckerFunction: typeof(fs.isDir) = if Type == "File" then fs.isFile else fs.isDir
	local CreatorFunction = (if Type == "File" then fs.writeFile else fs.writeDir) :: CreatorFunction

	if not CheckerFunction(Name) then
		CreatorFunction(Name, Contents)
	else
		local Index = 1
		while CheckerFunction(`{FileSystemUtilities.WithoutExtension(Name)} ({Index})`) do
			Index += 1
		end

		local Extension = FileSystemUtilities.GetExtension(Name)
		local NewFilePath = if Extension
			then `{FileSystemUtilities.WithoutExtension(Name)} ({Index}).{Extension}`
			else `{FileSystemUtilities.WithoutExtension(Name)} ({Index})`

		CreatorFunction(NewFilePath, Contents)
	end
end
FileSystemUtilities.SafeCreate = SafeCreate :: SafeCreate

function FileSystemUtilities.GetOrCreateDirectory(Name: string)
	if not fs.isDir(Name) then
		FileSystemUtilities.SafeCreate(Name, "Directory")
	end
end

return table.freeze(FileSystemUtilities)
