local BaseClass = require(script.Parent)
local InternalClass = BaseClass:Extend({
    Version = 0;
    Object = script;
})
function InternalClass:New(ClassName:string, Name:string)
    local NewClass = BaseClass:New(ClassName)
    NewClass.Name = Name or ClassName
    return self:Extend(NewClass)
end

function InternalClass:Destroy()
    self.Name = nil
    --warn(self.ClassName .." has called Destroy at Internal!")
    BaseClass.Destroy(self)
end

return InternalClass