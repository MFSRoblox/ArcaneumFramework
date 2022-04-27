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
ClassService:CheckVersion("1.0.0")
local InternalClass = ClassService:GetClass("InternalClass")
InternalClass:CheckVersion("1.1.0")
local TestResultClass: TestResult = InternalClass:Extend({
    ClassName = "TestResultClass";
    Version = "1.0.0";
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
    local NewTest = InternalClass.New(self,"TestCase",TestName)
    NewTest.Status = Status or "Unassigned";
    NewTest.Result = Result;
    return NewTest
end
function TestResultClass:Destroy()
    table.clear(self)
    InternalClass.Destroy(self)
end
return TestResultClass