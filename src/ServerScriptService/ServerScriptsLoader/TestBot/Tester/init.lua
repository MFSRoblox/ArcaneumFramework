local BaseClass = _G.Arcaneum.ClassFunctions.Internal
local ClientConnectorClass do
    local Mod = script:WaitForChild("ClientConnector")
    if Mod then
        ClientConnectorClass = require(Mod)
    end
end
local TestCaseClass do
    local Mod = script:WaitForChild("TestCase")
    if Mod then
        TestCaseClass = require(Mod)
    end
end
local TestResultClass do
    local Mod = script:WaitForChild("TestResult")
    if Mod then
        TestResultClass = require(Mod)
    end
end
local Tester = BaseClass:Extend({
    Version = 2;
    Object = script;
})
function Tester:New(TestName: String, DisplayName: String)
    local NewTest = BaseClass:New("Tester",TestName)
    if not DisplayName then
        local RandomNames = {"John Doe", "Jane Doe"}
        DisplayName = "Tester ".. RandomNames[Random.new():NextInteger(1,2)]
    end
    NewTest.DisplayName = DisplayName
    NewTest.Tests = {}
    return self:Extend(NewTest)
end

function Tester:AddTest(TestName: String, StopOnFailure: Boolean, StartFunction: Function)
    print(self.DisplayName.." added test:",TestName)
    local ClientConnector = nil
    if StartFunction == "Client" then
        if not self.ClientConnector then
            self.ClientConnector = ClientConnectorClass:New(TestName..self.Name)
        end
        ClientConnector = self.ClientConnector
        StartFunction = function()
            return "ClientConnector initialized."
        end
    end
    local NewTest = TestCaseClass:New(TestName, StopOnFailure, StartFunction, ClientConnector)
    table.insert(self.Tests, NewTest)
    return NewTest
end

function Tester:RunTests()
    local output = {}
    local s, v = pcall(function()
        local Tests = self.Tests
        for i = 1, #Tests do
            local Test = Tests[i]
            print(Test.Name, Test)
            local Success, Result = Test:Run()
            table.insert(output,TestResultClass:New(Test.Name, Success, Result))
        end
    end)
    if not s then output = {} warn("Tester " .. self.DisplayName .." cannot execute all tests! Result:"..tostring(v)) end
    return output
end

function Tester:Destroy(): boolean
    self.Tests = nil
    return BaseClass.Destroy(self)
end

print(Tester)
return Tester