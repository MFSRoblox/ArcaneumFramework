local ScriptUtilities = {}
ScriptUtilities.__index = ScriptUtilities
export type Function = typeof(function() end)
function ScriptUtilities:pcall(PCallFunction: Function, ErrorMsg:string, ...)
    local Success, Result = pcall(PCallFunction, ...)
    if not Success then warn(string.format("%s: %s",ErrorMsg, Result)) end
    return Success
end

function ScriptUtilities:ModulesToTable(ObjectTable: table)
    --print("ModulesToTable Invoked!")
    local output = {}
    for i=1, #ObjectTable do
        local Object = ObjectTable[i]
        if Object:IsA("ModuleScript") then
            local ModuleData = require(Object)
            --print(type(ModuleData),typeof(ModuleData))
            --if type(ModuleData) == "table" and not ModuleData.IsBaseClass then
                output[Object.Name] = ModuleData
            --end
        elseif Object:IsA("Folder") then
            output[Object.Name] = self:ModulesToTable(Object:GetChildren())
        end
    end
    return output
end

function ScriptUtilities:ImportModule(Start: Instance, ...: string)
    local GuidingOrder = table.pack(...)
    local CurrentObject = Start
    for i=1, #GuidingOrder do
        local NextObjectName = GuidingOrder[i]
        if NextObjectName == "Parent" then
            CurrentObject = CurrentObject.NextObjectName
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