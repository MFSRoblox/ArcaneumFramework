local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalModuleName = "Arcaneum"
local Separator = "----------------------------------"
local ArcaneumGlobals repeat
    ArcaneumGlobals = ReplicatedStorage:FindFirstChild(GlobalModuleName)
    if ArcaneumGlobals == nil then
        task.wait(1)
    else
        ArcaneumGlobals = require(ArcaneumGlobals)
    end
until ArcaneumGlobals ~= nil
local TestBot = ArcaneumGlobals.ClassFunctions:GetClass("Class"):Extend(
    {
        ArcaneumGlobals = ArcaneumGlobals;
        Version = 0;
        Object = script;
        TestVariables = {};
        TesterClass = require(script.Tester);
        RawData = {
            Server = {};
            Client = {};
        };
        TestData = {
            Tests = {};
            Positions = {}
        }
    }
)
function TestBot:New(TestPlayer: Player | nil)
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
    self.RawData = RawData
    self.TestPlayer = TestPlayer
    local NumberOfTests = #RawData.Server+#RawData.Client
    print("Number of Testers to check:",NumberOfTests)
    local TestData = {
        Tests = table.create(NumberOfTests, nil);
        Positions = table.create(NumberOfTests, nil)
    }
    for Perspective, DataSet in next, RawData do
        table.sort(DataSet,function(a,b)
            local aSuc, aNum = pcall(function()
                return a.Name + 0
            end)
            local bSuc, bNum = pcall(function()
                return b.Name + 0
            end)
            assert(aSuc and bSuc,"One of these aren't a number! A: " .. a.Name .. ", B: " .. b.Name)
            return aNum < bNum
        end)
        for i=1, #DataSet do
            local ModuleScript = DataSet[i]
            local Position = ModuleScript.Name
            if TestData.Tests[Position] then
                warn("The test with the number \""..Position.."\" [",TestData.Tests[Position],"] was replaced by", ModuleScript)
            end
            TestData.Tests[Position] = {Perspective = Perspective; Tester = ModuleScript}
            table.insert(TestData.Positions,Position)
        end
    end
    TestBot.TestData = TestData
    local TestBotProxy = script.TestBotProxy do
        if TestPlayer ~= nil then
            TestBotProxy.Disabled = false
            local ProxyFunction = Instance.new("RemoteFunction")
            ProxyFunction.Name = "ProxyFunction"
            ProxyFunction.Parent = TestPlayer
            local ProxyEvent = Instance.new("RemoteEvent")
            ProxyEvent.Name = "ProxyEvent"
            ProxyEvent.Parent = TestPlayer
            TestBotProxy.Parent = TestPlayer.PlayerGui
            TestBot.TestPlayer = TestPlayer
        else
            TestBotProxy:Destroy()
        end
    end
    return self
end

function TestBot:Run()
    local TestData = self.TestData
    local FailedCounter, SkippedCounter = 0,0
    for i=1, #TestData.Positions do
        local TesterData = TestData.Tests[TestData.Positions[i]]
        local Perspective = TesterData.Perspective
        local Module = TesterData.Tester
        local Tester = require(Module)(self)
        if Tester == 3 then
            SkippedCounter += 1
            continue
        end
        if Tester.RunTests then
            local DisplayName = Tester.DisplayName
            local TestName = Tester.Name
            if Perspective == "Server" then
                print("\n\n"..Separator.."\n" .. DisplayName .. " will now start their tests (".. TestName ..").")
                local TesterFeedback = Tester:RunTests()
                print("\n\n"..DisplayName.." has finished their tests! Here's their report:")
                for j=1, #TesterFeedback do
                    local Result = TesterFeedback[j]
                    if Result.Status == "Successful" then
                        print(Result)
                    elseif Result.Status == "Skipped" then
                        SkippedCounter += 1
                        warn("Test was skipped!")
                    elseif Result.Status == "Failed" then
                        warn(Result)
                    else
                        warn("Test did not have a Status!")
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
    print(FailedCounter,"failed,", SkippedCounter, "skipped")
    return true
end

return TestBot