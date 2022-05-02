local BaseClass = require(script.Parent)

--[=[
    @interface DataType
    @within DataType

    .new (...) -> (self)
    .__tostring (self) -> (string)
    .__concat (any,any) -> (string)
    .__eq (self,any) -> (boolean)
    .lt (self,any) -> (boolean)
    .le (self,any) -> (boolean)
]=]
local DataTypeInterface: DataTypeInterface = {}
export type DataTypeInterface = typeof(DataTypeInterface)
function DataTypeInterface.new()
    error(debug.traceback("DataType didn't set a .new() function!"))-- .. debug.traceback())
end;
function DataTypeInterface:__tostring()
    error(debug.traceback("Attempt to convert unset datatype to string."))
end;
function DataTypeInterface.__concat(value1: any,value2: any)
    return string.format("%s%s",tostring(value1),tostring(value2))
end;
function DataTypeInterface:__eq(_value)
    error(debug.traceback("Attempt to compare unset datatype another object."))
end;
function DataTypeInterface:__lt(_value)
    error(debug.traceback("Attempt to compare unset datatype another object."))
end;
function DataTypeInterface:__le(_value)
    error(debug.traceback("Attempt to compare unset datatype another object."))
end;
print(DataTypeInterface)
--[=[
    @class DataType
    @client
    @server

    The parent class for all DataTypes to initalize off. Sets commonly used metamethods and methods to throw errors.
]=]
local DataTypeClass: DataTypeClass = BaseClass:Extend({
    ClassName = "DataType";
    Version = "1.0.0";
    CoreModule = script;
})
export type DataTypeClass = typeof(DataTypeClass) & BaseClass.BaseClass
function DataTypeClass:Extend(NewObject: table): DataTypeClass
    if self ~= DataTypeClass then
        for MethodName: string, Method: (...any) -> (...any) in next, DataTypeInterface do
            if rawget(self,MethodName) == nil then
                rawset(self,MethodName,Method)
            end
        end
    end
    NewObject = BaseClass.Extend(self, NewObject) :: DataTypeClass
    return NewObject
end
function DataTypeClass:NewClass(ClassName: string, Version:string, CoreModule: ModuleScript): DataTypeClass
    local NewClass = BaseClass.New(self,ClassName, Version)
    rawset(NewClass, "CoreModule", CoreModule)
    return NewClass
end
return DataTypeClass