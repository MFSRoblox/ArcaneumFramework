local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local BaseAction = {}
BaseAction.__index = BaseAction
function BaseAction.new()
    local self = setmetatable(script:GetAttributes(),BaseAction)
    self.Humanoid = nil
    self.Animator = nil
    LocalPlayer.CharacterAdded:Connect(function(char) self:OnCharacterAdded(char) end)
	LocalPlayer.CharacterRemoving:Connect(function(char)  self:OnCharacterRemoving(char) end)
	if LocalPlayer.Character then
		self:OnCharacterAdded(LocalPlayer.Character)
	end
    self.Animations = {}
    self.AnimationWeights = 0
    return self
end

function BaseAction:Execute()
    warn("Action wasn't overwritten")
end

function BaseAction:LoadAnimation(AnimationId:Content)
    if not AnimationId then
        --AnimationId = T-Pose here
        warn("No AnimationId given for "..script.Parent.."! Using placeholder.")
    end
    local Animation = self.Animations[AnimationId]
    if not Animation then
        Animation = Instance.new("Animation")
        self.Animations[AnimationId] = Animation
        Animation.AnimationId = AnimationId
    end
    return Animation
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

function BaseAction:InitAnimation(AnimationId:Content, Weight:Number)
    self:LoadAnimation(AnimationId)
    self.AnimationWeights[AnimationId] = Weight or 1
end

function BaseAction:PickAnimation()
    local AnimationWeights = self.AnimationWeights
    local WeightSum = 0
    local AnimationOrder = {}
    local WeightBounds = {}
    for AnimationId, Weight in next, AnimationWeights do
        WeightSum += Weight
        table.insert(AnimationOrder, AnimationId)
        table.insert(WeightBounds, WeightSum)
    end
    if #AnimationOrder == 1 then
        return self:LoadAnimation(AnimationOrder[1])
    end
    assert(#AnimationOrder == #WeightBounds, "BaseAction:PickAnimation() doesn't have the same table length for AnimationOrder and WeightBounds! Critial Error!")
    local DiceRoll = Random.new():NextInteger(0,WeightSum)
    for i=1, #WeightBounds do
        if WeightBounds[i] <= DiceRoll then
            return self:LoadAnimation(AnimationOrder[i])
        end
    end
    assert(false,"No Animation was ever selected for BaseAction:PickAction()! Critical Error!")
end

function BaseAction:PlayAnimation(TargetTime: Number)
    if self.Animator then
        local Animation = self:PickAnimation()
        local AnimationTrack = self.Animator:LoadAnimation(Animation)
        local TimeToFinish = AnimationTrack.Length
        TargetTime = TargetTime or TimeToFinish
        local TimeMultiplier = TimeToFinish/TargetTime
        AnimationTrack:Play(0,1,TimeMultiplier)

        --Insert GetMarkerReachedSignal here if needed
    else
        warn("BaseAction:PlayAnimation() doesn't have an Animator to call LoadAnimation on!")
    end
end

return BaseAction