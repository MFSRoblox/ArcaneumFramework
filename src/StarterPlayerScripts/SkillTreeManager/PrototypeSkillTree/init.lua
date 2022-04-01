local gameIsLoaded = game:IsLoaded()
if not gameIsLoaded then
    game.Loaded:Wait()
end
--[[local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoactModule = ReplicatedStorage.Packages.roact
local Roact = require(RoactModule)
local GuiUtilitiesModule = ReplicatedStorage.GeneralGuiComponents.GuiUtilities
local GuiUtilities = require(GuiUtilitiesModule)
local WindowModule = ReplicatedStorage.GeneralGuiComponents.Window
local WindowClass = require(WindowModule)
--[=[
    @client
    @class SkillTreesGui
    The ScreenGui that holds all of the skill trees.
]=]
local SkillTreesGui: GuiUtilities.RoactComponent = Roact.Component:extend("SkillTreesGui")

--[=[
    The initialization of the Gui's state.
]=]
function SkillTreesGui:init()
    --self:setState({
        self.ref = Roact.createRef();
        self.WindowType = "Computer"; --Computer,Tablet,Phone
    --})
end

type RoactElement = typeof(Roact.createElement())
local SkillTreeFrameClass = require(script.SkillTreesFrame.SkillTreeFrame)
--[=[
    Setup the element that should be rendered

    @return RoactElement
]=]
function SkillTreesGui:render(): RoactElement
    local WindowProps: WindowClass.WindowProps = {
        OnCloseEvent = self.props.OnCloseEvent;
        ContentProps = {
            Children = {
                SkillTreeFrame1 = Roact.createElement(SkillTreeFrameClass);
                SkillTreeFrame2 = Roact.createElement(SkillTreeFrameClass);
                SkillTreeFrame3 = Roact.createElement(SkillTreeFrameClass);
                UIListLayout = Roact.createElement("UIListLayout",
                {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Center;
                    VerticalAlignment = Enum.VerticalAlignment.Center;
                    Padding = UDim.new(0,2)
                }
            )
            }
        };
    }
    return Roact.createElement(
        "ScreenGui",
        {
            [Roact.Ref] = self.ref;
            Name = "SkillTreesUI"
        },
        {--Children
            Window = Roact.createElement(WindowClass,WindowProps);
        }
    )
end

--[=[
    Initialize the frame for the Skill Tree.
]=]
function SkillTreesGui:didMount()
    --Initialize the frame.
    --[[local _FrameHandle = Roact.mount(Roact.createElement(require(script.Window),{
        --TitleBarColor3 = Color3.new(0,1,0)
    }),self.ref:getValue(),"SkillTreesGui")]]
end

return SkillTreesGui