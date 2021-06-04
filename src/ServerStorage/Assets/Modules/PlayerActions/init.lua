local BaseAction = {}
BaseAction.__index = BaseAction
function BaseAction.new()
    local self = {}
    setmetatable(self,BaseAction)

    return self
end

function BaseAction:InvokeAction(Data)
    warn("BaseAction:InvokeAction() wasn't overwritten! Data given", Data)
    return false, {} --SendReaction, ReactionData
end

return BaseAction

--[[
New Action Copy Pasta:

local ServerStorage = game:GetService("ServerStorage")
local ServerAssets = ServerStorage:WaitForChild("Assets")
local Modules = ServerAssets:WaitForChild("Modules")
local PlayerActionScript = Modules:WaitForChild("PlayerActions")
local BaseClass = require(PlayerActionScript)
local ParentClassScript = script.Parent.Parent:FindFirstChild("Server")
local ParentClass do
    if ParentClassScript then ParentClass = require(ParentClassScript) end
end
local BaseConstructor
if ParentClass then BaseConstructor = ParentClass.new else BaseConstructor = BaseClass.new end

local Action = {}
Action.__index = Action
function Action.new()
    local self = setmetatable(BaseClass.new(Data),Action)
    
    return self
end

function Action:InvokeAction(Data)
    warn("Action:InvokeAction() wasn't overwritten! Data given", Data)
    return false, {} --SendReaction, ReactionData
end

return Action
]]