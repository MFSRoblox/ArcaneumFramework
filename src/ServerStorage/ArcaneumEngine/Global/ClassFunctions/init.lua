local BaseClass = require(script.BaseClass)
BaseClass:CheckVersion("1.0.0")
--[=[
    @class ClassService
    A singleton that allows quick indexing of initialized classes in the environment.
]=]
local ClassService: ClassService = BaseClass:Extend({
    ClassName = "ClassService";
    Version = "1.0.0";
    Classes = {};
})
export type ClassService = {
    Classes: {[string]: any};
} & typeof(ClassService) & BaseClass.BaseClass

--[=[
    Adds the class into the Classes cache so it can be retrieved via [ClassSerivce:GetClass].

    @param ClassName string -- The name of the class being added.
    @param ClassData any -- The data of the class being added.
    @return any -- The class itself.
]=]
function ClassService:AddClass<Data>(ClassName: string, ClassData: Data): Data
    if self.Classes[ClassName] ~= nil then
        warn("Overwritting " .. ClassName .."! Unintended bugs might occur! Debug:\n"..debug.traceback())
    end
    self.Classes[ClassName] = ClassData
    return ClassData
end

--[=[
    A wrapper for [ClassService:AddClass] where you pass in a ModuleScript with the class data instead.

    @param ClassModule ModuleScript -- The ModuleScript with the name of the class and contains the ClassData when required.
    @return any -- The class itself.
]=]
function ClassService:AddClassModule(ClassModule: ModuleScript): any
    assert(typeof(ClassModule) == "Instance", "ClassModule is not an Instance! Debug:\n"..debug.traceback())
    assert(ClassModule:IsA("ModuleScript"), "ClassModule is not a ModuleScript! Debug:\n"..debug.traceback())
    return self:AddClass(ClassModule.Name, require(ClassModule))
end

--[=[
    Returns the requested class, if it exists.

    @param ClassName string -- The name of the requested class.
    @return any -- The class itself, if it exists.
]=]
function ClassService:GetClass(ClassName: string): any?
    local RequestedClass = self.Classes[ClassName]
    if RequestedClass ~= nil then
        return RequestedClass
    else
        warn("ClassService was asked to return a class that doesn't exist!",ClassName,debug.traceback())
    end
end
local function UnpackClasses(Parent: ModuleScript)
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