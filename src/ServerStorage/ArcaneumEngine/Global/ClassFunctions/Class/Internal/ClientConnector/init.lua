local Globals = _G.Arcaneum
local BaseClass = require(script.Parent)

local MailClass do
    local Mod = script:WaitForChild("Mail")
    if Mod then
        MailClass = require(Mod)
    end
end

local ClientConnector = BaseClass:Extend({
    Version = 2;
    Object = script;
    Timeout = 10;
})
type ClientConnector = table
function ClientConnector:New(Name: string, TargetPlayer: Player): ClientConnector
    local NewConnector = self:Extend(BaseClass:New("ClientConnector",Name))
    --local TargetPlayer = Globals.TestBot.TestPlayer
    NewConnector.TargetPlayer = TargetPlayer
    assert(TargetPlayer, "No TargetPlayer found!")
    local ProxyFunction = TargetPlayer:WaitForChild("ProxyFunction", 10)
    NewConnector.ProxyFunction = ProxyFunction
    assert(ProxyFunction, "No ProxyInterface found!")
    local ProxyEvent = TargetPlayer:WaitForChild("ProxyEvent", 10)
    NewConnector.ProxyEvent = ProxyEvent
    assert(ProxyEvent, "No ProxyEvent found!")
    NewConnector.Mailbox = {}
    NewConnector.Connections["ProxyListener"] = ProxyEvent.OnServerEvent:Connect(function(Player: Player, Type: string, PacketName: string, Data: table)
        if TargetPlayer == Player then
            local PacketHandler = NewConnector["Got"..tostring(Type)]
            if PacketHandler then
                PacketHandler(NewConnector,PacketName, Data)
            else
                warn("Received invalid ProxyEvent Type from "..tostring(Player).."!")
            end
        end
    end)
    return NewConnector
end

function ClientConnector:GotSend(PacketName: string, Data: table): boolean -- If the player has sent a packet to this connector.
    local ThisMail = self.Mailbox[PacketName]
    if ThisMail.Status < 3 then
        ThisMail:SetContents(Data)
        self.ProxyEvent:FireClient(self.TargetPlayer,"Receive",PacketName)
        return true
    else
        print("Got SEND extra packets for:", PacketName)
        return false
    end
end

function ClientConnector:GotReceive(PacketName: string, Data: table): boolean -- If the player has recieved a packet from this connector.
    local ThisMail = self.Mailbox[PacketName]
    if ThisMail.Status < 2 then
        ThisMail:SetStatus(2)
        return true
    else
        print("Got RECEIVE extra packets for:", PacketName)
        return false
    end
    if Data ~= nil then
        print("Got RECEIVE Data, but it isn't really used:", Data)
    end
end

function ClientConnector:FireClient(PacketName: string, Data: table)
    self.ProxyEvent:FireClient(self.TargetPlayer,"Send",PacketName,Data)
end

function ClientConnector:StartMail(BaseName: string)
    local RealName = BaseName or "UnnamedMail"
    local ExistingMail = self.Mailbox[RealName]
    local Counter = 1
    while ExistingMail do
        RealName = BaseName..tostring(Counter)
        ExistingMail = self.Mailbox[RealName]
    end
    local NewMail = MailClass:New(RealName)
    self.Mailbox[RealName] = NewMail
    return NewMail
end

function ClientConnector:InvokeClient(TestName, Data): boolean
    local Timeout = self.Timeout
    local Success = false
    local WatchedMail = self:StartMail(TestName)
    self:FireClient(TestName,Data)
    local Result
    local Counter = 0
    repeat
        Result = WatchedMail:GetContents()
        Counter += task.wait()
    until not Result or Counter > Timeout
    if Counter <= Timeout then
        Success = true
    end
    return Success, Result
end

function ClientConnector:Destroy(): boolean
    self.EventFunctions = nil
    self.TargetPlayer = nil
    self.ProxyFunction = nil
    self.ProxyEvent = nil
    return BaseClass.Destroy(self)
end

print(ClientConnector)
return ClientConnector