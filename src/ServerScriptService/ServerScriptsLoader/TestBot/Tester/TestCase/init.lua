local BaseClass = _G.Arcaneum.ClassFunctions.Internal
local TestCaseClass = BaseClass:Extend({
    Version = 1;
    Object = script;
})
function TestCaseClass:New(Name: String, StopOnFailure: Boolean, StartFunction: Function)
    local NewTest = self:Extend(BaseClass:New("TestCase",Name))
    NewTest.StopOnFailure = StopOnFailure or false;
    NewTest.Steps = {}
    if StartFunction then
        NewTest:AddStep("Server", StartFunction)
    end
    return NewTest
end

function TestCaseClass:AddStep(Perspective: String, Function: Function)
    table.insert(self.Steps,{
        Perspective = Perspective;
        Function = Function;
    })
end

function TestCaseClass:Run()
    local initialString = "TestCase " .. self.Name
    local Success, TestResult
    local Steps = self.Steps
    for i=1, #Steps do
        local CurrentStep = Steps[i]
        local Perspective = CurrentStep.Perspective
        if Perspective ~= "Client" then
            Success, TestResult = pcall(Steps[i].Function, TestResult)
        else
            --Success, TestResult = --InvokeRemote Function of sorts
        end
        if Success == false then
            break
        end
    end
    if Success and TestResult ~= nil then
        print(initialString.." has executed flawless as expected. Result: " .. tostring(TestResult))
        return true, TestResult
    else
        local outputMessage = initialString
        if Success then
            outputMessage ..= " didn't return a result!"
        else
            outputMessage ..= " has failed to work correctly! Debug: ".. tostring(TestResult)
        end
        if self.StopOnFailure then
            assert(false, outputMessage)
        else
            warn(outputMessage)
        end
        return false, TestResult
    end
end

function TestCaseClass:Destroy()
    self.Function = nil
    self.StopOnFailure = nil
    return true
end

return TestCaseClass