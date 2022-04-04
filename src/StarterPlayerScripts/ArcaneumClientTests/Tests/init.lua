export type TestInfo = {
    ToRun: boolean;
    TestName: string;
    ToPrintProcess: boolean;
    Init: (TestBot:table, Tester:table) -> (any);
}
local TestInfoInterface = {} do
    TestInfoInterface.__index = TestInfoInterface
end
local Default = {
    ToRun = true;
    TestName = "Unnamed Test";
    ToPrintProcess = true;
    Init = function(_TestBot, _ThisTest)
        warn("Init not implemented for this test! Debug:",debug.traceback())
    end;
}
function TestInfoInterface.new(NewInfo: TestInfo): TestInfo
    for key,value in pairs(Default) do
        if NewInfo[key] == nil then
            NewInfo[key] = value
        end
    end
    return NewInfo
end

return TestInfoInterface