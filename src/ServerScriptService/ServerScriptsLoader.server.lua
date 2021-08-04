local ServerStorage = game:GetService("ServerStorage")
local ServerAssets = ServerStorage:WaitForChild("Assets")
local ServerModule = ServerAssets:WaitForChild("ServerModule")

require(ServerModule)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedModules = ReplicatedStorage:WaitForChild("Modules")
local GlobalMod = ReplicatedModules:WaitForChild("Globals")
_G.Arcaneum = require(GlobalMod)

local TestBot = script.Parent:FindFirstChild("TestBot")
if TestBot then
    require(TestBot)
end