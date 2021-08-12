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

ThisTest:AddTest("PlayerManager Player Presence Test", function()
    local CurrentPlayers = game:GetService("Players"):GetPlayers()
    if #CurrentPlayers < 1 then return "No players to run test on." end
    assert(PlayerManager,"PlayerManager doesn't exist! Abort!")
    local TestPlayer = CurrentPlayers[1]
    print(PlayerManager.Supervisors)
    local TestSupervisor = PlayerManager.Supervisors[TestPlayer]
    assert(TestSupervisor, "No Supervisor found!")
    return true
end)

return ThisTest