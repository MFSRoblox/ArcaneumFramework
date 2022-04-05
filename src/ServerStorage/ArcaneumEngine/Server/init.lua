local ModuleInfo = {
    InitName = script.Name;
    BootOrder = 3;
    Version = "1.0.0";
    Dependacies = {
        Utilities = "1.0.0"
    };
}
local ServerNexus = {}
function ServerNexus.Setup(_output: table, ArcaneumGlobals: table): table
    local BaseClass = ArcaneumGlobals.ClassFunctions:GetClass("Internal")

    local Scripts = script.Scripts

    local ServerModule = BaseClass:Extend({
        Version = 0;
        Object = script;
        Globals = ArcaneumGlobals;
        AddOns = {};
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

    function ServerModule:AddModuleIntoEnvironment(Module: ModuleScript | any, Name: string?)
        local AddOn = Module
        if typeof(Module) == "Instance" and Module:IsA("ModuleScript") then
            if Name == nil then
                Name = Module.Name
            end
            AddOn = require(Module)
        else
            assert(Name ~= nil, "No name assigned to non-modulescript AddOn! Debug:"..debug.traceback())
        end
        self.AddOns[Name] = AddOn
    end

    function ServerModule:GetAddOn(AddOnName: string): any

    end
    local InitModule = ServerModule:New()
    _output = InitModule
    return InitModule
end
ModuleInfo.__call = ServerNexus.Setup
return ModuleInfo