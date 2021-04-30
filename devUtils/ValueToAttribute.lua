local function ValuesToAttribute(ValueDictionary,DictionaryParent)
    for StatName, ValueList in pairs(ValueDictionary) do
        local AttributeTarget = DictionaryParent:FindFirstChild(StatName)
        if not AttributeTarget then
            AttributeTarget = ValueList.Backup(DictionaryParent)
        end
        if AttributeTarget then
            for _, ValueStuffs in pairs(ValueList.Attributes) do
                local ValueName = ValueStuffs[1]
                if not AttributeTarget:GetAttribute(ValueName) then
                    local Value do
                        local Object = AttributeTarget:FindFirstChild(ValueName)
                        if Object then
                            Value = Object.Value
                            Object:Destroy()
                        else
                            Value = ValueStuffs[2]
                        end
                    end
                    AttributeTarget:SetAttribute(ValueName,Value)
                end
            end
        end
    end
end
local function UpdateShip(Ship)
    ValuesToAttribute(
        {
            Stats = {
                Backup = function(Parent) end;
                Attributes = {
                    {"Class", Ship.Parent.Name},
                    {"TechTreePosition", Vector3.new()},
                    {"Faction", ""},
                    {"RespawnTime", 0},
                    {"Tier", 1},
                    {"Creator", ""},
                }
            };
        },
        Ship
    )
    ValuesToAttribute(
        {
            Description = {
                Backup = function(Parent) end;
                Attributes = {
                    {"Author", ""};
                }
            };
            Health = {
                Backup = function(Parent) end;
                Attributes = {
                    {"MaxHealth", -1};
                }
            };
            Shield = {
                Backup = function(Parent)
                    print("Shield Backup")
                    local HealthObj = Parent:FindFirstChild("Health")
                    if HealthObj then
                        local Val = Instance.new("IntValue", Parent)
                        Val.Name = "Shield"
                        Val.Value = HealthObj.Value / 3
                        return Val
                    end
                end;
                Attributes = {
                    {"MaxShield", -1};
                    {"DelayTime", 20};
                    {"RechargeTime", 20};
                    {"ShieldGate", true};
                    {"PassiveRegen", 0};
                }
            };
        },
        Ship.Stats
    )
    ValuesToAttribute(
        {
            Tolerance = {
                Backup = function(Parent)
                    local Val = Instance.new("Vector3Value",Parent)
                    Val.Value = Vector3.new(0,1,0)
                    return Val
                end;
                Attributes = {
                    {"DelayTime", 20},
                }
            };
        },
        Ship.Stats.Shield
    )
end

for _,obj in pairs(game.ReplicatedStorage.Ships:GetDescendants()) do
    if obj:FindFirstChild("Stats") then
        UpdateShip(obj)
    end
end
return nil