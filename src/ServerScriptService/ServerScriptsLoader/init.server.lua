local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")
local BootDrive = ServerStorage:WaitForChild("ArcaneumEngine")
print("Booting")
require(BootDrive)
print("Booted")
--[[print(RunService:IsRunMode())
if _G.Arcaneum.IsStudio and not RunService:IsRunMode() then
    game:GetService("Players").PlayerAdded:Wait()]]
--end
local WaitTime = 5
if _G.Arcaneum.IsTesting then
    print("Waiting a little in case a player is being added...\n Starting tests in:")
    for i=WaitTime, 1, -1 do
        print(i)
        wait(1)
    end
    require(script.TestBot)
end