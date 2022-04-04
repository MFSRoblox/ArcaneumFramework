local PrintDebug = false
local function debugPrint(...)
    if PrintDebug == true then
        print(...)
    end
end
local ServerStorage = game:GetService("ServerStorage")
return function(self)
    --local ArcaneumGlobals = self.ArcaneumGlobals
    local TestPlayer = self.TestPlayer
    if TestPlayer == nil then
        return 3
    end
    local Nexus
    local ThisTest = self.TesterClass:New("Nexus Creation")
    ThisTest:SetPrintProcess(PrintDebug)
    ThisTest:AddTest("Nexus Test", true, function()
        Nexus = ServerStorage:WaitForChild("ArcaneumEngine")
        if Nexus then
            Nexus = require(Nexus)
        else
            warn("Nexus doesn't exist! Abort!")
            return false
        end
        --print(Nexus)
        return true
    end)
    local PlayerManager
    ThisTest:AddTest("PlayerManager Test", true, function()
        PlayerManager = Nexus:GetPlayerManager()
        assert(PlayerManager,"PlayerManager doesn't exist! Abort!")
        debugPrint(PlayerManager)
        return true
    end)

    ThisTest:AddTest("PlayerManager Player Presence Test", false, function()
        if TestPlayer == nil then return "No players to run test on." end
        assert(PlayerManager,"PlayerManager doesn't exist! Abort!")
        debugPrint(TestPlayer,PlayerManager.Supervisors)
        local TestSupervisor = PlayerManager.Supervisors[TestPlayer]
        debugPrint(TestSupervisor)
        assert(TestSupervisor, "No Supervisor found!")
        return true
    end)

    ThisTest:AddTest("PlayerManager Player \"Removed\" Test", false, function()
        if not TestPlayer then return "TestPlayer is nil!" end
        debugPrint(PlayerManager)
        PlayerManager:RemovePlayer(TestPlayer)
        assert(not PlayerManager.Supervisors[TestPlayer], "Supervisor for TestPlayer still exists!")
        --local ServerInterface = TestPlayer.PlayerGui:FindFirstChild("ServerHotline")
        --assert(not ServerInterface, "ServerInterface is still present in TestPlayer!")
        return true
    end)

    ThisTest:AddTest("PlayerManager Player \"Added\" Test", false, function()
        if not TestPlayer then return "TestPlayer is nil!" end
        PlayerManager:AddPlayer(TestPlayer)
        debugPrint(PlayerManager.Supervisors[TestPlayer])
        assert(PlayerManager.Supervisors[TestPlayer], "Supervisor for doesn't exist!")
        --local ServerInterface = TestPlayer.PlayerGui:FindFirstChild("ServerHotline")
        --assert(ServerInterface, "ServerInterface not still present in TestPlayer!")
        return true
    end)
    return ThisTest
end