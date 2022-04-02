local ModuleInfo = {
    InitName = script.Name;
    BootOrder = 3;
    Version = "1.0.0";
    Dependacies = {
        Utilities = "1.0.0"
    };
};
--[[local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local GlobalModuleName = "Arcaneum"
    local ArcaneumGlobals repeat
        ArcaneumGlobals = ReplicatedStorage:FindFirstChild(GlobalModuleName)
        if ArcaneumGlobals == nil then
            task.wait(1)
        else
            ArcaneumGlobals = require(ArcaneumGlobals)
        end
    until ArcaneumGlobals ~= nil]]
local ClientSoul = {}
function ClientSoul.Setup(_output: table, ArcaneumGlobals: table): table
    local BaseClass = ArcaneumGlobals.ClassFunctions:GetClass("Internal")

    local _Scripts = script.Scripts

    local ClientModule = BaseClass:Extend({
        Version = 2;
        Object = script;
        Globals = ArcaneumGlobals;
    })

    function ClientModule:New()
        local this = self:Extend(BaseClass:New("ClientSoul", "ClientSoul"))
        print("Created Client's Soul")
        return this
    end

    local InitModule = ClientModule:New()
    _output = InitModule
    return InitModule
end
ModuleInfo.__call = ClientSoul.Setup
return ModuleInfo