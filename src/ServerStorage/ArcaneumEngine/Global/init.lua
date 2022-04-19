local ClassFunctions = require(script.ClassFunctions):CheckVersion("1.0.0")
local BaseClass = ClassFunctions:GetClass("BaseClass"):CheckVersion("1.1.0")
local ArcaneumGlobals: ArcaneumGlobals = BaseClass:Extend({
    ClassName = "ArcaneumGlobals",
    Version = "1.0.0",
    Globals = require(script.Utilities):ModulesToTable(script:GetChildren()),
})
type ArcaneumGlobals = {
    Globals: Dictionary<any>
} & typeof(ArcaneumGlobals)
print(ArcaneumGlobals.Globals)
function ArcaneumGlobals:AddGlobal<T>(Data: ModuleScript | T, Name: string?): T
    if typeof(Data) == "Instance" and Data:IsA("ModuleScript") then
        Name = Data.Name
        Data = require(Data)
    end
    if ArcaneumGlobals.Globals[Name] ~= nil then
        warn("Overriding Global "..Name.."!")
    end
    ArcaneumGlobals.Globals[Name] = Data
    return Data
end

function ArcaneumGlobals:GetGlobal(Name: string): any
    assert(Name ~= nil, "")
    return ArcaneumGlobals.Globals[Name]
end

return ArcaneumGlobals