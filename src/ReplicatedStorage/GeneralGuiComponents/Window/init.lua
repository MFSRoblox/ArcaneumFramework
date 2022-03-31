local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local DragWatcherClass = require(script.DragWatcher)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
local TitleBarComponent = require(script.TitleBar)
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
    TitleText:string;
    TitleTextSize:number;
    TitleTextColor3: Color3;
    CloseButtonColor3:Color3;
    CloseButtonTransparency:number;
    Draggable:boolean;
    RestrictDragToWindow:boolean;
    RestrictDragWithTopRobloxBar:boolean;
    RestrictDragWithBottomRobloxBar:boolean;
}
local DefaultWindowProps: WindowProps = {
    ContentColor3 = Color3.fromRGB(60,60,60);
    ContentTransparency = 0;
    TitleBarHeight = 25;
    TitleBarColor3 = Color3.fromRGB(45,45,45);
    TitleBarTransparency = 0;
    TitleText = "Unnamed Window";
    TitleTextSize = 20;
    TitleTextColor3 = Color3.new(1,1,1);
    CloseButtonColor3 = Color3.new(1,0,0);
    CloseButtonTransparency = 0;
    Draggable = true;
    RestrictDragToWindow = true;
    RestrictDragWithTopRobloxBar = false;
    RestrictDragWithBottomRobloxBar = false;
}
--[=[
    @client
    @class Window

    A general frame that has the ability to open, close, and be dragable. A staple for PC users.
]=]
--[=[
    @prop ContentColor3 Color3
    @within Window
    The background color of the Content section. If "false" is put in, it will make the background transparent. By default RGB(60,60,60)
]=]
--[=[
    @prop ContentTransparency number
    @within Window
    The transparency of the Content section's background. By default 0 unless overrided by ContentColor3
]=]
--[=[
    @prop TitleBarHeight Integer
    @within Window
    The height of the title bar (in pixels). By default 25
]=]
--[=[
    @prop TitleBarColor3 Color3 | false
    @within Window
    The color of the TitleBar. If "false" is put in, it will make the background transparent. By default RGB(45,45,45)
]=]
--[=[
    @prop TitleBarTransparency number
    @within Window
    The transparency of the TitleBar's background. By default 0 unless overrided by [Window.TitleBarColor3]
]=]
--[=[
    @prop TitleText string
    @within Window
    The text of the window that will be displayed. By default "Unnamed Window"
]=]
--[=[
    @prop TitleTextSize Integer
    @within Window
    The size of the TitleBar text. By default 20
]=]
--[=[
    @prop TitleTextColor3 Color3
    @within Window
    The color of the TitleBar text. By default RGB(255,255,255)
]=]
--[=[
    @prop CloseButtonColor3 Color3 | false
    @within Window
    The color of the CloseButton. If "false" is put in, it will make the background transparent. By default RGB(255,0,0)
]=]
--[=[
    @prop CloseButtonTransparency number
    @within Window
    The transparency of the CloseButton's background. By default 0 unless overrided by CloseButtonColor3
]=]
--[=[
    @prop Draggable boolean
    @within Window
    Whether the window can be dragged by the user. By default true
]=]
--[=[
    @prop RestrictDragToWindow boolean
    @within Window
    Whether the window can be dragged outside of the game's window. By default true
]=]
--[=[
    @prop RestrictDragWithTopRobloxBar boolean
    @within Window
    Whether the window can be dragged beyond the top roblox bar. By default false
]=]
--[=[
    @prop RestrictDragWithBottomRobloxBar boolean
    @within Window
    Whether the window can be dragged beyond the bottom(?) roblox bar. By default false
]=]
--[=[
    @prop OnCloseEvent function
    @within Window
    The function that is called when the window's close button is activated.
]=]
--[=[
    @interface WindowProps
    @private
    @within Window
    .ContentColor3 Color3 | false -- [Window.ContentColor3]
    .ContentTransparency number -- [Window.ContentTransparency]
    .TitleBarHeight Integer -- [Window.TitleBarHeight]
    .TitleBarColor3 Color3 | false -- [Window.TitleBarColor3]
    .TitleBarTransparency number -- [Window.TitleBarTransparency]
    .TitleText string -- [Window.TitleText]
    .TitleTextSize Integer -- [Window.TitleTextSize]
    .TitleTextColor3 Color3 -- [Window.TitleTextColor3]
    .CloseButtonColor3 Color3 | false -- [Window.CloseButtonColor3]
    .CloseButtonTransparency number -- [Window.CloseButtonTransparency]
    .Draggable boolean -- [Window.Draggable]
    .RestrictDragToWindow boolean -- [Window.RestrictDragToWindow]
    .RestrictDragWithTopRobloxBar boolean -- [Window.RestrictDragWithTopRobloxBar]
    .RestrictDragWithBottomRobloxBar boolean -- [Window.RestrictDragWithBottomRobloxBar]

    The allowed properties to be passed into the component on creation.
]=]
type RoactComponent = typeof(Roact.Component:extend())
local Window: RoactComponent = Roact.Component:extend("GeneralWindow")

