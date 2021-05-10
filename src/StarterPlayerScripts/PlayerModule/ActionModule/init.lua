local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedEvents = ReplicatedStorage.Events

local ActionModule = {}
ActionModule.__index = ActionModule

function ActionModule.new()
    local self = setmetatable({},ActionModule)
    self.ServerEvent = ReplicatedEvents:WaitForChild("PlayerAction")
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
    self.ValidActions = {}
    self.ActionFolder = LocalPlayer:WaitForChild("PlayerActions")
    self.ActionFolder.ChildAdded:Connect(function(Child)
        self:LoadAction(Child)
    end)
    self:LoadActions()
    return self
end

function ActionModule:LoadActions()
    local Children = self.ActionFolder:GetChildren()
    for i=1, #Children do
        local Child = Children[i]
        self:LoadAction(Child)
    end
end

function ActionModule:LoadAction(Child)
    if self.ValidActions[Child.Name] then
        self.ValidActions[Child.Name] = nil
    end
    self.ValidActions[Child.Name] = Child
    --insert code here
end

function ActionModule:ExecuteAction(ActionName:String)
    local SubModule = self.ValidActions[ActionName]
    if SubModule then
        SubModule:Execute()
    else
        warn("Unknown Action",ActionName,"called on Client")
    end
end

function ActionModule:OnCharacterAdded(char)
	self.Humanoid = char:FindFirstChildOfClass("Humanoid")
	while not self.Humanoid do
		char.ChildAdded:wait()
		self.Humanoid = char:FindFirstChildOfClass("Humanoid")
	end
    self.Animator = self.Humanoid:WaitForChild("Animator")
end

function ActionModule:OnCharacterRemoving(char)
	self.humanoid = nil
    self.Animator = nil
end

function ActionModule:GetServerEvent()
    return self.ServerEvent
end

function ActionModule:GetClientEvent()
    return self.ClientEvent
end

return ActionModule.new()