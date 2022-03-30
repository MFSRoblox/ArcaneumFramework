local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
local CloseButtonClass = require(script.CloseButton)
local TitleTextClass = require(script.TitleText)
type TitleBarProps = {
    TitleBarTransparency:number;
    TitleBarColor3:Color3;
    TitleBarHeight:number;
    TitleText:string;
    TitleTextColor3:Color3;
    TitleTextSize:number;
    CloseButtonTransparency:number;
    CloseButtonColor3:Color3;
    DebugConfig:{
        InputEventOutput:boolean;
    };
}
local TitleBar = Roact.Component:extend("TitleBar")
function TitleBar:init(_userProps:TitleBarProps)
    self.DraggingBinded = {}
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
                {
                    TitleText = props.TitleText;
                    TitleTextColor3 = props.TitleTextColor3;
                    TitleTextSize = props.TitleTextSize;
                }
            );
            CloseButton = Roact.createElement(CloseButtonClass,
                {
                    CloseButtonTransparency = props.CloseButtonTransparency;
                    CloseButtonColor3 = props.CloseButtonColor3;
                    OnCloseEvent = props.OnCloseEvent;
                }
            );
        }
    )
end
return TitleBar