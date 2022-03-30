local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

--[=[
    @client
    @class SkillTreeManager
    The module of which client scripts can interact with to provide the user with their current skill tree setup,
    alongside allowing the user to change it for the server to remember.
]=]
local SkillTreeManager = {} do
    SkillTreeManager.__index = SkillTreeManager
end
--[=[
    Create a new SkillTreeManager singleton for other scripts to interact with.
    Prepares Gui elements for rendering.
    @return SkillTreeManager
]=]
function SkillTreeManager.new()
    local NewManager = setmetatable({},SkillTreeManager)
    local GuiInfo do
        local ModuleOfWindow = script:WaitForChild("PrototypeSkillTree")
        GuiInfo = require(ModuleOfWindow)
    end
    print(GuiInfo)
    NewManager.GuiInfo = GuiInfo
    NewManager.GuiElement = Roact.createElement(GuiInfo)
    return NewManager
end

--[=[
    The function used to change the state of the skill tree's Gui.

    @param _SkillTreeData {[SkillName]: Integer} -- A dictionary containing the names of skills and the number of points assigned to the skills.
]=]
function SkillTreeManager:UpdateSkillTree(_SkillTreeData: {[string]: number})
    --Notify the Gui to change state with the given data.
end

--[=[
    A quick function to toggle the gui. Provides an optional "OpenGui" argument, where 
    By default will open the gui if not opened, and close if opened.

    Returns if the Gui has been opened or closed.

    @param OpenGui boolean? -- If set to true, then it will open the Gui. Otherwise, it will close.
    @return boolean -- If the Gui has been opened or closed.
]=]
function SkillTreeManager:ToggleGui(OpenGui: boolean?): boolean
    local ToOpen = self.ActiveGui == nil
    if OpenGui ~= nil then
        ToOpen = OpenGui
    end
    if ToOpen then
        self:OpenGui()
    else
        self:CloseGui()
    end
    return ToOpen
end

--[=[
    The function that is called to open the Gui. It opens the Gui via "Roact.mount(self.GuiInfo)". Provides a warning if the Gui is already active.
]=]
function SkillTreeManager:OpenGui()
    if self.ActiveGui == nil then
        print(self.GuiInfo)
        self.ActiveGui = Roact.mount(Roact.createElement(self.GuiInfo,
        {
            OnCloseEvent = function(_Button:GuiButton, _InputObject: InputObject, _ClickCount: number)
                self:ToggleGui(false)
            end;
        }), PlayerGui, "SkillTreeGui") -- PlayerGui temp location
    else
        warn("Attempted to mount an already active Gui! Trackback:",debug.traceback())
    end
end

--[=[
    The function that is called to close the Gui. It closes the Gui via "Roact.unmount(self.ActiveGui)". Provides a warning if the Gui is not active.
]=]
function SkillTreeManager:CloseGui()
    local ActiveGui = self.ActiveGui
    if ActiveGui then
        Roact.unmount(ActiveGui)
        self.ActiveGui = nil
    else
        warn("Attempted to unmount inactive Gui! Trackback:",debug.traceback())
    end
end

return SkillTreeManager.new()