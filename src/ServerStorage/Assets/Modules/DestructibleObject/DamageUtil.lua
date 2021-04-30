local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local GameInfo do
	local Mod = Modules:WaitForChild("GameInfo")
	GameInfo = require(Mod)
end
local Round = GameInfo.Round

local ServerScriptService = game:GetService("ServerScriptService")
local Worker = ServerScriptService.Core.Worker

local DamageUtil = {} do
    local function AddScore(WinnerName: String, DamageScore: Number, Tag: String)
        Worker.PreGain:Fire(WinnerName, DamageScore, DamageScore/4, DamageScore/3, 0, Tag)
    end
    DamageUtil.AddScore = AddScore
    local function SendDamageText(ReceivingPlayer, SpawningPart: Part, DamageValue: Number, TextType: String)
        if typeof(ReceivingPlayer) == "string" then local PlayerName = ReceivingPlayer ReceivingPlayer = Players:FindFirstChild(PlayerName) end
        if typeof(ReceivingPlayer) == "Instance" and ReceivingPlayer:IsA("Player") then Events.FX:FireClient(ReceivingPlayer, "DamageText", nil, nil, {SpawningPart, DamageValue, TextType}) end
    end
    DamageUtil.SendDamageText = SendDamageText
    local CalculateDamage = {} do
        CalculateDamage.Shield = function(ShieldAmount: Number, Damage: Number, ShieldMultiplier: Number, BypassShieldGate: Boolean)
            local DamageDone = Damage * ShieldMultiplier
            local ActualDmg = DamageDone
            if ShieldAmount - DamageDone < 0 then ActualDmg = math.max(ShieldAmount,0) end
            ActualDmg = Round(ActualDmg,0.1)
            local OverflowDamage = 0
            if BypassShieldGate then OverflowDamage = (DamageDone - ActualDmg)/ShieldMultiplier end
            --print("ShieldCalculations ShieldAmount:",ShieldAmount,"Actual:",ActualDmg,"Overflow",OverflowDamage)
            return ActualDmg, OverflowDamage
        end
        CalculateDamage.Health = function(HealthAmount:Number, Damage: Number)
            local DamageDone = Damage
            local ActualDmg = DamageDone
            if HealthAmount - DamageDone < 0 then
                ActualDmg = math.max(HealthAmount,0)
            end
            ActualDmg = Round(ActualDmg,0.1)
            local OverflowDamage = DamageDone - ActualDmg
            --print("HealthCalculations HealthAmount:",HealthAmount,"Actual:",ActualDmg,"Overflow",OverflowDamage)
            return ActualDmg, OverflowDamage
        end
    end
    DamageUtil.CalculateDamage = CalculateDamage
