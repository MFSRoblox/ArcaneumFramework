local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local DragWatcherClass = require(script.DragWatcher)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
local DebugConfig = {
    InputEventOutput = false;
}
local RobloxTopBarSize = 36
local ColorableKeys = {
    "Content";
    "TitleBar";
    "CloseButton";
}
type False = boolean
type WindowProps = {
    ContentColor3:Color3;
    ContentTransparency:number;
    TitleBarHeight:number;
    TitleBarColor3:Color3;
    TitleBarTransparency:number;
    TitleTextSize:number;
    TitleTextColor3: Color3;
    CloseButtonColor3:Color3;
    CloseButtonTransparency:number;
    Draggable:boolean;
    RestrictDragToWindow:boolean;
}
local DefaultWindowProps: WindowProps = {
    ContentColor3 = Color3.fromRGB(60,60,60);
    ContentTransparency = 0;
    TitleBarHeight = 25;
    TitleBarColor3 = Color3.fromRGB(45,45,45);
    TitleBarTransparency = 0;
    TitleTextSize = 20;
    TitleTextColor3 = Color3.new(1,1,1);
    CloseButtonColor3 = Color3.new(1,0,0);
    CloseButtonTransparency = 0;
    Draggable = true;
    RestrictDragToWindow = true;
}
--[=[
    @client
    @class Window

    A general frame that has the ability to open, close, and be dragable. A staple for PC users.
]=]
--[=[
    @interface DefaultWindowProps
    @within Window
    .ContentColor3 Color3 | false -- The background color of the Content section. If "false" is put in, it will make the background transparent. By default RGB(60,60,60)
    .ContentTransparency number -- The transparency of the Content section's background. By default 0 unless overrided by ContentColor3
    .TitleBarHeight Integer -- The height of the title bar (in pixels). By default 25
    .TitleBarColor3 Color3 | false -- The color of the TitleBar. If "false" is put in, it will make the background transparent. By default RGB(45,45,45)
    .TitleBarTransparency number -- The transparency of the TitleBar's background. By default 0 unless overrided by TitleBarColor3
    .TitleTextSize Integer -- The size of the TitleBar text. By default 20
    .TitleTextColor3 Color3 -- The color of the TitleBar text. By default RGB(255,255,255)
    .CloseButtonColor3 Color3 | false -- The color of the CloseButton. If "false" is put in, it will make the background transparent. By default RGB(255,0,0)
    .CloseButtonTransparency number -- The transparency of the CloseButton's background. By default 0 unless overrided by CloseButtonColor3
    .Draggable boolean -- Whether the window can be dragged by the user. By default true
    .RestrictDragToWindow boolean -- Whether the window can be dragged outside of the game's window. By default true
    
    The allowed properties to be passed into the component on creation.
]=]
type RoactComponent = typeof(Roact.Component:extend())
local Window: RoactComponent = Roact.Component:extend("GeneralWindow")

--[=[
    The initialization of the frame's state from inputted properties.
]=]
function Window:init(userProps:WindowProps)
    self.ref = Roact.createRef();
    self.DragWatcher = nil;
    for PropName, PropValue in pairs(DefaultWindowProps) do -- Set property to default value if none was put in.
        if userProps[PropName] == nil then
            userProps[PropName] = PropValue
        end
    end
    --Color Checks
    for i=1, #ColorableKeys do
        local KeyName = ColorableKeys[i]
        local ColorKey = KeyName.."Color3"
        --local TransparencyKey = KeyName.."Transparency"
        assert(userProps[ColorKey], KeyName..".. Color3 doesn't exist in userProps! Debug:\n" .. debug.traceback())
        if userProps[ColorKey] == false then
            userProps[KeyName.."Transparency"] = 1
        end
    end
end
function Window:ToggleDrag(Toggle: boolean, Input: InputObject)
    local ToDrag = Toggle
    if ToDrag == nil then
        ToDrag = not self.DragWatcher
    end
    if ToDrag == true then
        self.DragWatcher = DragWatcherClass.new(Input, Enum.UserInputType.MouseMovement)
        self.DragWatcher:BindToDragged(function(_Input: InputObject, ActualDelta: Vector3)
            self:Drag(ActualDelta)
        end)
    else
        self.DragWatcher = self.DragWatcher:Destroy()
    end
