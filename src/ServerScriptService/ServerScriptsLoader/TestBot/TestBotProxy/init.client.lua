print("Booting TestBotProxy")
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
local Globals = ArcaneumGlobals
print(Globals)
local ClientConnectorClass = Globals.ClassFunctions.ClientConnector--local ClientConnector = require(script:WaitForChild("ClientConnector")):New("TestProxy")
local ClientConnector = ClientConnectorClass:New("TestProxy")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ProxyFunction = LocalPlayer:WaitForChild("ProxyFunction")
local ProxyEvent = LocalPlayer:WaitForChild("ProxyEvent")

ProxyEvent.OnClientEvent:Connect(function(Type,TestName, Data)

end)
Globals.ClassFunctions.Tester = require(script.Tester)
Globals.TestBot = {}
local RawData = {
    Client = {};
}
local ClientTestData = script:WaitForChild("Client",1) do
    if ClientTestData then
        RawData.Client = ClientTestData:GetChildren()
    end
end
local NumberOfTests = #RawData.Client
print("Number of Tests that should be carried out:",NumberOfTests)
local TestData = {
    Tests = table.create(NumberOfTests, nil);
}
local TargetPlayer = Players.LocalPlayer

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
OnRun()

print("TestBotProxy Booted")