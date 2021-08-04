local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedModules = ReplicatedStorage:WaitForChild("Modules")
local UtilitiesModule = ReplicatedModules:WaitForChild("ScriptUtilities")

return require(UtilitiesModule)