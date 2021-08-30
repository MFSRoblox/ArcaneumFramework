print("Setting up Interface")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local PlayerInterface = Events:WaitForChild("PlayerInterface")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
PlayerInterface.OnClientEvent:Connect(function(Data)
    print("Got Data:", Data)
end)
print("Interface Ready")
PlayerInterface:FireServer({
    Name = "InterfaceBooted";
})