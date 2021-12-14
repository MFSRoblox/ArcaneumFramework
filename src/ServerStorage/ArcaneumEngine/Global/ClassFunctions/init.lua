local Utilities do
    local Mod = script.Parent:WaitForChild("Utilities")
    if Mod then
        Utilities = require(Mod)
    end
end
local BaseClass = Utilities:ImportModule(script,"BaseClass")
--local Class = Utilities:ImportModule(script,"BaseClass","Class")
--[[local Internal = Utilities:ImportModule(script,"Class","Internal")
local External = nil --Utilities:ImportModule(script,"Class","External")
local Output = {
    Class = Class;
    Internal = Internal;
    External = External;
}]]
local ClassService = BaseClass:New("ClassService") do
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
    --[[local InitialModules = {
        script.BaseClass;
        script.BaseClass.Class;
        script.BaseClass.DataTypes;
        table.unpack(script.BaseClass.DataTypes:GetChildren());
        script.InitializerService;
        script.InitializerService.SingletonInitClass;
    }
    for i=1, #InitialModules do
        local Module = InitialModules[i]
        ClassService:AddClass(Module.Name, require(Module))
    end]]
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
end
return ClassService