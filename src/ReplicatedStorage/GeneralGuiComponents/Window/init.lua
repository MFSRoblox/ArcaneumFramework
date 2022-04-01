local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local DragWatcherClass = require(script.DragWatcher)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiUtilitiesModule = ReplicatedStorage.GeneralGuiComponents.GuiUtilities
local GuiUtilities = require(GuiUtilitiesModule)
local RoactModule = ReplicatedStorage.Packages:WaitForChild("roact")
local Roact = require(RoactModule)
local TitleBarComponent = require(script.TitleBar)
local ContentComponent = require(script.Content)
local DebugConfig = {
    InputEventOutput = false;
}
local RobloxTopBarSize = 36
--[=[
    @client
    @class Window

    A general frame that has the ability to open, close, and be dragable. A staple for PC users.
]=]
--[=[
    @prop Position UDim2;
    @within Window
    The initial position of the Window. By default is UDim2.fromScale(0.5,0.5)
]=]
--[=[
    @prop AnchorPoint Vector2;
    @within Window
    The anchor point of the Window. By default is Vector2.new(0.5,0.5)
]=]
--[=[
    @prop Position Size;
    @within Window
    The initial size of the Window. By default is UDim2.fromScale(0.5,0.5)
]=]
--[=[
    @within Window
    @interface DragProps
    .RestrictDragToWindow boolean -- [Window.RestrictDragToWindow]
    .RestrictDragWithTopRobloxBar boolean -- [Window.RestrictDragWithTopRobloxBar]
    .RestrictDragWithBottomRobloxBar boolean -- [Window.RestrictDragWithBottomRobloxBar]
    The interface for the [Window.DragProps] property.
]=]
--[=[
    @prop DragProps DragProps | nil
    @within Window
    Whether the window can be dragged by the user. By default not nil
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
    @prop InitialProps FrameProperties;
    @within Window
    The properties of the Window's Frame object. Refer to [Frame] for all of the properties.
]=]
--[=[
    @prop TitleBarProps TitleBar;
    @within Window
    The properties of the TitleBar object. Refer to [TitleBar]'s properties.
]=]
--[=[
    @within Window
    @prop ContentProps Content;
    The properties of the Content object. Refer to [Content]'s properties.
]=]

--[=[
    @prop OnCloseEvent (GuiButton, InputObject, number) -> ()
    @within Window
    The function that is called when the window's close button is activated. Passed to [CloseButton].
]=]
type RoactComponent = typeof(Roact.Component:extend())
local Window: RoactComponent = Roact.Component:extend("GeneralWindow")
export type WindowProps = {
    OnCloseEvent: (TextButton, InputObject, number) -> ();
    InitialProps: {
        Position: UDim2;
        AnchorPoint: Vector2;
        Size: UDim2;
        [string]: any;
    };
    Children: {
        [string]: GuiUtilities.RoactComponent;
    };
    DragProps:{
        RestrictDragToWindow:boolean;
        RestrictDragWithTopRobloxBar:boolean;
        RestrictDragWithBottomRobloxBar:boolean;
    };
    TitleBarProps: TitleBarComponent.TitleBarProps;
    ContentProps: ContentComponent.ContentProps;
}
Window.DefaultProps = {
    InitialProps = {
        Position = UDim2.fromScale(0.5,0.5);
        AnchorPoint = Vector2.new(0.5,0.5);
        Size = UDim2.fromScale(0.5,0.5);
    };
    Children = {};
    DragProps = {
        RestrictDragToWindow = true;
        RestrictDragWithTopRobloxBar = false;
        RestrictDragWithBottomRobloxBar = false;
    };
    TitleBarProps = TitleBarComponent.DefaultProps;
    ContentProps = ContentComponent.DefaultProps;
} :: WindowProps
--[=[
    The initialization of the frame's state from inputted properties.
]=]
function Window:init(userProps:WindowProps)
    self:setState({
        DragWatcher = nil;
    })
    self.ref = Roact.createRef();
    GuiUtilities:ApplyDefaults(self.DefaultProps,userProps) -- Set property to default value if none was put in.
    local TitleBarProps = userProps.TitleBarProps do
        TitleBarProps.CloseButtonProps.OnCloseEvent = userProps.OnCloseEvent
        TitleBarProps.BarOnInputBegan = function(selfFrame: Frame, input: InputObject)
            --[[
                Triggers:
                Mouse enter (Position,UserInputState.Change, UserInputType.MouseMovement)
            ]]
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                self:ToggleMove(true, input)
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
        TitleBarProps.BarOnInputChanged = function(selfFrame: Frame, input: InputObject)
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
        TitleBarProps.BarOnInputEnded = function(selfFrame: Frame, input: InputObject)
            --[[
                Triggers:
                Mouse exit (Position,UserInputState.Change, UserInputType.MouseMovement)
            ]]
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                self:ToggleMove(false)
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
    end
    local ContentProps = userProps.ContentProps do
        ContentProps.TitleBarHeight = TitleBarProps.BarHeight or 25
    end
end
--[=[
    Sets a [DragWatcher] to listen to the InputObject.UserInputType and binds [Window:Drag] to it.
]=]
function Window:ToggleMove(Toggle: boolean?, Input: InputObject)
    if self.props.DragProps ~= nil then
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
    local DragProps = props.DragProps
    local ToRestrictDrag = DragProps.RestrictDragToWindow
    local GUIInstance:Frame = self.ref:getValue()
    --GUIInstance.AnchorPoint = Vector2.new()
    local NewPosition = GUIInstance.Position + UDim2.new(0,Delta.X,0,Delta.Y)
    GUIInstance.Position = NewPosition
    if ToRestrictDrag == true then
        local CurrentGuiSize = GUIInstance.AbsoluteSize
        local CurrentPosition = GUIInstance.AbsolutePosition
        local CurrentScreenSize = Vector2.new(Mouse.ViewSizeX, Mouse.ViewSizeY)
        if DragProps.RestrictDragWithTopRobloxBar == false then
            CurrentPosition += Vector2.new(0,RobloxTopBarSize) -- Aligned to Top Left
            CurrentScreenSize += Vector2.new(0, RobloxTopBarSize) --For some reason ViewSizeY doesn't count the top bar, and has an increased size on the bottom too.
        end
        if DragProps.RestrictDragWithBottomRobloxBar == false then
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
    local initialProps = props.InitialProps do
        initialProps[Roact.Ref] = self.ref;
    end
    local Children = props.Children do
        Children.TitleBar = Roact.createElement(TitleBarComponent,props.TitleBarProps);
        Children.ContentFrame = Roact.createElement(ContentComponent,props.ContentProps);
    end
    return Roact.createElement("Frame",initialProps,Children)
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

function Window:willUnmount()
    if self.DragWatcher ~= nil then
        self.DragWatcher = self.DragWatcher:Destroy()
    end
end

return Window