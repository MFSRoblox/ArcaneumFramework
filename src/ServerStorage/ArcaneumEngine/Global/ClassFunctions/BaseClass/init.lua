--[=[
    @class BaseClass
    @server
    @client
    The foundational class for all classes.
]=]
local BaseClass = {
    Version = 0;
    Object = script;
}
--[=[
    @prop Object script
    @within BaseClass
    The script itself for external reference.
]=]

--[=[
    This is a very fancy function that sets the index of the table so you don't need to repeatedly .__index and setmetatable.

    @param NewObject table -- The table you want to set the __index metatable to.
    @return table -- Returns the table with the index set to itself.
]=]
function BaseClass:Extend(NewObject)
    NewObject = NewObject or {
        ClassName = "";
    }
    self.__index = self
    local output = setmetatable(NewObject, self)
    return output
end
--[=[
    Creates a new BaseClass object with a ClassName of "ClassName".

    @param ClassName string -- The name of the class being created.
    @return NewBaseClass -- Returns an object with the ClassName of "ClassName".
]=]
--[=[
    @prop ClassName string
    @within BaseClass
    The name of the object's class.
]=]
function BaseClass:New(ClassName:string)
    return self:NewFromTable({}, ClassName)
end

--[=[
    Creates a new BaseClass object from a premade table with a ClassName of "ClassName".

    @param ClassName string -- The name of the class being created.
    @return NewBaseClass -- Returns an object with the ClassName of "ClassName".
]=]
function BaseClass:NewFromTable(Table: table, ClassName:string)
    Table.ClassName = ClassName or ""
    return self:Extend(Table)
end

--[=[
    Destroy the BaseClass Object to clear up memory.
]=]
function BaseClass:Destroy(): nil
    --warn(self.ClassName .. " has been Destroyed!")
    self.ClassName = nil
    table.clear(self)
    self = nil
end

return BaseClass