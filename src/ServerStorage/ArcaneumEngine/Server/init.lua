local output = {
    __call = function(_output:table, ArcaneumGlobals: table)
    local BaseClass = ArcaneumGlobals.ClassFunctions.Internal

    local Scripts = script.Scripts

    local ServerModule = BaseClass:Extend({
        Version = 0;
        Object = script;
        Globals = ArcaneumGlobals;
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
    local InitModule = ServerModule:New()
    _output = InitModule
    return InitModule
end
}
return setmetatable(output,output)