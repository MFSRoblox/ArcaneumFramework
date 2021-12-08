local GlobalExpectations = {
    --Shared Globals
    ClassFunctions = "table";
    Events = "Folder";
    IsStudio = "boolean";
    Perspective = "string";
    Utilities = "table";
    Version = "table";
    --Server Globals
    IsPublic = "boolean";
    IsTesting = "boolean";
}
return function(self)
    local ArcaneumGlobals = self.ArcaneumGlobals
    --Globals tests
    local ThisTest = self.TesterClass:New("Engine Foundation")
    ThisTest:AddTest("Global Check", true, function()
        for VarName,Data in pairs(ArcaneumGlobals) do
            local Expectation = GlobalExpectations[VarName]
            if Expectation ~= nil then
                if type(Expectation) == "string" then
                    local DataType = typeof(Data)
                    if DataType == "Instance" then
                        DataType = Data.ClassName
                    end
                    assert(DataType==Expectation, string.format("Global var %s was a %s, which is not the intended type of %s!",VarName,DataType,Expectation))
                else
                    assert(Data == Expectation, string.format("Global var %s was set to %s, which does not match %s!",VarName,Data,Expectation))
                end
            else
                warn("No Type Check for",VarName,"!")
            end
            print(VarName,Data)
        end
        return true
    end)
    ThisTest:AddTest("BaseClass Check", true, function()
        --local BaseClassMod = ReplicatedModules:WaitForChild("BaseClass") do
            --assert(BaseClassMod, "BaseClass doesn't exist in ReplicatedStorage.Modules!")
            local BaseClass = ArcaneumGlobals.ClassFunctions:GetClass("Class")--require(BaseClassMod)
            assert(BaseClass, "BaseClass didn't return anything!")
            local TestClassName = "BaseTestClass"
            local Object = BaseClass:New(TestClassName)
            assert(Object, "BaseClass didn't return an object!")
            Object:Destroy()
        --end
        return true
    end)
    --[[ThisTest:AddTest("Class Test", true, function()
        --local BaseClassMod = ReplicatedModules:WaitForChild("BaseClass")
        --local ClassMod = BaseClassMod:WaitForChild("Class") do
            --assert(ClassMod, "Class doesn't exist in ReplicatedStorage.Modules!")
            local NewClass = Globals.ClassFunctions:GetClass("Class")--require(ClassMod)
            assert(NewClass, "Class didn't return anything!")
            local TestClassName = "TestClass"
            local Object = NewClass:New(TestClassName)
            assert(Object, "BaseClass didn't return an object!")
            Object:Destroy()
        --studend
        return true
    end)]]
    return ThisTest
end