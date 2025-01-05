--!optimize 2
--!strict

local Color3 = require("@contexts/Color3")
local SortedArray = require("@packages/SortedArray")

export type Color3 = Color3.PolyfillColor3
export type ColorData = {
	Color3: Color3,
	Name: string,
	Number: number,
}

local function DeepCopy<T>(object: T): T
	local new = table.clone(object :: never)
	for index, value in object :: never do
		if type(value) == "table" then
			new[index] = DeepCopy(value)
		end
	end
	return new :: never
end

local BASE_DATA: {ColorData} = {
	{
		Color3 = Color3.fromRGB(242, 243, 243);
		Name = "White";
		Number = 1;
	};
	{
		Color3 = Color3.fromRGB(161, 165, 162);
		Name = "Grey";
		Number = 2;
	};
	{
		Color3 = Color3.fromRGB(249, 233, 153);
		Name = "Light yellow";
		Number = 3;
	};
	{
		Color3 = Color3.fromRGB(215, 197, 154);
		Name = "Brick yellow";
		Number = 5;
	};
	{
		Color3 = Color3.fromRGB(194, 218, 184);
		Name = "Light green (Mint)";
		Number = 6;
	};
	{
		Color3 = Color3.fromRGB(232, 186, 200);
		Name = "Light reddish violet";
		Number = 9;
	};
	{
		Color3 = Color3.fromRGB(128, 187, 219);
		Name = "Pastel Blue";
		Number = 11;
	};
	{
		Color3 = Color3.fromRGB(203, 132, 66);
		Name = "Light orange brown";
		Number = 12;
	};
	{
		Color3 = Color3.fromRGB(204, 142, 105);
		Name = "Nougat";
		Number = 18;
	};
	{
		Color3 = Color3.fromRGB(196, 40, 28);
		Name = "Bright red";
		Number = 21;
	};
	{
		Color3 = Color3.fromRGB(196, 112, 160);
		Name = "Med. reddish violet";
		Number = 22;
	};
	{
		Color3 = Color3.fromRGB(13, 105, 172);
		Name = "Bright blue";
		Number = 23;
	};
	{
		Color3 = Color3.fromRGB(245, 205, 48);
		Name = "Bright yellow";
		Number = 24;
	};
	{
		Color3 = Color3.fromRGB(98, 71, 50);
		Name = "Earth orange";
		Number = 25;
	};
	{
		Color3 = Color3.fromRGB(27, 42, 53);
		Name = "Black";
		Number = 26;
	};
	{
		Color3 = Color3.fromRGB(109, 110, 108);
		Name = "Dark grey";
		Number = 27;
	};
	{
		Color3 = Color3.fromRGB(40, 127, 71);
		Name = "Dark green";
		Number = 28;
	};
	{
		Color3 = Color3.fromRGB(161, 196, 140);
		Name = "Medium green";
		Number = 29;
	};
	{
		Color3 = Color3.fromRGB(243, 207, 155);
		Name = "Lig. Yellowich orange";
		Number = 36;
	};
	{
		Color3 = Color3.fromRGB(75, 151, 75);
		Name = "Bright green";
		Number = 37;
	};
	{
		Color3 = Color3.fromRGB(160, 95, 53);
		Name = "Dark orange";
		Number = 38;
	};
	{
		Color3 = Color3.fromRGB(193, 202, 222);
		Name = "Light bluish violet";
		Number = 39;
	};
	{
		Color3 = Color3.fromRGB(236, 236, 236);
		Name = "Transparent";
		Number = 40;
	};
	{
		Color3 = Color3.fromRGB(205, 84, 75);
		Name = "Tr. Red";
		Number = 41;
	};
	{
		Color3 = Color3.fromRGB(193, 223, 240);
		Name = "Tr. Lg blue";
		Number = 42;
	};
	{
		Color3 = Color3.fromRGB(123, 182, 232);
		Name = "Tr. Blue";
		Number = 43;
	};
	{
		Color3 = Color3.fromRGB(247, 241, 141);
		Name = "Tr. Yellow";
		Number = 44;
	};
	{
		Color3 = Color3.fromRGB(180, 210, 228);
		Name = "Light blue";
		Number = 45;
	};
	{
		Color3 = Color3.fromRGB(217, 133, 108);
		Name = "Tr. Flu. Reddish orange";
		Number = 47;
	};
	{
		Color3 = Color3.fromRGB(132, 182, 141);
		Name = "Tr. Green";
		Number = 48;
	};
	{
		Color3 = Color3.fromRGB(248, 241, 132);
		Name = "Tr. Flu. Green";
		Number = 49;
	};
	{
		Color3 = Color3.fromRGB(236, 232, 222);
		Name = "Phosph. White";
		Number = 50;
	};
	{
		Color3 = Color3.fromRGB(238, 196, 182);
		Name = "Light red";
		Number = 100;
	};
	{
		Color3 = Color3.fromRGB(218, 134, 122);
		Name = "Medium red";
		Number = 101;
	};
	{
		Color3 = Color3.fromRGB(110, 153, 202);
		Name = "Medium blue";
		Number = 102;
	};
	{
		Color3 = Color3.fromRGB(199, 193, 183);
		Name = "Light grey";
		Number = 103;
	};
	{
		Color3 = Color3.fromRGB(107, 50, 124);
		Name = "Bright violet";
		Number = 104;
	};
	{
		Color3 = Color3.fromRGB(226, 155, 64);
		Name = "Br. yellowish orange";
		Number = 105;
	};
	{
		Color3 = Color3.fromRGB(218, 133, 65);
		Name = "Bright orange";
		Number = 106;
	};
	{
		Color3 = Color3.fromRGB(0, 143, 156);
		Name = "Bright bluish green";
		Number = 107;
	};
	{
		Color3 = Color3.fromRGB(104, 92, 67);
		Name = "Earth yellow";
		Number = 108;
	};
	{
		Color3 = Color3.fromRGB(67, 84, 147);
		Name = "Bright bluish violet";
		Number = 110;
	};
	{
		Color3 = Color3.fromRGB(191, 183, 177);
		Name = "Tr. Brown";
		Number = 111;
	};
	{
		Color3 = Color3.fromRGB(104, 116, 172);
		Name = "Medium bluish violet";
		Number = 112;
	};
	{
		Color3 = Color3.fromRGB(229, 173, 200);
		Name = "Tr. Medi. reddish violet";
		Number = 113;
	};
	{
		Color3 = Color3.fromRGB(199, 210, 60);
		Name = "Med. yellowish green";
		Number = 115;
	};
	{
		Color3 = Color3.fromRGB(85, 165, 175);
		Name = "Med. bluish green";
		Number = 116;
	};
	{
		Color3 = Color3.fromRGB(183, 215, 213);
		Name = "Light bluish green";
		Number = 118;
	};
	{
		Color3 = Color3.fromRGB(164, 189, 71);
		Name = "Br. yellowish green";
		Number = 119;
	};
	{
		Color3 = Color3.fromRGB(217, 228, 167);
		Name = "Lig. yellowish green";
		Number = 120;
	};
	{
		Color3 = Color3.fromRGB(231, 172, 88);
		Name = "Med. yellowish orange";
		Number = 121;
	};
	{
		Color3 = Color3.fromRGB(211, 111, 76);
		Name = "Br. reddish orange";
		Number = 123;
	};
	{
		Color3 = Color3.fromRGB(146, 57, 120);
		Name = "Bright reddish violet";
		Number = 124;
	};
	{
		Color3 = Color3.fromRGB(234, 184, 146);
		Name = "Light orange";
		Number = 125;
	};
	{
		Color3 = Color3.fromRGB(165, 165, 203);
		Name = "Tr. Bright bluish violet";
		Number = 126;
	};
	{
		Color3 = Color3.fromRGB(220, 188, 129);
		Name = "Gold";
		Number = 127;
	};
	{
		Color3 = Color3.fromRGB(174, 122, 89);
		Name = "Dark nougat";
		Number = 128;
	};
	{
		Color3 = Color3.fromRGB(156, 163, 168);
		Name = "Silver";
		Number = 131;
	};
	{
		Color3 = Color3.fromRGB(213, 115, 61);
		Name = "Neon orange";
		Number = 133;
	};
	{
		Color3 = Color3.fromRGB(216, 221, 86);
		Name = "Neon green";
		Number = 134;
	};
	{
		Color3 = Color3.fromRGB(116, 134, 157);
		Name = "Sand blue";
		Number = 135;
	};
	{
		Color3 = Color3.fromRGB(135, 124, 144);
		Name = "Sand violet";
		Number = 136;
	};
	{
		Color3 = Color3.fromRGB(224, 152, 100);
		Name = "Medium orange";
		Number = 137;
	};
	{
		Color3 = Color3.fromRGB(149, 138, 115);
		Name = "Sand yellow";
		Number = 138;
	};
	{
		Color3 = Color3.fromRGB(32, 58, 86);
		Name = "Earth blue";
		Number = 140;
	};
	{
		Color3 = Color3.fromRGB(39, 70, 45);
		Name = "Earth green";
		Number = 141;
	};
	{
		Color3 = Color3.fromRGB(207, 226, 247);
		Name = "Tr. Flu. Blue";
		Number = 143;
	};
	{
		Color3 = Color3.fromRGB(121, 136, 161);
		Name = "Sand blue metallic";
		Number = 145;
	};
	{
		Color3 = Color3.fromRGB(149, 142, 163);
		Name = "Sand violet metallic";
		Number = 146;
	};
	{
		Color3 = Color3.fromRGB(147, 135, 103);
		Name = "Sand yellow metallic";
		Number = 147;
	};
	{
		Color3 = Color3.fromRGB(87, 88, 87);
		Name = "Dark grey metallic";
		Number = 148;
	};
	{
		Color3 = Color3.fromRGB(22, 29, 50);
		Name = "Black metallic";
		Number = 149;
	};
	{
		Color3 = Color3.fromRGB(171, 173, 172);
		Name = "Light grey metallic";
		Number = 150;
	};
	{
		Color3 = Color3.fromRGB(120, 144, 130);
		Name = "Sand green";
		Number = 151;
	};
	{
		Color3 = Color3.fromRGB(149, 121, 119);
		Name = "Sand red";
		Number = 153;
	};
	{
		Color3 = Color3.fromRGB(123, 46, 47);
		Name = "Dark red";
		Number = 154;
	};
	{
		Color3 = Color3.fromRGB(255, 246, 123);
		Name = "Tr. Flu. Yellow";
		Number = 157;
	};
	{
		Color3 = Color3.fromRGB(225, 164, 194);
		Name = "Tr. Flu. Red";
		Number = 158;
	};
	{
		Color3 = Color3.fromRGB(117, 108, 98);
		Name = "Gun metallic";
		Number = 168;
	};
	{
		Color3 = Color3.fromRGB(151, 105, 91);
		Name = "Red flip/flop";
		Number = 176;
	};
	{
		Color3 = Color3.fromRGB(180, 132, 85);
		Name = "Yellow flip/flop";
		Number = 178;
	};
	{
		Color3 = Color3.fromRGB(137, 135, 136);
		Name = "Silver flip/flop";
		Number = 179;
	};
	{
		Color3 = Color3.fromRGB(215, 169, 75);
		Name = "Curry";
		Number = 180;
	};
	{
		Color3 = Color3.fromRGB(249, 214, 46);
		Name = "Fire Yellow";
		Number = 190;
	};
	{
		Color3 = Color3.fromRGB(232, 171, 45);
		Name = "Flame yellowish orange";
		Number = 191;
	};
	{
		Color3 = Color3.fromRGB(105, 64, 40);
		Name = "Reddish brown";
		Number = 192;
	};
	{
		Color3 = Color3.fromRGB(207, 96, 36);
		Name = "Flame reddish orange";
		Number = 193;
	};
	{
		Color3 = Color3.fromRGB(163, 162, 165);
		Name = "Medium stone grey";
		Number = 194;
	};
	{
		Color3 = Color3.fromRGB(70, 103, 164);
		Name = "Royal blue";
		Number = 195;
	};
	{
		Color3 = Color3.fromRGB(35, 71, 139);
		Name = "Dark Royal blue";
		Number = 196;
	};
	{
		Color3 = Color3.fromRGB(142, 66, 133);
		Name = "Bright reddish lilac";
		Number = 198;
	};
	{
		Color3 = Color3.fromRGB(99, 95, 98);
		Name = "Dark stone grey";
		Number = 199;
	};
	{
		Color3 = Color3.fromRGB(130, 138, 93);
		Name = "Lemon metalic";
		Number = 200;
	};
	{
		Color3 = Color3.fromRGB(229, 228, 223);
		Name = "Light stone grey";
		Number = 208;
	};
	{
		Color3 = Color3.fromRGB(176, 142, 68);
		Name = "Dark Curry";
		Number = 209;
	};
	{
		Color3 = Color3.fromRGB(112, 149, 120);
		Name = "Faded green";
		Number = 210;
	};
	{
		Color3 = Color3.fromRGB(121, 181, 181);
		Name = "Turquoise";
		Number = 211;
	};
	{
		Color3 = Color3.fromRGB(159, 195, 233);
		Name = "Light Royal blue";
		Number = 212;
	};
	{
		Color3 = Color3.fromRGB(108, 129, 183);
		Name = "Medium Royal blue";
		Number = 213;
	};
	{
		Color3 = Color3.fromRGB(144, 76, 42);
		Name = "Rust";
		Number = 216;
	};
	{
		Color3 = Color3.fromRGB(124, 92, 70);
		Name = "Brown";
		Number = 217;
	};
	{
		Color3 = Color3.fromRGB(150, 112, 159);
		Name = "Reddish lilac";
		Number = 218;
	};
	{
		Color3 = Color3.fromRGB(107, 98, 155);
		Name = "Lilac";
		Number = 219;
	};
	{
		Color3 = Color3.fromRGB(167, 169, 206);
		Name = "Light lilac";
		Number = 220;
	};
	{
		Color3 = Color3.fromRGB(205, 98, 152);
		Name = "Bright purple";
		Number = 221;
	};
	{
		Color3 = Color3.fromRGB(228, 173, 200);
		Name = "Light purple";
		Number = 222;
	};
	{
		Color3 = Color3.fromRGB(220, 144, 149);
		Name = "Light pink";
		Number = 223;
	};
	{
		Color3 = Color3.fromRGB(240, 213, 160);
		Name = "Light brick yellow";
		Number = 224;
	};
	{
		Color3 = Color3.fromRGB(235, 184, 127);
		Name = "Warm yellowish orange";
		Number = 225;
	};
	{
		Color3 = Color3.fromRGB(253, 234, 141);
		Name = "Cool yellow";
		Number = 226;
	};
	{
		Color3 = Color3.fromRGB(125, 187, 221);
		Name = "Dove blue";
		Number = 232;
	};
	{
		Color3 = Color3.fromRGB(52, 43, 117);
		Name = "Medium lilac";
		Number = 268;
	};
	{
		Color3 = Color3.fromRGB(80, 109, 84);
		Name = "Slime green";
		Number = 301;
	};
	{
		Color3 = Color3.fromRGB(91, 93, 105);
		Name = "Smoky grey";
		Number = 302;
	};
	{
		Color3 = Color3.fromRGB(0, 16, 176);
		Name = "Dark blue";
		Number = 303;
	};
	{
		Color3 = Color3.fromRGB(44, 101, 29);
		Name = "Parsley green";
		Number = 304;
	};
	{
		Color3 = Color3.fromRGB(82, 124, 174);
		Name = "Steel blue";
		Number = 305;
	};
	{
		Color3 = Color3.fromRGB(51, 88, 130);
		Name = "Storm blue";
		Number = 306;
	};
	{
		Color3 = Color3.fromRGB(16, 42, 220);
		Name = "Lapis";
		Number = 307;
	};
	{
		Color3 = Color3.fromRGB(61, 21, 133);
		Name = "Dark indigo";
		Number = 308;
	};
	{
		Color3 = Color3.fromRGB(52, 142, 64);
		Name = "Sea green";
		Number = 309;
	};
	{
		Color3 = Color3.fromRGB(91, 154, 76);
		Name = "Shamrock";
		Number = 310;
	};
	{
		Color3 = Color3.fromRGB(159, 161, 172);
		Name = "Fossil";
		Number = 311;
	};
	{
		Color3 = Color3.fromRGB(89, 34, 89);
		Name = "Mulberry";
		Number = 312;
	};
	{
		Color3 = Color3.fromRGB(31, 128, 29);
		Name = "Forest green";
		Number = 313;
	};
	{
		Color3 = Color3.fromRGB(159, 173, 192);
		Name = "Cadet blue";
		Number = 314;
	};
	{
		Color3 = Color3.fromRGB(9, 137, 207);
		Name = "Electric blue";
		Number = 315;
	};
	{
		Color3 = Color3.fromRGB(123, 0, 123);
		Name = "Eggplant";
		Number = 316;
	};
	{
		Color3 = Color3.fromRGB(124, 156, 107);
		Name = "Moss";
		Number = 317;
	};
	{
		Color3 = Color3.fromRGB(138, 171, 133);
		Name = "Artichoke";
		Number = 318;
	};
	{
		Color3 = Color3.fromRGB(185, 196, 177);
		Name = "Sage green";
		Number = 319;
	};
	{
		Color3 = Color3.fromRGB(202, 203, 209);
		Name = "Ghost grey";
		Number = 320;
	};
	{
		Color3 = Color3.fromRGB(167, 94, 155);
		Name = "Lilac";
		Number = 321;
	};
	{
		Color3 = Color3.fromRGB(123, 47, 123);
		Name = "Plum";
		Number = 322;
	};
	{
		Color3 = Color3.fromRGB(148, 190, 129);
		Name = "Olivine";
		Number = 323;
	};
	{
		Color3 = Color3.fromRGB(168, 189, 153);
		Name = "Laurel green";
		Number = 324;
	};
	{
		Color3 = Color3.fromRGB(223, 223, 222);
		Name = "Quill grey";
		Number = 325;
	};
	{
		Color3 = Color3.fromRGB(151, 0, 0);
		Name = "Crimson";
		Number = 327;
	};
	{
		Color3 = Color3.fromRGB(177, 229, 166);
		Name = "Mint";
		Number = 328;
	};
	{
		Color3 = Color3.fromRGB(152, 194, 219);
		Name = "Baby blue";
		Number = 329;
	};
	{
		Color3 = Color3.fromRGB(255, 152, 220);
		Name = "Carnation pink";
		Number = 330;
	};
	{
		Color3 = Color3.fromRGB(255, 89, 89);
		Name = "Persimmon";
		Number = 331;
	};
	{
		Color3 = Color3.fromRGB(117, 0, 0);
		Name = "Maroon";
		Number = 332;
	};
	{
		Color3 = Color3.fromRGB(239, 184, 56);
		Name = "Gold";
		Number = 333;
	};
	{
		Color3 = Color3.fromRGB(248, 217, 109);
		Name = "Daisy orange";
		Number = 334;
	};
	{
		Color3 = Color3.fromRGB(231, 231, 236);
		Name = "Pearl";
		Number = 335;
	};
	{
		Color3 = Color3.fromRGB(199, 212, 228);
		Name = "Fog";
		Number = 336;
	};
	{
		Color3 = Color3.fromRGB(255, 148, 148);
		Name = "Salmon";
		Number = 337;
	};
	{
		Color3 = Color3.fromRGB(190, 104, 98);
		Name = "Terra Cotta";
		Number = 338;
	};
	{
		Color3 = Color3.fromRGB(86, 36, 36);
		Name = "Cocoa";
		Number = 339;
	};
	{
		Color3 = Color3.fromRGB(241, 231, 199);
		Name = "Wheat";
		Number = 340;
	};
	{
		Color3 = Color3.fromRGB(254, 243, 187);
		Name = "Buttermilk";
		Number = 341;
	};
	{
		Color3 = Color3.fromRGB(224, 178, 208);
		Name = "Mauve";
		Number = 342;
	};
	{
		Color3 = Color3.fromRGB(212, 144, 189);
		Name = "Sunrise";
		Number = 343;
	};
	{
		Color3 = Color3.fromRGB(150, 85, 85);
		Name = "Tawny";
		Number = 344;
	};
	{
		Color3 = Color3.fromRGB(143, 76, 42);
		Name = "Rust";
		Number = 345;
	};
	{
		Color3 = Color3.fromRGB(211, 190, 150);
		Name = "Cashmere";
		Number = 346;
	};
	{
		Color3 = Color3.fromRGB(226, 220, 188);
		Name = "Khaki";
		Number = 347;
	};
	{
		Color3 = Color3.fromRGB(237, 234, 234);
		Name = "Lily white";
		Number = 348;
	};
	{
		Color3 = Color3.fromRGB(233, 218, 218);
		Name = "Seashell";
		Number = 349;
	};
	{
		Color3 = Color3.fromRGB(136, 62, 62);
		Name = "Burgundy";
		Number = 350;
	};
	{
		Color3 = Color3.fromRGB(188, 155, 93);
		Name = "Cork";
		Number = 351;
	};
	{
		Color3 = Color3.fromRGB(199, 172, 120);
		Name = "Burlap";
		Number = 352;
	};
	{
		Color3 = Color3.fromRGB(202, 191, 163);
		Name = "Beige";
		Number = 353;
	};
	{
		Color3 = Color3.fromRGB(187, 179, 178);
		Name = "Oyster";
		Number = 354;
	};
	{
		Color3 = Color3.fromRGB(108, 88, 75);
		Name = "Pine Cone";
		Number = 355;
	};
	{
		Color3 = Color3.fromRGB(160, 132, 79);
		Name = "Fawn brown";
		Number = 356;
	};
	{
		Color3 = Color3.fromRGB(149, 137, 136);
		Name = "Hurricane grey";
		Number = 357;
	};
	{
		Color3 = Color3.fromRGB(171, 168, 158);
		Name = "Cloudy grey";
		Number = 358;
	};
	{
		Color3 = Color3.fromRGB(175, 148, 131);
		Name = "Linen";
		Number = 359;
	};
	{
		Color3 = Color3.fromRGB(150, 103, 102);
		Name = "Copper";
		Number = 360;
	};
	{
		Color3 = Color3.fromRGB(86, 66, 54);
		Name = "Medium brown";
		Number = 361;
	};
	{
		Color3 = Color3.fromRGB(126, 104, 63);
		Name = "Bronze";
		Number = 362;
	};
	{
		Color3 = Color3.fromRGB(105, 102, 92);
		Name = "Flint";
		Number = 363;
	};
	{
		Color3 = Color3.fromRGB(90, 76, 66);
		Name = "Dark taupe";
		Number = 364;
	};
	{
		Color3 = Color3.fromRGB(106, 57, 9);
		Name = "Burnt Sienna";
		Number = 365;
	};
	{
		Color3 = Color3.fromRGB(248, 248, 248);
		Name = "Institutional white";
		Number = 1001;
	};
	{
		Color3 = Color3.fromRGB(205, 205, 205);
		Name = "Mid gray";
		Number = 1002;
	};
	{
		Color3 = Color3.fromRGB(17, 17, 17);
		Name = "Really black";
		Number = 1003;
	};
	{
		Color3 = Color3.fromRGB(255, 0, 0);
		Name = "Really red";
		Number = 1004;
	};
	{
		Color3 = Color3.fromRGB(255, 176, 0);
		Name = "Deep orange";
		Number = 1005;
	};
	{
		Color3 = Color3.fromRGB(180, 128, 255);
		Name = "Alder";
		Number = 1006;
	};
	{
		Color3 = Color3.fromRGB(163, 75, 75);
		Name = "Dusty Rose";
		Number = 1007;
	};
	{
		Color3 = Color3.fromRGB(193, 190, 66);
		Name = "Olive";
		Number = 1008;
	};
	{
		Color3 = Color3.fromRGB(255, 255, 0);
		Name = "New Yeller";
		Number = 1009;
	};
	{
		Color3 = Color3.fromRGB(0, 0, 255);
		Name = "Really blue";
		Number = 1010;
	};
	{
		Color3 = Color3.fromRGB(0, 32, 96);
		Name = "Navy blue";
		Number = 1011;
	};
	{
		Color3 = Color3.fromRGB(33, 84, 185);
		Name = "Deep blue";
		Number = 1012;
	};
	{
		Color3 = Color3.fromRGB(4, 175, 236);
		Name = "Cyan";
		Number = 1013;
	};
	{
		Color3 = Color3.fromRGB(170, 85, 0);
		Name = "CGA brown";
		Number = 1014;
	};
	{
		Color3 = Color3.fromRGB(170, 0, 170);
		Name = "Magenta";
		Number = 1015;
	};
	{
		Color3 = Color3.fromRGB(255, 102, 204);
		Name = "Pink";
		Number = 1016;
	};
	{
		Color3 = Color3.fromRGB(255, 175, 0);
		Name = "Deep orange";
		Number = 1017;
	};
	{
		Color3 = Color3.fromRGB(18, 238, 212);
		Name = "Teal";
		Number = 1018;
	};
	{
		Color3 = Color3.fromRGB(0, 255, 255);
		Name = "Toothpaste";
		Number = 1019;
	};
	{
		Color3 = Color3.fromRGB(0, 255, 0);
		Name = "Lime green";
		Number = 1020;
	};
	{
		Color3 = Color3.fromRGB(58, 125, 21);
		Name = "Camo";
		Number = 1021;
	};
	{
		Color3 = Color3.fromRGB(127, 142, 100);
		Name = "Grime";
		Number = 1022;
	};
	{
		Color3 = Color3.fromRGB(140, 91, 159);
		Name = "Lavender";
		Number = 1023;
	};
	{
		Color3 = Color3.fromRGB(175, 221, 255);
		Name = "Pastel light blue";
		Number = 1024;
	};
	{
		Color3 = Color3.fromRGB(255, 201, 201);
		Name = "Pastel orange";
		Number = 1025;
	};
	{
		Color3 = Color3.fromRGB(177, 167, 255);
		Name = "Pastel violet";
		Number = 1026;
	};
	{
		Color3 = Color3.fromRGB(159, 243, 233);
		Name = "Pastel blue-green";
		Number = 1027;
	};
	{
		Color3 = Color3.fromRGB(204, 255, 204);
		Name = "Pastel green";
		Number = 1028;
	};
	{
		Color3 = Color3.fromRGB(255, 255, 204);
		Name = "Pastel yellow";
		Number = 1029;
	};
	{
		Color3 = Color3.fromRGB(255, 204, 153);
		Name = "Pastel brown";
		Number = 1030;
	};
	{
		Color3 = Color3.fromRGB(98, 37, 209);
		Name = "Royal purple";
		Number = 1031;
	};
	{
		Color3 = Color3.fromRGB(255, 0, 191);
		Name = "Hot pink";
		Number = 1032;
	};
}

local Colors = table.freeze({
	ColorData = DeepCopy(BASE_DATA);
	SortedByName = SortedArray.new(DeepCopy(BASE_DATA), function(a, b)
		return a.Name < b.Name
	end);
	SortedByNumber = SortedArray.new(DeepCopy(BASE_DATA), function(a, b)
		return a.Number < b.Number
	end);
})

return Colors
