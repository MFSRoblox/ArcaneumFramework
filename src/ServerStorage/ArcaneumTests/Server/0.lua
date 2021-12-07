local GlobalExpectations = {
    ClassFunctions = "table";
    Events = "userdata";
    IsStudio = "boolean";
    Perspective = "string";
    Utilities = "table";
    Version = "table";
}
return function(self)
    local ArcaneumGlobals = self.ArcaneumGlobals
    --Globals tests
    local ThisTest = self.TesterClass:New("Engine Foundation")
    ThisTest:AddTest("Global Check", true, function()
        for VarName,Data in pairs(ArcaneumGlobals) do
            local Expectation = GlobalExpectations[VarName]
            if Expectation ~= nil then
                local DataType = type(Data)
                assert(DataType==Expectation, string.format("Global var %s was a %s, which is not the intended type of %s!",VarName,DataType,Expectation))
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
            local BaseClass = ArcaneumGlobals.ClassFunctions.Class--require(BaseClassMod)
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
            local NewClass = Globals.ClassFunctions.Class--require(ClassMod)
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