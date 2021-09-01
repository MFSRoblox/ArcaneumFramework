local Globals = _G.Arcaneum
local TargetPlayer = Globals.TestBot.TestPlayer
print("Got TargetPlayer:",TargetPlayer)
local ThisTest = Globals.ClassFunctions.Tester:New("Client Foundations")

local ProxyFunction
local ProxyEvent
local Timeout = 10
local EventFunctions = {

}
ThisTest:AddTest("TestBotProxy Check", true, "Client")
local ConnectionTest = ThisTest:AddTest("Client Connection Test", true, "Client")
ConnectionTest:AddStep("Client",function(HasConnection)
    assert(HasConnection,"Stopped test due to lack of connection.")
    print("insert test stuff here")
    return true
end)
return ThisTest