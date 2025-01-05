--!optimize 2
--!strict

local process = require("@lune/process")

local PathUtilities = {}
local SEPARATOR = if process.os == "windows" then "\\" else "/"
PathUtilities.Separator = SEPARATOR

--- Fixes the path so that it's properly formatted to the local operating system
--- @param path The path to format
--- @return A fixed path matching the OS format
function PathUtilities.OsPath(path: string): string
	local newPath = ""

	if process.os == "windows" then
		local index = 1
		while index <= #path do
			local character = string.sub(path, index, index)
			if character == "/" then
				character = "\\"
			end

			newPath ..= character
			index += 1
		end

		newPath = string.gsub(newPath, "\\+", "\\")
	else
		local index = 1
		while index <= #path do
			local character = string.sub(path, index, index)
			if character == "\\" then
				character = "/"
			end

			newPath ..= character
			index += 1
		end

		newPath = string.gsub(newPath, "/+", "/")
	end

	return newPath
end

--- Join multiple path parts into a combined path
--- @return A joined path
function PathUtilities.Join(...: string): string
	return PathUtilities.OsPath(table.concat({...}, SEPARATOR))
end

--- Gets the extension of the given path (if applicable) - otherwise returns nil
--- @param path The path to get the extension of
--- @return The path extension or nil
function PathUtilities.ExtensionName(path: string): string?
	return string.match(path, ".(%.[A-z0-9_-]+)$")
end

--- Gets the full directory path of the given path
--- @param path The path
--- @return The full directory path without the end item
function PathUtilities.DirectoryName(path: string): string
	local parts = string.split(PathUtilities.OsPath(path), SEPARATOR)
	table.remove(parts)
	return table.concat(parts, SEPARATOR)
end

function PathUtilities.FileName(path: string): string
	return string.match(path, `[^{PathUtilities.Separator}]+$`) or path
end
function PathUtilities.FileNameNoExtension(path: string): string?
	local extension = PathUtilities.ExtensionName(path)
	local fileName = string.match(path, `[^{PathUtilities.Separator}]+$`)
	if extension then
		return if fileName then string.gsub(fileName, `{extension}$`, "") else nil
	end

	return fileName
end

return table.freeze(PathUtilities)
