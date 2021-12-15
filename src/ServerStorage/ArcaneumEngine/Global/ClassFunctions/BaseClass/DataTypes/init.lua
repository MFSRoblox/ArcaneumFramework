local BaseClass = require(script.Parent)
local DataTypeInterface = BaseClass:New("DataTypeInterface")
function DataTypeInterface.new()
    assert(false, "DataType didn't set a .new() function!" .. debug.traceback())
end
function DataTypeInterface:NewClass(ClassName: string)
    local NewClass = self:Extend(BaseClass:New(ClassName))
    return NewClass
end
return DataTypeInterface