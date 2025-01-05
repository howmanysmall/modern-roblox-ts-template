--!optimize 2
--!strict

--[=[
	Lexical scanner for creating a sequence of tokens from Lua source code.
	This is a heavily modified and Roblox-optimized version of
	the original Penlight Lexer module:
		https://github.com/stevedonovan/Penlight
	Authors:
		stevedonovan <https://github.com/stevedonovan> ----------- Original Penlight lexer author
		ryanjmulder <https://github.com/ryanjmulder> ------------- Penlight lexer contributer
		mpeterv <https://github.com/mpeterv> --------------------- Penlight lexer contributer
		Tieske <https://github.com/Tieske> ----------------------- Penlight lexer contributer
		boatbomber <https://github.com/boatbomber> --------------- Roblox port, added builtin token,
		                                                           added patterns for incomplete syntax, bug fixes,
		                                                           behavior changes, token optimization, thread optimization
		                                                           Added lexer.navigator() for non-sequential reads
		Sleitnick <https://github.com/Sleitnick> ----------------- Roblox optimizations
		howmanysmall <https://github.com/howmanysmall> ----------- Lua + Roblox optimizations

	List of possible tokens:
		- iden
		- keyword
		- builtin
		- string
		- number
		- comment
		- operator
--]=]

local Language = require("./Language")

local Lexer = {}

local PREFIX, SUFFIX, CLEANER = "^[%c%s]*", "[%c%s]*", "[%c%s]+"

-- selene: allow(bad_string_escape)
local UNICODE = "[%z\x01-\x7F\xC2-\xF4][\x80-\xBF]+"
local NUMBER_A = "0[xX][%da-fA-F_]+"
local NUMBER_B = "0[bB][01_]+"
local NUMBER_C = "%d+%.?%d*[eE][%+%-]?%d+"
local NUMBER_D = "%d+[%._]?[%d_eE]*"
local OPERATORS = "[:;<>/~%*%(%)%-={},%.#%^%+%%]+"
local BRACKETS = "[%[%]]+" -- needs to be separate pattern from other operators or it'll mess up multiline strings
local IDEN = "[%a_][%w_]*"
local STRING_EMPTY = "(['\"])%1" --Empty String
local STRING_PLAIN = "(['\"])[^\n]-([^\\]%1)" --TODO: Handle escaping escapes
local STRING_INTER = "`[^\n]-`"
local STRING_INCOMP_A = "(['\"]).-\n" --Incompleted String with next line
local STRING_INCOMP_B = "(['\"])[^\n]*" --Incompleted String without next line
local STRING_MULTI = "%[(=*)%[.-%]%1%]" --Multiline-String
local STRING_MULTI_INCOMP = "%[=*%[.-.*" --Incompleted Multiline-String
local COMMENT_MULTI = "%-%-%[(=*)%[.-%]%1%]" --Completed Multiline-Comment
local COMMENT_MULTI_INCOMP = "%-%-%[=*%[.-.*" --Incompleted Multiline-Comment
local COMMENT_PLAIN = "%-%-.-\n" --Completed Singleline-Comment
local COMMENT_INCOMP = "%-%-.*" --Incompleted Singleline-Comment
-- local TYPED_VAR = ":%s*([%w%?%| \t]+%s*)" --Typed variable, parameter, function

local KEYWORDS = Language.Keyword
local BUILT_INS = Language.BuiltIn
local LIBRARIES = Language.Libraries

Lexer.Language = Language

export type TokenType =
	"var"
	| "number"
	| "string"
	| "string_inter"
	| "comment"
	| "operator"
	| "iden"
	| "keyword"
	| "builtin"

