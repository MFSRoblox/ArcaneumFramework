--[=[
    @class InitializerService
    @server
    @client
    A service that sets up the order of initialization of module scripts and the actual initialization of those scripts.
]=]
local InitializerService do
    InitializerService = setmetatable({},{__index = InitializerService})
end
local SingletonInitClass = require(script.SingletonInitClass)
--[=[
    @return InitializerObject
]=]
function InitializerService:New()
    local NewService = setmetatable({
        FilesToBoot = {}; --A dictionary
        BootGroups = {};
    },{__index = self})
    return NewService
end

--[[
    Adds a ModuleScript to self.FilesToBoot[ModuleScript.Name].
    @param ModuleScript ModuleScript
]]
function InitializerService:AddModule(ModuleScript: ModuleScript)
    assert(ModuleScript ~= nil, "No ModuleScript passed in for InitializerService!" .. debug.traceback())
    local FileContents = require(ModuleScript.ModuleInfo)
    local InitName = FileContents.InitName or ModuleScript.Name
    FileContents.InitName = InitName
    assert(type(FileContents) == "table", string.format("ModuleScript %s either was already initialized or is not a table! %s", tostring(ModuleScript), debug.traceback()))
    local BootOrder = FileContents.BootOrder
    assert(BootOrder ~= nil, string.format("ModuleScript %s does not have a BootOrder! %s", tostring(ModuleScript), debug.traceback()))
    assert(type(BootOrder) == "number", string.format("ModuleScript %s BootOrder is not a number! %s", tostring(ModuleScript), debug.traceback()))
    local FileBootIndex = self.FilesToBoot[InitName]
    if FileBootIndex == nil then
        self.FilesToBoot[InitName] = {}
        FileBootIndex = self.FilesToBoot[InitName]
    end
    --[[if FileBootIndex[Version] ~= nil then
        warn("The FileBootIndex of",ModuleScript,"with a Version of",Version,"already exists!")
    end]]
    table.insert(FileBootIndex,SingletonInitClass:NewFromDictionary(FileContents))
end

function InitializerService:Initialize(Globals: table?): table
    local FilesToBoot = self.FilesToBoot
    for FileName, FileContents in next, FilesToBoot do
        assert(type(FileContents) == "table", "FileContents of " .. FileName .." is not a table! " .. debug.traceback())
        assert(#FileContents > 0, "FileContents table of " .. FileName .." doesn't have at least one module! " .. debug.traceback())
        local FileToBoot = FileContents[1] do
            local FileToBootVersion = FileToBoot.Version
            for i=2, #FileContents do
                local Content = FileContents[i]
                local ContentVersion = Content.Version
                if Content.Version > FileToBootVersion then
                    FileToBoot = Content
                    FileToBootVersion = ContentVersion
                elseif ContentVersion == FileToBootVersion then
                    warn("A duplicate version was found when sorting through "..FileName.."! This should be checked, especially if it's the latest version! Duplicate version:",ContentVersion,debug.traceback())
                end
            end
        end
        self:AddToBootGroup(FileToBoot)
    end
    local BootGroups = self.BootGroups
    local BootOrders = {} do
        for BootOrder, _ in next, BootGroups do
            local PreviousOrder = table.find(BootOrders,BootOrder)
            if PreviousOrder == nil then
                table.insert(BootOrders, BootOrder)
            end
        end
        table.sort(BootOrders,function(OrderA: number,OrderB: number)
            return OrderA < OrderB
        end)
    end
    Globals = Globals or {}
    for i=1, #BootOrders do
        local CurrentOrder = BootOrders[i]
        local CurrentGroup = BootGroups[CurrentOrder]
        for j=1, #CurrentGroup do
            local FileToBoot = CurrentGroup[j]
            print("Initialing",FileToBoot.InitName)
            Globals[FileToBoot.InitName] = FileToBoot(Globals)
            
        end
    end
    return Globals
end

function InitializerService:AddToBootGroup(SingletonInitObject: table)
    local BootGroups = self.BootGroups
    local BootOrder = SingletonInitObject.BootOrder
    local BootGroup = BootGroups[BootOrder]
    if BootGroup == nil then
        BootGroup = {}
    end
    local CurrentInitName = SingletonInitObject.InitName
    for i=1, #BootGroup do
        local InitObject = BootGroup[i]
        if InitObject.InitName == CurrentInitName then
            warn("Duplicate InitGroup found!",debug.traceback())
        end
    end
    table.insert(BootGroup,SingletonInitObject)
    BootGroups[BootOrder] = BootGroup
end

function InitializerService:Destory()

end

return InitializerService