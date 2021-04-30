local ChangeHistoryService = game:GetService("ChangeHistoryService")
-- Create a new toolbar section titled "Custom Script Tools"
local Toolbar = plugin:CreateToolbar("Stardust Utilities")

-- Add a toolbar button named "Create Empty Script"
local VerifyShipButton = Toolbar:CreateButton("Verify Ship Configuration", "Checks Main.Ships and Test.Ships configuration and changes any discrepencies there might be.", "rbxassetid://6476375932")
VerifyShipButton.ClickableWhenViewportHidden = true

local function AppendOutput(Output:table,Input)
	warn(Output,Input)
	table.insert(Output,Input)
end

local function ValuesToAttribute(ValueDictionary,DictionaryParent, DebugOutput)
	for StatName, ValueList in pairs(ValueDictionary) do
		local AttributeTarget = DictionaryParent:FindFirstChild(StatName)
		if not AttributeTarget then
			AttributeTarget = ValueList.Backup(DictionaryParent)
			if AttributeTarget then
				table.insert(DebugOutput,"Added "..StatName.." to " .. DictionaryParent.Name)
				AttributeTarget.Parent = DictionaryParent
			end
		end
		if AttributeTarget then
			for _, ValueStuffs in pairs(ValueList.Attributes) do
				local ValueName = ValueStuffs[1]
				if not AttributeTarget:GetAttribute(ValueName) then
					table.insert(DebugOutput,"Converted "..ValueName.." to Attribute")
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
	return DebugOutput
end
local function UpdateShip(Ship)
	local Output = {Ship}
	Output = ValuesToAttribute(
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
		Ship,
		Output
	)
	Output = ValuesToAttribute(
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
		Ship.Stats,
		Output
	)
	Output = ValuesToAttribute(
		{
			Tolerance = {
				Backup = function(Parent)
					local Val = Instance.new("Vector3Value",Parent)
					Val.Name = "Tolerance"
					Val.Value = Vector3.new(0,1,0)
					return Val
				end;
				Attributes = {
					{"DelayTime", 20},
				}
			};
		},
		Ship.Stats.Shield,
		Output
	)
	print(table.unpack(Output),"\n")
end

local function onVerifyShipButtonClicked()
	warn("Checking Main Ships")
	for _,obj in pairs(game.ReplicatedStorage.Main.Ships:GetDescendants()) do
		if obj:FindFirstChild("Stats") then
			UpdateShip(obj)
		end
	end
	warn("Checking Test Ships")
	for _,obj in pairs(game.ReplicatedStorage.Test.Ships:GetDescendants()) do
		if obj:FindFirstChild("Stats") then
			UpdateShip(obj)
		end
	end
	ChangeHistoryService:SetWaypoint("Converted Ships")
	VerifyShipButton:SetActive(false)
end
VerifyShipButton.Click:Connect(onVerifyShipButtonClicked)