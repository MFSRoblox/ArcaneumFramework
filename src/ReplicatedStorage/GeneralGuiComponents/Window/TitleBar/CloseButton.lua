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
    ButtonColor3:Color3;
    ButtonTransparency:number;
    OnCloseEvent:(TextButton, InputObject, number) -> ();
}
local DefaultProps: CloseButtonProps = {
    ButtonColor3 = Color3.new(1,0,0);
    ButtonTransparency = 0;
    OnCloseEvent = function()
        warn("OnCloseEvent not implemented! Debug:",debug.traceback())
    end;
};
return function(props:CloseButtonProps)
    GuiUtilities:ApplyDefaults(DefaultProps,props)
    GuiUtilities:CheckColorProp(props,"Button")
    return Roact.createElement("TextButton",
    {
        SizeConstraint = Enum.SizeConstraint.RelativeYY;
        ZIndex = 2;
        AnchorPoint = Vector2.new(1,0.5);
        Size = UDim2.new(1,-1,1,-1);
        BackgroundTransparency = props.ButtonTransparency;
        BackgroundColor3 = props.ButtonColor3;
        Position = UDim2.new(1,-1,0.5,0);
        Text = "X";
        TextScaled = true;
        TextXAlignment = Enum.TextXAlignment.Center;
        TextYAlignment = Enum.TextYAlignment.Center;
        [Roact.Event.Activated] = props.OnCloseEvent
    })
end