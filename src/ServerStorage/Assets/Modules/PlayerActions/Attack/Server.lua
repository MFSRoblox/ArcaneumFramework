local ServerStorage = game:GetService("ServerStorage")
local ServerAssets = ServerStorage:WaitForChild("Assets")
local Modules = ServerAssets:WaitForChild("Modules")
local PlayerActionScript = Modules:WaitForChild("PlayerActions")
local BaseClass = require(PlayerActionScript)

local Attack = {}
Attack.__index = Attack
function Attack.new(Data)
    local self = setmetatable(BaseClass.new(),Attack)
    self.Damage = 0
    return self
end

function Attack:InvokeAction(Data)
    warn("Attack:InvokeAction() wasn't overwritten! Data given", Data)
    return false, {} --SendReaction, ReactionData
end

return Attack