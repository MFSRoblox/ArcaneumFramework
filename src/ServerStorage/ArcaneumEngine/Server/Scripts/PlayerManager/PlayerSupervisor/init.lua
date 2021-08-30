local Globals = _G.Arcaneum
local PlayerInterface = Globals.Events.PlayerInterface
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
    NewSupervisor.Functions = Globals.Utilities:ModulesToTable(script:GetChildren())
    local ClientPackage = game:GetService("ServerStorage").ArcaneumEngine:Clone()
    ClientPackage.Server:Destroy()
    ClientPackage.Parent = Player
    print(NewSupervisor)
    return NewSupervisor
end

function PlayerSupervisor:DataToPlayer(Data: Table)
    PlayerInterface:FireClient(self.Player,Data)
end

function PlayerSupervisor:DataFromPlayer(Data: Table)
    local Function = self.Functions[Data.Name]
    if self.Functions[Data.Name] then
        return Function(Data)
    else
        warn("Recieved Unknown DataName:",Data.Name)
    end
end

function PlayerSupervisor:LoadPlayerData()

end

function PlayerSupervisor:SavePlayerData()

end

function PlayerSupervisor:Destroy()
    print(self)
    --[[print(self.Interface)
    if self.Interface then
        self.Interface:Destroy()
        self.Interface = nil
    end]]
    --warn(self.ClassName .." has called Destroy at PlayerSupervisor!")
    BaseClass.Destroy(self)
end

return PlayerSupervisor