--[=[
    @class BaseClass
    @server
    @client
    The foundational class for all classes.
]=]
local BaseClass: BaseClass = {
    ClassName = "BaseClass";
    Version = "1.0.0";
}
export type BaseClass = {
    ClassName: string;
    Version: string;
} & typeof(BaseClass)
--[=[
    @prop ClassName string
    @within BaseClass
    The name of the object's class.
]=]
--[=[
    @prop Version string
    @within BaseClass
    The version of the object's class.
]=]

--[=[
    This is a very fancy function that sets the index of the table so you don't need to repeatedly .__index and setmetatable.

    @param NewObject table -- The table you want to set the __index metatable to.
    @return table -- Returns the table with the index set to itself.
]=]
function BaseClass:Extend(NewObject): BaseClass
    NewObject = NewObject or {}
    if NewObject.ClassName == nil then
        NewObject.ClassName = ""
    end
    if NewObject.Version == nil then
        NewObject.Version = "0.0.0"
    end
    self.__index = self
    local output = setmetatable(NewObject, self)
    return output
end

--[=[
    Creates a new BaseClass object with a ClassName of "ClassName".

    @param ClassName string -- The name of the class being created.
    @param Version string -- The name version of the class being created.
    @return NewBaseClass -- Returns an object with the ClassName of "ClassName".
]=]
function BaseClass:New(ClassName:string, Version:string): BaseClass
    return self:NewFromTable({}, ClassName, Version)
end

--[=[
    Creates a new BaseClass object from a premade table with a ClassName of "ClassName".

    @param ClassName string -- The name of the class being created.
    @return NewBaseClass -- Returns an object with the ClassName of "ClassName".
]=]
function BaseClass:NewFromTable(Table: table, ClassName:string, Version:string): BaseClass
    Table.ClassName = ClassName or ""
    Table.Version = Version or "0.0.0"
    return self:Extend(Table)
end

--[=[
    Checks if the inputted version is the class's current version. If not, put a message on the console.

    @param VersionUsed Version | string -- The version of the class that the code has used.
    @return self -- Returns the object itself for easily checks on initialization.

    @error "Code was expecting a version of 'ClassName' that was never released! Errors are likely to occur!" -- Occurs when the inputted version has is a newer version than the class itself. Should check to ensure nothing breaks.
    @error "Code was using a significantly older version of 'ClassName'. Errors are likely to occur!" -- Occurs when the inputted version has an older major update. Should check to ensure nothing breaks.
    @error "Code was using an older version of 'ClassName'. Check for possible deprecations!" -- Occurs when the inputted version has an older minor update. Should ensure deprecated code gets updated.
    @error "Code was using an older patch of 'ClassName'. Check for possible deprecations." -- Occurs when the inputted version has an older patch. Can ignore.
]=]
function BaseClass:CheckVersion(VersionUsed: string): any
    local VersionClass = require(script.DataTypes.VersionClass)
    type Version = typeof(VersionClass)
    local selfVersion = VersionClass.fromString(self.Version) :: Version --self.Version
    VersionUsed = VersionClass.fromString(VersionUsed) :: Version
    --[[if type(selfVersion) == "string" then
        selfVersion = VersionClass.fromString(selfVersion) :: Version
        self.Version = selfVersion
    end
    if type(VersionUsed) == "string" then
        VersionUsed = VersionClass.fromString(VersionUsed) :: Version
    end]]
    --[[if selfVersion == VersionUsed then
        return
    end]]
    --print(selfVersion,VersionUsed)
    if selfVersion > VersionUsed then
        local selfMajor,selfMinor,selfPatch = selfVersion:GetMajorVersion(),selfVersion:GetMinorVersion(),selfVersion:GetPatchVersion()
        local usedMajor,usedMinor,usedPatch = VersionUsed:GetMajorVersion(),VersionUsed:GetMinorVersion(),VersionUsed:GetPatchVersion()
        assert(selfMajor <= usedMajor,"Code was using a significantly older version of " .. self.ClassName .. "! Errors are likely to occur!\nModuleVersion:"..selfVersion.."\nVersionUsed:"..VersionUsed.."\nTraceback:\n"..debug.traceback())
        if selfMinor > usedMinor then
            warn("Code was using an older version of " .. self.ClassName .. ". Check for possible deprecations!\nselfVersion:"..selfVersion.."\nModuleVersion:"..VersionUsed.."\nTraceback:\n",debug.traceback())
        elseif selfPatch > usedPatch then
            print("Code was using an older patch of " .. self.ClassName .. ". Check for possible deprecations.\nselfVersion:"..selfVersion.."\nModuleVersion:"..VersionUsed.."\nTraceback:\n",debug.traceback())
        end
    else
        assert(selfVersion == VersionUsed, "Code was expecting a version of " .. self.ClassName .. " that was never released! Errors are likely to occur!\nModuleVersion:"..selfVersion.."\nVersionUsed:"..VersionUsed.."\nTrackback:\n"..debug.traceback())
    end
    selfVersion:Destroy()
    VersionUsed:Destroy()
    return self
end

--[=[
    Destroy the BaseClass Object to clear up memory.
]=]
function BaseClass:Destroy()
    --warn(self.ClassName .. " has been Destroyed!")
    self.ClassName = nil
    table.clear(self)
    self = nil
end

return BaseClass