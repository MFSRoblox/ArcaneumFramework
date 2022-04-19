local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
local ArcaneumGlobals repeat
    ArcaneumGlobals = ReplicatedStorage:FindFirstChild(GlobalModuleName)
    if ArcaneumGlobals == nil then
        task.wait(1)
    else
        ArcaneumGlobals = require(ArcaneumGlobals):CheckVersion("1.0.0")
    end
until ArcaneumGlobals ~= nil
local ClassFunctions = ArcaneumGlobals:GetGlobal("ClassFunctions"):CheckVersion("1.0.0")
local BaseClass = ClassFunctions:GetClass("InternalClass"):CheckVersion("1.1.0")
local Utilities = ArcaneumGlobals:GetGlobal("Utilities"):CheckVersion("1.0.0")
local Events = ArcaneumGlobals:GetGlobal("Events")
local PlayerInterface = Events.PlayerInterface
local PlayerSupervisor = BaseClass:Extend(
    {
        Version = "1.0.0";
    }
)

function PlayerSupervisor:New(Player: Player)
    local NewSupervisor = BaseClass.New(self,"PlayerSupervisor","Supervisor"..Player.Name,PlayerSupervisor.Version)
    NewSupervisor.Player = Player
    NewSupervisor.Functions = Utilities:ModulesToTable(script:GetChildren())
    local ClientPackage = game:GetService("ServerStorage").ArcaneumEngine:Clone()
    ClientPackage.Server:Destroy()
    ClientPackage.Parent = Player
    print(NewSupervisor)
    return NewSupervisor
end

function PlayerSupervisor:DataToPlayer(Data: table)
    PlayerInterface:FireClient(self.Player,Data)
end

function PlayerSupervisor:DataFromPlayer(Data: table)
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