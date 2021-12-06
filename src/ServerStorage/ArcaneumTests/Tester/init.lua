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
local BaseClass = ArcaneumGlobals.ClassFunctions.Internal
local ScriptUtilities = ArcaneumGlobals.Utilities
local ClientConnectorClass = ArcaneumGlobals.ClassFunctions.ClientConnector --ScriptUtilities:ImportModule(script,"Parent","ClientConnector")
local TestCaseClass = ScriptUtilities:ImportModule(script,"TestCase")
local TestResultClass = ScriptUtilities:ImportModule(script,"TestResult")
local Tester = BaseClass:Extend({
    Version = 2;
    Object = script;
})
function Tester:New(TestName: string, DisplayName: string)
    local NewTest = BaseClass:New("Tester",TestName)
    if not DisplayName then
        local RandomNames = {"John Doe", "Jane Doe"}
        DisplayName = "Tester ".. RandomNames[Random.new():NextInteger(1,2)]
    end
    NewTest.DisplayName = DisplayName
    NewTest.Tests = {}
    return self:Extend(NewTest)
end

function Tester:AddTest(TestName: string, StopOnFailure: boolean, Callback: (any) -> any)
    print(self.DisplayName.." added test:",TestName)
    local ClientConnector = nil
    if Callback == "Client" then
        if not self.ClientConnector then
            self.ClientConnector = ClientConnectorClass:New(TestName..self.Name)
        end
        ClientConnector = self.ClientConnector
        Callback = function()
            return "ClientConnector initialized."
        end
    end
    local NewTest = TestCaseClass:New(TestName, StopOnFailure, Callback, ClientConnector)
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
    if not s then
        output = {}
        warn("Tester " .. self.DisplayName .." cannot execute all tests! Result:"..tostring(v))
    end
    return output
end

function Tester:Destroy(): boolean
    self.Tests = nil
    return BaseClass.Destroy(self)
end

print(Tester)
return Tester