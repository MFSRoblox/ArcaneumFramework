local BaseClass = _G.Arcaneum.ClassFunctions.Internal
local TestCaseClass = BaseClass:Extend({
    Version = 1;
    Object = script;
})
function TestCaseClass:New(Name: String, Function: Function, StopOnFailure: Boolean)
    local NewTest = self:Extend({
        ClassName = "TestCase";
        Name = Name;
        Function = Function or function() end;
        StopOnFailure = StopOnFailure or false;
    })
    return NewTest
end

function TestCaseClass:Run()
    local initialString = "TestCase " .. self.Name
    local Success, TestResult = pcall(self.Function)
    if Success and TestResult ~= nil then
        print(initialString.." has executed flawless as expected. Result: " .. tostring(TestResult))
        return true, TestResult
    else
        local outputMessage = ""
        if Success then
            outputMessage = initialString.." didn't return a result!"
        else
            outputMessage = initialString.." has failed to work correctly! Debug: ".. tostring(TestResult)
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