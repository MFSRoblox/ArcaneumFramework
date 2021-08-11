--[[
	PlayerModule - This module requires and instantiates the camera and control modules,
	and provides getters for developers to access methods on these singletons without
	having to modify Roblox-supplied scripts.

	2018 PlayerScripts Update - AllYourBlox
--]]

local ServerModule = {}
ServerModule.__index = ServerModule

function ServerModule.new()
	local self = setmetatable({},ServerModule)
	self.PlayerActionHandler = require(script:WaitForChild("PlayerActionHandler"))
	return self
end

function ServerModule:GetPlayerActionHandler()
	return self.PlayerActionHandler
end

return ServerModule.new()
