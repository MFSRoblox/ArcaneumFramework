local ServerStorage = game:GetService("ServerStorage")
local ServerAssets = ServerStorage:WaitForChild("Assets")
local Nexus
local Globals = _G.Arcaneum
local ThisTest = Globals.ClassFunctions.TestClass:New("Test 1: ServerNexus")
ThisTest:AddTest("Nexus Test", function()
    Nexus = ServerAssets:WaitForChild("ServerNexus")
    if Nexus then
        Nexus = require(Nexus)
    else
        warn("Nexus doesn't exist! Abort!")
        return false
    end
    print(Nexus)
    return true
end, true)
local PlayerManager
ThisTest:AddTest("PlayerManager Test", function()
    PlayerManager = Nexus:GetPlayerManager()
    assert(PlayerManager,"PlayerManager doesn't exist! Abort!")
    print(PlayerManager)
    return true
end, true)

local TestPlayer
ThisTest:AddTest("PlayerManager Player Presence Test", function()
    local CurrentPlayers = game:GetService("Players"):GetPlayers()
    if #CurrentPlayers < 1 then return "No players to run test on." end
    assert(PlayerManager,"PlayerManager doesn't exist! Abort!")
    TestPlayer = CurrentPlayers[1]
    print(TestPlayer,PlayerManager.Supervisors)
    local TestSupervisor = PlayerManager.Supervisors[TestPlayer]
    print(TestSupervisor)
    assert(TestSupervisor, "No Supervisor found!")
    return true
end)

ThisTest:AddTest("PlayerManager Player \"Removed\" Test", function()
    if not TestPlayer then return "TestPlayer is nil!" end
    PlayerManager:RemovePlayer(TestPlayer)
    assert(not PlayerManager.Supervisors[TestPlayer], "Supervisor for TestPlayer still exists!")
    local ServerInterface = TestPlayer.PlayerGui:FindFirstChildWhichIsA("RemoteEvent")
    assert(not ServerInterface, "ServerInterface is still present in TestPlayer!")
    return true
end)

ThisTest:AddTest("PlayerManager Player \"Added\" Test", function()
    if not TestPlayer then return "TestPlayer is nil!" end
    PlayerManager:AddPlayer(TestPlayer)
    print(PlayerManager.Supervisors[TestPlayer])
    assert(PlayerManager.Supervisors[TestPlayer], "Supervisor for doesn't exist!")
    local ServerInterface = TestPlayer.PlayerGui:FindFirstChildWhichIsA("RemoteEvent")
    assert(ServerInterface, "ServerInterface not still present in TestPlayer!")
    return true
end)

return ThisTest