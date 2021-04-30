local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local ReplicatedAssets = ReplicatedStorage:WaitForChild("Assets")
local StatusTemplates = ReplicatedAssets:WaitForChild("Statuses")
local TriggerTemplates = StatusTemplates:WaitForChild("Triggers")
local CollectionService = game:GetService("CollectionService")

local TriggerUtil = {}
TriggerUtil.NewTrigger = function(TriggerName: String, TriggerFolder: Folder, Data: Dictionary)
    local BaseTrigger = TriggerTemplates:FindFirstChild(TriggerName)
    if BaseTrigger then
        local Trigger = BaseTrigger:Clone()
        local Attributes = Trigger:GetAttributes()
        for Name, DefaultValue in pairs(Attributes) do
            local InputValue = Data[Name] or DefaultValue
            Trigger:SetAttribute(Name,InputValue)
        end
        Trigger.Parent = TriggerFolder
        return Trigger
    else
        warn(TriggerName,"not found!")
    end
end
TriggerUtil.UpdateTrigger = function(TriggerObject: Folder, Data: Dictionary)
    local TriggerName = TriggerObject.Name
    local Attributes = TriggerTemplates[TriggerName]:GetAttributes()
    for Name, DefaultValue in pairs(Attributes) do
        local InputValue = Data[Name] or DefaultValue
        TriggerObject:SetAttribute(Name,InputValue)
    end
end
local Connections = {
    AbilityActivated = {};
    SpacecraftLaunch = {};
    WeaponFired = {};
}
local CheckByTarget = {
    any = function()
        return true
    end;
    self = function(Player, CallingPlayer)
        return Player == CallingPlayer
    end;
    allies = function(Player, CallingPlayer)
        return Player.Team == CallingPlayer.Team
    end;
    hostiles = function(Player, CallingPlayer)
        return Player.Team ~= CallingPlayer.Team
    end;
};

