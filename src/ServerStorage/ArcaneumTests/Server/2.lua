return function(self)
    --local ArcaneumGlobals = self.ArcaneumGlobals
    local TargetPlayer = self.TestPlayer
    if TargetPlayer == nil then
        return {}
    end
    print("Got TargetPlayer:",TargetPlayer)
    local ThisTest = self.TesterClass:New("Client Foundations")
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
end