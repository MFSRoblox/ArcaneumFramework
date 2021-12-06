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
local TestResultClass = BaseClass:Extend({
    Version = 1;
    Object = script;
})
TestResultClass.__tostring = function(self)
    return string.format("[%s] %s", self.Name, tostring(self.Result))
end
function TestResultClass:New(TestName: string, IsSuccessful: boolean, Result)
    local NewTest = BaseClass:New("TestCase",TestName)
    NewTest.IsSuccessful = IsSuccessful or false;
    NewTest.Result = Result;
    return self:Extend(NewTest)
end

return TestResultClass