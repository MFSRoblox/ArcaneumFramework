local ScriptUtilities = {}
ScriptUtilities.__index = ScriptUtilities

function ScriptUtilities.new()
    local self = {}
    setmetatable(self, ScriptUtilities)

    return self
end

function ScriptUtilities:pcall(PCallFunction: Function, ErrorMsg:String)
    
end

function ScriptUtilities:ModulesToTable(ObjectTable: Table)
    local output = {}
    for i=1, #ObjectTable do
        local Object = ObjectTable[i]
        if Object:IsA("ModuleScript") then
            local ModuleData = require(Object)
            if not ModuleData.IsBaseClass then
                output[Object.Name] = require(Object)
            end
        elseif Object:IsA("Folder") then
            output[Object.Name] = self:ModulesToTable(Object:GetChildren())
        end
    end
    return output
end

return ScriptUtilities.new()