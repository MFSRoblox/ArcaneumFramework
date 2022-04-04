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
    InitialProps: {
        Text:string;
        TextColor3:Color3;
        TextSize:number;
        [string]:any;
    };
    Children: {
        [string]: GuiUtilities.RoactComponent;
    };
}
local DefaultProps = {
    InitialProps = {
        Text = "Unnamed Window";
        TextSize = 20;
        TextColor3 = Color3.new(1,1,1);
    };
    Children = {};
};
return function(props:TitleTextProps)
    GuiUtilities:ApplyDefaults(DefaultProps,props)
    local InitialProps = props.InitialProps do
        InitialProps.ZIndex = 1
        InitialProps.Size = UDim2.new(1,0,1,0)
        InitialProps.BackgroundTransparency = 1
    end
    return Roact.createElement("TextLabel",InitialProps,props.Children);
end