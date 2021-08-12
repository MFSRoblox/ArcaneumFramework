local Globals = _G.Arcaneum
local BaseClass = Globals.ClassFunctions.Internal

local PlayerSupervisor = BaseClass:Extend(
    {
        Version = 1;
        Object = script
    }
)

function PlayerSupervisor:New(Player: Player)
    local NewSupervisor = self:Extend(BaseClass:New("PlayerSupervisor","Supervisor"..Player.Name))
    NewSupervisor.Player = Player
    local PlayerInterface = Instance.new("RemoteEvent")
    PlayerInterface.Name = "ServerHotline"
    NewSupervisor.Interface = PlayerInterface
    PlayerInterface.Parent = Player.PlayerScripts --Cannot be seen by other players, nice security
    NewSupervisor.Connections.PlayerInterface = PlayerInterface.OnServerEvent:Connect(function(Sender,Data)
        if Player ~= Sender then
            warn(tostring(Sender).." somehow sent data from "..tostring(Player).."'s interface! Should probably look into this...")
        end
        NewSupervisor:DataFromPlayer(Data)
    end)
    return NewSupervisor
end

function PlayerSupervisor:DataToPlayer(Data)
    self.Interface:FireClient(self.Player,Data)
end

function PlayerSupervisor:DataFromPlayer(Data)

end

function PlayerSupervisor:LoadPlayerData()

end

function PlayerSupervisor:SavePlayerData()

end

function PlayerSupervisor:Destroy()
    if self.Interface then
        self.Interface:Destroy()
        self.Interface = nil
    end
end

return PlayerSupervisor