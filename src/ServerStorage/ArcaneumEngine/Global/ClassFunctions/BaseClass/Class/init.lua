--[=[
    @class Class
    @server
    @client
    The foundational class for all services and factories. In comparison to the BaseClass, this class gives a Connections table to store any RBLXScriptSignals made and disconnect them when the class is destroyed.
]=]
local BaseClass = require(script.Parent)
local Class = BaseClass:Extend({
    Version = 0;
    Object = script;
})
--[=[
    @prop Object script
    @within Class
    The script itself for external reference.
]=]
--[=[
    Creates a new Class object with a ClassName of "ClassName".

    @param ClassName string -- The name of the class being created.
    @return NewClass -- Returns an object with the ClassName of "ClassName".
]=]
--[=[
    @prop ClassName string
    @within Class
    The name of the object's class.
]=]
--[=[
    @prop Connections table
    @within Class
    A table containing all existing connections to this object.
]=]
function Class:New(ClassName:string)
    local NewClass = BaseClass:New(ClassName)
    NewClass.Connections = {}
    return self:Extend(NewClass)
end

--[=[
    Destroy the Class Object to clear up memory.
]=]
function Class:Destroy(): nil
    for Label, Connection in next, self.Connections do
        Connection:Disconnect()
        self.Connections[Label] = nil
    end
    self.Connections = nil
    --warn(self.ClassName .. " has been Destroyed!")
    BaseClass.Destroy(self)
end

return Class