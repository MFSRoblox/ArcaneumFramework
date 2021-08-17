local Globals = _G.Arcaneum
local BaseClass = Globals.ClassFunctions.Internal

local Scripts = script.Scripts

local ServerModule = BaseClass:Extend({
    Version = 0;
    Object = script;
})

function ServerModule.new()
	local self = ServerModule:Extend(BaseClass:New("ServerNexus", "ServerNexus"))
	self.PlayerActionHandler = require(Scripts:WaitForChild("PlayerActionHandler"))
	self.PlayerManager = require(Scripts:WaitForChild("PlayerManager"))
	return self
end

function ServerModule:GetPlayerActionHandler()
	return self.PlayerActionHandler
end

function ServerModule:GetPlayerManager()
	return self.PlayerManager
end

return ServerModule.new()