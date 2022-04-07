local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
local ArcaneumGlobals = require(ReplicatedStorage:FindFirstChild(GlobalModuleName))
local Utilities = ArcaneumGlobals.Utilities
local ClientGlobals = Utilities:ModulesToTable(script:GetChildren())
return ClientGlobals