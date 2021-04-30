local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedAssets = ReplicatedStorage:WaitForChild("Assets")
local StatusTemplates = ReplicatedAssets:WaitForChild("Statuses")
local CollectionService = game:GetService("CollectionService")

local StatusObject = {} do
    local TypeUtil do
        local Mod = script:WaitForChild("TypeUtil")
        --if Mod then
            TypeUtil = require(Mod)
            StatusObject.TypeUtil = TypeUtil
        --end
    end
    local EffectUtil do
        local Mod = script:WaitForChild("EffectUtil")
        --if Mod then
            EffectUtil = require(Mod)
            StatusObject.EffectUtil = EffectUtil
        --end
    end
    local TriggerUtil do
        local Mod = script:WaitForChild("TriggerUtil")
        --if Mod then
            TriggerUtil = require(Mod)
            StatusObject.TriggerUtil = TriggerUtil
        --end
    end
    local function NewStatus(HeaderName: String, Data: Dictionary)
        print("New Status:",HeaderName)
        local newStatus = StatusTemplates.StatusTemplate:Clone()
        newStatus.Name = HeaderName
        for AttributeName, DefaultValue in pairs(newStatus:GetAttributes()) do
            local SetValue = Data[AttributeName] or DefaultValue
            newStatus:SetAttribute(AttributeName, SetValue)
        end
        for AttributeName, DefaultValue in pairs(newStatus.Types:GetAttributes()) do
            local SetValue = Data[AttributeName] or DefaultValue
            newStatus:SetAttribute(AttributeName, SetValue)
        end
        return newStatus
    end
    local function UpdateStatus(StatusObject: IntValue, Data: Dictionary)
        if Data.Stackable then
            local MaxStacks = StatusObject:GetAttribute("MaxStacks")
            local CurrentStacks = StatusObject.Value
            if CurrentStacks < MaxStacks then
                StatusObject.Value += 1
            end
        end
    end
    local Connections = {
        Changed = {}
    }
    StatusObject.NewStatus = function(StatusFolder: Folder, StatusData: Dictionary, TypeData: Dictionary, EffectData: Dictionary, TriggerData: Dictionary)
        StatusData = StatusData or {}
        TypeData = TypeData or {}
        EffectData = EffectData or {}
        TriggerData = TriggerData or {}
        local StatusHeader = StatusData.StatusHeader
        local Status = StatusFolder:FindFirstChild(StatusHeader)
        if not Status then
            Status = NewStatus(StatusHeader, StatusData)
            Status.Parent = StatusFolder
            Connections.Changed[Status] = Status.Changed:Connect(function(Value)
                if Value <= 0 then
                    Connections.Changed[Status]:Disconnect()
                    Status:Destroy()
                end
            end)
            CollectionService:AddTag(Status,"Status")
        else
            UpdateStatus(Status, StatusData)
        end
        local StatusTypes = Status.Types
        for Name, Data in pairs(TypeData) do
            local Type = StatusTypes:FindFirstChild(Name)
            if not Type then
                Type = TypeUtil.NewType(Name, StatusTypes, Data)
            elseif Data.RefreshOnNew then
                TypeUtil.UpdateType(Type, Data)
            end
        end
        local StatusEffects = Status.Effects
        for Name, Data in pairs(EffectData) do
            local Effect = StatusEffects:FindFirstChild(Name)
            if not Effect then
                Effect = EffectUtil.NewEffect(Name, StatusEffects, Data)
            elseif Data.RefreshOnNew then
                EffectUtil.UpdateEffect(Effect, Data)
            end
        end
        local SpyWare = Status.Triggers
        for Name, Data in pairs(TriggerData) do
            local Trigger = SpyWare:FindFirstChild(Name)
            if not Trigger then
                Trigger = TriggerUtil.NewTrigger(Name, SpyWare, Data)
            elseif Data.RefreshOnNew then
                TriggerUtil.UpdateTrigger(Trigger, Data)
            end
            TriggerUtil.ConnectTrigger(Trigger)
        end
        return Status
    end;
    StatusObject.UpdateStatus = function(StatusObject: ValueObject, StatusData: Dictionary, EffectData: Dictionary)
        TypeUtil.UpdateType(StatusObject, StatusData)
        for Name, Data in pairs(EffectData) do
            local Effect = StatusObject:FindFirstChild(Name)
            if not Effect then
                Effect = EffectUtil.NewEffect(Name, StatusObject, Data)
            else
                EffectUtil.UpdateEffect(Effect, Data)
            end
        end
    end;
    StatusObject.FolderToData = function(StatusObject: ValueObject, OwnerName: String)
        local output = {
            Status = {};
            Types = {};
            Effects = {};
            Triggers = {};
        }
        local StatusOutput = StatusObject:GetAttributes()
        StatusOutput.Owner = OwnerName
        StatusOutput.RealName = StatusObject.Name
        StatusOutput.StatusHeader = OwnerName..StatusOutput.RealName
        output.Status = StatusOutput
        local TypeOutput = {} do
            local AllTypes = StatusObject.Types:GetChildren()
            for i=1, #AllTypes do
                local TypeObject = AllTypes[i]
                TypeOutput[TypeObject.Name] = TypeUtil.FolderToData(TypeObject)
            end
        end
        output.Types = TypeOutput
        local EffectOutput = {} do
            local AllEffects = StatusObject.Effects:GetChildren()
            for i=1, #AllEffects do
                local EffectObject = AllEffects[i]
                EffectOutput[EffectObject.Name] = EffectUtil.FolderToData(EffectObject)
            end
        end
        output.Effects = EffectOutput
        local TriggerOutput = {} do
            local AllTriggers = StatusObject.Triggers:GetChildren()
            for i=1, #AllTriggers do
                local TriggerObject = AllTriggers[i]
                TriggerOutput[TriggerObject.Name] = TriggerUtil.FolderToData(TriggerObject)
            end
        end
        output.Triggers = TriggerOutput
        return output
    end
end
return StatusObject