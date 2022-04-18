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

local ArcaneumGlobals = Software.Globals
--[[
local RunService = game:GetService("RunService")
print(RunService:IsRunMode())
if ArcaneumGlobals.IsStudio and not RunService:IsRunMode() then
    game:GetService("Players").PlayerAdded:Wait()]]
--end
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestModuleName = "ArcaneumTests"
local TestModule = ReplicatedStorage:FindFirstChild(TestModuleName)
if ArcaneumGlobals.IsTesting then
    local TestService = require(TestModule):New(script.ServerTests)
    print("Run Tests")
    TestService:Run()
end