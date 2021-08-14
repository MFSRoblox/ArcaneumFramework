local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RepicatedEvents = ReplicatedStorage.Events
local ServerStorage = game:GetService("ServerStorage")
local ServerAssets = ServerStorage:WaitForChild("Assets")
local Modules = ServerAssets:WaitForChild("Modules")
local PlayerActionsFolder = Modules:WaitForChild("PlayerActions")

local PlayerActionHandler = {}
PlayerActionHandler.__index = PlayerActionHandler

function PlayerActionHandler.new()
    local self = setmetatable({},PlayerActionHandler)
    self.ActionEvent = RepicatedEvents:WaitForChild("PlayerAction")
    self.ReactionEvent = RepicatedEvents:WaitForChild("PlayerReaction")
    self.PlayerActions = {}
    self.ActionEventConnection = self.ActionEvent.OnServerEvent:Connect(function(CallingPlayer, ActionName, Data) self:OnActionEvent(CallingPlayer, ActionName, Data) end)
    return self
end

function PlayerActionHandler:LoadActions() --Includes reloading actions, if that needs to be done
    self:ResetActions()
    local function UnpackActionFolder(ActionFolder:Folder)
        local Children = ActionFolder:GetChildren()
        for i=1, #Children do
            local Child = Children[i]
            if Child:IsA("Folder") then
                UnpackActionFolder(Child)
            elseif Child:IsA("ModuleScript") then
                if Child.Name == "Server" then
                    self:LoadAction(ActionFolder.Name, Child)
                end
            end
        end
    end
    UnpackActionFolder(PlayerActionsFolder)
end

function PlayerActionHandler:ResetActions()
    for k,_ in self.PlayerActions, next do
        self.PlayerActions[k] = nil
    end
end

function PlayerActionHandler:LoadAction(ActionName: String, ServerModule: ModuleScript)
    if not ServerModule:IsA("ModuleScript") then
        warn(ServerModule.Name .. "("..ActionName..") ".."is not a ModuleScript!")
        return
    end
    if self.PlayerActions[ActionName] then self.PlayerActions[ActionName] = nil end
    self.PlayerActions[ActionName] = require(ServerModule)

    return true
end

function PlayerActionHandler:OnActionEvent(CallingPlayer: Player, ActionName:String, Data: Dictionary)
    ActionName = string.lower(ActionName)
    --[[local PlayerActions = {
        attack = function(Data:Dictionary)
            self.ReactionEvent:FireClient(CallingPlayer, "punch")
        end;
    }]]
    local PlayerAction = self.PlayerActions[ActionName]
    if PlayerAction then
        local SendReaction, ReactionData = PlayerAction:ExecuteAction(Data)
        if SendReaction then
            self.ReactionEvent:FireClient(CallingPlayer,string.lower(ActionName),ReactionData)
        end
    else
        warn("Unknown Action",ActionName,"called by",CallingPlayer)
    end
end

return PlayerActionHandler.new()