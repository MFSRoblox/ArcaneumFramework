local Globals = require(script.Global)
_G.Arcaneum = Globals
local BaseClass = Globals.ClassFunctions.BaseClass
local Arcaneum = BaseClass:Extend({
    Globals = Globals
})

function Arcaneum:New()
    local Perspective = Globals.Perspective
    local PerspectiveGlobals = require(script[Perspective].Shared)
    for Name, Data in next, PerspectiveGlobals do
        if _G.Arcaneum[Name] then print("(" .. tostring(Perspective) .. ") Overwritten " .. Name .." with " .. tostring(Data)) end
        _G.Arcaneum[Name] = Data
    end
    local Module = require(script[Perspective])
    return Module
end

return Arcaneum:New()