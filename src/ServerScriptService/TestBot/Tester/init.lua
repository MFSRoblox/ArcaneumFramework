local BaseClass = _G.Arcaneum.ClassFunctions.Internal
local TestCaseClass do
    local Mod = script:WaitForChild("TestCase")
    if Mod then
        TestCaseClass = require(Mod)
    end
end
local Tester = BaseClass:Extend({
    Version = 1;
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

function Tester:AddTest(Name: String, Function: Function, StopOnFailure: Boolean)
    print(self.DisplayName.." added test",Name)
    table.insert(self.Tests, TestCaseClass:New(Name, Function, StopOnFailure))
end

function Tester:RunTests()
    local output = {}
    local s, v = pcall(function()
        local Tests = self.Tests
        for i = 1, #Tests do
            local Test = Tests[i]
            print(Test)
            local Success, Result = Test:Run()
            table.insert(output,{IsSuccessful = Success; Result = Result})
        end
    end)
    if not s then output = {} warn("Tester " .. self.DisplayName .." cannot execute all tests! Result:"..tostring(v)) end
    return output
end

function Tester:Destroy()
    self.Tests = nil
    return true
end

print(Tester)
return Tester