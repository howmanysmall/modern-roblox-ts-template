--!optimize 2
--!strict

local fs = require("@lune/fs")
local process = require("@lune/process")
local stdio = require("@lune/stdio")

-- Gross hack, unfortunately.
getfenv(1).Vector2 = {
	new = function()
		return {X = 0, Y = 0}
	end;
}

local function CreateInterface(object: {[string]: any}, interfaceName: string)
	local interface = {string.format("interface %* {", interfaceName)}
	local interfaceLength = 1

	for assetName, assetValue in object do
		interfaceLength += 1
		interface[interfaceLength] = string.format(
			"\treadonly %*: %*;",
			assetName,
			if type(assetValue) == "string" then "AssetId" else "SpritesheetEntry"
		)
	end

	interface[interfaceLength + 1] = "}"
	interface[interfaceLength + 2] = ""
	return table.concat(interface, "\n")
end

local function CreateAssets(assetsPath: string, definitionPath: string, exportName: string)
	if not fs.isFile(assetsPath) then
		return 0
	end

	local require = require
	local assets: {[string]: any} = require(process.cwd .. (string.gsub(assetsPath, ".luau?", "")))

	assert(string.match(definitionPath, "%.d%.ts$"), "Not a valid definition path?")

	local stringArray = {
		"type AssetId = `rbxassetid://${string}`;";
		"";
		"interface SpritesheetEntry {";
		"\treadonly Image: AssetId;";
		"\treadonly ImageRectOffset: Vector2;";
		"\treadonly ImageRectSize: Vector2;";
		"}";
		"";
	}
	local length = 8

	local interfaces: {string} = {}
	local interfacesLength = 0

	for interfaceName, interfaceValue in assets do
		if type(interfaceValue) == "table" then
			interfacesLength += 1
			interfaces[interfacesLength] = interfaceName

			length += 1
			stringArray[length] = CreateInterface(interfaceValue, interfaceName)
		elseif type(interfaceValue) == "string" then
			length += 1
			stringArray[length] = string.format("\treadonly %*: AssetId;", interfaceName)
		end
	end

	local exportString = {"interface TarmacAssets {"}
	local exportLength = 1
	table.sort(interfaces)
	for _, interfaceName in interfaces do
		exportLength += 1
		exportString[exportLength] = string.format("\treadonly %*: %*;", interfaceName, interfaceName)
	end

	exportString[exportLength + 1] = "}"
	exportString[exportLength + 2] = ""
	exportString[exportLength + 3] = string.format("declare const %*: TarmacAssets;", exportName)
	exportString[exportLength + 4] = string.format("export = %*;", exportName)
	exportString[exportLength + 5] = ""

	stringArray[length + 1] = table.concat(exportString, "\n")
	fs.writeFile(definitionPath, table.concat(stringArray, "\n"))
	return 1
end

local assetsPath = stdio.prompt("text", "Please write the path to the assets file.", "src/shared/assets.luau")
local definitionPath =
	stdio.prompt("text", "Please write the path to the assets definition file.", "src/shared/assets.d.ts")

local exportName = stdio.prompt("text", "What do you want the export to be called?", "Assets")
CreateAssets(assetsPath, definitionPath, exportName)

return CreateAssets
