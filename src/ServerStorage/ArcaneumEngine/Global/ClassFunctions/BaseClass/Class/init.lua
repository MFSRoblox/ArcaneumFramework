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
type Class = table
type Sourcer = table
function Class:New(ClassName:string)
    local NewClass = BaseClass:New(ClassName)
    NewClass.Sourcers = {}
    return self:Extend(NewClass)
end

function Class:CreateLink(Target: Class): Sourcer
    warn(self.ClassName .. " has not overwritten CreateLink!")
end

function Class:Destroy()
    for i=1, #self.Sourcers do
        local Sourcer = self.Sourcers[i]
        Sourcer:Destroy()
    end
    self.Sourcers = nil
    --warn(self.ClassName .." has called Destroy at Class!")
    BaseClass.Destroy(self)
end

return Class