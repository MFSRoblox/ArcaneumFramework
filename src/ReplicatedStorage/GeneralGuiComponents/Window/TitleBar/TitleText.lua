local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
type TitleTextProps = {
    TitleText:string;
    TitleTextColor3:Color3;
    TitleTextSize:number;
}
return function(props:TitleTextProps)
    return Roact.createElement("TextLabel",
    {
        ZIndex = 1;
        Text = props.TitleText;
        TextColor3 = props.TitleTextColor3;
        TextSize = props.TitleTextSize;
        Size = UDim2.new(1,0,1,0);
        BackgroundTransparency = 1;
    });
end