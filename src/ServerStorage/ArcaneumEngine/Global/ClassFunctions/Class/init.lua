--[=[
    @class Class
    @server
    @client
    The foundational class for all classes.
]=]
local Class = {
    Version = 0;
    Object = script;
}
--[=[
    @prop Object script
    @within Class
    The script itself for external reference.
]=]

--[=[
    This is a very fancy function that sets the index of the table so you don't need to repeatedly .__index and setmetatable.

    @param NewObject table -- The table you want to set the __index metatable to.
    @return table -- Returns the table with the index set to itself.
]=]
function Class:Extend(NewObject)
    NewObject = NewObject or {
        ClassName = "";
        Connections = {}
    }
    self.__index = self
    local output = setmetatable(NewObject, self)
    return output
end
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
    return self:Extend({ClassName = ClassName; Connections = {};})
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
    self.ClassName = nil
    self = nil
end

return Class