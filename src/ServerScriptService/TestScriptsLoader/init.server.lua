local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
local ArcaneumGlobals repeat
    ArcaneumGlobals = ReplicatedStorage:FindFirstChild(GlobalModuleName)
    if ArcaneumGlobals == nil then
        task.wait(1)
    else
        ArcaneumGlobals = require(ArcaneumGlobals)
    end
until ArcaneumGlobals ~= nil
--[[
local RunService = game:GetService("RunService")
print(RunService:IsRunMode())
if ArcaneumGlobals.IsStudio and not RunService:IsRunMode() then
    game:GetService("Players").PlayerAdded:Wait()]]
--end
local WaitTime = 10
if ArcaneumGlobals.IsTesting then
    print("Waiting a little in case a player is being added...\n Starting tests in:")
    for i=WaitTime, 1, -1 do
        print(i)
        task.wait(1)
    end
    local TestPlayer do
        local AllPlayers = Players:GetPlayers()
        if #AllPlayers > 0 then
            TestPlayer = AllPlayers[1]
        end
    end
    require(script.TestBot)(TestPlayer)
end