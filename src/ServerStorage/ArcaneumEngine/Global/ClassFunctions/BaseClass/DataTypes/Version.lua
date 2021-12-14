local BaseClass = require(script.Parent)
local Version = BaseClass:NewClass("Version")

Version.__tostring = function(self)
    return string.format("%i.%i.%i",self.MajorVersion,self.MinorVersion,self.PatchVersion)
end;
Version.__concat = function(value1: any,value2: any)
    return string.format("%s%s",tostring(value1),tostring(value2))
end;
Version.__eq = function(self,value)
    assert(type(value) == "table", "Attempt to compare Version with a non-table." .. debug.traceback())
    assert(value.ClassName == "Version", "Attempt to compare Version with "..value.ClassName..debug.traceback())
    return self.MajorVersion == value.MajorVersion and
    self.MinorVersion == value.MinorVersion and
    self.PatchVersion == value.PatchVersion
end;
Version.__lt = function(self, value)
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
Version.__le = function(self, value)
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

function Version.new(MajorVersion:number,MinorVersion:number,PatchVersion:number)
    return Version:Extend({
        MajorVersion = MajorVersion;
        MinorVersion = MinorVersion;
        PatchVersion = PatchVersion;
    })
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

return Version