local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiUtilitiesModule = ReplicatedStorage.GeneralGuiComponents.GuiUtilities
local GuiUtilities = require(GuiUtilitiesModule)
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
--[=[
    @client
    @class CloseButton
    @tag RoactComponent
]=]
--[=[
    @within CloseButton
    @prop ButtonColor3 Color3 | false
    The color of the CloseButton. If "false" is put in, it will make the background transparent. By default RGB(255,0,0)
]=]
--[=[
    @within CloseButton
    @prop ButtonTransparency number
    The transparency of the CloseButton's background. By default 0 unless overrided by CloseButtonColor3
]=]
--[=[
    @within CloseButton
    @prop OnCloseEvent (GuiButton, InputObject, number) -> ()
    The function that is called when the window's close button is activated.
]=]
--[=[
    @within CloseButton
    @interface CloseButtonProps
    .ButtonColor3 Color3 | false -- [CloseButton.ButtonColor3]
    .ButtonTransparency number -- [CloseButton.ButtonTransparency]
    .OnCloseEvent (GuiButton, InputObject, number) -> () -- [CloseButton.OnCloseEvent]
]=]
export type CloseButtonProps = {
    InitialProps: {
        BackgroundColor3:Color3;
        BackgroundTransparency:number;
        [string]: any;
    };
    Children: {
        [string]: GuiUtilities.RoactComponent;
    };
    OnCloseEvent:(TextButton, InputObject, number) -> ();
}
local DefaultProps: CloseButtonProps = {
    InitialProps = {
        BackgroundColor3 = Color3.new(1,0,0);
        BackgroundTransparency = 0;
    };
    Children = {};
    OnCloseEvent = function()
        warn("OnCloseEvent not implemented! Debug:",debug.traceback())
    end;
};
return function(props:CloseButtonProps)
    GuiUtilities:ApplyDefaults(DefaultProps,props)
    local InitialProps = props.InitialProps do
        GuiUtilities:ApplyDefaults(DefaultProps.InitialProps,InitialProps)
        GuiUtilities:CheckColorProp(InitialProps,"Background")
        InitialProps.SizeConstraint = Enum.SizeConstraint.RelativeYY;
        InitialProps.ZIndex = 2;
        InitialProps.AnchorPoint = Vector2.new(1,0.5);
        InitialProps.Size = UDim2.new(1,-1,1,-1);
        InitialProps.Position = UDim2.new(1,-1,0.5,0);
        InitialProps.Text = "X";
        InitialProps.TextScaled = true;
        InitialProps.TextXAlignment = Enum.TextXAlignment.Center;
        InitialProps.TextYAlignment = Enum.TextYAlignment.Center;
        InitialProps[Roact.Event.Activated] = props.OnCloseEvent
    end
    return Roact.createElement("TextButton",InitialProps,props.Children)
end