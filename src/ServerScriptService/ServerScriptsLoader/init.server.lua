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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestModuleName = "ArcaneumTests"
local TestModule = ReplicatedStorage:FindFirstChild(TestModuleName)
if ArcaneumGlobals:GetGlobal("IsTesting") then
    local TestService = require(TestModule):New(script.ServerTests)
    print("Run Tests")
    TestService:Run()
end