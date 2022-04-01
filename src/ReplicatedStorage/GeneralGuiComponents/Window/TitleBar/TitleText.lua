local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiUtilitiesModule = ReplicatedStorage.GeneralGuiComponents.GuiUtilities
local GuiUtilities = require(GuiUtilitiesModule)
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
--[=[
    @client
    @class TitleText
    @tag RoactComponent
]=]
--[=[
    @within TitleText
    @prop Text string
    The text of the window that will be displayed. By default "Unnamed Window"
]=]
--[=[
    @within TitleText
    @prop TextSize Integer
    The size of the TitleBar text. By default 20
]=]
--[=[
    @within TitleText
    @prop TextColor3 Color3
    The color of the TitleBar text. By default RGB(255,255,255)
]=]
--[=[
    @private
    @within TitleText
    @interface TitleTextProps
    .Text string -- [TitleText.Text]
    .TextSize Integer -- [TitleText.TextSize]
    .TextColor3 Color3 -- [TitleText.TextColor3]
]=]

export type TitleTextProps = {
    Text:string;
    TextColor3:Color3;
    TextSize:number;
}
local DefaultProps = {
    Text = "Unnamed Window";
    TextSize = 20;
    TextColor3 = Color3.new(1,1,1);
};
return function(props:TitleTextProps)
    GuiUtilities:ApplyDefaults(DefaultProps,props)
    return Roact.createElement("TextLabel",
    {
        ZIndex = 1;
        Text = props.Text;
        TextColor3 = props.TextColor3;
        TextSize = props.TextSize;
        Size = UDim2.new(1,0,1,0);
        BackgroundTransparency = 1;
    });
end