local LUAU_MATCHES = {
	-- Indentifiers
	{PREFIX .. IDEN .. SUFFIX, "var" :: TokenType};

	-- Numbers
	{PREFIX .. NUMBER_A .. SUFFIX, "number" :: TokenType};
	{PREFIX .. NUMBER_B .. SUFFIX, "number" :: TokenType};
	{PREFIX .. NUMBER_C .. SUFFIX, "number" :: TokenType};
	{PREFIX .. NUMBER_D .. SUFFIX, "number" :: TokenType};

	-- Strings
	{PREFIX .. STRING_EMPTY .. SUFFIX, "string" :: TokenType};
	{PREFIX .. STRING_PLAIN .. SUFFIX, "string" :: TokenType};
	{PREFIX .. STRING_INCOMP_A .. SUFFIX, "string" :: TokenType};
	{PREFIX .. STRING_INCOMP_B .. SUFFIX, "string" :: TokenType};
	{PREFIX .. STRING_MULTI .. SUFFIX, "string" :: TokenType};
	{PREFIX .. STRING_MULTI_INCOMP .. SUFFIX, "string" :: TokenType};
	{PREFIX .. STRING_INTER .. SUFFIX, "string_inter" :: TokenType};

	-- Comments
	{PREFIX .. COMMENT_MULTI .. SUFFIX, "comment" :: TokenType};
	{PREFIX .. COMMENT_MULTI_INCOMP .. SUFFIX, "comment" :: TokenType};
	{PREFIX .. COMMENT_PLAIN .. SUFFIX, "comment" :: TokenType};
	{PREFIX .. COMMENT_INCOMP .. SUFFIX, "comment" :: TokenType};

	-- Operators
	{PREFIX .. OPERATORS .. SUFFIX, "operator" :: TokenType};
	{PREFIX .. BRACKETS .. SUFFIX, "operator" :: TokenType};

	-- Unicode
	{PREFIX .. UNICODE .. SUFFIX, "iden" :: TokenType};

	-- Unknown
	{"^.", "iden" :: TokenType};
}

-- To reduce the amount of table indexing during lexing, we separate the matches now
local PATTERNS = {}
local TOKENS: {TokenType} = {}
for index, match in LUAU_MATCHES do
	PATTERNS[index] = match[1]
	TOKENS[index] = match[2] :: TokenType
end

--- Create a plain token iterator from a string.
-- @tparam string s a string.

function Lexer.Scan(source: string): () -> (TokenType, string)
	local index = 1
	local size = #source
	local previousContent1, previousContent2, previousContent3, previousToken = "", "", "", ""

	local thread = coroutine.create(function()
		while index <= size do
			local matched = false
			for tokenType, pattern in PATTERNS do
				-- Find match
				local start, finish = string.find(source, pattern, index)
				if start == nil or finish == nil then
					continue
				end

				-- Move head
				index = finish + 1
				matched = true

				-- Gather results
				local content = string.sub(source, start, finish)
				local rawToken = TOKENS[tokenType]
				local processedToken: TokenType = rawToken :: TokenType

				-- Process token
				if rawToken == "var" then
					-- Since we merge spaces into the tok, we need to remove them
					-- in order to check the actual word it contains
					local cleanContent = string.gsub(content, CLEANER, "")

					if KEYWORDS[cleanContent] then
						processedToken = "keyword"
					elseif BUILT_INS[cleanContent] then
						processedToken = "builtin"
					elseif string.find(previousContent1, "%.[%s%c]*$") and previousToken ~= "comment" then
						-- The previous was a . so we need to special case indexing things
						local parent = string.gsub(previousContent2, CLEANER, "")
						local library = LIBRARIES[parent]
						if library and library[cleanContent] and not string.find(previousContent3, "%.[%s%c]*$") then
							-- Indexing a builtin lib with existing item, treat as a builtin
							processedToken = "builtin"
						else
							-- Indexing a non builtin, can't be treated as a keyword/builtin
							processedToken = "iden"
						end
						-- print("indexing",parent,"with",cleanTok,"as",t2)
					else
						processedToken = "iden"
					end
				elseif rawToken == "string_inter" then
					if not string.find(content, "[^\\]{") then
						-- This inter string doesnt actually have any inters
						processedToken = "string"
					else
						-- We're gonna do our own yields, so the main loop won't need to
						-- Our yields will be a mix of string and whatever is inside the inters
						processedToken = nil :: never

						local isString = true
						local subIndex = 1
						local subSize = #content
						while subIndex <= subSize do
							-- Find next brace
							local subStart, subFinish = string.find(content, "^.-[^\\][{}]", subIndex)
							if subStart == nil then
								-- No more braces, all string
								coroutine.yield("string", string.sub(content, subIndex))
								break
							end

							if not subFinish then
								error("Failed to find end of string?")
							end

							if isString then
								-- We are currently a string
								subIndex = subFinish + 1
								coroutine.yield("string", string.sub(content, subStart, subFinish))

								-- This brace opens code
								isString = false
							else
								-- We are currently in code
								subIndex = subFinish
								local subContent = string.sub(content, subStart, subFinish - 1)
								for innerToken, innerContent in Lexer.Scan(subContent) do
									coroutine.yield(innerToken, innerContent)
								end

								-- This brace opens string/closes code
								isString = true
							end
						end
					end
				end

				-- Record last 3 tokens for the indexing context check
				previousContent3 = previousContent2
				previousContent2 = previousContent1
				previousContent1 = content
				previousToken = processedToken or rawToken
				if processedToken then
					coroutine.yield(processedToken, content)
				end

				break
			end

			-- No matches found
			if not matched then
				return
			end
		end

		-- Completed the scan
		return
	end)

	return function()
		if coroutine.status(thread) == "dead" then
			return
		end

		local success, token, content = coroutine.resume(thread)
		if success and token then
			return token, content
		end

		return
	end :: never
