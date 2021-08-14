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
    for Label, Connection in next, self.Connections do
        Connection:Disconnect()
        self.Connections[Label] = nil
    end
    self.Connections = nil
    --warn(self.ClassName .. " has been Destroyed!")
    self.ClassName = nil
    self = nil
end

return BaseClass