local GlobalModuleName = "Arcaneum"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

local ServerModule = BaseClass:Extend({
    Version = 0;
    Object = script;
})

function ServerModule:New()
	local this = self:Extend(BaseClass:New("ServerNexus", "ServerNexus"))
	this.PlayerActionHandler = nil --require(Scripts:WaitForChild("PlayerActionHandler"))
	this.PlayerManager = require(Scripts:WaitForChild("PlayerManager"))
	return this
end

function ServerModule:GetPlayerActionHandler()
	return self.PlayerActionHandler
end

function ServerModule:GetPlayerManager()
	return self.PlayerManager
end

return ServerModule:New()