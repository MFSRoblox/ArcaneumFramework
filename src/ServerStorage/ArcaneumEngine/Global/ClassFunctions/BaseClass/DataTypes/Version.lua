--[=[
    @tag DataTypes
    @client
    @server
    @class Version

    A DataType used to format the version number of something, usually files. Set up to adhere to [Semantic Versioning 2.0.0](https://semver.org/).
]=]
--[=[
    @within Version
    @prop MajorVersion number

    The number representing which major version is represented. Different major versions indicate "when you make incompatible API changes."
]=]
--[=[
    @within Version
    @prop MinorVersion number

    The number representing which minor version is represented. Different minor versions indicate "when you add functionality in a backwards compatible manner."
]=]
--[=[
    @within Version
    @prop PatchVersion number

    The number representing which patch version is represented. Different patch versions indicate "when you make backwards compatible bug fixes."
]=]
local BaseClass = require(script.Parent)
local Version: Version = BaseClass:NewClass("Version")
export type Version = {
    MajorVersion: number;
    MinorVersion: number;
    PatchVersion: number;
} & typeof(Version)
--[=[
    @tag Metamethod
    @return string -- Returns in the format of "[[Version.MajorVersion]].[[Version.MinorVersion]].[[Version.PatchVersion]]".
]=]
function Version:__tostring(): string
    return string.format("%i.%i.%i",self.MajorVersion,self.MinorVersion,self.PatchVersion)
end;
--[=[
    @tag Metamethod
    @return string -- Concatinates values via "string.format("%s%s",tostring(value1),tostring(value2))"
]=]
function Version.__concat(value1: any,value2: any): string
    return string.format("%s%s",tostring(value1),tostring(value2))
end;
--[=[
    @tag Metamethod
    @return boolean -- Compares both Versions and returns if MajorVersion, MinorVersion, and PatchVersion are the same numbers.
]=]
function Version:__eq(value: Version): boolean
    assert(type(value) == "table", "Attempt to compare Version with a non-table." .. debug.traceback())
    assert(value.ClassName == "Version", "Attempt to compare Version with "..value.ClassName..debug.traceback())
    return self.MajorVersion == value.MajorVersion and self.MinorVersion == value.MinorVersion and self.PatchVersion == value.PatchVersion
end;
--[=[
    @tag Metamethod
    @return boolean -- Compares both Versions and returns if the current object has precedence over the next Version object. Refer to [Specification #11 of Semantic Versioning 2.0.0](https://semver.org/#spec-item-11).
]=]
function Version:__lt(value: Version): boolean
    assert(type(value) == "table", "Attempt to compare Version with a non-table." .. debug.traceback())
    assert(value.ClassName == "Version", "Attempt to compare Version with "..value.ClassName..debug.traceback())
    if self:GetMajorVersion() < value:GetMajorVersion() then
        return true
    elseif self:GetMajorVersion() == value:GetMajorVersion() then
        if self:GetMinorVersion() < value:GetMinorVersion() then
            return true
        elseif self:GetMinorVersion() == value:GetMinorVersion() then
            return self:GetPatchVersion() < value:GetPatchVersion()
        end
    end
    return false
end;
--[=[
    @tag Metamethod
    @return boolean -- Compares both Versions and returns if the current object has precedence over or is equal to the next Version object. Uses [Version:__eq] and [Version:__lt].
]=]
function Version:__le(value: Version): boolean
    assert(type(value) == "table", "Attempt to compare Version with a non-table." .. debug.traceback())
    assert(value.ClassName == "Version", "Attempt to compare Version with "..value.ClassName..debug.traceback())
    if self:GetMajorVersion() < value:GetMajorVersion() then
        return true
    elseif self:GetMajorVersion() == value:GetMajorVersion() then
        if self:GetMinorVersion() < value:GetMinorVersion() then
            return true
        elseif self:GetMinorVersion() == value:GetMinorVersion() then
            return self:GetPatchVersion() <= value:GetPatchVersion()
        end
    end
    return false
end;

--[=[
    @param MajorVersion -- The number representing which MajorVersion the new object has.
    @param MinorVersion -- The number representing which MinorVersion the new object has.
    @param PatchVersion -- The number representing which PatchVersion the new object has.
    @return Version -- A new version object.
]=]
function Version.new(MajorVersion:number | string,MinorVersion:number,PatchVersion:number): Version
    if type(MajorVersion) == "string" then
        return Version.fromString(MajorVersion)
    end
    return Version:Extend({
        MajorVersion = MajorVersion :: number;
        MinorVersion = MinorVersion :: number;
        PatchVersion = PatchVersion :: number;
    })
end

--[=[
    @param String -- A string in the format of "[[Version.MajorVersion]].[[Version.MinorVersion]].[[Version.PatchVersion]]".
    @return Version -- A new version object.
]=]
function Version.fromString(String: string): Version
    return Version.new(Version.getNumbersFromString(String))
end

--[=[
    @param String -- A string in the format of "[[Version.MajorVersion]].[[Version.MinorVersion]].[[Version.PatchVersion]]".
    @return MajorVersion,MinorVersion,PatchVersion -- The numbers representing the respective versions.
]=]
function Version.getNumbersFromString(String: string): (number,number,number)
    local VersionNumbers = string.split(String,".")
    assert(#VersionNumbers == 3, "Inputted String does not have 3 numbers! Input: " .. tostring(String) .. " Output: " .. #VersionNumbers .. "\n" .. debug.traceback())
    for i, StringNumber in next,VersionNumbers do
        local VersionNumber = tonumber(StringNumber)
        assert(VersionNumber ~= nil, "Can not convert inputted string to number! Input: " .. tostring(StringNumber) .. "\n" .. debug.traceback())
        VersionNumbers[i] = VersionNumber
    end
    return table.unpack(VersionNumbers)
end

function Version:GetMajorVersion(): number
    return self.MajorVersion
end

function Version:GetMinorVersion(): number
    return self.MinorVersion
end

function Version:GetPatchVersion(): number
    return self.PatchVersion
end

function Version:Destroy(): nil
    self.MajorVersion = nil
    self.MinorVersion = nil
    self.PatchVersion = nil
    return self.BaseClass.Destroy(self)
end

return Version