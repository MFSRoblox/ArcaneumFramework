local GlobalTable = require(script.Utilities):ModulesToTable(script:GetChildren())
type GlobalTable = Dictionary<any>
function GlobalTable:AddGlobal(Data: ModuleScript | any, Name: string?)
    if typeof(Data) == "Instance" and Data:IsA("ModuleScript") then
        Name = Data.Name
        Data = require(Data)
    end
    GlobalTable[Name] = Data
    return Data
end

return GlobalTable