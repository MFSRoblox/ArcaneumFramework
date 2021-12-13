--[=[
    @class SingletonInitClass
    @client
    @server
    A factory that allows for the creation of Initialization classes that can be initialized by doing NewSingletonInitObject(params).
]=]
local SingletonInitClass do
    SingletonInitClass = setmetatable({
        ClassName = "SingletonInitClass"
    },{__index = SingletonInitClass})
end

--[=[

@param InitName string
@param InitCallback (table,...any) -> table
@param InitTable table?
@param InitPriority number?

@return SingletonInitObject
]=]
function SingletonInitClass:New(InitName: string, InitCallback: (table,...any) -> table, InitTable:table?, BootOrder: number?)
    InitTable = InitTable or {}
    assert(InitName ~= nil, "No init name was passed for SingletonInitClass!" .. debug.traceback())
    InitTable.InitName = InitName
    InitTable.BootOrder = BootOrder
    return setmetatable(InitTable, {__call = InitCallback})
end
return SingletonInitClass