local Globals = _G.Arcaneum
local TargetPlayer = Globals.TestBot.TestPlayer
print("Got TargetPlayer:",TargetPlayer)
local ThisTest = Globals.ClassFunctions.Tester:New("Client Foundations")

local ProxyFunction
local ProxyEvent
ThisTest:AddTest("TestBotProxy Check", true, function()
    ProxyFunction = TargetPlayer:WaitForChild("ProxyFunction", 10)
    ProxyEvent = TargetPlayer:WaitForChild("ProxyEvent", 10)
    assert(ProxyFunction, "No ProxyInterface found!")
    assert(ProxyEvent, "No ProxyEvent found!")
    return true
end)
ThisTest:AddTest("Client Connection Test", true, function()
    local Result = ProxyFunction:InvokeClient(TargetPlayer,"Ping", true)
    return Result
end)
return ThisTest