local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RepicatedEvents = ReplicatedStorage.Events

local PlayerActionHandler = {}
PlayerActionHandler.__index = PlayerActionHandler

function PlayerActionHandler.new()
    local self = setmetatable({},PlayerActionHandler)
    self.ActionEvent = RepicatedEvents:WaitForChild("PlayerAction")
    self.ReactionEvent = RepicatedEvents:WaitForChild("PlayerReaction")
    self.ActionEventConnection = self.ActionEvent.OnServerEvent:Connect(function(CallingPlayer, ActionName, Data) self:OnActionEvent(CallingPlayer, ActionName, Data) end)
    return self
end

function PlayerActionHandler:OnActionEvent(CallingPlayer: Player, ActionName:String, Data: Dictionary)
    ActionName = string.lower(ActionName)
    local PlayerActions = {
        attack = function(Data:Dictionary)
            self.ReactionEvent:FireClient(CallingPlayer, "punch")
        end;
    }
    
    if PlayerActions[ActionName] then
        PlayerActions[ActionName](Data)
    else
        warn("Unknown Action",ActionName,"called by",CallingPlayer)
    end
end

return PlayerActionHandler.new()