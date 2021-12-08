local GlobalTable = {
    ClassFunctions = require(script.ClassFunctions)
}
local Utilities = require(script.Utilities)
GlobalTable = Utilities:ModulesToTable(script:GetChildren(), GlobalTable)
return GlobalTable