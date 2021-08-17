local ServerStorage = game:GetService("ServerStorage")
local BootDrive = ServerStorage:WaitForChild("ArcaneumEngine")
require(BootDrive)

if _G.Arcaneum.IsTesting then
    require(script.TestBot)
end