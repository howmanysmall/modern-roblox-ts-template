--!nonstrict
--!optimize 2

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TS = require(ReplicatedStorage:WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
return TS.Promise.all
