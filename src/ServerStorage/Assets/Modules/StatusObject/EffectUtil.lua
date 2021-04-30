local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedAssets = ReplicatedStorage:WaitForChild("Assets")
local StatusTemplates = ReplicatedAssets:WaitForChild("Statuses")
local EffectTemplates = StatusTemplates:WaitForChild("Effects")
local CollectionService = game:GetService("CollectionService")

local EffectUtil = {}
EffectUtil.NewEffect = function(EffectName: String, EffectFolder: Folder, Data: Dictionary)
    local BaseEffect = EffectTemplates:FindFirstChild(EffectName)
    if BaseEffect then
        local Effect = BaseEffect:Clone()
        local Attributes = Effect:GetAttributes()
        for Name, DefaultValue in pairs(Attributes) do
            local InputValue = Data[Name] or DefaultValue
            Effect:SetAttribute(Name,InputValue)
        end
        Effect.Parent = EffectFolder
        return Effect
    else
        warn(EffectName,"not found!")
    end
end
EffectUtil.UpdateEffect = function(EffectObject: ValueObject, Data: Dictionary)
    local EffectName = EffectObject.Name
    local Attributes = EffectTemplates[EffectName]:GetAttributes()
    for Name, DefaultValue in pairs(Attributes) do
        local InputValue = Data[Name] or DefaultValue
        EffectObject:SetAttribute(Name,InputValue)
    end
end
EffectUtil.FolderToData = function(EffectObject)
    return EffectObject:GetAttributes()
end
return EffectUtil