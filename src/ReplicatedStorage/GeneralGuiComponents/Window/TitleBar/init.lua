local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
local CloseButtonClass = require(script.CloseButton)
local TitleTextClass = require(script.TitleText)
type TitleBarProps = {
    BarHeight: number;
    BarColor3: Color3;
    BarTransparency: number;
    TitleTextProps: {
        Text: string;
        TextSize: number;
        TextColor3: Color3;
    };
    CloseButtonProps: CloseButtonClass.CloseButtonProps;
}
local DefaultProps = {
    BarHeight = 25;
    BarColor3 = Color3.fromRGB(45,45,45);
    BarTransparency = 0;
    TitleTextProps = {
        Text = "Unnamed Window";
        TextSize = 20;
        TextColor3 = Color3.new(1,1,1);
    };
    CloseButtonProps = {
        ButtonColor3 = Color3.new(1,0,0);
        ButtonTransparency = 0;
    };
}
local TitleBar = Roact.Component:extend("TitleBar")
function TitleBar:init(userProps:TitleBarProps)
    self.ref = Roact.createRef();
    for PropName, PropValue in pairs(DefaultProps) do -- Set property to default value if none was put in.
        if userProps[PropName] == nil then
            userProps[PropName] = PropValue
        end
    end
    --Color Checks
    assert(userProps.BarColor3, "BarColor3 doesn't exist in userProps! Debug:\n" .. debug.traceback())
    if userProps.BarColor3 == false then
        userProps.BarTransparency = 1
    end
end
function TitleBar:render()
    local props = self.props
    return Roact.createElement("Frame",{
        BackgroundTransparency = props.TitleBarTransparency;
        BackgroundColor3 = props.TitleBarColor3;
        Size = UDim2.new(1,0,0,props.TitleBarHeight);
        --Dragging events
        [Roact.Event.InputBegan] = props.TitleBarOnInputBegan;
        [Roact.Event.InputChanged] = props.TitleBarOnInputChanged;
        [Roact.Event.InputEnded] = props.TitleBarOnInputEnded;
    },
        {
            TitleText = Roact.createElement(TitleTextClass,
                props.TitleTextProps
                --[[{
                    TitleText = props.TitleText;
                    TitleTextColor3 = props.TitleTextColor3;
                    TitleTextSize = props.TitleTextSize;
                }]]
            );
            CloseButton = Roact.createElement(CloseButtonClass,
                props.CloseButtonProps
                --[[{
                    CloseButtonTransparency = props.CloseButtonTransparency;
                    CloseButtonColor3 = props.CloseButtonColor3;
                    OnCloseEvent = props.OnCloseEvent;
                }]]
            );
        }
    )
end
return TitleBar