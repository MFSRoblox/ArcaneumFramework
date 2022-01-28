--[=[
    @class InitializerService
    @server
    @client
    A service that sets up the order of initialization of module scripts and the actual initialization of those scripts.
    It takes into consideration the BootOrder of said scripts, alongside the dependacies required to initialize the scripts.
    The metadata of the script initialization occurs in the "ModuleInfo" module that is childed to the script.
]=]
local InitializerService do
    InitializerService = setmetatable({
        InitializedModules = {} :: {[string]: SingletonInitClass}
    },{__index = InitializerService})
end
type FileName = string
type FilesToBoot = {[FileName]: Array<SingletonInitClass>}
type FilesWillBoot = {}
type BootOrder = number
type BootGroup = Array<SingletonInitClass>
type BootGroups = {[BootOrder]: BootGroup}
type InitializerProperties = {FilesToBoot:FilesToBoot, FilesWillBoot:FilesWillBoot, BootGroups:BootGroups}
type InitializerObject = typeof(InitializerService:New()) & InitializerProperties
local DataTypesFolder = script.Parent.BaseClass.DataTypes
local VersionClass = require(DataTypesFolder.Version)
type VersionProperties = {
    MajorVersion : number;
    MinorVersion : number;
    PatchVersion : number;
}
type Version = typeof(VersionClass.new(0,0,0)) & VersionProperties
local DependacyClass = require(DataTypesFolder.DependacyObject)
type DependacyProperties = {FileName: FileName, Version: Version}
type DependacyObject = typeof(DependacyClass.new("",VersionClass.new())) & DependacyProperties
local SingletonInitClass = require(script.SingletonInitClass)
type SingletonInitClass = typeof(SingletonInitClass:New("","0.0.0",{},function() end,{},0))
--[=[
    A quick initialize module method that returns the module's contents with dependacies initialized, too.

    @param ModuleScript ModuleScript
    @param Globals table?
    @return module
]=]
function InitializerService:InitializeModule(ModuleScript: ModuleScript, Globals: table?): any
    local TempInitializer = self:New()
    TempInitializer:AddModule(ModuleScript)
    return TempInitializer:InitializeAll(Globals)[ModuleScript.Name]
end
--[=[
    Creates a new Initializer object. This is used to manage the inputted modules that need to be booted.
    @return InitializerObject
]=]
function InitializerService:New(): InitializerObject
    local NewService = setmetatable({
        FilesToBoot = {} :: {[FileName]: Array<SingletonInitClass>}; --A dictionary
        FilesWillBoot = {};
        BootGroups = {} :: {[BootOrder]: BootGroup};
    },{__index = self})
    return NewService
end

type ModuleInfo = {
    InitName: string,
    BootOrder: number,
    Version: string,
    Dependacies: {
        [string]:string
    },
    __call: (table, table) -> table
}
--[=[
    Adds a ModuleScript to self.FilesToBoot[ModuleScript.Name]. All modules will be added here will be initialized once [InitializerService:InitializeAll] is called.
    @param ModuleScript ModuleScript
]=]
function InitializerService:AddModule(ModuleScript: ModuleScript)
    assert(ModuleScript ~= nil, "No ModuleScript passed in for InitializerService!" .. debug.traceback())
    if self.InitializedModules[ModuleScript] ~= nil then
        return
    end
    local FileContents: ModuleInfo = require(ModuleScript.ModuleInfo)
    assert(type(FileContents) == "table", string.format("ModuleScript %s either was already initialized or is not a table! %s", tostring(ModuleScript), debug.traceback()))
    local InitName = FileContents.InitName or ModuleScript.Name
    FileContents.InitName = InitName
    local BootOrder = FileContents.BootOrder
    assert(BootOrder ~= nil, string.format("ModuleScript %s does not have a BootOrder! %s", tostring(ModuleScript), debug.traceback()))
    assert(type(BootOrder) == "number", string.format("ModuleScript %s BootOrder is not a number! %s", tostring(ModuleScript), debug.traceback()))
    local FileBootIndex = self.FilesToBoot[InitName]
    if FileBootIndex == nil then
        FileBootIndex = {}
        self.FilesToBoot[InitName] = FileBootIndex
    end
    --[[if FileBootIndex[Version] ~= nil then
        warn("The FileBootIndex of",ModuleScript,"with a Version of",Version,"already exists!")
    end]]
    table.insert(FileBootIndex,SingletonInitClass:NewFromDictionary(FileContents))
end

