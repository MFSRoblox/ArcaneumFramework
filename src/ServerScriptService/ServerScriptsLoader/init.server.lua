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
ArcaneumGlobals:CheckVersion("1.1.0")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestModuleName = "ArcaneumTesting"
local TestModule = ReplicatedStorage:FindFirstChild(TestModuleName)
if ArcaneumGlobals:GetGlobal("IsTesting") then
    local TestingService = require(TestModule)
    TestingService:CheckVersion("1.0.0")
    local Tests = TestingService:New(script.Tests)
    Tests:Run()
end