local TestInfoInterface = require(script.Parent)
local PrintDebug = false
local function debugPrint(...)
    if PrintDebug == true then
        print(...)
    end
end
local GlobalExpectations = {
    --Shared Globals
    ClassFunctions = "table";
    Ballistics = "table";
    Events = "Folder";
    IsStudio = "boolean";
    Perspective = "string";
    Utilities = "table";
    Version = "table";
    --Server Globals
    IsPublic = "boolean";
    IsTesting = "boolean";
}
local TestInfo = TestInfoInterface.new({
    ToRun = true;
    TestName = "Engine Foundation";
    ToPrintProcess = PrintDebug;
    Init = function(TestBot, ThisTest)
        local ArcaneumGlobals = TestBot.ArcaneumGlobals
        --Globals tests
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
                debugPrint(VarName,Data)
            end
            return true
        end)
        ThisTest:AddTest("BaseClass Check", true, function()
            --local BaseClassMod = ReplicatedModules:WaitForChild("BaseClass") do
                --assert(BaseClassMod, "BaseClass doesn't exist in ReplicatedStorage.Modules!")
                local BaseClass = ArcaneumGlobals.ClassFunctions:GetClass("BaseClass")--require(BaseClassMod)
                assert(BaseClass, "BaseClass didn't return anything!")
                local TestClassName = "BaseTestClass"
                local Object = BaseClass:New(TestClassName)
                assert(Object, "BaseClass didn't return an object! " .. tostring(Object))
                Object:Destroy()
                for key, value in next, Object do
                    if key ~= nil or value ~= nil then
                        assert(false, "BaseClass didn't destroy itself! " .. tostring(Object))
                    end
                end
            --end
            return true
        end)
        ThisTest:AddTest("Class Test", true, function()
            --local BaseClassMod = ReplicatedModules:WaitForChild("BaseClass")
            --local ClassMod = BaseClassMod:WaitForChild("Class") do
                --assert(ClassMod, "Class doesn't exist in ReplicatedStorage.Modules!")
                local Class = ArcaneumGlobals.ClassFunctions:GetClass("Class")--require(ClassMod)
                assert(Class, "Class didn't return anything!")
                local TestClassName = "TestClass"
                local Object = Class:New(TestClassName)
                assert(Object, "Class didn't return an object! " .. tostring(Object))
                assert(Object.Connections ~= nil, "Class didn't have a Connections table!")
                assert(type(Object.Connections) == "table", "Class's Connections property isn't a table!")
                Object:Destroy()
                for key, value in next, Object do
                    if key ~= nil or value ~= nil then
                        assert(false, "Class didn't destroy itself! " .. tostring(Object))
                    end
                end
            --studend
            return true
        end)
        ThisTest:AddTest("Version Test", true, function()
            --init test
            local Version = ArcaneumGlobals.ClassFunctions:GetClass("VersionClass")
            debugPrint("Checking Version Class")
            assert(Version, "Version didn't return anything!")
            assert(type(Version) == "table", "Version isn't a table!")
            assert(type(Version.new) == "function", "Version.new isn't a function!")
            --.new test
            debugPrint("Checking Version Creation")
            local Version1 = Version.new(1,2,3)
            debugPrint("Version1 Metatable:",getmetatable(Version1))
            assert(Version1:GetMajorVersion() == 1, "Test Version1 Object did not set its MajorVersion properly! Expected 1, got "..Version1:GetMajorVersion())
            assert(Version1:GetMinorVersion() == 2, "Test Version1 Object did not set its MinorVersion properly! Expected 2, got "..Version1:GetMinorVersion())
            assert(Version1:GetPatchVersion() == 3, "Test Version1 Object did not set its PatchVersion properly! Expected 3, got "..Version1:GetPatchVersion())
            --__tostring test
            debugPrint("Version1:__tostring Test")
            assert(tostring(Version1) == "1.2.3", "Test Version1 Object did not return expected result of 1.2.3! Instead, it returned: "..tostring(Version1))
            --__lt and __le tests
            debugPrint("Version:__eq Test")
            local DupeVersion1 = Version.new(1,2,3)
            assert(Version1 == DupeVersion1, "Version1 and DupeVersion1 should be equivelant, but isn't!")
            assert(Version1 == Version1, "Version1 and Version1 should be equivelant, but isn't!")
            debugPrint("Version1:__lt and __le Test")
            local MajorLessVersion = Version.new(0,4,5)
            --print("MajorLessVersion Metatable:",getmetatable(MajorLessVersion))
            assert(getmetatable(Version1) == getmetatable(MajorLessVersion),"Test Version1 Object and MajorLessVersion Object should share the same metatable!")
            assert(Version1 > MajorLessVersion, "Test Version1 Object should be greater than MajorLessVersion Object!")
            assert(Version1 >= MajorLessVersion, "Test Version1 Object should be greater than MajorLessVersion Object!")
            assert(not (Version1 < MajorLessVersion), "Test Version1 Object should be greater than MajorLessVersion Object!")
            assert(not (Version1 <= MajorLessVersion), "Test Version1 Object should be greater than MajorLessVersion Object!")
            assert(not (Version1 < DupeVersion1), "Version1 and DupeVersion1 should not be less than DupeVersion1!")
            assert(not (Version1 < Version1), "Version1 and DupeVersion1 should not be less than Version1")
            assert(not (Version1 > DupeVersion1), "Version1 and DupeVersion1 should not be less than DupeVersion1!")
            assert(not (Version1 > Version1), "Version1 and DupeVersion1 should not be less than Version1")
            --concat test
            debugPrint("Version:__concat Test")
            local ConcatTest = "Version1: "..Version1
            assert(ConcatTest == "Version1: 1.2.3", "ConcatTEst with Version1: .. Version1 did not return Version1: 1.2.3! Instead it returned: ".. ConcatTest)
            --__eq test
            return true
        end)
        return ThisTest
    end;
})
return TestInfo