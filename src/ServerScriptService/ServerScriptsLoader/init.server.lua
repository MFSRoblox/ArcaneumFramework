local ServerStorage = game:GetService("ServerStorage")
local BootDrive = ServerStorage:WaitForChild("ArcaneumEngine")
print("Booting")
require(BootDrive)
print("Booted")
if _G.Arcaneum.IsTesting then
    require(script.TestBot)
end