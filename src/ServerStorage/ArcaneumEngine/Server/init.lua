local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ArcaneumGlobals = require(ReplicatedStorage.Arcaneum)
local BaseClass = ArcaneumGlobals.ClassFunctions:GetClass("Internal")
BaseClass:CheckVersion("1.0.0")
local Scripts = script.Scripts

local ServerNexus = BaseClass:Extend({
    Globals = ArcaneumGlobals;
    AddOns = {};
})

function ServerNexus:New()
    local this = self:Extend(BaseClass:New("ServerNexus", "ServerNexus","1.0.0"))
    this.PlayerActionHandler = nil --require(Scripts:WaitForChild("PlayerActionHandler"))
    this.PlayerManager = require(Scripts:WaitForChild("PlayerManager"))
    return this
end

function ServerNexus:GetPlayerActionHandler()
    return self.PlayerActionHandler
end

function ServerNexus:GetPlayerManager()
    return self.PlayerManager
end

function ServerNexus:AddModuleIntoEnvironment(Module: ModuleScript | any, Name: string?)
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

function ServerNexus:GetAddOn(_AddOnName: string): any

end
return ServerNexus:New()