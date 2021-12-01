local ServerStorage = game:GetService("ServerStorage")
local BootDrive = ServerStorage:WaitForChild("ArcaneumEngine")
print("Booting")
local Software = require(BootDrive)
print("Booted")
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
if _G.Arcaneum.IsStudio and not RunService:IsRunMode() then
    game:GetService("Players").PlayerAdded:Wait()]]
--end
local WaitTime = 10

if ArcaneumGlobals.IsTesting then
    print("Waiting a little in case a player is being added...\n Starting tests in:")
    for i=WaitTime, 1, -1 do
        print(i)
        wait(1)
    end
    require(script.TestBot)(Software)
end