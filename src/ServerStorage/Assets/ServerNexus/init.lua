--[[
	PlayerModule - This module requires and instantiates the camera and control modules,
	and provides getters for developers to access methods on these singletons without
	having to modify Roblox-supplied scripts.

	2018 PlayerScripts Update - AllYourBlox
--]]
local Globals = _G.Arcaneum
local BaseClass = _G.Arcaneum.ClassFunctions.Internal

local ServerModule = BaseClass:Extend({
    Version = 0;
    Object = script;
})

function ServerModule.new()
	local self = ServerModule:Extend(BaseClass:New("ServerNexus", "ServerNexus"))
	self.PlayerActionHandler = require(script:WaitForChild("PlayerActionHandler"))
	self.PlayerManager = require(script:WaitForChild("PlayerManager"))
	return self
end

function ServerModule:GetPlayerActionHandler()
	return self.PlayerActionHandler
end

function ServerModule:GetPlayerManager()
	return self.PlayerManager
end

return ServerModule.new()