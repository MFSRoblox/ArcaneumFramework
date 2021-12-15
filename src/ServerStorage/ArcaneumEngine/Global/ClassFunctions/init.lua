local ClassService = {}
function ClassService:AddClass(ClassName: string, ClassData: table)
    self[ClassName] = ClassData
end
function ClassService:GetClass(ClassName: string): any
    local RequestedClass = self[ClassName]
    if RequestedClass ~= nil then
        return RequestedClass
    else
        warn("ClassService was asked to return a class that doesn't exist!",ClassName,debug.traceback())
    end
end
function ClassService.Setup(_output: table, ArcaneumGlobals: table): table
    local Utilities = ArcaneumGlobals.Utilities
    local BaseClass = Utilities:ImportModule(script,"BaseClass")
    ClassService = BaseClass:NewFromTable(ClassService,"ClassService")
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
end;
return ClassService