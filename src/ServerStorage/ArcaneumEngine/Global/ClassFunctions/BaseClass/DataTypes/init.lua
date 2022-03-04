local BaseClass = require(script.Parent)
local DataTypeInterface = BaseClass:New("DataTypeInterface")
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

function DataTypeInterface:NewClass(ClassName: string)
    local NewClass = self:Extend(BaseClass:New(ClassName))
    return NewClass
end

function DataTypeInterface.new()
    error("DataType didn't set a .new() function!")-- .. debug.traceback())
end
DataTypeInterface.__tostring = function(_self)
    error("Attempt to convert unset datatype to string.")
end;
DataTypeInterface.__concat = function(value1: any,value2: any)
    return string.format("%s%s",tostring(value1),tostring(value2))
end;
DataTypeInterface.__eq = function(_self,_value)
    error("Attempt to compare unset datatype another object.")
end;
DataTypeInterface.__lt = function(_self, _value)
    error("Attempt to compare unset datatype another object.")
end;
DataTypeInterface.__le = function(_self, _value)
    error("Attempt to compare unset datatype another object.")
end;
return DataTypeInterface