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
print("Arcaneum Globals:",ArcaneumGlobals)
local BaseClass = ArcaneumGlobals.ClassFunctions:GetClass("BaseClass")
local Arcaneum = BaseClass:New("ArcaneumFramework","0.0.1")

function Arcaneum:New()
    local Perspective = ArcaneumGlobals.Perspective
    print("Arcaneum initializing on",Perspective)
    local PerspectiveGlobals = require(script[Perspective].Shared)
    print("Arcaneum",Perspective,"Globals:",PerspectiveGlobals)
    for Name, Data in next, PerspectiveGlobals do
        if ArcaneumGlobals[Name] then
            local printOutput = "(" .. tostring(Perspective) .. ") Overwritten " .. Name .." with " .. tostring(Data)
            print(printOutput)
        end
        ArcaneumGlobals[Name] = Data
    end
    local Module = require(script[Perspective])
    return Module
end

return Arcaneum:New()