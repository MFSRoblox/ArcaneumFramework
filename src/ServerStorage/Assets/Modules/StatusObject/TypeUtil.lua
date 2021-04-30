local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedAssets = ReplicatedStorage:WaitForChild("Assets")
local StatusTemplates = ReplicatedAssets:WaitForChild("Statuses")
local TypeTemplates = StatusTemplates:WaitForChild("Types")
local CollectionService = game:GetService("CollectionService")

local TypeUtil = {}
local NewType = {
    Timed = function(TypeFolder,Data)
        local Status = TypeTemplates.Timed:Clone()
        local TickNow = Data.TickNow or tick()
        Status.Value = TickNow
        local MaxTime = -1
        local Duration = Data.Duration
        if Duration then
            MaxTime = Duration + TickNow
        end
        Status:SetAttribute("MaxTime", MaxTime)
        Status.Parent = TypeFolder
        CollectionService:AddTag(Status,"TimedStatus")
        return Status
    end;
    Linked = function(TypeFolder,Data)
        local Status = TypeTemplates.Linked:Clone()
        Status.Value = Data.LinkedObject
        Status:SetAttribute("MaxDistance", Data.MaxDistance)
        Status:SetAttribute("MinDistance", Data.MinDistance)
        Status.Parent = TypeFolder
        CollectionService:AddTag(Status,"LinkedStatus")
        return Status
    end;
    Passive = function(TypeFolder,Data)
        local Status = TypeTemplates.Passive:Clone()
        Status.Value = Data.Activated --Should be true...
        Status.Parent = TypeFolder
        CollectionService:AddTag(Status,"PassiveStatus")
        return Status
    end;
    Position = function(TypeFolder,Data)
        local Status = TypeTemplates.Position:Clone()
        Status.Value = Data.Position
        Status:SetAttribute("MaxDistance", Data.MaxDistance)
        Status:SetAttribute("MinDistance", Data.MinDistance)
        Status.Parent = TypeFolder
        CollectionService:AddTag(Status,"PositionStatus")
        return Status
    end;
    Template = function(TypeFolder,Data)
        local Status = TypeTemplates.Linked:Clone()
        Status.Value = Data.Value
        Status.Parent = TypeFolder
        CollectionService:AddTag(Status,"LinkedStatus")
        return Status
    end;
}
TypeUtil.NewType = function(Type: String, TypeFolder: Folder, Data: Dictionary)
    return NewType[Type](TypeFolder,Data)
end
local UpdateType = {
    Timed = function(TypeObject: ValueObject,Data: Dictionary)
        local TickNow = Data.TickNow or tick()
        TypeObject.Value = TickNow
        local MaxTime = -1
        local Duration = Data.Duration
        if Duration then
            MaxTime = Duration + TickNow
        end
        TypeObject:SetAttribute("MaxTime", MaxTime)
    end;
    Linked = function(TypeObject: ValueObject,Data: Dictionary)
        TypeObject.Value = Data.LinkedObject or TypeObject.Value
        TypeObject:SetAttribute("MaxDistance", Data.MaxDistance)
        TypeObject:SetAttribute("MinDistance", Data.MinDistance)
    end;
    Passive = function(TypeObject: ValueObject,Data: Dictionary)
        TypeObject.Value = Data.Activated
    end;
    Position = function(TypeObject: ValueObject,Data: Dictionary)
        TypeObject.Value = Data.Position or TypeObject.Value
        TypeObject:SetAttribute("MaxDistance", Data.MaxDistance)
        TypeObject:SetAttribute("MinDistance", Data.MinDistance)
    end;
    Template = function(TypeObject: ValueObject,Data: Dictionary)

    end;
}
TypeUtil.UpdateType = function(TypeObject: ValueObject, Data: Dictionary)
    local Type = TypeObject:GetAttribute("Type")
    UpdateType[Type](TypeObject,Data)
end
local FolderToData = {
    Timed = function(TypeObject: ValueObject)
        local output = TypeObject:GetAttributes()
        return output
    end;
    Linked = function(TypeObject: ValueObject)
        local output = TypeObject:GetAttributes()
        output.LinkedObject = TypeObject.Value
        return output
    end;
    Passive = function(TypeObject: ValueObject)
        local output = TypeObject:GetAttributes()
        return output
    end;
    Position = function(TypeObject: ValueObject)
        local output = TypeObject:GetAttributes()
        output.Position = TypeObject.Value
        return output
    end;
    Template = function(TypeObject: ValueObject)
        local output = TypeObject:GetAttributes()

        return output
    end;
}
TypeUtil.FolderToData = function(TypeObject)
    return FolderToData[TypeObject.Name](TypeObject)
end
return TypeUtil