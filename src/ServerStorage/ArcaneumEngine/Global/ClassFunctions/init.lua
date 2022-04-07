local BaseClass = require(script.BaseClass)
local ClassService = BaseClass:New("ClassService","1.0.0")
function ClassService:AddClass(ClassName: string, ClassData: table): any
    self[ClassName] = ClassData
    return ClassData
end
--ClassService:AddClass("BaseClass",BaseClass)
function ClassService:GetClass(ClassName: string): any
    local RequestedClass = self[ClassName]
    if RequestedClass ~= nil then
        return RequestedClass
    else
        warn("ClassService was asked to return a class that doesn't exist!",ClassName,debug.traceback())
    end
end
local function UnpackClasses(Parent: ModuleScript): table
    local PotentialModules = Parent:GetChildren()
    for i=1, #PotentialModules do
        local PotentialModule = PotentialModules[i]
        if PotentialModule:IsA("ModuleScript") then
            ClassService:AddClass(PotentialModule.Name, require(PotentialModule))
        end
        UnpackClasses(PotentialModule)
    end
end
UnpackClasses(script)
return ClassService