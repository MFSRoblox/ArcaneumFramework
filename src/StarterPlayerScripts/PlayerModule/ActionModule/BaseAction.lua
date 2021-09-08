local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local BaseAction = {}
BaseAction.__index = BaseAction
function BaseAction.new(Attributes:table)
    local self = setmetatable(Attributes,BaseAction)
    self.Humanoid = nil
    self.Animator = nil
    LocalPlayer.CharacterAdded:Connect(function(char) self:OnCharacterAdded(char) end)
	LocalPlayer.CharacterRemoving:Connect(function(char) self:OnCharacterRemoving(char) end)
	if LocalPlayer.Character then
		self:OnCharacterAdded(LocalPlayer.Character)
	end
    self.Animations = {}
    self.AnimationWeights = 0
    return self
end

function BaseAction:Enable(ToEnable:boolean)
    warn("BaseAction:Enable wasn't overwritten")
end

function BaseAction:Execute()
    warn("BaseAction:Execute wasn't overwritten")
end

function BaseAction:OnCharacterAdded(char)
	self.Humanoid = char:FindFirstChildOfClass("Humanoid")
	while not self.Humanoid do
		char.ChildAdded:wait()
		self.Humanoid = char:FindFirstChildOfClass("Humanoid")
	end
    self.Animator = self.Humanoid:WaitForChild("Animator")
end

function BaseAction:OnCharacterRemoving(char)
	self.humanoid = nil
    self.Animator = nil
end

return BaseAction