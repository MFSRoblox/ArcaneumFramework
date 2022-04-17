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
local TestCaseClass:TestCase = BaseClass:Extend({
    Version = 1;
    Object = script;
})
export type TestCase = {
    Version: number;
    Object: ModuleScript;
    StopOnFailure: boolean;
    PrintProcess: boolean;
    Steps: Array<(any) -> (any)>;
} & typeof(TestCaseClass)
function TestCaseClass:New(Name: string, StopOnFailure: boolean, Callback: (any) -> any): TestCase
    local NewTest = self:Extend(BaseClass:New("TestCase",Name))
    NewTest.StopOnFailure = StopOnFailure or false;
    NewTest.Steps = {}
    NewTest.PrintProcess = nil
    NewTest:AddStep(Callback)
    return NewTest
end

function TestCaseClass:SetPrintProcess(ShouldPrintProcess: boolean)
    self.PrintProcess = ShouldPrintProcess
end

function TestCaseClass:AddStep(Callback: (any) -> any)
    if Callback then
        table.insert(self.Steps,Callback)
    else
        warn("No Callback included! Debug:",debug.traceback())
    end
end

function TestCaseClass:Run(DefaultPrintProcess:boolean)
    local PrintProcess = self.PrintProcess
    if PrintProcess == nil then
        PrintProcess = DefaultPrintProcess
    end
    local function debugPrint(...)
        if PrintProcess then
            print(...)
        end
    end
    local initialString = "TestCase " .. self.Name
    debugPrint("Running",initialString)
    local Success, TestResult
    local Steps = self.Steps
    for i=1, #Steps do
        local CurrentStep = Steps[i]
        if CurrentStep then
            Success, TestResult = pcall(CurrentStep, TestResult)
        end
        if Success == false then
            break
        end
    end
    if Success and TestResult ~= nil then
        debugPrint(initialString.." has executed flawless as expected. Result:\n" .. tostring(TestResult) .. "\n")
        return true, TestResult
    else
        local outputMessage = initialString
        if Success then
            outputMessage ..= " didn't return a result!\n"
        else
            outputMessage ..= " has failed to work correctly! Debug:\n".. tostring(TestResult)
        end
        if self.StopOnFailure then
            assert(false, outputMessage .. "\n")
        else
            warn(outputMessage .. "\n")
        end
        return false, TestResult
    end
end

function TestCaseClass:Destroy()
    table.clear(self.Steps)
    table.clear(self)
    return BaseClass.Destroy(self)
end

return TestCaseClass