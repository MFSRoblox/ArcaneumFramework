local BaseClass = {
    Version = 0;
    Object = script;
}
function BaseClass:Extend(NewObject)
    NewObject = NewObject or {
        ClassName = "";
        Connections = {}
    }
    self.__index = self
    local output = setmetatable(NewObject, self)
    return output
end

function BaseClass:New(ClassName:String)
    return self:Extend({ClassName = ClassName; Connections = {};})
end

function BaseClass:Destroy(): nil
    warn(self.ClassName .. " has not overwritten Destroy!")
end

return BaseClass