--[=[
    The method that tells the Initializer to launch all of the requested modules and their dependacies. It returns a dictionary under the format of {"ModuleName" = ModuleContents}.

    @param Globals table?
    @return Dictionary<Modules>
]=]
function InitializerService:InitializeAll(Globals: table?): {[string]: any}
    self:CheckDependacies(Globals)
    local BootGroups:BootGroups = self.BootGroups --Get current BootGroups dictionary
    local BootOrders: Array<BootOrder> = {} do --Grab all of the BootOrder keys from BootGroups and sort them
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
    local Output = {}
    for i=1, #BootOrders do
        local CurrentOrder = BootOrders[i]
        local CurrentGroup = BootGroups[CurrentOrder]
        for j=1, #CurrentGroup do
            local FileToBoot = CurrentGroup[j]
            print("Initialing",FileToBoot.InitName)
            Output[FileToBoot.InitName] = FileToBoot(Globals)
        end
    end
    self:Destroy()
    return Output
end

--[=[
    A helper function used to verify all of the required dependacies, and then set the order of the boot groups according to the dependacies.
    @param _Globals table?
    @return nil
]=]
function InitializerService:CheckDependacies(_Globals: table?)
    local Dependacies:{[FileName]: Array<Version>} = {}
    local FilesToBoot: FilesToBoot = self.FilesToBoot
    for FileName, FileContents in next, FilesToBoot do --initial setup and add to group, get dependacies
        assert(type(FileContents) == "table", "FileContents of " .. FileName .." is not a table! " .. debug.traceback())
        assert(#FileContents > 0, "FileContents table of " .. FileName .." doesn't have at least one module! " .. debug.traceback())
        local FileToBoot = FileContents[1] do
            local FileToBootVersion = FileToBoot.Version
            for i=2, #FileContents do --Check to see if there are more up-to-date versions
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
        print("FileToBoot.Name:",FileToBoot.InitName)
        print("FileToBoot.Dependacies:",FileToBoot.Dependacies)
        local ThisFileDependacies: Array<DependacyObject> = FileToBoot.Dependacies
        for _, Dependacy in next, ThisFileDependacies do
            local DependacyFileName: FileName = Dependacy:GetFileName()
            local DependacyVersion: Version = Dependacy:GetVersion()
            local DependacyCluster = Dependacies[DependacyFileName]
            if not DependacyCluster then
                Dependacies[DependacyFileName] = {DependacyVersion}
            elseif not table.find(DependacyCluster,DependacyVersion) then
                warn("Alternative Version for " .. DependacyFileName .. " requested by " .. FileName .."!".. debug.traceback())
                table.insert(DependacyCluster,DependacyVersion)
            end
        end
        self:AddToBootGroup(FileToBoot)
    end
    for DependacyName, DependacyVersions in next, Dependacies do
        local PotentialDependacyFiles = FilesToBoot[DependacyName]
        if PotentialDependacyFiles then
            for i=1, #DependacyVersions do
                local DependacyVersion = DependacyVersions[i]
                local Success = false
                print("DependacyVersion:",DependacyVersion)
                for j=1, #PotentialDependacyFiles do
                    local ThisInitObject = PotentialDependacyFiles[j]
                    print("ThisInitObject.Version:",ThisInitObject.Version)
                    if ThisInitObject.Version == DependacyVersion then
                        self:AddToBootGroup(ThisInitObject)
                        Success = true
                        break
                    end
                end
                if Success == false then
                    warn("Could not find",DependacyName,DependacyVersions,"! Potential errors will likely occur! Debug:",debug.traceback())
                end
            end
        else
            local InitializedModule = self.InitializedModules[DependacyName]
            if InitializedModule then
                --stuff
            else
                warn(DependacyName,"is needed, but was never found in FilesToBoot!\nFilesToBoot:",FilesToBoot,"\nDebug:",debug.traceback())
            end
        end
    end
end

function InitializerService:AddToBootGroup(SingletonInitObject: SingletonInitClass)
    local BootGroups: BootGroups = self.BootGroups
    local BootOrder = SingletonInitObject.BootOrder
    local BootGroup = BootGroups[BootOrder]
    if BootGroup == nil then
        BootGroup = {} :: BootGroup --empty bootgroup
    end
    local CurrentInitName = SingletonInitObject.InitName
    for i=1, #BootGroup do
        local InitObject = BootGroup[i]
        if InitObject.InitName == CurrentInitName then
            warn("Duplicate InitGroup found! Not inserting duplicate! Debug:",debug.traceback())
            return
        end
    end
    table.insert(BootGroup,SingletonInitObject)
    BootGroups[BootOrder] = BootGroup
end

function InitializerService:Destroy()
    for FileName, FileContents in next, self.FilesToBoot do
        for i=1, #FileContents do
            FileContents[i] = nil
        end
        FileContents = nil
        self.FilesToBoot[FileName] = nil
    end
    self.FilesToBoot = nil
    for BootOrderNumber, BootGroup in next, self.BootGroups do
        for i=1, #BootGroup do
            BootGroup[i] = nil
        end
        BootGroup = nil
        self.BootGroups[BootOrderNumber] = nil
    end
    self.BootGroups = nil
    self = nil
end

return InitializerService