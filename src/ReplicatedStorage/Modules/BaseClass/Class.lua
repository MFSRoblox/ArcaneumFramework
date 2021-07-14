local Class = {
    Version = 0;
}
Class.__index = Class
local BaseClass do
    local Module = script.Parent
    if Module then
        BaseClass = require(Module)
    end
end
function Class:New(ClassName:String)
    local NewClass = BaseClass:New(ClassName)
    NewClass.Sourcers = {}
    return NewClass
end

function Class:CreateLink(Target: Class): Sourcer
    warn(self.ClassName .. " has not overwritten CreateLink!")
end

return Class