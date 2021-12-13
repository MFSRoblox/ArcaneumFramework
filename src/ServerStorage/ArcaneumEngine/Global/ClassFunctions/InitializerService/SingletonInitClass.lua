--[=[
    @class SingletonInitClass
    @client
    @server
    A factory that allows for the creation of Initialization classes that can be initialized by doing NewSingletonInitObject(params).
]=]
local SingletonInitClass do
    SingletonInitClass = setmetatable({
        ClassName = "SingletonInitClass";
    },{__index = SingletonInitClass})
end
export type SingletonInitObject = typeof(SingletonInitClass:NewFromDictionary({__call = function() end}))
--[=[

@param InitName string
@param InitCallback (table,...any) -> table
@param InitTable table?
@param InitPriority number?

@return SingletonInitObject
]=]
function SingletonInitClass:New(InitName: string, InitCallback: (table,...any) -> table, InitTable:table?, BootOrder: number?): SingletonInitObject
    InitTable = InitTable or {}
    assert(InitName ~= nil, "No init name was passed for SingletonInitClass!" .. debug.traceback())
    InitTable.InitName = InitName
    InitTable.BootOrder = BootOrder
    InitTable.Version = nil --need to setup
    InitTable.Dependacies = nil --need to setup
    return setmetatable(InitTable, {__call = InitCallback})
end
function SingletonInitClass:NewFromDictionary(InitTable: table): SingletonInitObject
    assert(type(InitTable) == "table", "InitTable isn't a table! Critical error!" .. debug.traceback())
    assert(InitTable.__call ~= nil, "Table doesn't have a __call set! Critical error!" .. debug.traceback())
    if InitTable.InitName == nil then
        warn("Table does not have InitName!",debug.traceback())
        InitTable.InitName = ""
    end
    if InitTable.BootOrder == nil then
        warn("Table does not have BootOrder! Setting it to 1000...",debug.traceback())
        InitTable.BootOrder = 1000
    end
    return setmetatable(InitTable, InitTable)
end
return SingletonInitClass