--[=[
    The initialization of the frame's state from inputted properties.
]=]
function Window:init(userProps:WindowProps)
    self:setState({
        DragWatcher = nil;
    })
    self.ref = Roact.createRef();
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
--[=[
    Sets a [DragWatcher] to listen to the InputObject.UserInputType and binds [Window:Drag] to it.
]=]
function Window:ToggleDrag(Toggle: boolean?, Input: InputObject)
    if self.props.Draggable then
        local ToDrag = Toggle
        if ToDrag == nil then
            ToDrag = not self.DragWatcher
        end
        if ToDrag == true then
            self.DragWatcher = DragWatcherClass.new(Input, Enum.UserInputType.MouseMovement)
            self.DragWatcher:BindToDragged(function(_Input: InputObject, ActualDelta: Vector3)
                self:MoveBy(ActualDelta)
            end)
        else
            if self.DragWatcher ~= nil then
                self.DragWatcher = self.DragWatcher:Destroy()
            end
        end
    end
end
--[=[
    Moves the window by the inputted delta. Affected by the following:
    - RestrictDragToWindow
    - RestrictDragWithTopRobloxBar
    - RestrictDragWithBottomRobloxBar
]=]
function Window:MoveBy(Delta: Vector3)
    local props:WindowProps = self.props
    local ToRestrictDrag = props.RestrictDragToWindow
    local GUIInstance:Frame = self.ref:getValue()
    --GUIInstance.AnchorPoint = Vector2.new()
    local NewPosition = GUIInstance.Position + UDim2.new(0,Delta.X,0,Delta.Y)
    GUIInstance.Position = NewPosition
    if ToRestrictDrag == true then
        local CurrentGuiSize = GUIInstance.AbsoluteSize
        local CurrentPosition = GUIInstance.AbsolutePosition
        local CurrentScreenSize = Vector2.new(Mouse.ViewSizeX, Mouse.ViewSizeY)
        if props.RestrictDragWithTopRobloxBar == false then
            CurrentPosition += Vector2.new(0,RobloxTopBarSize) -- Aligned to Top Left
            CurrentScreenSize += Vector2.new(0, RobloxTopBarSize) --For some reason ViewSizeY doesn't count the top bar, and has an increased size on the bottom too.
        end
        if props.RestrictDragWithBottomRobloxBar == false then
            CurrentScreenSize += Vector2.new(0, RobloxTopBarSize) --For some reason ViewSizeY doesn't count the top bar, and has an increased size on the bottom too.
        end
        --local CameraScreenSize = workspace.CurrentCamera.ViewportSize
        local MaxPosition = CurrentScreenSize - CurrentGuiSize
        --[[print(
            --"CurrentMousePos:",Vector2.new(Mouse.X,Mouse.Y),
            "CurrentPosition:",CurrentPosition,
            "\nCurrentGuiSize:",CurrentGuiSize,
            --"\nCameraScreenSize:",CameraScreenSize,
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
            TitleBar = Roact.createElement(TitleBarComponent,{
                TitleBarTransparency = props.TitleBarTransparency;
                TitleBarColor3 = props.TitleBarColor3;
                TitleBarHeight = props.TitleBarHeight;
                TitleText = props.TitleText;
                TitleTextColor3 = props.TitleTextColor3;
                TitleTextSize = props.TitleTextSize;
                CloseButtonTransparency = props.CloseButtonTransparency;
                CloseButtonColor3 = props.CloseButtonColor3;
                TitleBarOnInputBegan = function(selfFrame: Frame, input: InputObject)
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
                TitleBarOnInputChanged = function(selfFrame: Frame, input: InputObject)
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
                TitleBarOnInputEnded = function(selfFrame: Frame, input: InputObject)
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
                OnCloseEvent = props.OnCloseEvent;
            });
            ContentFrame = Roact.createElement("ScrollingFrame",
                {
                    CanvasSize = UDim2.new(); --Might need to change, unsure.
                    BackgroundTransparency = props.ContentTransparency;
                    BackgroundColor3 = props.ContentColor3;
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