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

    return NewSupervisor
end

return PlayerSupervisor