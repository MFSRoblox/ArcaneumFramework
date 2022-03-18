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
type InitializerProperties = {FilesToBoot:FilesToBoot}
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
    @type InitializerObject {FilesToBoot: {[FileName]: Array<SingletonInitClass>}}
    @within InitializerService

    The object created by [InitializerService:New] to initialize a batch of modules
]=]
--[=[
    Creates a new Initializer object. This is used to manage the inputted modules that need to be booted.
    @return InitializerObject
]=]
function InitializerService:New(): InitializerObject
    local NewService = setmetatable({
        FilesToBoot = {} :: {[FileName]: Array<SingletonInitClass>}; --A dictionary
        Output = {};
    },{__index = self})
    return NewService
end
--[=[
    @type ModuleInfo {InitName: string,BootOrder: number,Version: string,Dependacies: {[string]:string},__call: (table, table) -> table}
    @within InitializerService

    A ModuleScript that contains the metadata of the parent ModuleScript that's initialized.
]=]
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
    local FileContents: ModuleInfo = require(ModuleScript.ModuleInfo)
    assert(type(FileContents) == "table", string.format("ModuleScript %s either was already initialized or is not a table! %s", tostring(ModuleScript), debug.traceback()))
    local InitName = FileContents.InitName or ModuleScript.Name
    FileContents.InitName = InitName
    if self.InitializedModules[InitName] and self.InitializedModules[InitName][FileContents.Version] ~= nil then
        return
    end
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
    local FilesToBoot = self.FilesToBoot
    print("Ordering FilesToBoot:",FilesToBoot)
    local SortedFilesToBoot = {} :: Array<SingletonInitClass> do
        for _FileName, InitClasses in next, FilesToBoot do
            print("Inserting",InitClasses[1],"to SortedFilesToBoot...")
            table.insert(SortedFilesToBoot, InitClasses[1])
        end
    end
    table.sort(SortedFilesToBoot, function(File1:SingletonInitClass,File2:SingletonInitClass)
        if File1 ~= nil then
            if File2 ~= nil then
                return File1.BootOrder < File2.BootOrder
            else
                return true
            end
        else
            return false
        end
    end)
    print("Booting SortedFilesToBoot:",SortedFilesToBoot)
    local Output = self.Output
    local InitializedModules = self.InitializedModules
    for i=1, #SortedFilesToBoot do
        local FileToBoot = SortedFilesToBoot[i]
        local FileName = FileToBoot.InitName
        print("Initialing",FileName)
        if Output[FileName] ~= nil then
            warn(FileName,"was found in Boot! Potential Output override!")
        end
        Output[FileName] = FileToBoot(Globals)
        if InitializedModules[FileName] ~= nil then
            warn(FileName,"was found in InitializedModules! Potential InitializedModules override!")
        end
        InitializedModules[FileName] = {tostring(FileToBoot.Version)}
    end
    print("Done! Output:",Output)
    print("Cleaning up...")
    self:Destroy()
    return Output
end

