local Version do
    Version = setmetatable({},{
        __index = Version;
        _tostring = function(self)
            return string.format("%c.%c.%c",self.MajorVersion,self.MinorVersion,self.PatchVersion)
        end;
        __concat = function(self,value)
            return string.format("%s%s",value,tostring(self))
        end;
        __eq = function(self,value)
            assert(type(value) == "table", "Attempt to compare Version with a non-table." .. debug.traceback())
            assert(value.ClassName == "Version", "Attempt to compare Version with "..value.ClassName..debug.traceback())
            return self.MajorVersion == value.MajorVersion and
            self.MinorVersion == value.MinorVersion and
            self.PatchVersion == value.PatchVersion
        end;
        _lt = function(self, value)
            assert(type(value) == "table", "Attempt to compare Version with a non-table." .. debug.traceback())
            assert(value.ClassName == "Version", "Attempt to compare Version with "..value.ClassName..debug.traceback())
            return self.MajorVersion < value.MajorVersion or
            self.MinorVersion < value.MinorVersion or
            self.PatchVersion < value.PatchVersion
        end;
        _le = function(self, value)
            assert(type(value) == "table", "Attempt to compare Version with a non-table." .. debug.traceback())
            assert(value.ClassName == "Version", "Attempt to compare Version with "..value.ClassName..debug.traceback())
            return self.MajorVersion <= value.MajorVersion and
            self.MinorVersion <= value.MinorVersion and
            self.PatchVersion <= value.PatchVersion
        end;
    })
end

function Version.new(MajorVersion:number,MinorVersion:number,PatchVersion:number)
    return setmetatable({
        MajorVersion = MajorVersion;
        MinorVersion = MinorVersion;
        PatchVersion = PatchVersion;
    }, Version)
end

return Version