end

type Tuple<T, V> = {T | V}
export type LexerNavigator = {
	Source: string,
	TokenCache: {Tuple<string, string>},

	Next: () -> (TokenType, string),
	Peek: (peekAmount: number) -> (TokenType, string),

	SetSource: (source: string) -> (),
	Destroy: () -> (),
}

function Lexer.Navigator()
	local navigator = {
		Source = "";
		TokenCache = table.create(50);
	} :: LexerNavigator

	local realIndex = 0
	local userIndex = 0
	local scanThread: thread? = nil

	function navigator.Destroy()
		navigator.TokenCache = nil :: never
		navigator.Source = nil :: never
		realIndex = nil :: never
		userIndex = nil :: never
		scanThread = nil
	end

	function navigator.SetSource(sourceString)
		navigator.Source = sourceString

		realIndex = 0
		userIndex = 0
		table.clear(navigator.TokenCache)

		scanThread = coroutine.create(function()
			for token, source in Lexer.Scan(navigator.Source) do
				realIndex += 1
				navigator.TokenCache[realIndex] = {token, source}
				coroutine.yield(token, source)
			end
		end)
	end

	local function navigateNext(): ()
		userIndex += 1

		if realIndex >= userIndex then
			-- Already scanned, return cached
			return table.unpack(navigator.TokenCache[userIndex])
		end

		if not scanThread or coroutine.status(scanThread) == "dead" then
			-- Scan thread dead
			return
		end

		local success, token, source = coroutine.resume(scanThread)
		if success and token then
			-- Scanned new data
			return token, source
		end

		return
	end
	navigator.Next = navigateNext :: never

	local function navigatePeek(peekAmount: number): ()
		local goalIndex = userIndex + peekAmount

		if realIndex >= goalIndex then
			-- Already scanned, return cached
			if goalIndex > 0 then
				return table.unpack(navigator.TokenCache[goalIndex])
			end

			return
		end

		if not scanThread or coroutine.status(scanThread) == "dead" then
			-- Scan thread dead
			return
		end

		local success, token, source = nil, nil, nil
		for _ = 1, goalIndex - realIndex do
			success, token, source = coroutine.resume(scanThread)
			if not (success or token) then
				-- Lex completed
				break
			end
		end

		return token :: never, source
	end
	navigator.Peek = navigatePeek :: never

	return navigator
end

return table.freeze(Lexer)
