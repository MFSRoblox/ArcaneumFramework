local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ArcaneumGlobals = require(ReplicatedStorage.Arcaneum)
ArcaneumGlobals:CheckVersion("1.1.0")
local Utilities = ArcaneumGlobals:GetGlobal("Utilities"):CheckVersion("1.0.0")
local ServerGlobals = Utilities:ModulesToTable(script:GetChildren())
return ServerGlobals