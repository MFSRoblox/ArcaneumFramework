local UtilitiesModule = script.Utilities
local Utilities = require(UtilitiesModule)
local ClassFunctionsModule = script.ClassFunctions
local GlobalTable = {
    Utilities = Utilities;
    ClassFunctions = require(ClassFunctionsModule)
}
local ScriptChildren = script:GetChildren()
Utilities:RemoveFromTable(ScriptChildren,UtilitiesModule)
Utilities:RemoveFromTable(ScriptChildren,ClassFunctionsModule)
GlobalTable = Utilities:ModulesToTable(script:GetChildren(), GlobalTable)
return GlobalTable