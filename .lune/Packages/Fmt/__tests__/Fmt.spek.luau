--!optimize 2
--!strict

local Fmt = require("@packages/Fmt")
local Spek = require("@packages/Spek")

return function(t: Spek.T)
	local describe = t.describe
	local expect = t.expect
	local expectError = t.expectError
	local it = t.it
	local measure = t.measure
	local operation = t.operation

	describe("Fmt")(function()
		it("should throw when format specifier is not closed")(function()
			expectError(function()
				Fmt("{")
			end)
		end)

		it("should throw when close brace has no matching open brace")(function()
			expectError(function()
				Fmt("}")
			end)
		end)

		it("should throw when there is one parameter and no argument")(function()
			expectError(function()
				Fmt("{}")
			end)
		end)

		it("should throw when there are more parameters than arguments")(function()
			expectError(function()
				Fmt("{}, {}", 1)
			end)
		end)

		it("should throw when there are more arguments than parameter")(function()
			expectError(function()
				Fmt("{}", 1, 2)
			end)
		end)

		it("should return an identical string")(function()
			expect(function()
				return Fmt("Hello, world!") == "Hello, world!"
			end)
		end)

		it("should escape")(function()
			expect(function()
				return Fmt("{{}}") == "{}"
			end)
		end)

		it("should replace parameter")(function()
			expect(function()
				return Fmt("Hello, {}!", "Gamer") == "Hello, Gamer!"
			end)
		end)

		it("should format positional parameter")(function()
			expect(function()
				return Fmt("{1} {} {0} {}", 1, 2) == "2 1 1 2"
			end)
		end)

		it("should format extra positional parameter")(function()
			expect(function()
				return Fmt("{} {1}", 1, 2) == "1 2"
			end)
		end)

		it("should throw with extra parameter")(function()
			expectError(function()
				Fmt("{} {1} {} {}", 1, 2)
			end)
		end)

		it("should return open brace literal")(function()
			expect(function()
				return Fmt("{{") == "{"
			end)
		end)

		it("should return open brace literal")(function()
			expect(function()
				return Fmt("}}") == "}"
			end)
		end)

		it("should throw with a negative positional parameter")(function()
			expectError(function()
				Fmt("{-1}", 1)
			end)

			expectError(function()
				Fmt("{1.5}", 1)
			end)
		end)

		it("should throw with an invalid positional parameter")(function()
			expectError(function()
				Fmt("{1}", 1)
			end)
		end)

		it("should throw when more arguments than positional parameters are provided")(function()
			expectError(function()
				Fmt("{2}", 1, 2)
			end)
		end)

		it("should format named parameter")(function()
			expect(function()
				return Fmt("Hello, {name}!", {
					name = "Gamer";
				}) == "Hello, Gamer!"
			end)
		end)

		it("should format named and regular parameters")(function()
			expect(function()
				return Fmt("Hello, {name}! How are {} today, {name}?", "you", {
					name = "Gamer";
				}) == "Hello, Gamer! How are you today, Gamer?"
			end)
		end)

		it("should format multiple named parameters")(function()
			expect(function()
				return Fmt("Hello, {name}! How {word} you doing {other}?", {
					word = "are";
					name = "Gamer";
					other = "today";
				}) == "Hello, Gamer! How are you doing today?"
			end)
		end)

		it("should format named, regular, and positional parameters")(function()
			expect(function()
				return Fmt("Hello, {name}! How {} you {1}, {name}?", "are", "today", {
					name = "Gamer";
				}) == "Hello, Gamer! How are you today, Gamer?"
			end)
		end)

		it("should throw with extra parameters")(function()
			expectError(function()
				Fmt("Hello, {name}! How {} you {1}, {name}? {} {}", "are", "today", {
					name = "Gamer";
				})
			end)
		end)

		it("should throw with extra arguments")(function()
			expectError(function()
				Fmt("Hello, {name}! How {} you {1}, {name}? {}", "are", "today", "yes", {
					name = "Gamer";
				})
			end)
		end)

		it("should use debug form")(function()
			expect(function()
				return Fmt("{}", "\"") == "\""
			end)
			expect(function()
				return Fmt("{:?}", "\"") == "\"\\\"\""
			end)
		end)

		it("should throw with invalid enhanced parameter")(function()
			expectError(function()
				Fmt("{:!}")
			end)
		end)

		it("should add spaces to fit minimum width")(function()
			expect(function()
				return Fmt("{:5}", "x") == "x    "
			end)
		end)

		it("should not add spaces when greater than minimum width")(function()
			expect(function()
				return Fmt("{:5}", "hello") == "hello"
			end)
		end)

		it("should handle sign")(function()
			expect(function()
				return Fmt("{positive} {positive:+} {negative:+} {zero:+} {message:+}", {
					positive = 5;
					negative = -5;
					zero = 0;
					message = "hello";
				}) == "5 +5 -5 +0 hello"
			end)
		end)

		it("should handle precision")(function()
			expect(function()
				return Fmt("{0:.5} {1:.3}", 5, 5.0001) == "5.00000 5.000"
			end)
		end)

		it("should handle leading zeros")(function()
			expect(function()
				return Fmt("{0:05} {1:02} {1:01}", 5, 42) == "00005 42 42"
			end)
		end)

		it("should handle array")(function()
			local array = {1, 2, 3}

			expect(function()
				return string.find(Fmt("{}", array), "table: 0x") ~= nil
			end)
			expect(function()
				return Fmt("{:?}", array) == "{[1] = 1, [2] = 2, [3] = 3}"
			end)
			expect(function()
				return Fmt("{:#?}", array) == "{\n    [1] = 1,\n    [2] = 2,\n    [3] = 3\n}"
			end)
		end)

		it("should handle edge case")(function()
			local buffer = table.pack(Fmt.Output("{} {} {}", "hello", 5, "yes"))
			expect(function()
				return buffer[1] == "hello 5 yes"
			end)
			expect(function()
				return buffer[2] == nil
			end)
		end)
	end)

	measure("none")(function()
		operation(function()
			for _ = 1, 100 do
				Fmt("Hello, world!")
			end
		end)
	end, "Fmt")

	measure("string")(function()
		local array = {
			"swagalicious";
			utf8.char(9757, 129299);
			"Hello!";
			`{utf8.char(129327)} Wow, what an exciting day! {utf8.char(10024)} Let's keep going!`;
			utf8.char(128077, 128076, 129310, 129311);
			"A long string without emojis just to see the performance!";
			`{utf8.char(9992, 65039)} Traveling is so much fun! {utf8.char(127757, 9996, 65039)}`;
		}

		operation(function()
			for _, value in array do
				Fmt("{}", value)
			end
		end)
	end, "Fmt")

	measure("multi-input")(function()
		-- Testing with a larger input to evaluate performance
		local array = table.create(100)
		for index = 1, 100 do
			array[index] = {math.random(-1E4, 1E4), "gaming", {math.random(-10, 10)}} :: {unknown}
		end

		operation(function()
			for _, values in array do
				Fmt("{} {}, {}", table.unpack(values, 1, 3))
			end
		end)
	end, "Fmt")

	measure("sign")(function()
		operation(function()
			for _ = 1, 100 do
				Fmt("{positive} {positive:+} {negative:+} {zero:+} {message:+}", {
					positive = 5;
					negative = -5;
					zero = 0;
					message = "hello";
				})
			end
		end)
	end, "Fmt")

	measure("precision")(function()
		operation(function()
			for _ = 1, 100 do
				Fmt("{0:.5} {1:.3}", 5, 5.0001)
			end
		end)
	end, "Fmt")

	measure("padding")(function()
		operation(function()
			for _ = 1, 100 do
				Fmt("{:5}", "x")
				Fmt("{:5}", "hello")
			end
		end)
	end, "Fmt")

	local ARRAY = {1, 2, 3}

	measure("{:?} table")(function()
		operation(function()
			for _ = 1, 100 do
				Fmt("{:?}", ARRAY)
			end
		end)
	end, "Fmt")

	measure("{:#?} table")(function()
		operation(function()
			for _ = 1, 100 do
				Fmt("{:#?}", ARRAY)
			end
		end)
	end, "Fmt")
end
