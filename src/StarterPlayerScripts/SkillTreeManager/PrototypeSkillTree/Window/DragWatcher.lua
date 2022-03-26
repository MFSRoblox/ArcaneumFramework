local UserInputService = game:GetService("UserInputService")
local DragWatcher = {} do
    DragWatcher.__index = DragWatcher
end

function DragWatcher.new(InitialInput: InputObject,InputTypeForUpdate: Enum.UserInputType, InputTypeForStop: Enum.UserInputType)
    local NewWatcher = setmetatable({},DragWatcher)
    NewWatcher.StopEvent = UserInputService.InputEnded:Connect(function(input: InputObject, _gameProcessedEvent: boolean)
        if input.UserInputType == InputTypeForStop then
            NewWatcher:Destroy()
        end
    end)
    NewWatcher.LatestDelta = InitialInput.Delta
    NewWatcher.LatestPosition = InitialInput.Position
    NewWatcher.UpdateBinded = {}
    NewWatcher.UpdateEvent = UserInputService.InputChanged:Connect(function(input, _gameProcessedEvent)
        if input.UserInputType == InputTypeForUpdate then
            NewWatcher:Dragged(input)
        end
    end)
    return NewWatcher
end
function DragWatcher:Dragged(input:InputObject)
    self.LastDelta = self.LatestDelta
    self.LastPosition = self.LatestPosition
    self.LatestDelta = input.Delta
    self.LatestPosition = input.Position
    local ActualDelta = self.LatestPosition-self.LastPosition
    local BindedFunctions = self.UpdateBinded
    for i=1, #BindedFunctions do
        local ThisFunction = BindedFunctions[i]
        ThisFunction(ActualDelta)
    end
    return ActualDelta
end
function DragWatcher:BindToDragged(callback: (Vector3) -> ())
    table.insert(self.UpdateBinded,callback)
end
function DragWatcher:Destroy()
    if self.StopEvent ~= nil then
        self.StopEvent:Disconnect()
        self.StopEvent = nil
    end
    if self.UpdateEvent ~= nil then
        self.UpdateEvent:Disconnect()
        self.UpdateEvent = nil
    end
end
return DragWatcher