local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
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
local Class = ClassService:GetClass("Class")
Class:CheckVersion("1.2.0")
local Utilities = ArcaneumGlobals:GetGlobal("Utilities")
Utilities:CheckVersion("1.0.0")
local TestCollectionClass = require(script.TestCollection)
local TestBot: TestBot = Class:Extend(
    {
        ClassName = "ArcaneumTestService";
        ArcaneumGlobals = ArcaneumGlobals;
        Version = "1.0.0";
        CoreModule = script;
        TestCollections = {};
    }
)
export type TestBot = {
    TestCollections: Dictionary<TestCollectionClass.TestCollection>;
} & typeof(TestBot) & typeof(Class)
function TestBot:New(Tests: Folder?): TestBot
    local NewBot = self:Extend({});
    local TestCollections = {}
    TestCollections.GlobalTests = TestCollectionClass:New("GlobalTests",script.GlobalTests);
    local TestModulesFolder = Tests do
        if TestModulesFolder then
            TestCollections.OtherTests = TestCollectionClass:New(Tests.Name,Tests);
        end
    end
    NewBot.TestCollections = TestCollections
    return NewBot
end

function TestBot:Run()
    local TestCollections = self.TestCollections
    local FailedCounter, WarnCounter, SkippedCounter = TestCollections.GlobalTests:Run()
    if TestCollections.OtherTests ~= nil then
        local OtherFailed, OtherWarn, OtherSkipped = TestCollections.OtherTests:Run()
        FailedCounter += OtherFailed
        WarnCounter += OtherWarn
        SkippedCounter += OtherSkipped
    end
    print(FailedCounter,"failed,", WarnCounter, "issue(s),", SkippedCounter, "skipped")
    self:Destroy()
end

function TestBot:Destroy()
    for _,v in pairs(self.TestCollections) do
        v:Destroy()
    end
    return Class.Destroy(self)
end

return TestBot