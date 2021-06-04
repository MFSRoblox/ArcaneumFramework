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

local Melee = {}
Melee.__index = Melee
function Melee.new(Data)
    local self = setmetatable(BaseConstructor(Data),Melee)
    self.AttackVolume = Vector3.new() --Facing in the same direction as the player.
    self.AttackDisplacement = Vector3.new() --Relative to the Torso of the player.
    
    return self
end

function Melee:InvokeAction(Data)
    warn("BaseAction:InvokeAction() wasn't overwritten! Data given", Data)
    return false, {} --SendReaction, ReactionData
end

return Melee