local Globals = _G.Arcaneum
_G.Arcaneum.ClassFunctions.Tester = require(script.Tester)
local Utilities = Globals.Utilities
local TestData = {
    Client = {};
    Server = {};
}
local ServerTestData = script:WaitForChild("Server",1) do
    if ServerTestData then
        TestData.Server = ServerTestData:GetChildren()
    end
end
local ClientTestData = script:WaitForChild("Client",1) do
    if ClientTestData then
        TestData.Client = ClientTestData:GetChildren()
    end
end
local function OnRun()
    for DataSetName, Data in next, TestData do
        table.sort(Data,function(a,b)
            local aSuc, aNum = pcall(function() return a.Name + 0 end)
            local bSuc, bNum = pcall(function() return b.Name + 0 end)
            if aSuc and bSuc then
                return aNum < bNum
            else
                warn("One of these aren't a number! A: " .. a.Name .. ", B: " .. b.Name)
            end
        end)
    end
    for i,Tester in next, TestData.Server do
        Tester = require(Tester)
        if Tester.RunTests then
            local TesterFeedback = Tester:RunTests()
            print(TesterFeedback)
        end
    end
    return true
end
return OnRun()