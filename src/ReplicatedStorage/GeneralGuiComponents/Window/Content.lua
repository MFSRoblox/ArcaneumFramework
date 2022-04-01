local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiUtilitiesModule = ReplicatedStorage.GeneralGuiComponents.GuiUtilities
local GuiUtilities = require(GuiUtilitiesModule)
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
--[=[
    @client
    @class Content
    A [ScrollingFrame] that holds other Guis.
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
local Content = Roact.Component:extend("TitleBar")
export type ContentProps = {
    InitialProps: {
        BackgroundColor3: Color3;
        BackgroundTransparency: number;
        [string]: any;
    };
    Children: {
        [string]: GuiUtilities.RoactComponent;
    };
}
Content.DefaultProps = {
    InitialProps = {
        BackgroundColor3 = Color3.fromRGB(90,90,90);
        BackgroundTransparency = 0;
    };
    Children = {};
}
function Content:init(userProps:ContentProps)
    self.ref = Roact.createRef();
    GuiUtilities:ApplyDefaults(self.DefaultProps,userProps)
    GuiUtilities:CheckColorProp(userProps.InitialProps,"Background")
end
function Content:render()
    local props:ContentProps = self.props
    local initialProps = props.InitialProps do
        initialProps[Roact.Ref] = self.ref;
        initialProps.AnchorPoint = Vector2.new(0.5,1);
        initialProps.Position = UDim2.new(0.5,0,1,0);
        initialProps.Size = UDim2.new(1,0,1,-1*props.TitleBarHeight);
    end
    local Children = props.Children do
        
    end
    return Roact.createElement("ScrollingFrame",initialProps,Children)
end
return Content