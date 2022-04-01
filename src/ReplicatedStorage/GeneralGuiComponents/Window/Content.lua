local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiUtilitiesModule = ReplicatedStorage.GeneralGuiComponents.GuiUtilities
local GuiUtilities = require(GuiUtilitiesModule)
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
--[=[
    @client
    @class Content
]=]
--[=[
    @prop ContentColor3 Color3
    @within Content
    The background color of the Content section. If "false" is put in, it will make the background transparent. By default RGB(60,60,60)
]=]
--[=[
    @prop ContentTransparency number
    @within Content
    The transparency of the Content section's background. By default 0 unless overrided by ContentColor3
]=]
export type ContentProps = {
    ContentColor3: Color3;
    ContentTransparency: number;
}
local DefaultProps = {
    ContentColor3 = Color3.fromRGB(90,90,90);
    ContentTransparency = 0;
}
local Content = Roact.Component:extend("TitleBar")
function Content:init(userProps:ContentProps)
    self.ref = Roact.createRef();
    GuiUtilities:ApplyDefaults(DefaultProps,userProps)
    GuiUtilities:CheckColorProp(userProps,"Content")
end
function Content:render()
    local props = self.props
    return Roact.createElement("ScrollingFrame",
    {
        AnchorPoint = Vector2.new(0.5,1);
        Position = UDim2.new(0.5,0,1,0);
        Size = UDim2.new(1,0,1,-1*props.TitleBarHeight);
        CanvasSize = UDim2.new(); --Might need to change, unsure.
        BackgroundTransparency = props.ContentTransparency;
        BackgroundColor3 = props.ContentColor3;
    },
    {
        ContentElement = props.ContentElement
    }
)
end
return Content