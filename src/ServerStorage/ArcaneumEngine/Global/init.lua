local InitializerService = require(script.ClassFunctions.InitializerService)
local GlobalInit = InitializerService:New()
local UtilitiesModule = script.Utilities
GlobalInit:AddModule(UtilitiesModule)
local ClassFunctionsModule = script.ClassFunctions
GlobalInit:AddModule(ClassFunctionsModule)
local GlobalTable = GlobalInit:Initialize()
local Utilities = GlobalTable.Utilities
local ScriptChildren = script:GetChildren()
GlobalTable.Utilities:RemoveFromTable(ScriptChildren,UtilitiesModule)
Utilities:RemoveFromTable(ScriptChildren,ClassFunctionsModule)
GlobalTable = Utilities:ModulesToTable(script:GetChildren(), GlobalTable, false)
return GlobalTable