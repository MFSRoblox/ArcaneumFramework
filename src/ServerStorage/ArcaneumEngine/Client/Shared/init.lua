local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
local ArcaneumGlobals = require(ReplicatedStorage:FindFirstChild(GlobalModuleName))
ArcaneumGlobals:CheckVersion("1.1.0")
local Utilities = ArcaneumGlobals:GetGlobal("Utilities")
Utilities:CheckVersion("1.1.0")
local ClientGlobals = Utilities:ModulesToTable(script:GetChildren())
return ClientGlobals