end
--[[Template Functions
    local function RewardDamage(Damager: Player, DamageDone: Number, ROFVal: StringValue, Receiver: Player, ReceiverObject: Model, IsRestricted: Boolean)
        local DmgScore = DamageDone
        local AddScoreChecked = AddScore
        if IsRestricted then AddScoreChecked = function() end end
        local DamagerName = Damager.Name
        local ROF = ROFVal.Value
        local ROFSource = ROFVal.Source.Value
        local ROFSourcePlayer = Players:FindFirstChild(ROFSource)
        local PrimaryPart = ReceiverObject.PrimaryPart
        if true then
            if not IsRestricted then
                AddScoreChecked(DamagerName, DmgScore, "Damage Caused to ships")
                if ROFSource and ROFSource ~= "" and ROF ~= 1 then
                    if ROF > 1 and ROFSource ~= DamagerName and ROFSourcePlayer.Team ~= Receiver.Team then
                        local Boosted = (DamageDone*(ROF-1))/2
                        AddScoreChecked(ROFSource, Boosted, "Allied Damage Boosted")--Damage | XP | 
                        SendDamageText(Players[ROFSource], PrimaryPart, (DamageDone*ROF-DamageDone)/2, "Booster")
                    elseif ROF < 1 and ROFSourcePlayer.Team == Receiver.Team then
                        local Reduced = (DamageDone*(1-ROF))/2
                        AddScoreChecked(ROFSource, Reduced, "Hostile Damage Reduced")--Damage | XP | 
                        SendDamageText(Players[ROFSource], PrimaryPart, (DamageDone*ROF-DamageDone)/2, "Booster")
                    end
                end
            end
            --Ship.ServerFlyer.LastHit.Value = DamagerName
            SendDamageText(Damager, PrimaryPart, DamageDone)
        else--Move code to barrier
            AddScoreChecked(Receiver.Name, DmgScore, "Damage Blocked With Abilties")--Damage | XP | 
            if ROFSource and ROFSource ~= "" and ROF ~= 1 then
                if ROF > 1 and ROFSource ~= DamagerName and ROFSourcePlayer.Team ~= Receiver.Team then
                    local Boosted = (DamageDone*(ROF-1))/2
                    AddScoreChecked(Receiver.Name, Boosted, "Boosted Damage Blocked With Abilties")--Damage | XP | 
                    SendDamageText(Receiver, PrimaryPart, (DamageDone*ROF-DamageDone)/2, "Booster")
                    SendDamageText(Receiver, PrimaryPart, DamageDone, "BoostedFriendlyBlocked")
                    SendDamageText(Players[ROFSource], PrimaryPart, (DamageDone*ROF-DamageDone)/2, "HostileBlocked")
                elseif ROF < 1 and ROFSourcePlayer.Team == Receiver.Team then
                    local Reduced = (DamageDone*(1-ROF))/2
                    AddScoreChecked(ROFSource, Reduced, "Hostile Damage Reduced")--Damage | XP | 
                    SendDamageText(Players[ROFSource], PrimaryPart, (DamageDone*ROF-DamageDone)/2, "Booster")
                end
            end
            SendDamageText(Damager, PrimaryPart, DamageDone, "HostileBlocked")
            SendDamageText(Receiver, PrimaryPart, DamageDone, "FriendlyBlocked")
        end
    end
    local function ApplyDamage(StatsFolder: Folder, DamageToBeDone: Number, ShieldMultiplier: Number, BypassShieldGate: Boolean)
        local ActualDmg = 0
        local ShieldObj = StatsFolder:FindFirstChild("Shield")
        if ShieldObj and ShieldObj.Value > 0 then
            local ShieldDamage = 0
            ShieldDamage,DamageToBeDone = CalculateDamage.Shields(ShieldObj.Value, DamageToBeDone, ShieldMultiplier, BypassShieldGate)
            ActualDmg += ShieldDamage

            ShieldObj.Value -= Round(ShieldDamage, 0.1)
            local ToleranceObj = ShieldObj:FindFirstChild("Tolerance")
            if ToleranceObj and ToleranceObj.Value.X ~= 0 then
                ToleranceObj.Current.Value -= math.min(ToleranceObj.Current.Value, Round(ActualDmg, 0.1))
                ToleranceObj.DelayTime.Timeout.Value = ToleranceObj:GetAttribute("DelayTime")
            end
        end
        local HealthObj = StatsFolder:FindFirstChild("Health")
        if HealthObj and HealthObj.Value > 0 then
            local HealthDamage = 0
            HealthDamage,DamageToBeDone = CalculateDamage.Health(HealthObj.Value, DamageToBeDone)
            ActualDmg += HealthDamage
        
            HealthObj.Value -= Round(HealthDamage,0.1)
        end
        return ActualDmg, DamageToBeDone
    end
    local function Damage(RPlayer, RPlayerShip, Object, Data)
        local ReceivingModel = Object
        
        local DamageDone = Data.Damage
		local ShieldMultiplier = Data.ShieldMultiplier
        local BypassShieldGate = Data.BypassShieldGate

		local DamagerName = Data.OwnerName
		local Damager = Players:FindFirstChild(DamagerName)
        local IsRestricted = InRestrictedShip(RPlayerShip)
		local ROFVal = Data.ROFObj
        if Damager and RPlayer then
			if Damager.Team ~= RPlayer.Team then
				local ShipStats = ReceivingModel:FindFirstChild("Stats")
				if ShipStats then
					local DamageDelt, DamageOverflow = ApplyDamage(ReceivingModel:FindFirstChild("Stats"),DamageDone,ShieldMultiplier,BypassShieldGate)
					RewardDamage(Damager,DamageDelt,ROFVal,RPlayer,ReceivingModel,IsRestricted)
				end
			end
		end
    end
]]
return DamageUtil