--[[=[
    @class ServerScriptsLoader
    @server
    This script sets up Arcaneum for the environment.
]=]]
local ServerStorage = game:GetService("ServerStorage")
local BootDrive = ServerStorage:WaitForChild("ArcaneumEngine")
print("Booting")
local Software = require(BootDrive)
print("Booted")

local Players = game:GetService("Players")
local ArcaneumGlobals = Software.Globals
--[[
local RunService = game:GetService("RunService")
print(RunService:IsRunMode())
if ArcaneumGlobals.IsStudio and not RunService:IsRunMode() then
    game:GetService("Players").PlayerAdded:Wait()]]
--end
local WaitTime = 3
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
end