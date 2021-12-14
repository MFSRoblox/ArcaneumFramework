local BaseClass = require(script.Parent)
--[=[
    @class InternalClass
    @server
    @client
    The foundational class for replicated objects. In comparison to the BaseClass, the InternalClass includes the Name property to help distinglish it from other InternalClass objects.
]=]
local InternalClass = BaseClass:Extend({
    Version = 0;
    Object = script;
})
--[=[
    Creates a new InternalClass object with the ClassName of "ClassName" and Name of "Name".

    @param ClassName string -- The name of the class being created.
    @param Name string -- The name of the object being created.
    @return NewInternalClass -- Returns an object with the ClassName of "ClassName" and Name of "Name".
]=]
--[=[
    @prop ClassName string
    @within InternalClass
    Inherited from BaseClass.
    The name of the object's class.
]=]
--[=[
    @prop Name string
    @within InternalClass
    The name of the object's class.
]=]
--[=[
    @prop Connections table
    @within InternalClass
    Inherited from BaseClass.
    A table containing all existing connections to this object.
]=]
function InternalClass:New(ClassName:string, Name:string)
    local NewClass = BaseClass:New(ClassName)
    NewClass.Name = Name or ClassName
    return self:Extend(NewClass)
end

--[=[
    Destroy the BaseClass Object to clear up memory.
]=]
function InternalClass:Destroy()
    self.Name = nil
    --warn(self.ClassName .." has called Destroy at Internal!")
    BaseClass.Destroy(self)
end

return InternalClass