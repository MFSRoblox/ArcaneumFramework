local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
local ArcaneumGlobals = require(ReplicatedStorage:FindFirstChild(GlobalModuleName))
local Utilities = ArcaneumGlobals.Utilities
Utilities:CheckVersion("1.0.0")
local ClientGlobals = Utilities:ModulesToTable(script:GetChildren())
return ClientGlobals