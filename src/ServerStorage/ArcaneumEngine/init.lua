print("Initializing Arcaneum Globals...")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
local GlobalsModule = ReplicatedStorage:FindFirstChild(GlobalModuleName) do
    if not GlobalsModule then
        GlobalsModule = script.Global
        GlobalsModule.Name = GlobalModuleName
    end
    GlobalsModule.Parent = ReplicatedStorage
end
local ArcaneumGlobals = require(GlobalsModule)
ArcaneumGlobals:CheckVersion("1.1.0")
print("Arcaneum Globals:",ArcaneumGlobals)
local ClassService = ArcaneumGlobals:GetGlobal("ClassService")
ClassService:CheckVersion("1.0.0")
local BaseClass = ClassService:GetClass("BaseClass")
BaseClass:CheckVersion("1.1.0")
local Arcaneum = BaseClass:Extend({
    ClassName = "ArcaneumFramework",
    Version = "0.0.1"
})

function Arcaneum:New()
    local Perspective = ArcaneumGlobals:GetGlobal("Perspective")
    print("Arcaneum initializing on",Perspective)
    local PerspectiveGlobals = require(script[Perspective].Shared)
    print("Arcaneum",Perspective,"Globals:",PerspectiveGlobals)
    for Name, Data in next, PerspectiveGlobals do
        ArcaneumGlobals:AddGlobal(Data,Name)
    end
    local Module = require(script[Perspective])
    return Module
end

return Arcaneum:New()