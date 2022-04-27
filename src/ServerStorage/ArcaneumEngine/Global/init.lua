local ClassService = require(script.ClassService):CheckVersion("1.0.0")
local BaseClass = ClassService:GetClass("BaseClass"):CheckVersion("1.1.0")
--[=[
    @class ArcaneumGlobals
    The class that manages each global that is present within the environment.
    It is NOT replicated between server and client.
]=]
local ArcaneumGlobals: ArcaneumGlobals = BaseClass:Extend({
    ClassName = "ArcaneumGlobals",
    Version = "1.0.0",
    Globals = require(script.Utilities):ModulesToTable(script:GetChildren()),
})
type ArcaneumGlobals = {
    Globals: Dictionary<any>
} & typeof(ArcaneumGlobals)
print(ArcaneumGlobals.Globals)
--[=[
    Adds a global into the global environment. If it is a ModuleScript, set its parent to be the Global's script.

    @param Data -- The data to be saved to the global. Can be any non-instance or a ModuleScript.
    @param Name -- A string that will be associated with the new global. It should be unique within the environment. Optional if Data is a ModuleScript.
    @return Data -- The data that has been put into the method. Returns ModuleScript's contents if Data is a ModuleScript.
]=]
function ArcaneumGlobals:AddGlobal<T>(Data: ModuleScript | T, Name: string?): T
    if typeof(Data) == "Instance" and Data:IsA("ModuleScript") then
        Name = Data.Name
        Data.Parent = script
        Data = require(Data)
    end
    return self:SetGlobal(Data,Name)
end
--[=[
    Sets a global into the global environment with the key of Name.

    @param Data -- The data to be saved to the global.
    @param Name -- A string that will be associated with the new global. It should be unique within the environment.
    @return Data -- The data that has been put into the method and saved as a global.

    @error "No name was passed into SetGlobal" -- Occurs when SetGlobal is called and there is no name inputted as a parameter.
    @error "Overriding Global [Name]!" -- Occurs when SetGlobal is used and there was a previous global in that position.
]=]
function ArcaneumGlobals:SetGlobal<T>(Data: T, Name: string?): T
    assert(Name ~= nil, debug.traceback("No name was passed into SetGlobal!"))
    if ArcaneumGlobals.Globals[Name] ~= nil then
        warn(debug.traceback("Overriding Global "..Name.."!"))
    end
    ArcaneumGlobals.Globals[Name] = Data
    return ArcaneumGlobals.Globals[Name]
end
--[=[
    Gets a global from the global environment with the key of Name.

    @param Name -- A string that will be associated with the new global. It should be unique within the environment.
    @return Data -- The data that has been put into the method and saved as a global.

    @error "No name was passed into GetGlobal" -- Occurs when GetGlobal is called and there is no name inputted as a parameter.
]=]
function ArcaneumGlobals:GetGlobal(Name: string): any
    assert(Name ~= nil, debug.traceback("No name was passed into GetGlobal!"))
    return ArcaneumGlobals.Globals[Name]
end

return ArcaneumGlobals