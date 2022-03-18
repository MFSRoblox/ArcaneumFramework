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
--ArcaneumGlobals.ClassFunctions.ClientConnector = ArcaneumGlobals.Utilities:ImportModule(GlobalsModule,"ClassFunctions","Class","Internal","ClientConnector")
print("Arcaneum Globals:",ArcaneumGlobals)
local BaseClass = ArcaneumGlobals.ClassFunctions:GetClass("BaseClass")
local Arcaneum = BaseClass:New("ArcaneumFramework")

function Arcaneum:New()
    local Perspective = ArcaneumGlobals.Perspective
    print("Arcaneum initializing on",Perspective)
    local InitializerService = ArcaneumGlobals.ClassFunctions:GetClass("InitializerService")
    local PerspectiveGlobals = InitializerService:InitializeModule(script[Perspective].Shared,ArcaneumGlobals)
    print("Arcaneum",Perspective,"Globals:",PerspectiveGlobals)
    for Name, Data in next, PerspectiveGlobals do
        if ArcaneumGlobals[Name] then
            local printOutput = "(" .. tostring(Perspective) .. ") Overwritten " .. Name .." with " .. tostring(Data)
            print(printOutput)
        end
        ArcaneumGlobals[Name] = Data
    end
    local Module = InitializerService:InitializeModule(script[Perspective],ArcaneumGlobals)
    return Module
end

return Arcaneum:New()