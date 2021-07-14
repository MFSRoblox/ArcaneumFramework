local BaseClass = {
    Version = 0
}
BaseClass.__index = BaseClass

function BaseClass:New(ClassName:String)
    return setmetatable({ClassName = ClassName}, self)
end

function BaseClass:Destroy(): nil
    warn(self.ClassName .. " has not overwritten Destroy!")
end

return BaseClass