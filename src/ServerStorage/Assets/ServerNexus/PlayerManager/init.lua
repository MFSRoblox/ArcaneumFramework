local Globals = _G.Arcaneum
local BaseClass = Globals.ClassFunctions.Internal
local Players = game:GetService("Players")
local PlayerManager = BaseClass:Extend(
    {
        Version = 1;
        Object = script
    }
)
local PlayerSupervisor = require(script.PlayerSupervisor)

function PlayerManager:New()
    local NewManager = self:Extend(BaseClass:New("PlayerManager"))
    NewManager.Supervisors = {}
    NewManager.Connections["PlayerRemoving"] = Players.PlayerRemoving:Connect(function(Player)
        NewManager:RemovePlayer(Player)
    end)
    local CurrentPlayers = Players:GetPlayers()
    for i=1, #CurrentPlayers do
        local Player = CurrentPlayers[i]
        NewManager:AddPlayer(Player)
    end
    NewManager.Connections["PlayerAdded"] = Players.PlayerAdded:Connect(function(Player)
        NewManager:AddPlayer(Player)
    end)
    return NewManager
end

function PlayerManager:AddPlayer(Player: Player)
    self.Supervisors[Player] = PlayerSupervisor:New(Player)
end

function PlayerManager:RemovePlayer(Player: Player)
    self.Supervisors[Player]:Destroy()
    self.Supervisors[Player] = nil
end

function PlayerManager:SignalAllPlayers(FunctionName:String,...)
    local CurrentSupervisors = self.Supervisors
    for Player, Supervisor in next, CurrentSupervisors do
        Supervisor[FunctionName](Supervisor,...)
    end
end

return PlayerManager:New()