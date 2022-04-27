local BaseClass = require(script.BaseClass)
BaseClass:CheckVersion("1.2.0")
--[=[
    @class ClassService
    A singleton that allows quick indexing of initialized classes in the environment.
]=]
local ClassService: ClassService = BaseClass:Extend({
    ClassName = "ClassService";
    Version = "1.1.0";
    CoreModule = script;
    Classes = {};
    AddOnFolder = script.AddOns;
})
export type ClassService = {
    Classes: {[string]: any};
    AddOnFolder: Folder;
} & typeof(ClassService) & BaseClass.BaseClass

--[=[
    @since 1.0.0
    Adds the class into the Classes cache so it can be retrieved via [ClassSerivce:GetClass].

    @param ClassName string -- The name of the class being added.
    @param ClassData any -- The data of the class being added.
    @return any -- The class itself.
]=]
function ClassService:SetClass<Data>(ClassName: string, ClassData: Data): Data
    if self.Classes[ClassName] ~= nil then
        warn("Overwritting " .. ClassName .."! Unintended bugs might occur! Debug:\n"..debug.traceback())
    end
    self.Classes[ClassName] = ClassData
    return ClassData
end

--[=[
    @since 1.1.0
    Sets the ClassModule's parent to be the ParentClass's modulescript.
    @param ClassModule ModuleScript -- The ModuleScript to be moved.
    @param ParentClass string -- The class which the ClassModule should be parented under. If "AddOn" is put in, it will instead be put into the AddOns folder.

    @error "Attempted to add ClassModule to a class ([ParentClass]) that hasn't been made yet!" -- Occurs when the ParentClass doesn't exist in the service.
    @error "[ParentClass].CoreModule is nil!" -- Occurs when the ParentClass doesn't have a CoreModule property.
]=]
function ClassService:SetClassParent(ClassModule: ModuleScript, ParentClass: string)
    if ParentClass ~= "AddOn" then
        local TargetParent = self:GetClass(ParentClass)
        if TargetParent and TargetParent.CoreModule then
            if TargetParent.CoreModule then
                ClassModule.Parent = TargetParent.CoreModule
            else
                warn(debug.traceback(ParentClass..".CoreModule is nil!"))
            end
        else
            warn(debug.traceback("Attempted to add ClassModule to a class ("..ParentClass..") that hasn't been made yet!"))
        end
    else
        ClassModule.Parent = self.AddOnFolder
    end
end

--[=[
    @since 1.1.0
    A wrapper for [ClassService:AddClass] where you pass in a ModuleScript with the class data instead.

    @param ClassModule ModuleScript -- The ModuleScript with the name of the class and contains the ClassData when required.
    @param ParentClass string? -- The class which the ClassModule should be parented under. If "AddOn" is put in, it will instead be put into the AddOns folder.
    @return table -- The class itself.
]=]
function ClassService:AddClassModule(ClassModule: ModuleScript, ParentClass: string?): table
    assert(typeof(ClassModule) == "Instance", "ClassModule is not an Instance! Debug:\n"..debug.traceback())
    assert(ClassModule:IsA("ModuleScript"), "ClassModule is not a ModuleScript! Debug:\n"..debug.traceback())
    if ParentClass ~= nil then
        self:SetClassParent(ClassModule, ParentClass)
    end
    return self:SetClass(ClassModule.Name, require(ClassModule))
end

--[=[
    @since 1.0.0
    Returns the requested class, if it exists.

    @param ClassName string -- The name of the requested class.
    @return any -- The class itself, if it exists.
]=]
function ClassService:GetClass(ClassName: string): any?
    assert(type(ClassName) == "string", debug.traceback("Invalid ClassName given!"))
    local RequestedClass = self.Classes[ClassName]
    if RequestedClass ~= nil then
        return RequestedClass
    else
        warn(debug.traceback("ClassService was asked to return a class that doesn't exist! Requested class: "..ClassName))
    end
end

--[=[
    @since 1.0.0
    @private
    Sets up the initial classes upon being required.
]=]
local function UnpackClasses(Parent: ModuleScript)
    local PotentialModules = Parent:GetChildren()
    for i=1, #PotentialModules do
        local PotentialModule = PotentialModules[i]
        if PotentialModule:IsA("ModuleScript") then
            ClassService:AddClassModule(PotentialModule)
        end
        UnpackClasses(PotentialModule)
    end
end
UnpackClasses(script)
return ClassService