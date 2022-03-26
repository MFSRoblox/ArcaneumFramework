--[[local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
--[=[
    @class SkillTreeFrame

    The frame that represents a Skill Tree and holds all of the skills.
]=]
type RoactComponent = typeof(Roact.Component:extend())
local SkillTreeFrame: RoactComponent = Roact.Component:extend("SkillTreeFrame")

--[=[
    The initialization of the frame's state.
]=]
function SkillTreeFrame:init()
    self.ref = Roact.createRef();
end

type RoactElement = typeof(Roact.createElement())
function SkillTreeFrame:render(): RoactElement
    return Roact.createElement(
        "Frame",
        {--Properties of the frame
            [Roact.Ref] = self.ref;
            Name = "SkillTreeFrame";
            --Position = UDim2.fromScale(0.5,0.5);
            --AnchorPoint = Vector2.new(0,0.5);
            Size = UDim2.new(1/3,-2,1,-2);
        },
        {--Children
            
        }
    )
end

--[=[
    Initialize the frame for the Skill Tree
]=]
function SkillTreeFrame:didMount()
    --Initialize the sub-trees.
    --Roact.mount(Roact.createElement(require(script.SkillTreeFrame)),self.ref:getValue(),"SkillTreeFrame")
end

return SkillTreeFrame