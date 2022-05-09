--[=[
    @since v1.0.0
    @server
    @client
    @class Class
    ### Current Version: 1.2.0
    The foundational class for all services and factories that need to manage connections. Inherits from [BaseClass].
    
    In comparison to [BaseClass], this class gives a Connections table to store any RBLXScriptSignals made and disconnect them when the class is destroyed.
]=]
local BaseClass = require(script.Parent)
BaseClass:CheckVersion("1.2.0")
local Class: Class = BaseClass:Extend({
    ClassName = "Class";
    Version = "1.2.0";
    CoreModule = script;
})
export type Class = {
    Connections: {[any]:RBXScriptConnection};
} & typeof(Class) & BaseClass.BaseClass
--[=[
    @since v1.0.0
    @within Class
    @prop Connections table
    A table containing all existing connections to this object.
]=]

--[=[
    @since v1.0.0
    Applies metatable to NewObject and verifies that all properties of Class has been applied to it.

    @param NewObject table -- The table that is being turned into a Class.
    @return NewClass -- Returns an object with the ClassName of "ClassName".
]=]
function Class:Extend(NewObject: table): Class
    NewObject = BaseClass.Extend(self, NewObject) :: Class
    if rawget(NewObject,"Connections") == nil then
        NewObject.Connections = {}
    end
    return NewObject
end
--[=[
    @since v1.1.0
    Creates a new Class object with a ClassName of "ClassName".

    @param ClassName string -- The name of the class being created.
    @return NewClass -- Returns an object with the ClassName of "ClassName".
]=]
function Class:New(ClassName:string, Version:string): Class
    return self:Extend({
        ClassName = ClassName;
        Version = Version;
    })
end

--[=[
    @deprecated v1.1.0 -- Removed as [Class:Extend] functionally does the same thing.
    Creates a new Class object from a premade table with a ClassName of "ClassName".

    @param ClassName string -- The name of the class being created.
    @return NewClass -- Returns an object with the ClassName of "ClassName".
]=]
function Class:NewFromTable(Table: table, ClassName:string, Version:string): Class
    Table = BaseClass.NewFromTable(self, Table, ClassName, Version)
    return self:Extend(Table)
end

--[=[
    Adds a connection to the Connections dictionary with inputted key so it can be disconnected later (either automatically on [Class:Destroy] or manually on [Class:RemoveConnection]).

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
    self.Connections[ConnectionKey] = nil
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