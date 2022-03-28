--[[local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
type RoactComponent = typeof(Roact.Component:extend())
--[=[
    @client
    @class SkillTreesGui
    The ScreenGui that holds all of the skill trees.
]=]
local SkillTreesGui: RoactComponent = Roact.Component:extend("SkillTreesGui")

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
--[=[
    Setup the element that should be rendered

    @return RoactElement
]=]
function SkillTreesGui:render(): RoactElement
    return Roact.createElement(
        "ScreenGui",
        {
            [Roact.Ref] = self.ref;
            Name = "SkillTreesUI"
        },
        {--Children
            
        }
    )
end

--[=[
    Initialize the frame for the Skill Tree.
]=]
function SkillTreesGui:didMount()
    --Initialize the frame.
    local _FrameHandle = Roact.mount(Roact.createElement(require(script.Window),{
        --TitleBarColor3 = Color3.new(0,1,0)
    }),self.ref:getValue(),"SkillTreesGui")

end

return SkillTreesGui