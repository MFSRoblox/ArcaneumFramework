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
local ScriptUtilities = ArcaneumGlobals.Utilities
local ClientConnectorClass = ArcaneumGlobals.ClassFunctions:GetClass("ClientConnector") --ScriptUtilities:ImportModule(script,"Parent","ClientConnector")
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

local TestStatuses = {
    "Successful",
    "Failure",
    "Skipped",
    "Unassigned"
}

function Tester:RunTests()
    local output = {}
    local s, v = pcall(function()
        local Tests = self.Tests
        for i = 1, #Tests do
            local Test = Tests[i]
            print(Test.Name, Test)
            local Success, Result = Test:Run()
            local Status = TestStatuses[4] do
                if Success then
                    Status = TestStatuses[1]
                elseif Result == 3 then
                    Status = TestStatuses[3]
                elseif Result ~= nil then
                    Status = TestStatuses[2]
                end
            end
            table.insert(output,TestResultClass:New(Test.Name, Status, Result))
        end
    end)
    if not s then
        output = {}
        warn(self.DisplayName .." cannot execute all tests! Result:\n"..tostring(v))
    end
    return output
end

function Tester:Destroy(): boolean
    self.Tests = nil
    return BaseClass.Destroy(self)
end

print(Tester)
return Tester