local gameIsLoaded = game:IsLoaded()
if not gameIsLoaded then
    game.Loaded:Wait()
end
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoactModule = ReplicatedStorage.Packages.roact
local Roact = require(RoactModule)
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
local DebugConfig = {
    ApplyDefaultDebugText = true;
}
local GuiUtilities = {} do
    GuiUtilities.__index = GuiUtilities
end
export type RoactComponent = typeof(Roact.Component:extend())
--[=[
    Apply the default values from a "default" dictionary to another dictionary, if that other dictionary doesn't have a value already.

    @param DefaultDictionary Dictionary<any> -- The dictionary that contains the default values of each key.
    @param NewDictionary Dictionary<any> -- The dictionary of which "Defaults" will be applied to.
    @return NewDictionary -- The "NewDictionary" with default values applied (if applicable).
]=]
function GuiUtilities:ApplyDefaults(DefaultDictionary: Dictionary<any>, NewDictionary: Dictionary<any>): Dictionary<any>
    for PropName, PropValue in pairs(DefaultDictionary) do -- Set property to default value if none was put in.
        if NewDictionary[PropName] == nil then
            if DebugConfig.ApplyDefaultDebugText then
                print("Applied",PropName,"with value of",PropValue,"to",NewDictionary)
            end
            NewDictionary[PropName] = PropValue
        end
    end
    return NewDictionary
end

function GuiUtilities:CheckColorProp(PropDictionary: Dictionary<any>, ColorTag: string): Dictionary<any>
    local ColorName = ColorTag.."Color3"
    local TransparencyName = ColorTag.."Transparency"
    assert(PropDictionary[ColorName] ~= nil, ColorTag.."Color3 doesn't exist in the property table! Debug:\n" .. debug.traceback())
    if PropDictionary[ColorName] == false then
        PropDictionary[TransparencyName] = 1
    end
    return PropDictionary
end

return setmetatable({},GuiUtilities)