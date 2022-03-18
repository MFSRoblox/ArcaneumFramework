local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
local function clock(currentTime: number)
    return Roact.createElement("ScreenGui", {}, {
        TimeLabel = Roact.createElement("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            Text = "Current Time: " .. currentTime
        })
    })
end

local PlayerGui = Players.LocalPlayer.PlayerGui

-- Create our initial UI.
local currentTime = 0
local handle = Roact.mount(clock(currentTime), PlayerGui, "Clock UI")

-- Every second, update the UI to show our new time.
while true do
    wait(1)

    currentTime = currentTime + 1
    handle = Roact.update(handle, clock(currentTime))
end