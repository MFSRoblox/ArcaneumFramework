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
local TestModuleName = "ArcaneumClientTests"
local TestModule = script.Parent:FindFirstChild(TestModuleName)
print(ArcaneumGlobals.IsTesting)
if ArcaneumGlobals.IsTesting then
    local TestService = require(TestModule):New()
    TestService:Run()
end