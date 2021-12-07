local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventsFolderName = "Events"
local Events = ReplicatedStorage:FindFirstChild(EventsFolderName)
if not Events then
    Events = Instance.new("Folder")
    Events.Name = EventsFolderName
    Events.Parent = ReplicatedStorage
end
return Events