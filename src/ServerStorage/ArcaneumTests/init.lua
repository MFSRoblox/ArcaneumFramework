local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
local Separator = "----------------------------------"
local ArcaneumGlobals repeat
    ArcaneumGlobals = ReplicatedStorage:FindFirstChild(GlobalModuleName)
    if ArcaneumGlobals == nil then
        task.wait(1)
    else
        ArcaneumGlobals = require(ArcaneumGlobals)
    end
until ArcaneumGlobals ~= nil
local TesterClass = require(script.Tester)
TesterClass:CheckVersion("1.0.0")
local TestBot: TestBot = ArcaneumGlobals.ClassFunctions:GetClass("Class"):Extend(
    {
        ClassName = "ArcaneumTestService";
        ArcaneumGlobals = ArcaneumGlobals;
        Version = "1.0.0";
        Object = script;
        TesterClass = require(script.Tester);
        RawData = {};
        TestData = {
            Tests = {};
            Positions = {}
        }
    }
)
type TestBot = {
    RawData: Array<ModuleScript>;
    TestData: {
        Tests: Array<ModuleScript>;
        Positions: Array<number>;
    };
} & typeof(TestBot)
function TestBot:New(Tests: Array<ModuleScript>): TestBot
    assert(Tests ~= nil, "No tests provided! Debug:\n"..debug.traceback())
    local RawData = Tests
    self.RawData = RawData
    local NumberOfTests = #RawData
    print("Number of Testers to check:",NumberOfTests)
    local TestData = {
        Tests = table.create(NumberOfTests, nil) :: Array<ModuleScript>;
        Positions = table.create(NumberOfTests, nil) :: Array<number>;
    }
    table.sort(RawData,function(a,b)
        local aSuc, aNum = pcall(function()
            return a.Name + 0
        end)
        local bSuc, bNum = pcall(function()
            return b.Name + 0
        end)
        assert(aSuc and bSuc,"One of these aren't a number! A: " .. a.Name .. ", B: " .. b.Name)
        return aNum < bNum
    end)
    for i=1, #RawData do
        local ModuleScript = RawData[i]
        local Position = ModuleScript.Name
        if TestData.Tests[Position] then
            warn("The test with the number \""..Position.."\" [",TestData.Tests[Position],"] was replaced by", ModuleScript)
        end
        TestData.Tests[Position] = ModuleScript
        table.insert(TestData.Positions,Position)
    end
    TestBot.TestData = TestData
    return self
end

function TestBot:Run()
    local TestData = self.TestData
    local FailedCounter, WarnCounter, SkippedCounter = 0,0,0
    for i=1, #TestData.Positions do
        local TesterData = TestData.Tests[TestData.Positions[i]]
        --local Perspective = TesterData.Perspective
        local Module = TesterData
        local Tester = require(Module)(self)
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
                    ArcaneumGlobals.Utilities:error(Result)
                    FailedCounter += 1
                else
                    warn("Test did not have a Status!")
                end
            end
            print(Separator .."\n\n")
        end
    end
    print(FailedCounter,"failed,", WarnCounter, "issue(s),", SkippedCounter, "skipped")
    return true
end

return TestBot