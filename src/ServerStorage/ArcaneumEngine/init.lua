print("Initializing Arcaneum Globals...")
local Globals = require(script.Global)
_G.Arcaneum = Globals
Globals.ClassFunctions.ClientConnector = Globals.Utilities:ImportModule(script,"Global","ClassFunctions","Class","Internal","ClientConnector")
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
        if _G.Arcaneum[Name] then print("(" .. tostring(Perspective) .. ") Overwritten " .. Name .." with " .. tostring(Data)) end
        _G.Arcaneum[Name] = Data
    end
    local Module = require(script[Perspective])
    return Module
end

return Arcaneum:New()