--[=[
    @client
    @class GuiUtilities
    The singleton for Gui modules to call for universal functions.
]=]
--[=[
    @type RoactElement RoactType
    @within GuiUtilities
    A Roact Element in any form, created through Roact.createElement. [Refer to their documentation for more information.](https://roblox.github.io/roact/guide/elements/)
]=]
local GuiUtilities = {} do
    GuiUtilities.__index = GuiUtilities
end

--[=[
    Apply the default values from a "default" dictionary to another dictionary, if that other dictionary doesn't have a value already.

    @param DefaultDictionary Dictionary<any> -- The dictionary that contains the default values of each key.
    @param NewDictionary Dictionary<any> -- The dictionary of which "Defaults" will be applied to.
    @return NewDictionary -- The "NewDictionary" with default values applied (if applicable).
]=]
function GuiUtilities:ApplyDefaults(DefaultDictionary: Dictionary<any>, NewDictionary: Dictionary<any>): Dictionary<any>
    for PropName, PropValue in pairs(DefaultDictionary) do -- Set property to default value if none was put in.
        if NewDictionary[PropName] == nil then
            NewDictionary[PropName] = PropValue
        end
    end
    return NewDictionary
end

return setmetatable({},GuiUtilities)