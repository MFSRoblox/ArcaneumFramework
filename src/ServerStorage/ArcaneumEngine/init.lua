print("Initializing Arcaneum Globals...")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFolderName = "Arcaneum"
local ReplicatedFolder = ReplicatedStorage:FindFirstChild(ReplicatedFolderName) do
    if not ReplicatedFolder then
        ReplicatedFolder = Instance.new("Folder")
        ReplicatedFolder.Name = ReplicatedFolderName
        ReplicatedFolder.Parent = ReplicatedStorage
    end
end
local GlobalsModule = script.Global
GlobalsModule.Parent = ReplicatedFolder
local Globals = require(GlobalsModule)
--_G.Arcaneum = Globals
Globals.ClassFunctions.ClientConnector = Globals.Utilities:ImportModule(GlobalsModule,"ClassFunctions","Class","Internal","ClientConnector")
print("Arcaneum Globals:",Globals)
local BaseClass = Globals.ClassFunctions.Class
local Arcaneum = BaseClass:Extend({
    Globals = Globals
})

function Arcaneum:New()
    local Perspective = Globals.Perspective
    print("Arcaneum initializing on",Perspective)
    local PerspectiveGlobals = require(script[Perspective].Shared)
    print("Arcaneum",Perspective,"Globals:",PerspectiveGlobals)
    for Name, Data in next, PerspectiveGlobals do
        if Globals[Name] then
            local printOutput = "(" .. tostring(Perspective) .. ") Overwritten " .. Name .." with " .. tostring(Data)
            print(printOutput)
        end
        Globals[Name] = Data
    end
    local Module = require(script[Perspective])
    return Module
end

return Arcaneum:New()