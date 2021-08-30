local Globals = _G.Arcaneum
local BaseClass = Globals.ClassFunctions.Internal

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