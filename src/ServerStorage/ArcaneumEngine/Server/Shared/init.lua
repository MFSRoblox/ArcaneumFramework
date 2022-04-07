local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ArcaneumGlobals = require(ReplicatedStorage.Arcaneum)
local Utilities = ArcaneumGlobals.Utilities
local ServerGlobals = Utilities:ModulesToTable(script:GetChildren())
return ServerGlobals