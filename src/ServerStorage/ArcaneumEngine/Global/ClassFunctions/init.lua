local Utilities do
    local Mod = script.Parent:WaitForChild("Utilities")
    if Mod then
        Utilities = require(Mod)
    end
end
local Class = Utilities:ImportModule(script,"Class")
local Internal = Utilities:ImportModule(script,"Class","Internal")
local External = nil --Utilities:ImportModule(script,"Class","External")
local Output = {
    Class = Class;
    Internal = Internal;
    External = External;
}
return Output