--[[local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)]]
local ModuleOfWindow = script.Parent:WaitForChild("SkillTreeManager")
local SkillTreeManager = require(ModuleOfWindow)
SkillTreeManager:OpenGui()
--[[local PlayerGui = LocalPlayer.PlayerGui
local ModuleOfWindow = script.Parent:WaitForChild("PrototypeSkillTree")
local GuiInfo = require(ModuleOfWindow)
print(GuiInfo)
local _SkillTreeGuiHandle = Roact.mount(Roact.createElement(GuiInfo),PlayerGui, "Skill Tree Gui")]]