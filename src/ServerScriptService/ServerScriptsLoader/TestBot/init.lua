local Globals = _G.Arcaneum
Globals.ClassFunctions.Tester = require(script.Tester)
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
local Separator = "----------------------------------"
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
    for _,Tester in next, TestData.Server do
        Tester = require(Tester)
        local DisplayName = Tester.DisplayName
        local TestName = Tester.Name
        if Tester.RunTests then
            print("\n\n"..Separator.."\n" .. DisplayName .. " will now start their tests (".. TestName ..").")
            local TesterFeedback = Tester:RunTests()
            print("\n\n"..DisplayName.." has finished their tests! Here's their report:")
            for i=1, #TesterFeedback do
                local Result = TesterFeedback[i]
                if Result.IsSuccessful then
                    print(Result)
                else
                    warn(Result)
                end
            end
            print(Separator .."\n\n")
        end
    end
    return true
end
return OnRun()