local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedModules = ReplicatedStorage:WaitForChild("Modules")
local GlobalsMod = ReplicatedModules:WaitForChild("Globals")
local Globals do
    if GlobalsMod then
        Globals = require(GlobalsMod)
    end
end
--Globals tests
do
    for GlobalVar,Data in pairs(Globals) do
        print(GlobalVar,Data)
    end
end
local LogService = game:GetService("LogService")
local function ListenForMessage(Message:String,True:Function,False:Function)
    local MessageOutListener do
        MessageOutListener = LogService.MessageOut:Connect(function(OutputMessage,MessageType)
            if OutputMessage == Message then
                if True then True() end
            else
                if False then False() end
            end
            MessageOutListener:Disconnect()
        end)
    end
end

--BaseClass tests
local BaseClassMod = ReplicatedModules:WaitForChild("BaseClass") do
    assert(BaseClassMod, "BaseClass doesn't exist in ReplicatedStorage.Modules!")
    local BaseClass = require(BaseClassMod)
    assert(BaseClass, "BaseClass didn't return anything!")
    local TestClassName = "BaseTestClass"
    local Object = BaseClass:New(TestClassName)
    assert(Object, "BaseClass didn't return an object!")
    ListenForMessage(
        TestClassName .." has not overwritten Destroy!",
        nil,
        function() warn("Destroy test failed!") end
    )
    Object:Destroy()
end
local ClassMod = BaseClassMod:WaitForChild("Class") do
    assert(ClassMod, "Class doesn't exist in ReplicatedStorage.Modules!")
    local NewClass = require(ClassMod)
    assert(NewClass, "Class didn't return anything!")
    local TestClassName = "TestClass"
    local Object = NewClass:New(TestClassName)
    assert(Object, "BaseClass didn't return an object!")
    ListenForMessage(
        TestClassName .." has not overwritten Destroy!",
        nil,
        function() warn("Destroy test failed!") end
    )
    Object:Destroy()
end