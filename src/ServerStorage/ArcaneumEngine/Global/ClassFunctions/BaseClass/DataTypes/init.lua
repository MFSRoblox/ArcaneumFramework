local BaseClass = require(script.Parent)
local DataTypeInterface: DataTypeInterface = BaseClass:New("DataTypeInterface")
export type DataTypeInterface = typeof(DataTypeInterface)
--[=[
    @class DataTypes
    @client
    @server

    The parent class for all DataTypes to initalize off. Sets commonly used metamethods and methods to throw errors.
]=]
--[=[
    @interface DataType
    @within DataTypes

    .new (...) -> (self)
    .__tostring (self) -> (string)
    .__concat (any,any) -> (string)
    .__eq (self,any) -> (boolean)
    .lt (self,any) -> (boolean)
    .le (self,any) -> (boolean)
]=]

function DataTypeInterface:NewClass(ClassName: string): DataTypeInterface
    local NewClass = self:Extend(BaseClass:New(ClassName))
    return NewClass
end

function DataTypeInterface.new()
    error("DataType didn't set a .new() function!")-- .. debug.traceback())
end
--[[function DataTypeInterface:__tostring()
    error("Attempt to convert unset datatype to string.")
end;
function DataTypeInterface.__concat(value1: any,value2: any)
    return string.format("%s%s",tostring(value1),tostring(value2))
end;
function DataTypeInterface:__eq(_value)
    error("Attempt to compare unset datatype another object.")
end;
function DataTypeInterface:__lt(_value)
    error("Attempt to compare unset datatype another object.")
end;
function DataTypeInterface:__le(_value)
    error("Attempt to compare unset datatype another object.")
end;]]
return DataTypeInterface