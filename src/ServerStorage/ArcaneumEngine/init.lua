local Globals = require(script.Global)
_G.Arcaneum = Globals

local Arcaneum = {
    Globals = Globals
}
Arcaneum.__index = Arcaneum

function Arcaneum.new()
    local Perspective = Globals.Perspective
    local PerspectiveGlobals = require(script[Perspective].Shared)
    for Name, Data in next, PerspectiveGlobals do
        if _G.Arcaneum[Name] then print("(" .. tostring(Perspective) .. ") Overwritten " .. Name .." with " .. tostring(Data)) end
        _G.Arcaneum[Name] = Data
    end
    local self = require(script[Perspective])
    return self
end

return Arcaneum.new()