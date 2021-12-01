print("Initializing Arcaneum Globals...")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
local GlobalsModule = ReplicatedStorage:FindFirstChild(GlobalModuleName) do
    if not GlobalsModule then
        GlobalsModule = script.Global
        GlobalsModule.Name = GlobalModuleName
        GlobalsModule.Parent = ReplicatedStorage
    end
end
GlobalsModule.Parent = ReplicatedStorage
local ArcaneumGlobals = require(GlobalsModule)
ArcaneumGlobals.ClassFunctions.ClientConnector = ArcaneumGlobals.Utilities:ImportModule(GlobalsModule,"ClassFunctions","Class","Internal","ClientConnector")
print("Arcaneum Globals:",ArcaneumGlobals)
local BaseClass = ArcaneumGlobals.ClassFunctions.Class
local Arcaneum = BaseClass:Extend({
    Globals = ArcaneumGlobals
})

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