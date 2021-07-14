local ScriptUtilities = {}
ScriptUtilities.__index = ScriptUtilities

function ScriptUtilities.new()
    return setmetatable({}, ScriptUtilities)
end

function ScriptUtilities:pcall(PCallFunction: Function, ErrorMsg:String, ...)
    local Success, Result = pcall(PCallFunction, ...)
    if not Success then warn(string.format("%s: %s",ErrorMsg, Result)) end
    return Success
end

function ScriptUtilities:ModulesToTable(ObjectTable: Table)
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

return ScriptUtilities.new()