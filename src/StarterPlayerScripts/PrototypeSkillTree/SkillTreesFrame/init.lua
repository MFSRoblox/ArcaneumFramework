--[[local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
--[[
    @class SkillTreesFrame

    The frame that holds all of the skill trees.
]]
local SkillTreesFrame = Roact.Component:extend("SkillTreesFrame")

--[[
    The initialization of the frame's state.
]]
function SkillTreesFrame:init()
    self.ref = Roact.createRef();
end

function SkillTreesFrame:render()
    return Roact.createElement(
        "Frame",
        {--Properties of the frame
            [Roact.Ref] = self.ref;
            Name = "SkillTreesFrame";
            Position = UDim2.fromScale(0.5,0.5);
            AnchorPoint = Vector2.new(0.5,0.5);
            Size = UDim2.fromScale(0.5,0.5);
        },
        {--Children
            
        }
    )
end

--[=[
    Initialize the frame for the Skill Tree
]=]
function SkillTreesFrame:didMount()
    --Initialize the sub-trees.
    --Roact.mount(Roact.createElement(require(script.SkillTreeFrame)),self.ref:getValue(),"SkillTreesFrame")
end

return SkillTreesFrame