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
    },self)
    return NewService
end

--[[
    Adds a ModuleScript to self.FilesToBoot[ModuleScript.Name].
    @param ModuleScript ModuleScript
]]
function InitializerService:AddModule(ModuleScript: ModuleScript)
    assert(ModuleScript ~= nil, "No ModuleScript passed in for InitializerService!" .. debug.traceback())
    local FileName = ModuleScript.Name
    local FileContents = require(ModuleScript)
    FileContents.InitName = FileContents.InitName or FileName
    assert(type(FileContents) == "table", string.format("ModuleScript %s either was already initialized or is not a table! %s", ModuleScript, debug.traceback()))
    local BootPriority = FileContents.BootPriority
    assert(BootPriority ~= nil, string.format("ModuleScript %s does not have a BootPriority! %s", ModuleScript, debug.traceback()))
    assert(type(BootPriority) == "number", string.format("ModuleScript %s BootPriority is not a number! %s", ModuleScript, debug.traceback()))
    local Dependacies = FileContents.Dependacies
    local FileBootIndex = self.FilesToBoot[FileName]
    if FileBootIndex == nil then
        self.FilesToBoot[FileName] = {}
        FileBootIndex = self.FilesToBoot[FileName]
    end
    --[[if FileBootIndex[Version] ~= nil then
        warn("The FileBootIndex of",ModuleScript,"with a Version of",Version,"already exists!")
    end]]
    table.insert(FileBootIndex,SingletonInitClass:NewFromDictionary(FileContents))
end

function InitializerService:Initialize()
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
    for i=1, #BootOrders do
        local CurrentOrder = BootOrders[i]
        local CurrentGroup = BootGroups[CurrentOrder]
        for j=1, #CurrentGroup do
            local FileToBoot = CurrentGroup[j]
            FileToBoot()
        end
    end
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