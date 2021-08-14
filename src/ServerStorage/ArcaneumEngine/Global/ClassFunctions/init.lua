local BaseClassMod = script:WaitForChild("BaseClass")
local BaseClass do
    if BaseClassMod then
        BaseClass = require(BaseClassMod)
    end
end
local ClassMod do
    if BaseClassMod then
        ClassMod = BaseClassMod:WaitForChild("Class")
    end
end
local Class do
    if ClassMod then
        Class = require(ClassMod)
    end
end
local Internal do
    local Mod = ClassMod:WaitForChild("Internal")
    if Mod then
        Internal = require(Mod)
    end
end
local External do
    local Mod = nil--ClassMod:WaitForChild("External")
    if Mod then
        External = require(Mod)
    end
end
local Output = {
    BaseClass = BaseClass;
    Class = Class;
    Internal = Internal;
    External = External;
}
return Output