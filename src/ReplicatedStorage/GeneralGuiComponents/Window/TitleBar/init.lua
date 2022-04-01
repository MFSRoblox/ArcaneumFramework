local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiUtilitiesModule = ReplicatedStorage.GeneralGuiComponents.GuiUtilities
local GuiUtilities = require(GuiUtilitiesModule)
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
local CloseButtonClass = require(script.CloseButton)
local TitleTextClass = require(script.TitleText)
--[=[
    @client
    @class TitleBar
    @tag RoactComponent
]=]
--[=[
    @prop BarHeight Integer
    @within TitleBar
    The height of the title bar (in pixels). By default 25
]=]
--[=[
    @prop BarColor3 Color3 | false
    @within TitleBar
    The color of the TitleBar. If "false" is put in, it will make the background transparent. By default RGB(45,45,45)
]=]
--[=[
    @prop BarTransparency number
    @within TitleBar
    The transparency of the TitleBar's background. By default 0 unless overrided by [Window.BarColor3]
]=]
--[=[
    @prop BarOnInputBegan (Frame, InputObject) -> ();
    @within TitleBar
    A function that will be called when "OnInputBegan" is invoked by the TitleBar's Frame.
]=]
--[=[
    @prop BarOnInputChanged (Frame, InputObject) -> ();
    @within TitleBar
    A function that will be called when "OnInputChanged" is invoked by the TitleBar's Frame.
]=]
--[=[
    @prop BarOnInputEnded (Frame, InputObject) -> ();
    @within TitleBar
    A function that will be called when "OnInputEnded" is invoked by the TitleBar's Frame.
]=]
--[=[
    @prop TitleTextProps TitleTextProps;
    @within TitleBar
    The properties of the TitleText object. Refer to [TitleText]'s properties.
]=]
--[=[
    @prop CloseButtonProps CloseButtonProps;
    @within TitleBar
    The properties of the CloseButton object. Refer to [CloseButton]'s properties.
]=]
--[=[
    @private
    @within TitleBar
    @interface TitleBarProps
    .BarHeight Integer -- [TitleBar.BarHeight]
    .BarColor3 Color3 | false -- [TitleBar.BarColor3]
    .BarTransparency number -- [TitleBar.BarTransparency]
    .BarOnInputBegan (Frame, InputObject) -> (); -- [TitleBar.BarOnInputBegan]
    .BarOnInputChanged (Frame, InputObject) -> (); -- [TitleBar.BarOnInputChanged]
    .BarOnInputEnded (Frame, InputObject) -> (); -- [TitleBar.BarOnInputEnded]
    .TitleTextProps TitleTextProps; -- [TitleBar.TitleTextProps]
    .CloseButtonProps CloseButtonProps; -- [TitleBar.CloseButtonProps]
]=]
export type TitleBarProps = {
    BarHeight: number;
    InitialProps: {
        BackgroundColor3: Color3;
        BackgroundTransparency: number;
        [string]: any;
    };
    Children: {
        [string]: GuiUtilities.RoactComponent;
    };
    BarOnInputBegan: (Frame, InputObject) -> ();
    BarOnInputChanged: (Frame, InputObject) -> ();
    BarOnInputEnded: (Frame, InputObject) -> ();
    TitleTextProps: TitleTextClass.TitleTextProps;
    CloseButtonProps: CloseButtonClass.CloseButtonProps;
}
local DefaultProps = {
    BarHeight = 25;
    InitialProps = {
        BackgroundColor3 = Color3.fromRGB(45,45,45);
        BackgroundTransparency = 0;
    };
    Chlidren = {};
    BarOnInputBegan = function()
        warn("BarOnInputBegan not implemented! Debug:",debug.traceback())
    end;
    BarOnInputChanged = function()
        warn("BarOnInputChanged not implemented! Debug:",debug.traceback())
    end;
    BarOnInputEnded = function()
        warn("BarOnInputEnded not implemented! Debug:",debug.traceback())
    end;
    TitleTextProps = {};
    CloseButtonProps = {};
}
local TitleBar = Roact.Component:extend("TitleBar")
function TitleBar:init(userProps:TitleBarProps)
    self.ref = Roact.createRef();
    GuiUtilities:ApplyDefaults(DefaultProps,userProps)
    GuiUtilities:CheckColorProp(userProps.InitialProps,"Background")
end
function TitleBar:render()
    local props: TitleBarProps = self.props
    local InitialProps = props.InitialProps do
        InitialProps.Size = UDim2.new(1,0,0,props.BarHeight);
        --Dragging events
        InitialProps[Roact.Event.InputBegan] = props.BarOnInputBegan;
        InitialProps[Roact.Event.InputChanged] = props.BarOnInputChanged;
        InitialProps[Roact.Event.InputEnded] = props.BarOnInputEnded;
    end
    local Children = props.Chlidren do
        Children.TitleText = Roact.createElement(TitleTextClass, props.TitleTextProps);
        Children.CloseButton = Roact.createElement(CloseButtonClass, props.CloseButtonProps);
    end
    return Roact.createElement("Frame",InitialProps,Children)
end
return TitleBar