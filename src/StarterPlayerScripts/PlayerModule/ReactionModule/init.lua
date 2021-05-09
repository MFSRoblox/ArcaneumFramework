local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedEvents = ReplicatedStorage.Events

local DefaultActions = require(script:WaitForChild("DefaultActions"))

local ReactionModule = {}
ReactionModule.__index = ReactionModule

function ReactionModule.new()
    local self = setmetatable({},ReactionModule)
    self.ServerEvent = ReplicatedEvents:WaitForChild("PlayerReaction")
    self.ServerEvent.OnClientEvent:Connect(function(ActionName) self:PlayAction(ActionName) end)
    self.ClientEvent = Instance.new("BindableEvent")
    self.ClientEvent.Event:Connect(function(ActionName) self:PlayAction(ActionName) end)
    self.Humanoid = nil
    self.Animator = nil
    self.Animations = {}
    LocalPlayer.CharacterAdded:Connect(function(char) self:OnCharacterAdded(char) end)
	LocalPlayer.CharacterRemoving:Connect(function(char)  self:OnCharacterRemoving(char) end)
	if LocalPlayer.Character then
		self:OnCharacterAdded(LocalPlayer.Character)
	end
    
    return self
end

function ReactionModule:OnCharacterAdded(char)
	self.Humanoid = char:FindFirstChildOfClass("Humanoid")
	while not self.Humanoid do
		char.ChildAdded:wait()
		self.Humanoid = char:FindFirstChildOfClass("Humanoid")
	end
    self.Animator = self.Humanoid:WaitForChild("Animator")
end

function ReactionModule:OnCharacterRemoving(char)
	self.humanoid = nil
    self.Animator = nil
end

function ReactionModule:PlayAction(ActionName:String)
    ActionName = string.lower(ActionName)
    local Animation = self.Animations[ActionName]
    if not Animation then
        local NewAnimation = self:LoadAction(ActionName)
        self.Animations[ActionName] = NewAnimation
        Animation = NewAnimation
    end
    local AnimationTrack = self.Animator:LoadAnimation(Animation)
    AnimationTrack:Play()

    --Insert GetMarkerReachedSignal here if needed
end

function ReactionModule:LoadAction(ActionName:String, AnimationId:Content)
    ActionName = string.lower(ActionName)
    if not AnimationId then
        AnimationId = DefaultActions[ActionName]
    end
    local Animation = self.Animations[ActionName]
    if not Animation then
        Animation = Instance.new("Animation")
    end
    Animation.AnimationId = AnimationId
    return Animation
end

function ReactionModule:GetServerEvent()
    return self.ServerEvent
end

function ReactionModule:GetClientEvent()
    return self.ClientEvent
end

return ReactionModule.new()