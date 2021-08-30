print("Booting TestBotProxy")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ProxyFunction = LocalPlayer:WaitForChild("ProxyFunction")

local ProxyFunctions = {
    Ping = function(ReturnValue)
        print("Pinged by server!")
        return ReturnValue
    end;
}
ProxyFunction.OnClientInvoke = function(FunctionName,...)
    return ProxyFunctions[FunctionName](...)
end

print("TestBotProxy Booted")