local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
type CloseButtonProps = {
    CloseButtonTransparency:number;
    CloseButtonColor3:Color3;
    OnCloseEvent:(TextButton, InputObject, number) -> ()
}
return function(props:CloseButtonProps)
    return Roact.createElement("TextButton",
    {
        SizeConstraint = Enum.SizeConstraint.RelativeYY;
        ZIndex = 2;
        AnchorPoint = Vector2.new(1,0.5);
        Size = UDim2.new(1,-1,1,-1);
        BackgroundTransparency = props.CloseButtonTransparency;
        BackgroundColor3 = props.CloseButtonColor3;
        Position = UDim2.new(1,-1,0.5,0);
        Text = "X";
        TextScaled = true;
        TextXAlignment = Enum.TextXAlignment.Center;
        TextYAlignment = Enum.TextYAlignment.Center;
        [Roact.Event.Activated] = props.OnCloseEvent
    })
end