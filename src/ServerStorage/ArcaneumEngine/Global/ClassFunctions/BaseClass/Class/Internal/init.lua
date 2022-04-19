local BaseClass = require(script.Parent):CheckVersion("1.1.0")
--[=[
    @class InternalClass
    @server
    @client
    The foundational class for replicated objects. Inherits from [Class].
    
    In comparison to [Class], the InternalClass includes the Name property to help distinglish it from other InternalClass objects.
]=]
local InternalClass:InternalClass = BaseClass:Extend({
    ClassName = "InternalClass",
    Version = "1.0.0",
})
export type InternalClass = {
    Name: string;
} & typeof(InternalClass) & BaseClass.Class
--[=[
    @prop Name string
    @within InternalClass
    The name of the object's class.
]=]

--[=[
    Applies metatable to NewObject and verifies that all properties of InternalClass has been applied to it.

    @param NewObject table -- The table that is being turned into a Class.
    @return NewClass -- Returns an object with the ClassName of "ClassName".
]=]
function InternalClass:Extend(NewObject: table): InternalClass
    NewObject = BaseClass.Extend(self, NewObject) :: InternalClass
    if NewObject.Name == nil then
        NewObject.Name = NewObject.ClassName
    end
    return NewObject
end

--[=[
    Creates a new InternalClass object with the ClassName of "ClassName" and Name of "Name".

    @param ClassName string -- The name of the class being created.
    @param Name string -- The name of the object being created.
    @return NewInternalClass -- Returns an object with the ClassName of "ClassName" and Name of "Name".
]=]
function InternalClass:New(ClassName:string, Name:string, Version:string): InternalClass
    return self:NewFromTable({},ClassName, Name, Version)
end

--[=[
    Creates a new Class object from a premade table with a ClassName of "ClassName".

    @param ClassName string -- The name of the class being created.
    @return NewClass -- Returns an object with the ClassName of "ClassName".
]=]
function InternalClass:NewFromTable(Table: table, ClassName:string, Name:string, Version:string): InternalClass
    Table = BaseClass:NewFromTable(Table, ClassName, Version)
    Table.Name = Name or ClassName
    return self:Extend(Table)
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