--[=[
    A helper function used to verify all of the required dependacies, and then set the order of the boot groups according to the dependacies.
    @param _Globals table?
    @return nil
]=]
function InitializerService:CheckDependacies(_Globals: table?)
    type FileNameVersion = string
    local Dependacies:{[FileNameVersion]: {Object: DependacyObject; InitObj: SingletonInitClass; Dependants: Array<SingletonInitClass>}} = {}
    local DependacyOrder: Array<FileNameVersion> = {}
    --Generally, if a module needs another to function, the other file needs to be initialized first. Thus, if we track the modules that are depended upon, then we can sort the order they should launch in.
    local FilesToBoot: FilesToBoot = self.FilesToBoot
    for FileName, FileInits in next, FilesToBoot do --initial setup and add to group, get dependacies
        assert(type(FileInits) == "table", "FileContents of " .. FileName .." is not a table! " .. debug.traceback())
        assert(#FileInits > 0, "FileContents table of " .. FileName .." doesn't have at least one module! " .. debug.traceback())
        local FileToBoot = FileInits[1] do
            local FileToBootVersion = FileToBoot.Version
            for i=2, #FileInits do --Check to see if there are more up-to-date versions
                local InitInfo = FileInits[i]
                local FileVersion = InitInfo.Version
                if InitInfo.Version > FileToBootVersion then
                    FileToBoot = InitInfo
                    FileToBootVersion = FileVersion
                elseif FileVersion == FileToBootVersion then
                    warn("A duplicate version was found when sorting through "..FileName.."! This should be checked, especially if it's the latest version! Duplicate version:",FileVersion,debug.traceback())
                end
            end
        end
        print("FileToBoot.Name:",FileToBoot.InitName)
        print("FileToBoot.Dependacies:",FileToBoot.Dependacies)
        local ThisFileDependacies: Array<DependacyObject> = FileToBoot.Dependacies
        for _, Dependacy in next, ThisFileDependacies do
            local DependacyKey = tostring(Dependacy)
            local DependacyInitObj do
                local FileInitObjs = FilesToBoot[Dependacy.FileName]
                if FileInitObjs then
                    for i=1, #FileInitObjs do
                        local PotentialInitObj = FileInitObjs[i]
                        if PotentialInitObj.Version == Dependacy.Version then
                            DependacyInitObj = PotentialInitObj
                        end
                    end
                    
                end
            end
            local DependacyCluster = Dependacies[DependacyKey]
            if not DependacyCluster then
                DependacyCluster = {
                    Object = Dependacy;
                    InitObj = DependacyInitObj;
                    Dependants = {}
                }
                Dependacies[DependacyKey] = DependacyCluster
            --[[elseif not table.find(DependacyCluster,DependacyVersion) then
                warn("Alternative Version for " .. DependacyFileName .. " requested by " .. FileName .."!".. debug.traceback())
                table.insert(DependacyCluster,DependacyVersion)]]
            end
            table.insert(DependacyCluster.Dependants,FileToBoot)
            table.insert(DependacyOrder,DependacyKey)
        end
        --self:AddToBootGroup(FileToBoot)
    end
    --order the DependacyOrder
    table.sort(DependacyOrder, function(Dependacy1:FileNameVersion,Dependacy2:FileNameVersion)
        local Dependacy1Obj = Dependacies[Dependacy1].InitObj
        local Dependacy2Obj = Dependacies[Dependacy2].InitObj
        if Dependacy1Obj ~= nil then
            if Dependacy2Obj ~= nil then
                return Dependacy1Obj.BootOrder < Dependacy2Obj.BootOrder
            else
                return true
            end
        else
            return false
        end
    end)
    for i=1, #DependacyOrder do
        local DependacyNameVersion = DependacyOrder[i]
        local DependacyInfo = Dependacies[DependacyNameVersion]
        print("Getting Dependacy:",DependacyNameVersion)
        local DependacyName = DependacyInfo.Object.FileName
        local DependacyInitObj = DependacyInfo.InitObj
        print("DependacyInitObj:",DependacyInitObj)
        if DependacyInitObj then --if the dependacy is in the same boot section, then make sure it is in a boot group that launches before all of the other dependants.
            --local DependacyVersion = DependacyInfo.Object.Version
            --local DependacyInitObj = DependacyInitObj[tostring(DependacyVersion)]
            local EarliestBootOrder = DependacyInitObj.BootOrder
            local Dependants = DependacyInfo.Dependants
            for j=1, #Dependants do
                local ThisDependant = Dependants[j]
                local DependantBootOrder = ThisDependant.BootOrder
                if EarliestBootOrder >= DependantBootOrder then
                    EarliestBootOrder = DependantBootOrder - 1
                end
            end
            DependacyInitObj.BootOrder = EarliestBootOrder
        else
            local InitializedModule = self.InitializedModules[DependacyName]
            if InitializedModule then
                for j=1, #DependacyInfo do
                    local DependacyVersion = DependacyInfo[j]
                    if InitializedModule[tostring(DependacyVersion)] ~= nil then
                        print("Environment already has",DependacyNameVersion,"initialized. Next!")
                        continue
                    end
                end
            else
                warn(DependacyNameVersion,"is needed, but was never found in FilesToBoot!\nFilesToBoot:",FilesToBoot,"\nInitializedModules:",self.InitializedModules,"\nDebug:",debug.traceback())
            end
        end
    end
    
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
    self = nil
end

return InitializerService