end
function Window:Drag(MouseDelta: Vector3)
    local props:WindowProps = self.props
    local ToRestrictDrag = props.RestrictDragToWindow
    local GUIInstance:Frame = self.ref:getValue()
    --GUIInstance.AnchorPoint = Vector2.new()
    local NewPosition = GUIInstance.Position + UDim2.new(0,MouseDelta.X,0,MouseDelta.Y)
    GUIInstance.Position = NewPosition
    if ToRestrictDrag == true then
        local CurrentGuiSize = GUIInstance.AbsoluteSize
        local CurrentPosition = GUIInstance.AbsolutePosition + Vector2.new(0,RobloxTopBarSize)-- CurrentGuiSize*GUIInstance.AnchorPoint -- Aligned to Top Left
        local CurrentScreenSize = Vector2.new(Mouse.ViewSizeX, Mouse.ViewSizeY + RobloxTopBarSize*2) --For some reason ViewSizeY doesn't count the top bar, and has an increased size on the bottom too.
        local MaxPosition = CurrentScreenSize - CurrentGuiSize
        --[[print(
            --"CurrentMousePos:",Vector2.new(Mouse.X,Mouse.Y),
            "CurrentPosition:",CurrentPosition,
            "\nCurrentGuiSize:",CurrentGuiSize,
            "\nCurrentScreenSize:",CurrentScreenSize,
            "\nMaxPosition:", MaxPosition
        )]]
        --Check if it's out of bounds on bottom or right
        local Difference = MaxPosition - CurrentPosition
        if CurrentPosition.X > MaxPosition.X then
            GUIInstance.Position += UDim2.new(0,Difference.X,0,0)
        end
        if CurrentPosition.Y > MaxPosition.Y then
            GUIInstance.Position += UDim2.new(0,0,0,Difference.Y)
        end
        --Check if it's out of bounds on top or left
        if CurrentPosition.X < 0 then
            GUIInstance.Position -= UDim2.new(0,CurrentPosition.X,0,0)
        end
        if CurrentPosition.Y < 0 then
            GUIInstance.Position -= UDim2.new(0,0,0,CurrentPosition.Y)
        end
    end
end
type RoactElement = typeof(Roact.createElement())
function Window:render(): RoactElement
    local props: WindowProps = self.props
    return Roact.createElement(
        "Frame",
        {--Properties of the frame
            [Roact.Ref] = self.ref;
            Name = "GeneralWindow";
            Position = UDim2.fromScale(0.5,0.5);
            AnchorPoint = Vector2.new(0.5,0.5);
            Size = UDim2.fromScale(0.5,0.5);
        },
        {--Children
            TitleBar = Roact.createElement("Frame",{
                BackgroundTransparency = props.TitleBarTransparency;
                BackgroundColor3 = props.TitleBarColor3;
                Size = UDim2.new(1,0,0,props.TitleBarHeight);
                --Dragging events
                [Roact.Event.InputBegan] = function(selfFrame: Frame, input: InputObject)
                    --[[
                        Triggers:
                        Mouse enter (Position,UserInputState.Change, UserInputType.MouseMovement)
                    ]]
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        self:ToggleDrag(true, input)
                    end
                    if DebugConfig.InputEventOutput then
                        print(selfFrame,"Input Began")
                        print(
                            "InputInfo:\nDelta:", input.Delta,
                            "\nKeyCode:", input.KeyCode,
                            "\nPosition:", input.Position,
                            "\nUserInputState:", input.UserInputState,
                            "\nUserInputType:", input.UserInputType
                        )
                    end
                end;
                [Roact.Event.InputChanged] = function(selfFrame: Frame, input: InputObject)
                    --[[
                        Triggers:
                        Mouse move (Position,UserInputState.Change, UserInputType.MouseMovement)
                    ]]
                    --self:Drag(input.Delta)
                    if DebugConfig.InputEventOutput then
                        print(selfFrame,"Input Changed")
                        print(
                            "InputInfo:\nDelta:", input.Delta,
                            "\nKeyCode:", input.KeyCode,
                            "\nPosition:", input.Position,
                            "\nUserInputState:", input.UserInputState,
                            "\nUserInputType:", input.UserInputType
                        )
                    end
                end;
                [Roact.Event.InputEnded] = function(selfFrame: Frame, input: InputObject)
                    --[[
                        Triggers:
                        Mouse exit (Position,UserInputState.Change, UserInputType.MouseMovement)
                    ]]
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        self:ToggleDrag(false)
                    end
                    if DebugConfig.InputEventOutput then
                        print(selfFrame,"Input Ended")
                        print(
                            "InputInfo:\nDelta:", input.Delta,
                            "\nKeyCode:", input.KeyCode,
                            "\nPosition:", input.Position,
                            "\nUserInputState:", input.UserInputState,
                            "\nUserInputType:", input.UserInputType
                        )
                    end
                end;
            },
                {
                    TitleText = Roact.createElement("TextLabel",
                        {
                            ZIndex = 1;
                            Text = props.TitleText;
                            TextColor3 = props.TitleTextColor3;
                            TextSize = props.TitleTextSize;
                            Size = UDim2.new(1,0,1,0);
                            BackgroundTransparency = 1;
                        }
                    );
                    CloseButton = Roact.createElement("TextButton",
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
                            [Roact.Event.Activated] = function(selfButton: TextButton, inputObject: InputObject, clickCount: number)
                                print(selfButton, inputObject, clickCount)
                                print("Close the window when functionality is implemented")
                            end;
                        }
                    );
                }
            );
            ContentFrame = Roact.createElement("ScrollingFrame",
                {
                    CanvasSize = UDim2.new(); --Might need to change, unsure.
                    BackgroundTransparency = self.ContentTransparency;
                    BackgroundColor3 = self.ContentColor3;
                }
            )
        }
    )
end

--[=[
    Initialize the frame for the Skill Tree
]=]
function Window:didMount()
    --Initialize the sub-trees.
    --[[Roact.mount(Roact.createElement(require(script.SkillTreeFrame)),self.ref:getValue(),"SkillTreesFrame1")
    Roact.mount(Roact.createElement(require(script.SkillTreeFrame)),self.ref:getValue(),"SkillTreesFrame2")
    Roact.mount(Roact.createElement(require(script.SkillTreeFrame)),self.ref:getValue(),"SkillTreesFrame3")]]
end

return Window