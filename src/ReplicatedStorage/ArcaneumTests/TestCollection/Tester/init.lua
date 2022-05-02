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
local InternalClass = ClassService:GetClass("InternalClass")
InternalClass:CheckVersion("1.2.0")
local Utilities = ArcaneumGlobals:GetGlobal("Utilities")
Utilities:CheckVersion("1.0.0")
local TestCaseClass = require(script.TestCase)
local TestResultClass = require(script.TestResult)
local Tester:Tester = InternalClass:Extend({
    ClassName = "Tester",
    Version = "1.0.0";
    CoreModule = script;
})
export type Tester = {
    Version: number;
    Object: ModuleScript;
    Name: string;
    DisplayName: string;
    PrintProcess: boolean;
    Tests: Array<TestCaseClass.TestCase>;
} & typeof(Tester)
function Tester:New(TestName: string, DisplayName: string): Tester
    local NewTester = InternalClass.New(self,"Tester",TestName)
    if not DisplayName then
        local RandomNames = {"John Doe", "Jane Doe"}
        DisplayName = "Tester ".. RandomNames[Random.new():NextInteger(1,2)]
    end
    NewTester.DisplayName = DisplayName
    NewTester.PrintProcess = true
    NewTester.Tests = {}
    return self:Extend(NewTester)
end

function Tester:print(...:any)
    if self.PrintProcess then
        print(...)
    end
end

function Tester:SetPrintProcess(ShouldPrintProcess: boolean): nil
    self.PrintProcess = ShouldPrintProcess
end

function Tester:AddTest(TestName: string, StopOnFailure: boolean, Callback: (PreviousReturns:any) -> (any))
    self:print(self.DisplayName.." added test:",TestName)
    local NewTest = TestCaseClass:New(TestName, StopOnFailure, Callback)
    table.insert(self.Tests, NewTest)
    return NewTest
end

local TestStatuses = {
    "Successful",
    "Critical Failure",
    "Skipped",
    "Failure",
    "Unassigned"
}

function Tester:RunTests(): Array<TestResultClass.TestResult>
    local output = {}
    local LatestTestName:string
    local s, v = pcall(function()
        local Tests = self.Tests
        for i = 1, #Tests do
            local Test = Tests[i]
            LatestTestName = Test.Name
            Test:SetPrintProcess(self.PrintProcess)
            local Success, Result = Test:Run()
            local Status = TestStatuses[5] do
                if Success then
                    Status = TestStatuses[1]
                elseif Result == 3 then
                    Status = TestStatuses[3]
                elseif Test.StopOnFailure == false then
                    Status = TestStatuses[4]
                else
                    Status = TestStatuses[2]
                end
            end
            table.insert(output,TestResultClass:New(LatestTestName, Status, Result))
        end
    end)
    if not s then
        Utilities:error(self.DisplayName .." cannot execute all tests! Result:\n"..tostring(v))
        table.insert(output,TestResultClass:New(LatestTestName, TestStatuses[2], tostring(v)))
    end
    return output
end

function Tester:Destroy(): boolean
    self.Tests = nil
    return InternalClass.Destroy(self)
end

return Tester