--!optimize 2
--!strict

local LuauLexer = require("@packages/LuauLexer")
local LuauPolyfill = require("@packages/LuauPolyfill")

local String = LuauPolyfill.String
local console = LuauPolyfill.console

local CodeTransformers = {}

type ResultingValue = {
	NewFileSource: string,
	WasChanged: true,
} | {
	WasChanged: false,
}
type TokenType = LuauLexer.TokenType

function CodeTransformers.FunctionFix(source: string, isVerbose: boolean?): ResultingValue
	local navigator = LuauLexer.Navigator()
	navigator.SetSource(source)

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

	return if wasChanged
		then {
			NewFileSource = table.concat(newFileSource);
			WasChanged = true;
		}
		else {WasChanged = false}
end

local EMPTY_STRING = "\"\""

function CodeTransformers.TableConcatFix(source: string, isVerbose: boolean?): ResultingValue
	local navigator = LuauLexer.Navigator()
	navigator.SetSource(source)

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

		if tokenType == "builtin" then
			local tableName: string? = nil
			local skipAmount = 0

			if content == "table" then
				local operatorTokenType: TokenType, operatorContent = navigator.Peek(1)
				if operatorTokenType == "operator" and operatorContent == "." then
					skipAmount += 1
					local nextBuiltInTokenType: TokenType, nextBuiltInContent = navigator.Peek(2)
					if nextBuiltInTokenType == "builtin" and nextBuiltInContent == "concat" then
						skipAmount += 1
						local nextOperatorTokenType: TokenType, nextOperatorContent = navigator.Peek(3)
						if nextOperatorTokenType == "operator" and nextOperatorContent == "(" then
							skipAmount += 1

							local identifierTokenType: TokenType, identifierContent = navigator.Peek(4)
							if identifierTokenType == "iden" then
								tableName = String.trim(identifierContent)
								skipAmount += 1

								local nextNextOperatorTokenType: TokenType, nextNextOperatorContent = navigator.Peek(5)
								if
									nextNextOperatorTokenType == "operator"
									and String.trim(nextNextOperatorContent) == ","
								then
									skipAmount += 1

									local stringTokenType: TokenType, stringContent = navigator.Peek(6)
									if stringTokenType == "string" and stringContent == EMPTY_STRING then
										skipAmount += 1

										local nextNextNextOperatorTokenType: TokenType, nextNextNextOperatorContent =
											navigator.Peek(7)
										if
											nextNextNextOperatorTokenType == "operator"
											and String.trim(nextNextNextOperatorContent) == ")"
										then
											skipAmount += 1
										else
											skipAmount = 0
											tableName = nil
										end
									else
										skipAmount = 0
										tableName = nil
									end
								else
									skipAmount = 0
									tableName = nil
								end
							else
								skipAmount = 0
								tableName = nil
							end
						else
							skipAmount = 0
							tableName = nil
						end
					else
						skipAmount = 0
						tableName = nil
					end
				else
					skipAmount = 0
					tableName = nil
				end
			end

			if skipAmount ~= 0 and tableName then
				addContent = string.format("table.concat(%*)\n", tableName)
				wasChanged = true
				for _ = 1, skipAmount do
					navigator.Next()
				end
			end
		end

		length += 1
		newFileSource[length] = addContent
	end

	return if wasChanged
		then {
			NewFileSource = table.concat(newFileSource);
			WasChanged = true;
		}
		else {WasChanged = false}
end

return table.freeze(CodeTransformers)
