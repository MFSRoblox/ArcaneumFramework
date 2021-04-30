local function NewAbilityFolder(AbilityFolder,AbilityModule,Number)
    local NewFolder = game.ServerStorage.DevAssets.Templates.AbilityName:Clone()
    NewFolder.Parent = AbilityFolder
    NewFolder.Name = Number
    AbilityModule.Parent = NewFolder
    AbilityModule.Name = "Original"
    local AbilityInfo = require(AbilityModule)
    NewFolder:SetAttribute("RealName", AbilityInfo.RealName)
    NewFolder:SetAttribute("Range", AbilityInfo.Range)
    NewFolder:SetAttribute("ChargeTime", AbilityInfo.ChargeTime)
    NewFolder:SetAttribute("Duration", AbilityInfo.Duration)
    NewFolder:SetAttribute("Recharge",AbilityInfo.Recharge)
    NewFolder.Effects.SpeedChange:SetAttribute("Multiplier",AbilityInfo.Multiplier)
    return NewFolder
end
local AbilityToFolder = {
    Cloaking = function(Ship:Model,AbilityModule:ModuleScript,Number:Number)
        local Folder = NewAbilityFolder(Ship.Stats.Abilities,AbilityModule,Number)
        local Targets = Folder.Targets
        Targets:SetAttribute("Hostiles",false)
        Targets:SetAttribute("Allies",false)
        Targets:SetAttribute("Self",true)
        local Effects = Folder.Effects
        Effects.Cloak:SetAttribute("Transparency",1)
        Effects.Cloak.Targets:Destroy()
        Effects.DeployShield:Destroy()
        Effects.GeneralEffect:Destroy()
        Effects.MissileDisruptor:Destroy()
        Effects.ROFBooster:Destroy()
        Effects.SpeedChange:Destroy()
        return Folder
    end;
    DeployShield = function(Ship:Model,AbilityModule:ModuleScript,Number:Number)
        local Folder = NewAbilityFolder(Ship.Stats.Abilities,AbilityModule,Number)
        local AbilityInfo = require(AbilityModule)
        local Targets = Folder.Targets
        Targets:SetAttribute("Hostiles",false)
        Targets:SetAttribute("Allies",true)
        Targets:SetAttribute("Self",true)
        local Effects = Folder.Effects
        Effects.Cloak:Destroy()
        local DeployShield = Effects.DeployShield
        DeployShield.Targets:Destroy()
        local Deployment = DeployShield.Deployment
        Deployment:SetAttribute("DeployedPerShot",AbilityInfo.DeployedPerShot)
        Deployment:SetAttribute("InheritVelocity",AbilityInfo.InheritVelocity)
        Deployment:SetAttribute("RateOfFire",AbilityInfo.RateOfFire)
        Deployment:SetAttribute("Effect", AbilityInfo.Effect)
        Effects.GeneralEffect:Destroy()
        Effects.HideID:Destroy()
        Effects.MissileDisruptor:Destroy()
        Effects.ROFBooster:Destroy()
        Effects.SpeedChange:Destroy()
        return Folder
    end;
    GravityWell = function(Ship:Model,AbilityModule:ModuleScript,Number:Number)
        local Folder = NewAbilityFolder(Ship.Stats.Abilities,AbilityModule,Number)
        local AbilityInfo = require(AbilityModule)
        local Targets = Folder.Targets
        Targets:SetAttribute("Hostiles",true)
        Targets:SetAttribute("Allies",false)
        Targets:SetAttribute("Self",false)
        local Effects = Folder.Effects
        Effects.Cloak:Destroy()
        Effects.DeployShield:Destroy()
        Effects.GeneralEffect:Destroy()
        Effects.HideID:Destroy()
        Effects.ROFBooster:Destroy()
        Effects.MissileDisruptor.Targets:Destroy()
        Effects.SpeedChange:Destroy()
        return Folder
    end;
    ROF = function(Ship:Model,AbilityModule:ModuleScript,Number:Number)
        local Folder = NewAbilityFolder(Ship.Stats.Abilities,AbilityModule,Number)
        local AbilityInfo = require(AbilityModule)
        local Targets = Folder.Targets
        Targets:SetAttribute("Hostiles",false)
        Targets:SetAttribute("Allies",true)
        Targets:SetAttribute("Self",true)
        local Effects = Folder.Effects
        Effects.Cloak:Destroy()
        Effects.DeployShield:Destroy()
        Effects.GeneralEffect:Destroy()
        Effects.HideID:Destroy()
        Effects.MissileDisruptor:Destroy()
        Effects.ROFBooster:SetAttribute("Multiplier",AbilityInfo.AlliedROFMod)
        Effects.ROFBooster.Targets:Destroy()
        Effects.SpeedChange:Destroy()
        return Folder
    end;
    PassiveBuff = function(Ship:Model,AbilityFolder:ModuleScript,Number:Number)
        local Folder = game.ServerStorage.DevAssets.Templates.AbilityName:Clone()
        Folder.Parent = Ship.Stats.Abilities
        Folder.Name = "PassiveBuff"
        AbilityFolder.Parent = Folder
        AbilityFolder.Name = "Original"
        local Targets = Folder.Targets
        Targets:SetAttribute("Hostiles",false)
        Targets:SetAttribute("Allies",true)
        Targets:SetAttribute("Self",true)
        local BuffedFactions = AbilityFolder.Factions:GetChildren()
        for i=1, #BuffedFactions do
            local Faction = BuffedFactions[i]
            local NewObj = Instance.new("BoolValue",Targets.Factions)
            NewObj.Name = Faction.Name
        end
        Folder:SetAttribute("RealName", "Passive ROF Booster")
        Folder:SetAttribute("Range", AbilityFolder.Range.Value)
        Folder:SetAttribute("ChargeTime", 0)
        Folder:SetAttribute("Duration", 0)
        Folder:SetAttribute("Recharge", 0)
        Folder:SetAttribute("Passive", true)
        local Effects = Folder.Effects
        Effects.Cloak:Destroy()
        Effects.DeployShield:Destroy()
        Effects.GeneralEffect:Destroy()
        Effects.HideID:Destroy()
        Effects.MissileDisruptor:Destroy()
        Effects.ROFBooster:SetAttribute("Multiplier",AbilityFolder.Strength.Value/100+1)
        Effects.ROFBooster.Targets:Destroy()
        Effects.SpeedChange:Destroy()
        return Folder
    end;
    MobilityBoost = function(Ship:Model,AbilityModule:ModuleScript,Number:Number)
        local Folder = NewAbilityFolder(Ship.Stats.Abilities,AbilityModule,Number)
        local AbilityInfo = require(AbilityModule)
        local Targets = Folder.Targets
        Targets:SetAttribute("Hostiles",false)
        Targets:SetAttribute("Allies",true)
        Targets:SetAttribute("Self",true)
        local Effects = Folder.Effects
        Effects.Cloak:Destroy()
        Effects.DeployShield:Destroy()
        Effects.GeneralEffect:Destroy()
        Effects.HideID:Destroy()
        Effects.MissileDisruptor:Destroy()
        Effects.ROFBooster:Destroy()
        Effects.SpeedChange:SetAttribute("Multiplier",AbilityInfo.SelfSpeedMod)
        Effects.SpeedChange.Targets:Destroy()
        return Folder
    end;
}
local function GetAbilities(Ship:Model)
    local AbilityList = {}
    local StatsChildren = Ship.Stats:GetChildren()
    for i=1, #StatsChildren do
        local StatChild = StatsChildren[i]
        if AbilityToFolder[StatChild.Name] then
            table.insert(AbilityList, StatChild)
        end
    end
    return AbilityList
end

for _,obj in pairs(game.ReplicatedStorage.UnstableTest.Ships:GetDescendants()) do
    if obj:FindFirstChild("Stats") then
        local Ship = obj
        local AbilityFolder = Ship.Stats:FindFirstChild("Abilities")
        if not AbilityFolder then
            AbilityFolder = Instance.new("Folder",Ship.Stats)
            AbilityFolder.Name = "Abilities"
        end
        local Abilities = GetAbilities(Ship)
        if #Abilities > 0 then
            for i=1, #Abilities do
                local Ability = Abilities[i]
                AbilityToFolder[Ability.Name](Ship,Ability,i)
            end
            print(Ship.Name, "has", table.unpack(Abilities))
        end
    end
end
game.ChangeHistoryService:SetWaypoint("Converted Ship Abilities in UnstableTest")

return nil