local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedModules = ReplicatedStorage:WaitForChild("Modules")
local Utilities do
    local Module = ReplicatedModules:WaitForChild("ScriptUtilities")
    Utilities = require(Module)
end
local PlayerState = {}
PlayerState.__index = PlayerState

local TrackerSubmodules = Utilities:ModulesToTable(script:GetChildren())

function PlayerState.new(Player: Player)
    local self = {}
    setmetatable(self, PlayerState)
    self.Player = Player
    self.ClassName = "PlayerStateTracker"
    Players.PlayerRemoving:Connect(function(player) if Player == player then self:Remove() end end)
    self.Loaded = false
    self.LastAction = nil
    self.Class = nil
    self.Resources = {}
    self.Permissions = {}
    self.Equipment = {}
    self.Inventory = {}
    self.Abilities = {}
    return self
end

function PlayerState:LoadState(StateData: Dictionary)
    self.Loaded = false
    for StateName, Data in StateData, next do
        local Submodule = TrackerSubmodules[StateName]
        if Submodule then
            self[StateName] = Submodule.new(Data)
        else
            self[StateName] = Data
        end
    end
    self.Loaded = true
end

function PlayerState:FreshState() --Good for debugging, should be called if this is the first time a player has played
    self.Loaded = false
    self.Class = TrackerSubmodules["ClassTracker"]
    self.Loaded = true
end

local function CheckWhitelist(Permissions: Dictionary, AllowedDataSet: Dictionary, OnAccess: Function)
    for PermissionType, Permitted in Permissions, next do
        if Permitted then
            local AllowedData = AllowedDataSet[PermissionType]
            for i=1, #AllowedData do
                local DataName = AllowedData[i]
                OnAccess(DataName)
            end
        end
    end
end

local AllowedGet = {
    Developer = {"Player","LastAction","Class","Resources","Permissions","Equipment","Inventory","Abilities"},
    Moderator = {"Player","LastAction","Class","Resources","Permissions","Equipment","Inventory","Abilities"},
    CurrentPlayer = {"Player","LastAction","Class","Resources","Equipment","Inventory","Abilities"},
    OtherPlayer = {"Player","Class","Resources","Equipment","Abilities"},
}

function PlayerState:GetState(Permissions:Dictionary, ...)
    local RequestedStates = {...}
    local Output = {}
    if #RequestedStates > 0 then
        if Permissions then
            CheckWhitelist(Permissions,AllowedGet,function(DataName)
                local RequestedStatePosition = table.find(RequestedStates, DataName)
                if RequestedStatePosition then
                    if Output[DataName] == nil then Output[DataName] = self[DataName] end
                    table.remove(RequestedStates,RequestedStatePosition)
                end
            end)
        else
            for i=1, #RequestedStates do
                local DataName = RequestedStates[i]
                if Output[DataName] == nil then Output[DataName] = self[DataName] end
            end
        end
    else
        if Permissions then
            for PermissionType, Permitted in Permissions, next do
                if Permitted then
                    local AllowedData = AllowedGet[PermissionType]
                    for i=1, #AllowedData do
                        local DataName = AllowedData[i]
                        if Output[DataName] == nil then Output[DataName] = self[DataName] end
                    end
                end
            end
        else
            Output = self
        end
    end
    return Output
end

local AllowedSet = {
    Developer = {"Player","LastAction","Class","Resources","Permissions","Equipment","Inventory","Abilities"},
    Moderator = {},
    CurrentPlayer = {"LastAction","Class","Resources","Equipment","Inventory","Abilities"},
    OtherPlayer = {},
}

function PlayerState:SetState(Permissions:Dictionary, StateName:String, StateValue)
    local StateObject = self[StateName]
    if StateObject then
        local function SetState(Value)
            if StateObject["ClassName"] then
                StateObject:SetState(Value)
            else
                self[StateName] = Value
            end
        end
        if Permissions then
            CheckWhitelist(Permissions,AllowedSet,function(DataName)
                SetState(StateValue)
            end)
        end
    else
        warn(self,"was requested to set an invalid state! StateName:", StateName)
    end
end

return PlayerState