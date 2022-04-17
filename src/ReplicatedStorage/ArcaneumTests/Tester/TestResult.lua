local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
local ArcaneumGlobals repeat
    ArcaneumGlobals = ReplicatedStorage:FindFirstChild(GlobalModuleName)
    if ArcaneumGlobals == nil then
        task.wait(1)
    else
        ArcaneumGlobals = require(ArcaneumGlobals)
    end
until ArcaneumGlobals ~= nil
local BaseClass = ArcaneumGlobals.ClassFunctions:GetClass("Internal")
local TestResultClass: TestResult = BaseClass:Extend({
    Version = 1;
    Object = script;
})
export type TestResult = {
    Version: number;
    Object: ModuleScript;
    Status: string;--"Successful"|"Critical Failure"|"Skipped"|"Failure"|"Unassigned";
    Result: any;
} & typeof(TestResultClass)
TestResultClass.__tostring = function(self)
    return string.format("[%s] [Status: %s] [Result: %s]", self.Name, tostring(self.Status), tostring(self.Result))
end
function TestResultClass:New(TestName: string, Status: string, Result: any): TestResult
    local NewTest = self:Extend(BaseClass:New("TestCase",TestName))
    NewTest.Status = Status or "Unassigned";
    NewTest.Result = Result;
    return NewTest
end
function TestResultClass:Destroy()
    table.clear(self)
    BaseClass.Destroy(self)
end
return TestResultClass