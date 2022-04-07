--[=[
    @class Class
    @server
    @client
    The foundational class for all services and factories. In comparison to the BaseClass, this class gives a Connections table to store any RBLXScriptSignals made and disconnect them when the class is destroyed.
]=]
local BaseClass = require(script.Parent)
local Class: Class = BaseClass:Extend({
    Version = "1.0.0";
})
export type Class = {
    Connections: {[any]:RBXScriptConnection};
} & typeof(Class) & BaseClass.BaseClass
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
--[=[
    Creates a new Class object with a ClassName of "ClassName".

    @param ClassName string -- The name of the class being created.
    @return NewClass -- Returns an object with the ClassName of "ClassName".
]=]
function Class:New(ClassName:string): Class
    return self:NewFromTable({},ClassName)
end

--[=[
    Creates a new Class object from a premade table with a ClassName of "ClassName".

    @param ClassName string -- The name of the class being created.
    @return NewClass -- Returns an object with the ClassName of "ClassName".
]=]
function Class:NewFromTable(Table: table, ClassName:string): Class
    Table = BaseClass:NewFromTable(Table, ClassName)
    Table.Connections = {}
    return self:Extend(Table)
end

--[=[
    Adds a connection to the Connections dictionary with inputted key.

    @param ConnectionKey any -- The reference of which the Connection will be assoiated with.
    @param Connection RBXScriptConnection -- The connection returned by a [RBXScriptSignal]:Connect().
]=]
function Class:AddConnection(ConnectionKey: any, Connection: RBXScriptConnection)
    local PreviousConnection = self.Connections[ConnectionKey]
    if PreviousConnection then
        warn("Attempt to add a new connection before removing previous one! Automatically disconnecting previous connection! Debug:",debug.traceback())
        PreviousConnection:Disconnect()
    end
    self.Connections[ConnectionKey] = Connection
end

--[=[
    Removes a connection from the Connections dictionary with inputted key.

    @param ConnectionKey any -- The reference of which the Connection will be assoiated with.
]=]
function Class:RemoveConnection(ConnectionKey: any)
    local PreviousConnection = self.Connections[ConnectionKey]
    if PreviousConnection then
        PreviousConnection:Disconnect()
    end
end

--[=[
    Destroy the Class Object to clear up memory.
]=]
function Class:Destroy()
    for Key, Connection in next, self.Connections do
        Connection:Disconnect()
        self.Connections[Key] = nil
    end
    self.Connections = nil
    --warn(self.ClassName .. " has been Destroyed!")
    BaseClass.Destroy(self)
end

return Class