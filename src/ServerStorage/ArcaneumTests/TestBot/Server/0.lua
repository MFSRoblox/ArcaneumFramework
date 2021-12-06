--[[local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedModules = ReplicatedStorage:WaitForChild("Modules")]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
local ArcaneumGlobals repeat
    ArcaneumGlobals = ReplicatedStorage:FindFirstChild(GlobalModuleName)
    if ArcaneumGlobals == nil then
        task.wait(1)
    else
        ArcaneumGlobals = require(ArcaneumGlobals)
    end
until ArcaneumGlobals ~= nil
--Globals tests
local ThisTest = ArcaneumGlobals.ClassFunctions.Tester:New("Engine Foundation")
ThisTest:AddTest("Global Check", true, function()
    for GlobalVar,Data in pairs(ArcaneumGlobals) do
        print(GlobalVar,Data)
    end
    return true
end)
ThisTest:AddTest("BaseClass Check", true, function()
    --local BaseClassMod = ReplicatedModules:WaitForChild("BaseClass") do
        --assert(BaseClassMod, "BaseClass doesn't exist in ReplicatedStorage.Modules!")
        local BaseClass = ArcaneumGlobals.ClassFunctions.Class--require(BaseClassMod)
        assert(BaseClass, "BaseClass didn't return anything!")
        local TestClassName = "BaseTestClass"
        local Object = BaseClass:New(TestClassName)
        assert(Object, "BaseClass didn't return an object!")
        Object:Destroy()
    --end
    return true
end)
--[[ThisTest:AddTest("Class Test", true, function()
    --local BaseClassMod = ReplicatedModules:WaitForChild("BaseClass")
    --local ClassMod = BaseClassMod:WaitForChild("Class") do
        --assert(ClassMod, "Class doesn't exist in ReplicatedStorage.Modules!")
        local NewClass = Globals.ClassFunctions.Class--require(ClassMod)
        assert(NewClass, "Class didn't return anything!")
        local TestClassName = "TestClass"
        local Object = NewClass:New(TestClassName)
        assert(Object, "BaseClass didn't return an object!")
        Object:Destroy()
    --studend
    return true
end)]]
return ThisTest