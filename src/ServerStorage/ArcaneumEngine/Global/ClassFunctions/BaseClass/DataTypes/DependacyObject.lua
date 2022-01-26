local BaseClass = require(script.Parent)
local VersionClass = require(script.Parent.Version)
type Version = typeof(VersionClass.new(0,0,0))
local ClassName = "DependacyObject"
local DependacyObject = BaseClass:NewClass(ClassName)
DependacyObject.__tostring = function(self)
    return string.format("%s %s",self:GetFileName(),tostring(self:GetVersion()))
end;
DependacyObject.__concat = function(value1: any,value2: any)
    return string.format("%s%s",tostring(value1),tostring(value2))
end;
DependacyObject.__eq = function(self,value)
    assert(type(value) == "table", "Attempt to compare " .. ClassName .. " with a non-table." .. debug.traceback())
    assert(value.ClassName == ClassName, "Attempt to compare  " .. ClassName .. "  with "..value.ClassName..debug.traceback())
    return self:GetFileName() == value:GetFileName() and
    self:GetVersion() == value:GetVersion()
end;
DependacyObject.__lt = function(self, value)
    assert(type(value) == "table", "Attempt to compare  " .. ClassName .. "  with a non-table." .. debug.traceback())
    assert(value.ClassName == ClassName, "Attempt to compare  " .. ClassName .. "  with "..value.ClassName..debug.traceback())
    if self:GetFileName() < value:GetFileName() then
        return true
    elseif self:GetFileName() == value:GetFileName() then
        return self:GetVersion() < value:GetVersion()
    end
    return false
end;
DependacyObject.__le = function(self, value)
    assert(type(value) == "table", "Attempt to compare  " .. ClassName .. "  with a non-table." .. debug.traceback())
    assert(value.ClassName == ClassName, "Attempt to compare  " .. ClassName .. "  with "..value.ClassName..debug.traceback())
    if self:GetFileName() < value:GetFileName() then
        return true
    elseif self:GetFileName() == value:GetFileName() then
        return self:GetVersion() <= value:GetVersion()
    end
    return false
end;

export type DependacyObject = typeof(DependacyObject.new("",VersionClass.new()))
function DependacyObject.new(FileName: string, Version: Version): DependacyObject
    assert(FileName ~= nil, "No FileName given for " .. ClassName .. ".new()!" .. debug.traceback())
    assert(Version ~= nil, "No Version given for " .. ClassName .. ".new()!" .. debug.traceback())
    if type(Version) == "string" then
        Version = VersionClass.fromString(Version)
    end
    assert(type(Version) == "table", "Version is not a table in " .. ClassName .. ".new()! Type given: ".. type(Version).."\nDebug:" .. debug.traceback())
    assert(Version.ClassName == "Version", "Version is not a Version Class in " .. ClassName .. ".new()!" .. debug.traceback())
    return DependacyObject:Extend({
        FileName = FileName;
        Version = Version;
    })
end

function DependacyObject:GetVersion(): Version
    return self.Version
end

function DependacyObject:GetFileName(): string
    return self.FileName
end

function DependacyObject:Destroy(): nil
    self.FileName = nil
    self.Version:Destroy()
    return self.BaseClass.Destroy(self)
end

return DependacyObject