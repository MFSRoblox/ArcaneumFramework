local ShipFolder = game.ReplicatedStorage.Main.Ships
local Row = {}
do
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
local TechTree = {}
do
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
end

local ShipFolderChildren = ShipFolder:GetChildren()
for i=1, #ShipFolderChildren do
    local Franchise = ShipFolderChildren[i]
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
    warn("\n"..Franchise.Name)
    print(tostring(ThisTechTree))
end

return nil