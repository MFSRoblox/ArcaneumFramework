local Globals = _G.Arcaneum
Globals.ClassFunctions.Tester = require(script.Tester)
Globals.TestBot = {}
local RawData = {
    Server = {};
    Client = {};
}
local ServerTestData = script:WaitForChild("Server",1) do
    if ServerTestData then
        RawData.Server = ServerTestData:GetChildren()
    end
end
local ClientTestData = script:WaitForChild("Client",1) do
    if ClientTestData then
        RawData.Client = ClientTestData:GetChildren()
    end
end
local NumberOfTests = #RawData.Server+#RawData.Client
print("Number of Testers to check:",NumberOfTests)
local TestData = {
    Tests = table.create(NumberOfTests, nil);
    Positions = table.create(NumberOfTests, nil)
}
for Perspective, DataSet in next, RawData do
    table.sort(DataSet,function(a,b)
        local aSuc, aNum = pcall(function() return a.Name + 0 end)
        local bSuc, bNum = pcall(function() return b.Name + 0 end)
        assert(aSuc and bSuc,"One of these aren't a number! A: " .. a.Name .. ", B: " .. b.Name)
        return aNum < bNum
    end)
    for i=1, #DataSet do
        local ModuleScript = DataSet[i]
        local Position = ModuleScript.Name
        if TestData.Tests[Position] then warn("The test with the number \""..Position.."\" [",TestData.Tests[Position],"] was replaced by", ModuleScript) end
        TestData.Tests[Position] = {Perspective = Perspective; Tester = ModuleScript}
        table.insert(TestData.Positions,Position)
    end
end

local Players = game:GetService("Players")
local TestBotProxy = script.TestBotProxy
TestBotProxy.Disabled = false
local TargetPlayer do
    local CurrentPlayers = Players:GetPlayers()
    if #CurrentPlayers > 0 then
        TargetPlayer = CurrentPlayers[1]
    else
        warn("No Player")
        --TargetPlayer = Players.PlayerAdded:Wait()
    end
    if TargetPlayer then
        local ProxyFunction = Instance.new("RemoteFunction", TargetPlayer)
        ProxyFunction.Name = "ProxyFunction"
        local ProxyEvent = Instance.new("RemoteEvent", TargetPlayer)
        ProxyEvent.Name = "ProxyEvent"
    end
end
TestBotProxy.Parent = TargetPlayer.PlayerGui
Globals.TestBot.TestPlayer = TargetPlayer

RawData = nil
local Separator = "----------------------------------"
local function OnRun()
    for i=1, #TestData.Positions do
        local TesterData = TestData.Tests[TestData.Positions[i]]
        local Perspective = TesterData.Perspective
        local Module = TesterData.Tester
        local Tester = require(Module)
        if Tester.RunTests then
            local DisplayName = Tester.DisplayName
            local TestName = Tester.Name
            if Perspective == "Server" then
                print("\n\n"..Separator.."\n" .. DisplayName .. " will now start their tests (".. TestName ..").")
                local TesterFeedback = Tester:RunTests()
                print("\n\n"..DisplayName.." has finished their tests! Here's their report:")
                for j=1, #TesterFeedback do
                    local Result = TesterFeedback[j]
                    if Result.IsSuccessful then
                        print(Result)
                    else
                        warn(Result)
                    end
                end
                print(Separator .."\n\n")
            elseif Perspective == "Client" then
                print("\n\n"..Separator.."\n" .. DisplayName .. " will now start their tests (".. TestName ..").")
                local TesterFeedback = Tester:RunTests()
                print("\n\n"..DisplayName.." has finished their tests! Here's their report:")
                for j=1, #TesterFeedback do
                    local Result = TesterFeedback[j]
                    if Result.IsSuccessful then
                        print(Result)
                    else
                        warn(Result)
                    end
                end
                print(Separator .."\n\n")
            else
                warn("Unknown Perspective: ", Perspective, Module)
            end
        end
    end
    return true
end
return OnRun()