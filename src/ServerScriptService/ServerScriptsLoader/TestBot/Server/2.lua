local Globals = _G.Arcaneum
local TargetPlayer = Globals.TestBot.TestPlayer
print("Got TargetPlayer:",TargetPlayer)
local ThisTest = Globals.ClassFunctions.Tester:New("Client Foundations")

local ProxyFunction
local ProxyEvent
local Timeout = 10
local EventFunctions = {

}
ThisTest:AddTest("TestBotProxy Check", true, function()
    ProxyFunction = ThisTest.ProxyFunction
    assert(ProxyFunction, "No ProxyInterface found!")
    ProxyEvent = ThisTest.ProxyEvent
    assert(ProxyEvent, "No ProxyEvent found!")
    return true
end)
ThisTest:AddTest("Client Connection Test", true, function()
    ProxyEvent:FireClient(TargetPlayer,"Ping", true)
    local Result, Counter
    repeat
        Result = nil
        Counter += task.wait()
    until not Result or Counter > Timeout
    return Result
end)
return ThisTest