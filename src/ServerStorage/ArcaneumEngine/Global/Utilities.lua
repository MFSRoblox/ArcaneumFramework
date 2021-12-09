local ScriptUtilities = {} do
    ScriptUtilities.__index = ScriptUtilities
    ScriptUtilities = setmetatable(ScriptUtilities,ScriptUtilities)
end
function ScriptUtilities:pcall(PCallFunction: (...any) -> any, ErrorMsg:string, ...)
    local Success, Result = pcall(PCallFunction, ...)
    if not Success then
        local warnMessage = string.format("%s: %s",ErrorMsg, Result)
        warn(warnMessage)
    end
    return Success
end
function ScriptUtilities:RemoveFromTable(TargetTable: table, ThingToRemove: any)
    local PositionOfThing = table.find(TargetTable,ThingToRemove)
    if PositionOfThing ~= nil then
        table.remove(TargetTable,PositionOfThing)
        return true
    end
    warn(ThingToRemove,"could not be found in",TargetTable,debug.traceback())
    return false
end
function ScriptUtilities:GetAttributeFromInstances(AttributeName: string, DefaultValue: any, ...: Instance): ...any
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

function ScriptUtilities:ModulesToTable(ObjectTable: table, BaseOutput: table?, Overwrite: boolean?): Dictionary<any>
    --[[
        Used to turn a table of modules (commonly obtained through Instance:GetChildren()) into a dictionary that contains the each module, with the names of each module representing the key to said modules.
    ]]
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
                elseif Object:IsA("Folder") then
                    ThisOutput = self:ModulesToTable(Object:GetChildren(), nil, Overwrite)
                end
            end
            output[ObjectName] = ThisOutput
        elseif InitialOutput ~= nil and Overwrite then
            warn("Attempted to overwrite",ObjectName,"when overwritting has been disabled!",debug.traceback())
        end
    end
    return output
end

function ScriptUtilities:ImportModule(Start: Instance, ...: string)
    --[[
        Safely imports a module using traditional syntax such as "script.Parent[InstanceName][InstanceName][InstanceName][etc]", but ensures each object in the index exists through WaitForChild functions.
        If successful, it will require that module and return the contents of said module.
    ]]
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

return ScriptUtilities