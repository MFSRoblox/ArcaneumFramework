--[[=[
    @class ClientScriptsLoader
    @client
    This script sets up Arcaneum for the player's environment.
]=]]
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local BootDrive = LocalPlayer:WaitForChild("ArcaneumFramework")
print("Booting")
local Software = require(BootDrive)
print("Booted")

local ArcaneumGlobals = Software.Globals
ArcaneumGlobals:CheckVersion("1.1.0")
print("Arcaneum Client Initialized. Software:",Software,"\nArcaneumGlobals:",ArcaneumGlobals)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestModuleName = "ArcaneumTesting"
local TestModule = ReplicatedStorage:FindFirstChild(TestModuleName)
if ArcaneumGlobals:GetGlobal("IsTesting") then
    local TestingService = require(TestModule)
    TestingService:CheckVersion("1.0.0")
    local Tests = TestingService:New(script.Tests)
    Tests:Run()
end