local StudioService = game:GetService("StudioService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
-- Create a new toolbar section titled "Custom Script Tools"
local Toolbar = plugin:CreateToolbar("Stardust Utilities")

-- Add a toolbar button named "Create Empty Script"
local VerifyShipButton = Toolbar:CreateButton("Verify Ship Configuration", "Checks Main.Ships and Test.Ships configuration and changes any discrepencies there might be.", "rbxassetid://6476375932") do
	VerifyShipButton.ClickableWhenViewportHidden = true

	local function AppendOutput(Output:table,Input)
		warn(Output,Input)
		table.insert(Output,Input)
	end

	local function ValuesToAttribute(ValueDictionary,DictionaryParent, DebugOutput)
		local NewOutput = DebugOutput
		for StatName, ValueList in pairs(ValueDictionary) do
			local AttributeTarget = DictionaryParent:FindFirstChild(StatName)
			if not AttributeTarget then
				AttributeTarget = ValueList.Backup(DictionaryParent)
				if AttributeTarget then
					table.insert(NewOutput,"Added "..StatName.." to " .. DictionaryParent.Name)
					AttributeTarget.Parent = DictionaryParent
				end
			end
			if AttributeTarget then
				for _, ValueStuffs in pairs(ValueList.Attributes) do
					local ValueName = ValueStuffs[1]
					if AttributeTarget:GetAttribute(ValueName) == nil then
						table.insert(NewOutput,"Converted "..ValueName.." to Attribute")
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
		return NewOutput
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
						{"FaceFrontOnTechTree", false}
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
		if #Output > 1 then
			local OutputMessage = ""
			for i=1, #Output do
				OutputMessage = string.format("%s%s\n",OutputMessage,tostring(Output[i]))
			end
			print(OutputMessage,"\n")
		end
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
end

do --TechTree Functionality
	local Row = {} do
		Row.__index = Row
		Row.__tostring = function(self)
			local assembly = self:ReturnTable()
			local output = ""
			for i=1, #assembly do
				output = string.format("%s,%s", output, assembly[i])
			end
			return output
		end;
		function Row.new(YPos: int, MinX, MaxX)
			local NewRow = {
				Y = YPos;
				MinX = MinX;
				Ships = table.create(MaxX-MinX+1,"")
			}
			return setmetatable(NewRow,Row)
		end
		function Row.newFromTable(InputTable: StringTable, MinX: int)
			local NewRow = {
				Y = InputTable[1];
				MinX = MinX;
				Ships = {}
			}
			for i=2, #InputTable do
				table.insert(NewRow.Ships,string.gsub(InputTable[i], "\n",""))
			end
			return setmetatable(NewRow,Row)
		end
		function Row:InsertShip(ShipName,XPos)
			local Position = XPos-self.MinX+1
			local initString = self.Ships[Position]
			local formatString = "%s%s"
			if initString ~= "" then
				formatString = "%s & %s"
			end
			self.Ships[Position] = string.format(formatString, initString, ShipName)
		end
		function Row:ReturnTable()
			local assembly = {self.Y}
			for i=1, #self.Ships do
				table.insert(assembly,self.Ships[i])
			end
			return assembly
		end
	end
	local TechTree = {} do
		TechTree.__index = TechTree
		TechTree.__tostring = function(self)
			local assembly = self:ReturnTable()
			local output = ""
			for i=1, #assembly do
				local ThisRow = assembly[i]
				for j=1, #ThisRow do
					local formatString = "%s,%s"
					if j==1 then
						formatString = "%s%s"
					end
					output = string.format(formatString, output, ThisRow[j])
				end
				output = string.format("%s\n", output)
			end
			return output
		end;
		function TechTree:ReturnTable()
			local assembly = {{""}}
			local MinX = self.X[1]
			local MaxX = self.X[2]
			for i=MinX, MaxX do
				table.insert(assembly[1],i)
			end
			local MinY = self.Y[1]
			local MaxY = self.Y[2]
			for i=MinY, MaxY do
				local ThisRow = Row.new(i,MinX,MaxX)
				local ShipsInThisRow = self.Ships[i]
				if ShipsInThisRow == nil then
					ShipsInThisRow = {}
				end
				for j=1, #ShipsInThisRow do
					local Ship = ShipsInThisRow[j]
					ThisRow:InsertShip(
						Ship["Name"], 
						Ship["XPos"]
					)
				end
				table.insert(assembly,ThisRow:ReturnTable())
			end
			return assembly
		end
		function TechTree.new()
			local NewTechTree = {
				X = {0,0};
				Y = {0,0};
				Ships = {};
			}
			return setmetatable(NewTechTree,TechTree)
		end
		function TechTree.newFromTable(InputTable:StringTable)
			local FirstRow = InputTable[1]
			local NewTechTree = {
				X = {tonumber(FirstRow[2]),tonumber(FirstRow[#FirstRow])};
				Y = {tonumber(InputTable[2][1]),tonumber(InputTable[#InputTable-1][1])};
				Ships = {};
			}
			setmetatable(NewTechTree,TechTree)
			for i=2, #InputTable do
				local AssembledRow = InputTable[i]
				for j=2, #AssembledRow do
					local ShipName = AssembledRow[j]
					if ShipName ~= "" and ShipName ~= "\n" then
						NewTechTree:AddShip(ShipName, Vector3.new(FirstRow[j], 0, AssembledRow[1]))
					end
				end
			end
			return NewTechTree
		end
		function TechTree:CheckMinMax(ValueName,Value)
			if Value < self[ValueName][1] then
				self[ValueName][1] = Value
			elseif Value > self[ValueName][2] then
				self[ValueName][2] = Value
			end
		end
		function TechTree:AddShip(ShipName, TreePositionValue)
			local X = TreePositionValue.X
			local Y = TreePositionValue.Z
			self:CheckMinMax("X",X)
			self:CheckMinMax("Y",Y)
			if not self.Ships[Y] then
				self.Ships[Y] = {}
			end
			table.insert(self.Ships[Y],{Name = ShipName; XPos = X})
		end
		function TechTree:ApplyPositions(Franchise: Folder)
			local ShipObjects = {}
			local Classes = Franchise:GetChildren()
			for i=1, #Classes do
				local Class = Classes[i]
				local Ships = Class:GetChildren()
				for j=1, #Ships do
					local Ship = Ships[j]
					if Ship:IsA("Model") and Ship:FindFirstChild("Stats") then
						table.insert(ShipObjects,Ship)
					end
				end
			end
			local SummaryMessage,WarnMessage = "",""
			local AllShips = self.Ships
			for YPos, ShipData in pairs(AllShips) do
				for i=1, #ShipData do
					local ShipInfo = ShipData[i]
					local ShipName = ShipInfo.Name
					local XPos = ShipInfo.XPos
					local Success = false
					for j=1, #ShipObjects do
						local Ship = ShipObjects[j]
						if Ship.Name == ShipName then
							local NewPos = Vector3.new(XPos,0,YPos)
							local OldPos = Ship.Stats:GetAttribute("TechTreePosition")
							if NewPos ~= OldPos then
								SummaryMessage = string.format("%s%s\n",SummaryMessage,ShipName.." position changed from "..tostring(OldPos).." to "..tostring(NewPos))
								Ship.Stats:SetAttribute("TechTreePosition", Vector3.new(XPos,0,YPos))
							end
							table.remove(ShipObjects,j)
							Success = true
							break
						end
					end
					if not Success then
						WarnMessage = string.format("%s%s\n",WarnMessage,ShipName.." wasn't found in "..Franchise.Name)
					end
				end
			end
			if SummaryMessage == "" then
				print("No changes done to",Franchise.Name)
			else
				print("Changes done to " .. Franchise.Name .. ":\n" .. SummaryMessage)
			end
			for i=1, #ShipObjects do
				WarnMessage = string.format("%s%s\n",WarnMessage,ShipObjects[i].Name.." wasn't found in CSV.")
			end
			warn(WarnMessage)
			return true
		end
	end

	local TechTreeToCSVButton = Toolbar:CreateButton("TechTree To CSV", "Outputs text to the Output window that contains the positions of ships in CSV format. You can select a folder to filter the search, which is either the direct Ship folder or a franchise. By default, it will print out all franchises under game.ReplicatedStorage.Ships.", "rbxassetid://6476375932") do
		TechTreeToCSVButton.ClickableWhenViewportHidden = true

		local function PrintFranchiseCSV(Franchise:Folder)
			warn("\n"..Franchise.Name,"Tech Tree CSV:")
			local ThisTechTree = TechTree.new()
			local Classes = Franchise:GetChildren()
			for j=1, #Classes do
				local Class = Classes[j]
				local Ships = Class:GetChildren()
				for k=1, #Ships do
					local Ship = Ships[k]
					ThisTechTree:AddShip(Ship.Name,Ship.Stats:GetAttribute("TechTreePosition"))
				end
			end
			print(tostring(ThisTechTree))
		end

		local function PrintShipFolderCSV(ShipFolder)
			local ShipFolderChildren = ShipFolder:GetChildren()
			for i=1, #ShipFolderChildren do
				local Franchise = ShipFolderChildren[i]
				PrintFranchiseCSV(Franchise)
			end
		end

		local function onTechTreeToCSVButtonClicked()
			local SelectedObjects = Selection:Get()
			if #SelectedObjects <= 0 then
				SelectedObjects = {game.ReplicatedStorage.Main.Ships}
				Selection:Set(SelectedObjects)
			end
			for i=1, #SelectedObjects do
				local SelectedObject = SelectedObjects[i]
				if SelectedObject.Name == "Ships" then
					PrintShipFolderCSV(SelectedObject)
				elseif SelectedObject.Parent.Name == "Ships" and SelectedObject:IsA("Folder") then
					PrintFranchiseCSV(SelectedObject)
				else
					warn(SelectedObject.Name,"isn't compatible!")
				end
			end
			ChangeHistoryService:SetWaypoint("Printed CSV Strings")
			TechTreeToCSVButton:SetActive(false)
		end
		TechTreeToCSVButton.Click:Connect(onTechTreeToCSVButtonClicked)
	end

	local CSVToTechTreeButton = Toolbar:CreateButton("CSV To TechTree", "Reads a CSV formatted in the \"TechTree To CSV\" output and applies the positions to the ships in the respective Franchise.\nYou need to select the appropriate Franchise folder that contains the ships.", "rbxassetid://6476375932") do
		CSVToTechTreeButton.ClickableWhenViewportHidden = true
		local function CSVToTechTree() : TechTrees
			local TechTrees = {}
			local CSVFiles = StudioService:PromptImportFiles({"csv"}) --https://developer.roblox.com/en-us/api-reference/function/StudioService/PromptImportFiles
			for i=1, #CSVFiles do
				local CSVFile = CSVFiles[i] --https://developer.roblox.com/en-us/api-reference/class/File
				local TechTreeName = string.sub(CSVFile.Name, 1, string.len(CSVFile.Name)-4)
				local CSVString = CSVFile:GetBinaryContents()
				local RawRows = string.split(CSVString,"\n")
				local FullTable = {}
				for j=1, #RawRows do
					local RawRow = RawRows[j]
					local AssembledRow = string.split(RawRow,",")
					for k=1, #AssembledRow do
						local String = string.gsub(AssembledRow[k], "%s$","")
						local Count
						String, Count = string.gsub(String, "\"\"","\"")
						if Count > 0 then
							String = string.gsub(String, "^\"","")
							String = string.gsub(String, "\"$","")
						end
						AssembledRow[k] = String
					end
					table.insert(FullTable,AssembledRow)
				end
				local ThisTechTree = TechTree.newFromTable(FullTable)
				TechTrees[TechTreeName] = ThisTechTree
			end
			return TechTrees
		end
		local function onCSVToTechTreeButtonButtonClicked()
			local SelectedObjects = Selection:Get()
			if #SelectedObjects < 1 then
				warn("Nothing is selected!")
				return false
			end
			local TechTreesData = CSVToTechTree()
			for i=1, #SelectedObjects do
				local SelectedObject = SelectedObjects[i]
				local TechTreeData = TechTreesData[SelectedObject.Name]
				if SelectedObject.Parent.Name == "Ships" and SelectedObject:IsA("Folder") and TechTreeData then
					print(SelectedObject.Name,"read successfully:")
					print(TechTreeData)
					TechTreeData:ApplyPositions(SelectedObject)
				else
					if SelectedObject.Parent.Name ~= "Ships" or not SelectedObject:IsA("Folder") then
						warn(SelectedObject.Name,"isn't a Franchise!")
					elseif not TechTreeData then
						warn("The File's name doesn't match the Franchise's name! Franchise:", SelectedObject.Name)
					end
					return false
				end
			end
			ChangeHistoryService:SetWaypoint("Interpretted CSV To TechTree")
			CSVToTechTreeButton:SetActive(false)
		end
		CSVToTechTreeButton.Click:Connect(onCSVToTechTreeButtonButtonClicked)
	end
end
return true