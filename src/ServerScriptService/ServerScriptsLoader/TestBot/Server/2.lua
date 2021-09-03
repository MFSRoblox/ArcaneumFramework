local Globals = _G.Arcaneum
local TargetPlayer = Globals.TestBot.TestPlayer
print("Got TargetPlayer:",TargetPlayer)
local ThisTest = Globals.ClassFunctions.Tester:New("Client Foundations")
ThisTest:AddTest("TestBotProxy Check", true, "Client")
local ConnectionTest = ThisTest:AddTest("Client Connection Test", true, "Client")
local ClientConnector = ConnectionTest.ClientConnector
ConnectionTest:AddStep("[2]ClientResponseTest",function(HasConnection)
    assert(HasConnection,"Stopped test due to lack of connection.")
    return {
        Message = "Hello World!";
    }
end)
return ThisTest