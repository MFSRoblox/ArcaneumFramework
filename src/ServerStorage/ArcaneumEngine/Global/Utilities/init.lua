local ClassService = require(script.Parent.ClassService)
ClassService:CheckVersion("1.1.0")
local Class = ClassService:GetClass("Class")
Class:CheckVersion("1.2.0")
--[=[
    @class Utilities
    @server
    @client
    A module that consists of handy functions that will be used throughout the framework and game. Extends [Class].
]=]
local Utilities = Class:Extend({
    ClassName = "Utilities";
    Version = "1.0.0";
    CoreModule = script;
    ErrorEvent = Instance.new("BindableEvent");
}) do
    Utilities:AddConnection("ErrorEvent",
    Utilities.ErrorEvent.Event:Connect(function(ErrorMsg:string)
        error(ErrorMsg,0)
    end))
    
end
--[=[
    A pcall function with a prebuilt message in the format of "ErrorMsg: Result \n traceback"

    @param callback function -- The function that you want to be called by the pcall method.
    @param ErrorMsg string -- The Error label used in the warning message, if there were to be one.
    @param ... any -- The parameters passed into the callback.
    @return boolean, any -- Returns if the callback successfully executed, alongside anything it returned.
]=]
function Utilities:pcall(callback: (...any) -> any, ErrorMsg:string, ...:any): boolean & any
    local Success, Result = pcall(callback, ...)
    if not Success then
        local warnMessage = string.format("%s: %s\n%s",ErrorMsg, Result,debug.traceback())
        warn(warnMessage)
    end
    return Success, Result
end
--[=[
    An error function that creates an error message without killing the thread it was called in

    @param ErrorMsg string -- The Error message that will be displayed.
    @return nil
]=]
function Utilities:error(ErrorMsg:string): nil
    self.ErrorEvent:Fire(tostring(ErrorMsg))
end
--[=[
    A quick table.remove(table.find) method that would try to find your object in the TargetTable and remove it, if it exists.

    @param TargetTable table -- The table of which would be searched and have the object removed from.
    @param ThingToRemove any -- The object of which you want to remove from the table.
    @return boolean -- Returns if it actually removed the item.
]=]
function Utilities:RemoveFromTable(TargetTable: table, ThingToRemove: any): boolean
    local PositionOfThing = table.find(TargetTable,ThingToRemove)
    if PositionOfThing ~= nil then
        table.remove(TargetTable,PositionOfThing)
        return true
    end
    warn(ThingToRemove,"could not be found in",TargetTable,debug.traceback())
    return false
end
--[=[
    Used to get a specific attribute from a set of instances, setting a default value for the output if the instance doesn't have the attribute.
    The output will return attribute values in the order of which they are inputted into the function.
    
    @param AttributeName string -- The name of the Attribute to get from the inputted instances.
    @param DefaultValue any -- The default value incase the inputted instance doesn't have the Attribute.
    @param ... Instance -- The Instances that will be checked for the attribute.
    @return ...any -- The values of the attributes retrieved from the inputted Instances.
]=]
function Utilities:GetAttributeFromInstances(AttributeName: string, DefaultValue: any, ...: Instance): ...any
    --[[
        Used to get a specific attribute from a set of instances, setting a default value for the output if the instance doesn't have the attribute.
        The output will return attribute values in the order of which they are inputted into the function.
    ]]
    local Objects = table.pack(...)
    Objects.n = nil --It returns n apparently
    local OutputTable = {}
    for k, Object in next, Objects do
        local Output = Object:GetAttribute(AttributeName)
        if Output == nil then
            Output = DefaultValue
        end
        OutputTable[k] = Output
    end
    return table.unpack(OutputTable)
end

--[=[
    Used to turn a table of modules (commonly obtained through Instance:GetChildren()) into a dictionary that contains the each module, with the names of each module representing the key to said modules.

    @param ObjectTable table
    @param BaseOutput table?
    @param Overwrite boolean?
    @return Dictionary
]=]
function Utilities:ModulesToTable(ObjectTable: table, BaseOutput: table?, Overwrite: boolean?): Dictionary<any>
    if Overwrite == nil then
        Overwrite = true
    end
    table.sort(ObjectTable,function(Object1:Instance, Object2:Instance)
        local Sort1,Sort2 = self:GetAttributeFromInstances("BootPriority", 0, Object1, Object2)
        return Sort1 > Sort2
    end)
    local output = BaseOutput or {}
    for i=1, #ObjectTable do
        local Object = ObjectTable[i]
        local ObjectName = Object.Name
        local InitialOutput = output[ObjectName]
        if InitialOutput == nil or Overwrite then
            local ThisOutput do
                if Object:IsA("ModuleScript") then
                    local ModuleData = require(Object)
                    ThisOutput = ModuleData
                --[[elseif Object:IsA("Folder") then
                    ThisOutput = self:ModulesToTable(Object:GetChildren(), nil, Overwrite)]]
                end
            end
            output[ObjectName] = ThisOutput
        elseif InitialOutput ~= nil and Overwrite then
            warn("Attempted to overwrite",ObjectName,"when overwritting has been disabled!",debug.traceback())
        end
    end
    return output
end

--[=[
    Safely imports a module using traditional syntax such as "script.Parent.InstanceName.InstanceName.InstanceName.etc", but ensures each object in the index exists through WaitForChild functions.
    If successful, it will require that module and return the contents of said module.

    @param Start Instance
    @param ... string
    @return any -- The output of the module via require(module), assuming the module exists.
]=]
function Utilities:ImportModule(Start: Instance, ...: string): any
    local GuidingOrder = table.pack(...)
    local CurrentObject = Start
    for i=1, #GuidingOrder do
        local NextObjectName = GuidingOrder[i]
        if NextObjectName == "Parent" then
            CurrentObject = CurrentObject[NextObjectName]
        else
            local ScannedObject = CurrentObject:WaitForChild(NextObjectName)
            if ScannedObject then
                CurrentObject = ScannedObject
            end
        end
    end
    local output = CurrentObject
    if typeof(output) == "Instance" and output:IsA("ModuleScript") then
        output = require(CurrentObject)
    end
    return output
end
return Utilities