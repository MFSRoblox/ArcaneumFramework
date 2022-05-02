local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
local Separator = "----------------------------------"
local ArcaneumGlobals repeat
    ArcaneumGlobals = ReplicatedStorage:FindFirstChild(GlobalModuleName)
    if ArcaneumGlobals == nil then
        task.wait(1)
    else
        ArcaneumGlobals = require(ArcaneumGlobals)
        ArcaneumGlobals:CheckVersion("1.1.0")
    end
until ArcaneumGlobals ~= nil
local ClassService = ArcaneumGlobals:GetGlobal("ClassService")
ClassService:CheckVersion("1.1.0")
local InternalClass = ClassService:GetClass("InternalClass")
InternalClass:CheckVersion("1.2.0")
local Utilities = ArcaneumGlobals:GetGlobal("Utilities")
local TesterClass = require(script.Tester)
local TestsClass = require(script.Parent.TestInfoInterface)
local TestCollection: TestCollection = InternalClass:Extend(
    {
        Version = "1.0.0";
        ClassName = "TestCollection";
        CoreModule = script;
        ArcaneumGlobals = ArcaneumGlobals;
        TesterClass = TesterClass;
    }
)
export type TestCollection = {
    TesterClass: TesterClass.Tester;
    TestModules: Array<ModuleScript>;
    TestData: Array<TestsClass.TestInfo>;
} & typeof(TestCollection) & typeof(InternalClass);
function TestCollection:New(Name: string, Tests: Folder): TestCollection
    assert(Name ~= nil, debug.traceback("No Name provided! Debug:"))
    assert(Tests ~= nil, debug.traceback("No tests provided! Debug:"))
    print("Initializing Test Collection",Name)
    local TestModules = {}
    local TestModulesFolder = Tests do
        if TestModulesFolder then
            TestModules = TestModulesFolder:GetChildren()
        end
    end
    local NumberOfTests = #TestModules
    print("Number of Testers to check:",NumberOfTests)
    local TestData = {};
    for i=1, #TestModules do
        local ModuleScript = TestModules[i]
        if ModuleScript:IsA("ModuleScript") then
            print("Initializing test:",ModuleScript)
            local TestInfo: TestsClass.TestInfo = require(ModuleScript)
            table.insert(TestData, TestInfo)
        end
    end
    table.sort(TestData,function(a,b)
        local aSuc, aNum = pcall(function()
            return a.TestPriority + 0
        end)
        local bSuc, bNum = pcall(function()
            return b.TestPriority + 0
        end)
        if aSuc and bSuc then
            return aNum < bNum
        elseif aSuc then
            return true
        elseif bSuc then
            return false
        end
        assert(aSuc and bSuc,"One of these aren't a number! A: " .. a.Name .. ", B: " .. b.Name)
    end)
    local NewCollection = self:Extend({
        Name = Name;
        TestModules = TestModules;
        TestData = TestData;
    })
    print(Name,"Collection Initialized")
    return NewCollection
end
function TestCollection:Run(): (number, number, number)
    local TestData = self.TestData
    print(self.Name,"Tests Running:",TestData)
    local FailedCounter, WarnCounter, SkippedCounter = 0,0,0
    for i=1, #TestData do
        local TesterInitData = TestData[i]
        if TesterInitData.ToRun == true then
            local Tester = self.TesterClass:New(TesterInitData.TestName)
            Tester:SetPrintProcess(TesterInitData.ToPrintProcess)
            Tester = TesterInitData.Init(self, Tester)::TesterClass.Tester
            if Tester == 3 then
                SkippedCounter += 1
                continue
            end
            if Tester.RunTests then
                local DisplayName = Tester.DisplayName
                local TestName = Tester.Name
                print("\n\n"..Separator.."\n" .. DisplayName .. " will now start their tests (".. TestName ..").")
                local TesterFeedback = Tester:RunTests()
                print("\n\n"..DisplayName.." has finished their tests! Here's their report:")
                for j=1, #TesterFeedback do
                    local Result = TesterFeedback[j]
                    if Result.Status == "Successful" then
                        print(Result)
                    elseif Result.Status == "Skipped" then
                        SkippedCounter += 1
                        warn("Test was skipped!")
                    elseif Result.Status == "Failure" then
                        warn(Result)
                        WarnCounter += 1
                    elseif Result.Status == "Critical Failure" then
                        Utilities:error(Result)
                        FailedCounter += 1
                    else
                        warn("Test did not have a Status!")
                    end
                end
                print(Separator .."\n\n")
            end
        else
            SkippedCounter += 1
            continue
        end
    end
    return FailedCounter, WarnCounter, SkippedCounter
end
function TestCollection:Destroy()
    table.clear(self.TestModules)
    table.clear(self.TestData)
    return InternalClass.Destroy(self)
end

return TestCollection