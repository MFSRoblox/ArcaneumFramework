local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestInfoInterface = require(ReplicatedStorage.ArcaneumTests.TestInfoInterface)
local PrintDebug = false
local function debugPrint(...)
    if PrintDebug == true then
        print(...)
    end
end
local GlobalExpectations = {
    --Shared Globals
    ClassService = "table";
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
    TestPriority = 0;
    Init = function(TestBot, ThisTest)
        local ArcaneumGlobals = TestBot.ArcaneumGlobals
        --Globals tests
        ThisTest:AddTest("Global Check", true, function()
            for VarName,Data in pairs(ArcaneumGlobals.Globals) do
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
        ThisTest:AddTest("Version Test", true, function()
            local ClassService = ArcaneumGlobals:GetGlobal("ClassService")
            local Version = ClassService:GetClass("VersionClass")
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
        local InitVersion = "1.5.1"
        local function CheckClassVersion(Object:table)
            local SameVersionSuccess, SameVersionResult = pcall(function()
                Object:CheckVersion("1.5.1")
            end)
            assert(SameVersionSuccess, "The CheckVersion(\"1.5.1\") of NewInternalClass did not pass! Debug:"..tostring(SameVersionResult))
            if PrintDebug then
                local OverVersionSuccess, OverVersionResult = pcall(function()
                    Object:CheckVersion("2.0.0")
                end)
                assert(not OverVersionSuccess, "The CheckVersion(\"2.0.0\") of NewInternalClass somehow passed! It shouldn't have passed! Debug:"..tostring(OverVersionResult))
                local OldPatchSuccess, OldPatchResult = pcall(function()
                    Object:CheckVersion("1.5.0")
                end)
                assert(OldPatchSuccess, "The CheckVersion(\"1.5.0\") of NewInternalClass did not pass! Debug:"..tostring(OldPatchResult))
                local OldMinorSuccess, OldMinorResult = pcall(function()
                    Object:CheckVersion("1.4.0")
                end)
                assert(OldMinorSuccess, "The CheckVersion(\"1.4.0\") of NewInternalClass did not pass! Debug:"..tostring(OldMinorResult))
                local OldMajorSuccess, OldMajorResult = pcall(function()
                    Object:CheckVersion("0.5.1")
                end)
                assert(not OldMajorSuccess, "The CheckVersion(\"0.5.1\") of NewInternalClass somehow passed! It shouldn't have passed! Debug:"..tostring(OldMajorResult))
            end
        end
        local function CheckBaseClass(Object:table,ExpectedClassName:string)
            assert(Object ~= nil, "BaseClass didn't return an object! Object:" .. tostring(Object) .. "\nDebug: " .. debug.traceback())
            assert(Object.ClassName == ExpectedClassName, "BaseClass didn't assign the provided ClassName! Object.ClassName:" .. tostring(Object.ClassName) .. " ~= " .. ExpectedClassName .. "\nDebug: " .. debug.traceback())
            assert(Object.Version == InitVersion, "BaseClass didn't assign the provided Version! Object.Version:" .. tostring(Object.Version) .. " ~= " .. InitVersion .. "\nDebug: " .. debug.traceback())
            CheckClassVersion(Object)
        end
        local BaseClassName = "BaseTestClass" do
            ThisTest:AddTest("BaseClass:New Check", true, function()
                local ClassService = ArcaneumGlobals:GetGlobal("ClassService")
                local BaseClass = ClassService:GetClass("BaseClass")
                assert(BaseClass, "ClassService:GetClass(\"BaseClass\") didn't return anything!")
                local Object = BaseClass:New(BaseClassName, InitVersion)
                CheckBaseClass(Object, BaseClassName)
                Object:Destroy()
                for key, value in next, Object do
                    if key ~= nil or value ~= nil then
                        assert(false, "BaseClass didn't destroy itself! " .. tostring(Object))
                    end
                end
                return true
            end)
            ThisTest:AddTest("BaseClass:NewFromTable [table] Check", false, function()
                local ClassService = ArcaneumGlobals:GetGlobal("ClassService")
                local BaseClass = ClassService:GetClass("BaseClass")
                assert(BaseClass, "ClassService:GetClass(\"BaseClass\") didn't return anything!")
                local Object = BaseClass:NewFromTable({ClassName = BaseClassName, Version = InitVersion})
                CheckBaseClass(Object, BaseClassName)
                Object:Destroy()
                for key, value in next, Object do
                    if key ~= nil or value ~= nil then
                        assert(false, "BaseClass didn't destroy itself! " .. tostring(Object))
                    end
                end
                return true
            end)
            ThisTest:AddTest("BaseClass:Extend [table] Check", true, function()
                local ClassService = ArcaneumGlobals:GetGlobal("ClassService")
                local BaseClass = ClassService:GetClass("BaseClass")
                assert(BaseClass, "ClassService:GetClass(\"BaseClass\") didn't return anything!")
                local Object = BaseClass:Extend({ClassName = BaseClassName, Version = InitVersion})
                CheckBaseClass(Object, BaseClassName)
                Object:Destroy()
                for key, value in next, Object do
                    if key ~= nil or value ~= nil then
                        assert(false, "BaseClass didn't destroy itself! " .. tostring(Object))
                    end
                end
                return true
            end)
            ThisTest:AddTest("BaseClass:Extend [nil table, post init] Check", true, function()
                local ClassService = ArcaneumGlobals:GetGlobal("ClassService")
                local BaseClass = ClassService:GetClass("BaseClass")
                assert(BaseClass, "ClassService:GetClass(\"BaseClass\") didn't return anything!")
                local Object = BaseClass:Extend()
                Object.ClassName = BaseClassName
                Object.Version = InitVersion
                CheckBaseClass(Object, BaseClassName)
                Object:Destroy()
                for key, value in next, Object do
                    if key ~= nil or value ~= nil then
                        assert(false, "BaseClass didn't destroy itself! " .. tostring(Object))
                    end
                end
                return true
            end)
            ThisTest:AddTest("BaseClass:Extend and New Object Check", true, function()
                local ClassService = ArcaneumGlobals:GetGlobal("ClassService")
                local BaseClass = ClassService:GetClass("BaseClass")
                assert(BaseClass, "ClassService:GetClass(\"BaseClass\") didn't return anything!")
                local Object = BaseClass:Extend()
                Object.ClassName = BaseClassName
                Object.Version = InitVersion
                CheckBaseClass(Object, BaseClassName)
                local NewObject = Object:New("SecondNewTest", "1.5.1")
                CheckBaseClass(NewObject, "SecondNewTest")
                NewObject:Destroy()
                for key, value in next, NewObject do
                    assert(key == nil and value == nil, "NewObject BaseClass didn't destroy itself! " .. tostring(Object))
                end
                Object:Destroy()
                for key, value in next, Object do
                    assert(key == nil and value == nil, "BaseClass didn't destroy itself! " .. tostring(Object))
                end
                return true
            end)
        end
        local function CheckClass(Object:table,ExpectedClassName:string)
            CheckBaseClass(Object, ExpectedClassName)
            assert(Object.Connections ~= nil, "Class didn't have a Connections table!")
            assert(type(Object.Connections) == "table", "Class's Connections property isn't a table!")
        end
        ThisTest:AddTest("Class:New Test", true, function()
            local ClassService = ArcaneumGlobals:GetGlobal("ClassService")
            local Class = ClassService:GetClass("Class")
            assert(Class, "ClassService:GetClass(\"Class\") didn't return anything!")
            local TestClassName = "TestClass"
            local Object = Class:New(TestClassName, "1.5.1")
            CheckClass(Object, TestClassName)
            Object:Destroy()
            for key, value in next, Object do
                assert(key == nil and value == nil, "Class didn't destroy itself! " .. tostring(Object))
            end
            return true
        end)
        local function CheckInternalClass(Object:table,ExpectedClassName:string,ExpectedName:string)
            ExpectedName = ExpectedName or ExpectedClassName or ""
            CheckClass(Object, ExpectedClassName)
            assert(Object.Name == ExpectedName, "InternalClass didn't assign the provided Name! Object.Name:" .. tostring(Object.Name) .. " ~= " .. ExpectedName .. "\nDebug: " .. debug.traceback())
        end
        ThisTest:AddTest("InternalClass:New Test", true, function()
            local ClassService = ArcaneumGlobals:GetGlobal("ClassService")
            local InternalClass = ClassService:GetClass("InternalClass")
            assert(InternalClass, "ClassService:GetClass(\"Internal\") didn't return anything!")
            local TestClassName = "InternalTestClass"
            local Object = InternalClass:New(TestClassName, nil, "1.5.1")
            CheckInternalClass(Object, TestClassName)
            Object:Destroy()
            for key, value in next, Object do
                assert(key == nil and value == nil, "Class didn't destroy itself! " .. tostring(Object))
            end
            return true
        end)
        ThisTest:AddTest("InternalClass CheckVersion Test", true, function()
            local ClassService = ArcaneumGlobals:GetGlobal("ClassService")
            local InternalClass = ClassService:GetClass("InternalClass")
            local NewInternalClass = InternalClass:Extend({
                Version = "1.5.1",
                ClassName = "TestNewInternalClass"
            })
            function NewInternalClass:TestFunction():number
                return 200
            end
            CheckClassVersion(NewInternalClass)
            assert(NewInternalClass:TestFunction() == 200, debug.traceback("Custom assigned function did not return expected result! Traceback:"))
            return true
        end)
        return ThisTest
    end;
})
return TestInfo