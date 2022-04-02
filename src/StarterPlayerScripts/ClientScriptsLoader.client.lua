--[[=[
    @class ClientScriptsLoader
    @client
    This script sets up Arcaneum for the player's environment.
]=]]
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local BootDrive = LocalPlayer:WaitForChild("ArcaneumEngine")
print("Booting")
local Software = require(BootDrive)
print("Booted")

local ArcaneumGlobals = Software.Globals
print("Arcaneum Client Initialized. Software:",Software,"\nArcaneumGlobals:",ArcaneumGlobals)
--[[
local RunService = game:GetService("RunService")
print(RunService:IsRunMode())
if ArcaneumGlobals.IsStudio and not RunService:IsRunMode() then
    game:GetService("Players").PlayerAdded:Wait()]]
--end
--[[local WaitTime = 0
local TestModuleName = "ArcaneumTests"
local TestModule = ServerStorage:FindFirstChild(TestModuleName)
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
    local TestService = require(TestModule):New(TestPlayer)
    TestService:Run()
end]]