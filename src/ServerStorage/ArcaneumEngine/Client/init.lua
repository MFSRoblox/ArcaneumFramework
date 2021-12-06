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
local BaseClass = ArcaneumGlobals.ClassFunctions.Internal

local Scripts = script.Scripts

local ClientModule = BaseClass:Extend({
    Version = 2;
    Object = script;
})

function ClientModule:New()
	local this = self:Extend(BaseClass:New("ClientSoul", "ClientSoul"))
	return this
end

return ClientModule:New()