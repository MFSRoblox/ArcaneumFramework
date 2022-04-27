local ClassService = require(script.ClassService):CheckVersion("1.0.0")
local BaseClass = ClassService:GetClass("BaseClass"):CheckVersion("1.1.0")
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
        Data.Parent = script
        Data = require(Data)
    end
    return self:SetGlobal(Data,Name)
end

function ArcaneumGlobals:SetGlobal<T>(Data: T, Name: string?): T
    assert(Name ~= nil, debug.traceback("No name was passed into SetGlobal!"))
    if ArcaneumGlobals.Globals[Name] ~= nil then
        warn(debug.traceback("Overriding Global "..Name.."!"))
    end
    ArcaneumGlobals.Globals[Name] = Data
    return ArcaneumGlobals.Globals[Name]
end

function ArcaneumGlobals:GetGlobal(Name: string): any
    assert(Name ~= nil, debug.traceback("No name was passed into GetGlobal!"))
    return ArcaneumGlobals.Globals[Name]
end

return ArcaneumGlobals