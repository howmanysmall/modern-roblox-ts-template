--!optimize 2
--!strict
--[=[ lunar
	about = "Transforms the bad function declaration to the good one."
	args = "[--verbose]"
]=]

local ArgParse = require("@packages/ArgParse")
local LuauLexer = require("@packages/LuauLexer")
local LuauPolyfill = require("@packages/LuauPolyfill")
local PathFileSystem = require("@packages/PathFileSystem")
local StyluaUtilities = require("@utilities/StyluaUtilities")
local ThreadUtilities = require("@utilities/ThreadUtilities")
local process = require("@lune/process")

local Set = LuauPolyfill.Set
local console = LuauPolyfill.console

type Path = PathFileSystem.Path
type Set<T> = LuauPolyfill.Set<T>
type TokenType = LuauLexer.TokenType

local parser = ArgParse("transform-functions", "Transforms the bad function declaration to the good one.")
parser:flag("verbose", "Prints more information.")

local arguments: {verbose: boolean?} = parser:parse()
local isVerbose = not not arguments.verbose

local OUT_DIRECTORY = PathFileSystem.CWD:join("out")

if not PathFileSystem.IsDirectory(OUT_DIRECTORY) then
	console.error("Could not find out directory")
	process.exit(1)
end

local CAN_TRANSFORM: Set<string> = Set.new({"luau", "lua"})

local toTransform: {Path} = {}
local totalTransformed = 0

for _, filePath in PathFileSystem.GetDescendants(OUT_DIRECTORY) do
	if not PathFileSystem.IsFile(filePath) then
		if isVerbose then
			console.log(`Skipping directory {filePath}`)
		end
		continue
	end

	local fileExtension = filePath:extension()
	if not fileExtension then
		if isVerbose then
			console.log(`Skipping file {filePath} (missing extension?)`)
		end
		continue
	end

	if not CAN_TRANSFORM:has(fileExtension) then
		if isVerbose then
			console.log(`Skipping file {filePath} (not a Luau file)`)
		end
		continue
	end

	local navigator = LuauLexer.Navigator()
	navigator.SetSource(PathFileSystem.ReadFile(filePath))

	local newFileSource = {}
	local length = 0
	local wasChanged = false

	while true do
		local tokenType: TokenType, content = navigator.Next()
		if tokenType == nil then
			if isVerbose then
				console.log("Breaking the navigation loop.")
			end
			break
		end

		local addContent = content

		if tokenType == "keyword" then
			local functionName: string? = nil
			local skipAmount = 0

			if content == "local " then
				local identifierTokenType: TokenType, identifierContent = navigator.Peek(1)
				if identifierTokenType == "iden" then
					functionName = string.gsub(identifierContent, "%s+$", "")
					skipAmount += 1

					local operatorTokenType: TokenType, operatorContent = navigator.Peek(2)
					if operatorTokenType == "operator" and operatorContent == "= " then
						skipAmount += 1
						local keywordTokenType: TokenType, keywordContent = navigator.Peek(3)
						if keywordTokenType == "keyword" and keywordContent == "function" then
							skipAmount += 1
						else
							skipAmount = 0
							functionName = nil
						end
					else
						skipAmount = 0
						functionName = nil
					end
				end
			end

			if skipAmount ~= 0 and functionName then
				addContent = string.format("local function %*", functionName)
				wasChanged = true
				for _ = 1, skipAmount do
					navigator.Next()
				end
			end
		end

		length += 1
		newFileSource[length] = addContent
	end

	if wasChanged then
		PathFileSystem.WriteFile(filePath, table.concat(newFileSource))
		totalTransformed += 1
		toTransform[totalTransformed] = filePath
	end
end

for _, filePath in toTransform do
	if isVerbose then
		console.log(`Formatting {filePath}...`)
	end
	ThreadUtilities.FastDefer(function()
		StyluaUtilities.FormatFile(filePath)
	end)
end
