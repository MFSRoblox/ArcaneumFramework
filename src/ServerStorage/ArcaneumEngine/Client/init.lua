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
local ClientSoul = BaseClass:Extend({
    Globals = ArcaneumGlobals;
    AddOns = {};
})
ClientSoul.Globals = ArcaneumGlobals;

local _Scripts = script.Scripts

function ClientSoul:New()
    local this = self:Extend(BaseClass:New("ClientSoul", "ClientSoul","0.0.1"))
    print("Created Client's Soul")
    return this
end

return ClientSoul:New()