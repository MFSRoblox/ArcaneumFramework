local BaseClass = _G.Arcaneum.ClassFunctions.Internal
type Function = typeof(function() end)
local TestCaseClass = BaseClass:Extend({
    Version = 1;
    Object = script;
})
type ClientConnector = table
function TestCaseClass:New(Name: string, StopOnFailure: boolean, StartFunction: Function, ClientConnector: ClientConnector)
    local NewTest = self:Extend(BaseClass:New("TestCase",Name))
    NewTest.StopOnFailure = StopOnFailure or false;
    NewTest.Steps = {}
    NewTest.ClientConnector = ClientConnector
    if StartFunction then
        NewTest:AddStep("Server", StartFunction)
    elseif StartFunction == "Client" then
        NewTest:AddStep("Server", function()
            local TargetPlayer = ClientConnector.TargetPlayer
            assert(TargetPlayer, "No TargetPlayer found!")
            local ProxyFunction = ClientConnector.ProxyFunction
            assert(ProxyFunction, "No ProxyInterface found!")
            local ProxyEvent = ClientConnector.ProxyEvent
            assert(ProxyEvent, "No ProxyEvent found!")
            return true
        end)
    end
    return NewTest
end

function TestCaseClass:AddStep(Perspective: string, Function: Function)
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
        local Function = CurrentStep.Function
        if Function then
            Success, TestResult = pcall(CurrentStep.Function, TestResult)
        end
        local Perspective = CurrentStep.Perspective
        if Perspective == "Client" then
            Success, TestResult = pcall(self.InvokeClient, self, TestResult)
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

function TestCaseClass:InvokeClient(TestResult)
    return self.ClientConnector:InvokeClient(self.TestName, TestResult)
end

function TestCaseClass:Destroy()
    self.Function = nil
    self.StopOnFailure = nil
    return true
end

return TestCaseClass