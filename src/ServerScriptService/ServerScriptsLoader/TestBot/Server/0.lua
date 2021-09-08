--[[local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedModules = ReplicatedStorage:WaitForChild("Modules")]]
local Globals = _G.Arcaneum
--Globals tests
local ThisTest = Globals.ClassFunctions.Tester:New("Engine Foundation")
ThisTest:AddTest("Global Check", true, function()
    for GlobalVar,Data in pairs(Globals) do
        print(GlobalVar,Data)
    end
    return true
end)
ThisTest:AddTest("BaseClass Check", true, function()
    --local BaseClassMod = ReplicatedModules:WaitForChild("BaseClass") do
        --assert(BaseClassMod, "BaseClass doesn't exist in ReplicatedStorage.Modules!")
        local BaseClass = Globals.ClassFunctions.BaseClass--require(BaseClassMod)
        assert(BaseClass, "BaseClass didn't return anything!")
        local TestClassName = "BaseTestClass"
        local Object = BaseClass:New(TestClassName)
        assert(Object, "BaseClass didn't return an object!")
        --[[ListenForMessage(
            TestClassName .." has not overwritten Destroy!",
            nil,
            function() warn("BaseClassMod: Destroy test failed!") end
        )]]
        Object:Destroy()
    --end
    return true
end)
ThisTest:AddTest("Class Test", true, function()
    --local BaseClassMod = ReplicatedModules:WaitForChild("BaseClass")
    --local ClassMod = BaseClassMod:WaitForChild("Class") do
        --assert(ClassMod, "Class doesn't exist in ReplicatedStorage.Modules!")
        local NewClass = Globals.ClassFunctions.Class--require(ClassMod)
        assert(NewClass, "Class didn't return anything!")
        local TestClassName = "TestClass"
        local Object = NewClass:New(TestClassName)
        assert(Object, "BaseClass didn't return an object!")
        --[[ListenForMessage(
            TestClassName .." has not overwritten Destroy!",
            nil,
            function() warn("ClassMod: Destroy test failed!") end
        )]]
        Object:Destroy()
    --studend
    return true
end)
--[[local LogService = game:GetService("LogService")
local function ListenForMessage(Message:string,True:Function,False:Function)
    local MessageOutListener
    MessageOutListener = LogService.MessageOut:Connect(function()
        local History = LogService:GetLogHistory()
        local LatestMessage = History[#History]
        --print(LatestMessage)
        --print(OutputMessage, MessageType)
        local OutputMessage = ""
        for k,v in pairs(LatestMessage) do
            print(k,v)
            if k == "message" then
                OutputMessage = v
                print("Got the message!", v)
                break
            end
        end
        if OutputMessage == Message then
            if True then True() end
        else
            if False then False() end
        end
        MessageOutListener:Disconnect()
    end)
end]]
return ThisTest