local StatusTriggers = {
    AbilityActivated = function(TriggerObject, LinkedObject, DisconnectFunction)
        local StatusObject = TriggerObject.Parent.Parent
        local Ship = TriggerObject:FindFirstAncestorWhichIsA("Model")
        local ServerFlyerScript = Ship:FindFirstChild("ServerFlyer")
        if ServerFlyerScript then
            local PlayerName = Ship.Parent.Name
            local Player = Players:FindFirstChild(PlayerName)
            local Data = TriggerObject:GetAttributes()
            Data.ByTarget = TriggerUtil.DecodeString(Data.ByTarget)
            Data.OnAbility = TriggerUtil.DecodeString(Data.OnAbility)
            local PreviousConnection = Connections.AbilityActivated[TriggerObject]
            if PreviousConnection then
                PreviousConnection:Disconnect()
            end
            Connections.AbilityActivated[StatusObject] = ServerFlyerScript.Special.OnServerEvent:Connect(function(CallingPlayer, Special, CameraCFrame)
                local Disconnect = false
                local IsTarget = false
                for i=1, #Data.ByTarget do
                    local Filter = string.lower(Data.ByTarget[i])
                    IsTarget = CheckByTarget[Filter](Player, CallingPlayer)
                    if IsTarget then
                        break
                    end
                end
                if IsTarget then
                    for i=1, #Data.OnAbility do
                        local Filter = string.lower(Data.OnAbility[i])
                        local FormattedSpecial = string.lower(Special)
                        Disconnect = Filter == FormattedSpecial or Filter == "any"
                        if Disconnect then
                            break
                        end
                    end
                end
                if Disconnect then
                    StatusObject.Value += Data.StackChange
                end
            end)
        end
    end;
    SpacecraftLaunch = function(TriggerObject)
        local StatusObject = TriggerObject.Parent.Parent
        local Ship = TriggerObject:FindFirstAncestorWhichIsA("Model")
        local ServerFlyerScript = Ship:FindFirstChild("ServerFlyer")
        if ServerFlyerScript then
            local PlayerName = Ship.Parent.Name
            local Player = Players:FindFirstChild(PlayerName)
            local Data = TriggerObject:GetAttributes()
            Data.ByTarget = TriggerUtil.DecodeString(Data.ByTarget)
            Data.OnMode = TriggerUtil.DecodeString(Data.OnMode)
            local PreviousConnection = Connections.SpacecraftLaunch[TriggerObject]
            if PreviousConnection then
                PreviousConnection:Disconnect()
            end
            Connections.SpacecraftLaunch[StatusObject] = Events.ChangeFighter.OnServerEvent:Connect(function(CallingPlayer, Gun, Mode, Extra)
                local Disconnect = false
                local IsTarget = false
                for i=1, #Data.ByTarget do
                    local Filter = string.lower(Data.ByTarget[i])
                    IsTarget = CheckByTarget[Filter](Player, CallingPlayer)
                    if IsTarget then
                        break
                    end
                end
                if IsTarget then
                    for i=1, #Data.OnMode do
                        local Filter = string.lower(Data.OnMode[i])
                        local FormattedMode = string.lower(Mode)
                        Disconnect = Filter == FormattedMode or Filter == "any"
                        if Disconnect then
                            break
                        end
                    end
                end
                if Disconnect then
                    StatusObject.Value += Data.StackChange
                end
            end)
        end
    end;
    WeaponFired = function(TriggerObject)
        local StatusObject = TriggerObject.Parent.Parent
        local Ship = TriggerObject:FindFirstAncestorWhichIsA("Model")
        local ServerFlyerScript = Ship:FindFirstChild("ServerFlyer")
        if ServerFlyerScript then
            local PlayerName = Ship.Parent.Name
            local Player = Players:FindFirstChild(PlayerName)
            local Data = TriggerObject:GetAttributes()
            Data.ByTarget = TriggerUtil.DecodeString(Data.ByTarget)
            Data.WeaponType = TriggerUtil.DecodeString(Data.WeaponType)
            local PreviousConnection = Connections.WeaponFired[TriggerObject]
            if PreviousConnection then
                PreviousConnection:Disconnect()
            end
            Connections.WeaponFired[StatusObject] = Events.ChangeFire.OnServerEvent:Connect(function(CallingPlayer, Mode, Gun)
                if Mode == "Fire" then
                    local Disconnect = false
                    local IsTarget = false
                    for i=1, #Data.ByTarget do
                        local Filter = Data.ByTarget[i]
                        --print(Filter)
                        IsTarget = CheckByTarget[Filter](Player, CallingPlayer)
                        if IsTarget then
                            break
                        end
                    end
                    if IsTarget then
                        for i=1, #Data.WeaponType do
                            local Filter = Data.WeaponType[i]
                            local FormattedMode = Gun[1].WeaponStat.Type.Value
                            Disconnect = Filter == FormattedMode or Filter == "any"
                            if Disconnect then
                                break
                            end
                        end
                    end
                    if Disconnect then
                        StatusObject.Value += Data.StackChange
                    end
                end
            end)
        end
    end;
}
TriggerUtil.ConnectTrigger = function(TriggerObject: Folder)
    print(TriggerObject.Name)
    StatusTriggers[TriggerObject.Name](TriggerObject)
end

local function DisconnectStatus(StatusObject)
    for _, ConnectionList in pairs(Connections) do
        local Connection = ConnectionList[StatusObject]
        if Connection then Connection:Disconnect() end
    end
end
CollectionService:GetInstanceRemovedSignal("Status"):Connect(DisconnectStatus)

TriggerUtil.DecodeString = function(String: String)
    local output = string.split(string.lower(String),",")
    if table.find(output,"any") then
        return {"any"}
    else
        return output
    end
end

TriggerUtil.FolderToData = function(TriggerObject)
    return TriggerObject:GetAttributes()
end
return TriggerUtil