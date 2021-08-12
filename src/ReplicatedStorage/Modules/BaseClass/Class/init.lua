local BaseClass do
    local Module = script.Parent
    if Module then
        BaseClass = require(Module)
    end
end
local Class = BaseClass:Extend({
    Version = 0;
    Object = script;
})
function Class:New(ClassName:String)
    local NewClass = BaseClass:New(ClassName)
    NewClass.Sourcers = {}
    return self:Extend(NewClass)
end

function Class:CreateLink(Target: Class): Sourcer
    warn(self.ClassName .. " has not overwritten CreateLink!")
end

return Class