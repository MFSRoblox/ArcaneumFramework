local AnimationClass = {}
AnimationClass.__index = AnimationClass

function AnimationClass.new(Package:ModuleScript)
    local self = {}
    setmetatable({},AnimationClass)
    local RawAnimations = Package:GetChildren()
    table.sort(RawAnimations, function(a,b)
        local aOrder = a:GetAttribute("Order")
        local bOrder = b:GetAttribute("Order")
        if aOrder and bOrder then
            return a:GetAttribute("Order") < b:GetAttribute("Order")
        elseif aOrder then
            return true
        elseif bOrder then
            return false
        else
            return a.Name < b.Name
        end
    end)
    local Sets = 0
    local OrderValues = {}
    local Animations = {}
    for i=1, #RawAnimations do
        local Animation = RawAnimations[i]
        local AnimationOrder = Animation:GetAttribute("Order")
        if Sets == 0 or OrderValues[Sets] ~= AnimationOrder then
            Sets += 1
            OrderValues[Sets] = AnimationOrder
            Animations[Sets] = {}
        end
        Animations[Sets][#Animations[Sets]+1] = {Id = Animation.AnimationId; Weight = Animation:GetAttribute("Weight") or 1}
    end
    self.Animations = Animations
    self.Animator = nil
    return self
end

function AnimationClass:LoadAnimation(AnimationId:Content)
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

function AnimationClass:PickAnimation(AnimationGroup:Table)
    local WeightSum = 0
    local AnimationOrder = {}
    local WeightBounds = {}
    for i=1, #AnimationGroup do
        local Animation = AnimationGroup[i]
        WeightSum += Animation["Weight"]
        AnimationOrder[#AnimationOrder+1] = Animation["Id"]
        WeightBounds[#WeightBounds+1] = WeightSum
    end
    if #AnimationOrder == 1 then
        return self:LoadAnimation(AnimationOrder[1])
    end
    assert(#AnimationOrder == #WeightBounds, "AnimationClass:PickAnimation() doesn't have the same table length for AnimationOrder and WeightBounds! Critial Error!")
    local DiceRoll = Random.new():NextInteger(0,WeightSum)
    for i=1, #WeightBounds do
        if WeightBounds[i] <= DiceRoll then
            return self:LoadAnimation(AnimationOrder[i])
        end
    end
    assert(false,"No Animation was ever selected for AnimationClass:PickAction()! Critical Error!")
end

function AnimationClass:PlayAnimation(TargetTime: Number)
    if self.Animator then
        local Animation = self:PickAnimation()
        local AnimationTrack = self.Animator:LoadAnimation(Animation)
        local TimeToFinish = AnimationTrack.Length
        TargetTime = TargetTime or TimeToFinish
        local TimeMultiplier = TimeToFinish/TargetTime
        AnimationTrack:Play(0,1,TimeMultiplier)

        --Insert GetMarkerReachedSignal here if needed
    else
        warn("AnimationClass:PlayAnimation() doesn't have an Animator to call LoadAnimation on!")
    end
end
return AnimationClass