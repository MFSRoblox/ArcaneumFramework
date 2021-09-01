local Globals = _G.Arcaneum
local BaseClass = Globals.ClassFunctions.Tester
local ClientTester = BaseClass:Extend({
    Version = 2;
    Object = script;
    Timeout = 10;
})
function ClientTester:New(TestName: String, DisplayName: String)
    local NewTest = self:Extend(BaseClass:New(TestName,DisplayName))
    NewTest.EventFunctions = {}
    local TargetPlayer = Globals.TestBot.TestPlayer
    NewTest.TargetPlayer = TargetPlayer
    local ProxyFunction = TargetPlayer:WaitForChild("ProxyFunction", 10)
    NewTest.ProxyFunction = ProxyFunction
    assert(ProxyFunction, "No ProxyInterface found!")
    local ProxyEvent = TargetPlayer:WaitForChild("ProxyEvent", 10)
    NewTest.ProxyEvent = ProxyEvent
    assert(ProxyEvent, "No ProxyEvent found!")
    NewTest.Connections["TestBotProxyListener"] = ProxyEvent.OnServerEvent:Connect(function(Player, TestName, Data)
        if TargetPlayer == Player then
            NewTest.EventFunctions[TestName](Data)
        end
    end)
    return NewTest
end

function ClientTester:AddTest(Name: String, StopOnFailure: Boolean, StartFunction: Function)
    print(self.DisplayName.." added test",Name)
    local NewTest = TestCaseClass:New(Name, StopOnFailure, StartFunction)
    table.insert(self.Tests, NewTest)
    return NewTest
end

function ClientTester:RunTests()
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

function ClientTester:Destroy(): boolean
    self.Tests = nil
    return BaseClass.Destroy(self)
end

print(ClientTester)
return ClientTester