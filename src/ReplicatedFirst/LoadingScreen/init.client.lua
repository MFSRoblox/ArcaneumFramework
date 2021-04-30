local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local TeleportService = game:GetService("TeleportService")
local TeleportData = TeleportService:GetLocalPlayerTeleportData()
if TeleportData then
    local SetServerInfo = Events:WaitForChild("SetServerInfo")
    SetServerInfo:FireServer(TeleportData)
end
local LocalPlayer = game:GetService("Players").LocalPlayer
local ReplicatedFirst = game:GetService("ReplicatedFirst")
game.StarterGui:SetCoreGuiEnabled("PlayerList", false)
game.StarterGui:SetCoreGuiEnabled("Backpack", false)
ReplicatedFirst:RemoveDefaultLoadingScreen()
local TweenService = game:GetService("TweenService")

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local LoadingGui = script.Loading:Clone()
LoadingGui.Parent = PlayerGui
local LoadingMain = LoadingGui.Main
local LoadingRing = LoadingMain.LoadingRing
local Logo = LoadingMain.Logo
local LoadingText = LoadingMain.TextLabel
LoadingText.TextTransparency = 1
LoadingRing.Size = UDim2.fromScale(0,0)
Logo.Size = UDim2.fromScale(0,0)

local FullSizeLogo = UDim2.fromScale(0.375,0.375)
local FullSizeLoading = UDim2.fromScale(0.4425,0.4425)
--wait(2)

local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)
local Anime = TweenService:Create(LoadingRing, tweenInfo, {Rotation = 360})
Anime:Play()
local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local Anime = TweenService:Create(Logo, tweenInfo, {Size = FullSizeLogo})
Anime:Play()

local tweenInfo = TweenInfo.new(2.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local Anime = TweenService:Create(LoadingRing, tweenInfo, {Size = FullSizeLoading})
Anime:Play()
Anime.Completed:Wait()

--wait(2)
if not game:IsLoaded() then game.Loaded:Wait() end
--local ReplicatedStorage = game:GetService("ReplicatedStorage")
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
--[[local LoadedVal = ReplicatedStorage.Stats.Server:WaitForChild("Loaded")
local Connections = {}
if not LoadedVal.Value then
    local Anime = TweenService:Create(LoadingText, tweenInfo,{TextTransparency = 0})
    Anime:Play()
    local State = LoadedVal:GetAttribute("State")
    local CurrentTask = LoadedVal:GetAttribute("CurrentTask")
    local TotalTasks = LoadedVal:GetAttribute("TotalTasks")
    SetLoadingText(State,CurrentTask,TotalTasks)
    table.insert(Connections,LoadedVal:GetAttributeChangedSignal("State"):Connect(function()
        State = LoadedVal:GetAttribute("State")
        SetLoadingText(State,CurrentTask,TotalTasks)
    end))
    table.insert(Connections,LoadedVal:GetAttributeChangedSignal("CurrentTask"):Connect(function()
        CurrentTask = LoadedVal:GetAttribute("CurrentTask")
        SetLoadingText(State,CurrentTask,TotalTasks)
    end))
    table.insert(Connections,LoadedVal:GetAttributeChangedSignal("TotalTasks"):Connect(function()
        TotalTasks = LoadedVal:GetAttribute("TotalTasks")
        SetLoadingText(State,CurrentTask,TotalTasks)
    end))
    if not LoadedVal.Value then
        LoadedVal.Changed:Wait()
    end
end

for i=1,#Connections do
    Connections[i]:Disconnect()
end
LoadingText.Text = string.format("Server Loading Completed after %.1f seconds",LoadedVal:GetAttribute("EndTime")-LoadedVal:GetAttribute("StartTime"))]]
local Anime = TweenService:Create(LoadingRing, tweenInfo, {ImageTransparency = 1})
Anime:Play()
Anime.Completed:Wait()

local Anime = TweenService:Create(Logo.UICorner, tweenInfo, {CornerRadius = UDim.new(0.1,0)})
Anime:Play()
local Anime = TweenService:Create(LoadingGui.Main, tweenInfo, {BackgroundTransparency = 1})
Anime:Play()
local Anime = TweenService:Create(LoadingText, tweenInfo,{TextTransparency = 1})
Anime:Play()
Anime.Completed:Wait()
LoadingText.Visible = false

local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.In)
local Anime = TweenService:Create(Logo, tweenInfo, {Position = UDim2.fromScale(0.5,-0.5)})
Anime:Play()
Anime.Completed:Wait()
LoadingGui:Destroy()