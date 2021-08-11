local BaseClass do
    local Module = script.Parent
    if Module then
        BaseClass = require(Module)
    end
end
local InternalClass = BaseClass:Extend({
    Version = 0;
    Object = script;
})
function InternalClass:New(ClassName:String, Name:String)
    local NewClass = self:Extend((
        {
            ClassName = ClassName;
            Connections = {};
            Sourcers = {};
            Name = Name or "UnnamedInternalClass";
        }
    ))
    return NewClass
end

return InternalClass