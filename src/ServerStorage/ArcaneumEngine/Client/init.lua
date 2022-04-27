local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
local ArcaneumGlobals repeat
    ArcaneumGlobals = ReplicatedStorage:FindFirstChild(GlobalModuleName)
    if ArcaneumGlobals == nil then
        task.wait(1)
    else
        ArcaneumGlobals = require(ArcaneumGlobals)
        ArcaneumGlobals:CheckVersion("1.1.0")
    end
until ArcaneumGlobals ~= nil
local ClassService = ArcaneumGlobals:GetGlobal("ClassService")
ClassService:CheckVersion("1.0.0")
local InternalClass = ClassService:GetClass("InternalClass")
InternalClass:CheckVersion("1.1.0")
local ClientSoul = InternalClass:Extend({
    Globals = ArcaneumGlobals;
    AddOns = {};
})
ClientSoul.Globals = ArcaneumGlobals;

local _Scripts = script.Scripts

function ClientSoul:New()
    local this = InternalClass.New(self,"ClientSoul", "ClientSoul","0.0.1")
    print("Created Client's Soul")
    return this
end

return ClientSoul:New()