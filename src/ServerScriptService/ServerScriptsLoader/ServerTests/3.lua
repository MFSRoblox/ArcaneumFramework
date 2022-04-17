local PrintDebug = false
local function debugPrint(...)
    if PrintDebug == true then
        print(...)
    end
end
return function(self)
    --local ArcaneumGlobals = self.ArcaneumGlobals
    local TargetPlayer = self.TestPlayer
    if TargetPlayer == nil then
        return 3
    end
    debugPrint("Got TargetPlayer:",TargetPlayer)
    local ThisTest = self.TesterClass:New("Client Foundations")
    ThisTest:SetPrintProcess(PrintDebug)
    ThisTest:AddTest("TestBotProxy Check", true, "Client")
    local ConnectionTest = ThisTest:AddTest("Client Connection Test", true, "Client")
    local _ClientConnector = ConnectionTest.ClientConnector
    ConnectionTest:AddStep("[2]ClientResponseTest",function(HasConnection)
        assert(HasConnection,"Stopped test due to lack of connection.")
        return {
            Message = "Hello World!";
        }
    end)
    return ThisTest
end