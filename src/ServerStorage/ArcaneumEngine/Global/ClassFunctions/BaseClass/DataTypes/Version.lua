local BaseClass = require(script.Parent)
local Version = BaseClass:NewClass("Version")
function Version:__tostring(): string
    return string.format("%i.%i.%i",self.MajorVersion,self.MinorVersion,self.PatchVersion)
end;
function Version.__concat(value1: any,value2: any): string
    return string.format("%s%s",tostring(value1),tostring(value2))
end;
function Version:__eq(value: Version): boolean
    assert(type(value) == "table", "Attempt to compare Version with a non-table." .. debug.traceback())
    assert(value.ClassName == "Version", "Attempt to compare Version with "..value.ClassName..debug.traceback())
    return self.MajorVersion == value.MajorVersion and
    self.MinorVersion == value.MinorVersion and
    self.PatchVersion == value.PatchVersion
end;
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

export type Version = typeof(Version.new(0,0,0))
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

function Version.fromString(String: string): Version
    return Version.new(Version.getNumbersFromString(String))
end

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