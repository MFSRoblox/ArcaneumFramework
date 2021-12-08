local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
local ArcaneumGlobals repeat
    ArcaneumGlobals = ReplicatedStorage:FindFirstChild(GlobalModuleName)
    if ArcaneumGlobals == nil then
        task.wait(1)
    else
        ArcaneumGlobals = require(ArcaneumGlobals)
    end
until ArcaneumGlobals ~= nil
local BaseClass = ArcaneumGlobals.ClassFunctions:GetClass("Internal")
local Players = game:GetService("Players")
local PlayerManager = BaseClass:Extend(
    {
        Version = 1;
        Object = script
    }
)
type PlayerManager = table

local PlayerInterface = Instance.new("RemoteEvent")
PlayerInterface.Name = "PlayerInterface"
PlayerInterface.Parent = ArcaneumGlobals.Events
local PlayerSupervisor = require(script.PlayerSupervisor)

function PlayerManager:New(): PlayerManager
    local NewManager = self:Extend(BaseClass:New("PlayerManager"))
    --NewManager.PlayerInterface = PlayerInterface
    NewManager.Connections.Interface = PlayerInterface.OnServerEvent:Connect(function(Sender,Data)
        NewManager.Supervisors[Sender]:DataFromPlayer(Data)
    end)
    NewManager.Supervisors = {}
    local CurrentPlayers = Players:GetPlayers()
    for i=1, #CurrentPlayers do
        local Player = CurrentPlayers[i]
        NewManager:AddPlayer(Player)
    end
    NewManager.Connections["PlayerAdded"] = Players.PlayerAdded:Connect(function(Player)
        NewManager:AddPlayer(Player)
    end)
    NewManager.Connections["PlayerRemoving"] = Players.PlayerRemoving:Connect(function(Player)
        NewManager:RemovePlayer(Player)
    end)
    print("PlayerManager Booted:", NewManager)
    return NewManager
end

type PlayerSupervisor = table
function PlayerManager:AddPlayer(Player: Player): PlayerSupervisor
    print("PlayerManager AddPlayer Triggered!", Player)
    local NewSupervisor = PlayerSupervisor:New(Player)
    self.Supervisors[Player] = NewSupervisor
    return NewSupervisor
end

function PlayerManager:RemovePlayer(Player: Player): nil
    self.Supervisors[Player]:Destroy()
    self.Supervisors[Player] = nil
end

function PlayerManager:SignalAllPlayers(FunctionName:string,...)
    local CurrentSupervisors = self.Supervisors
    for _Player, Supervisor in next, CurrentSupervisors do
        Supervisor[FunctionName](Supervisor,...)
    end
end

return PlayerManager:New()