local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedModules = ReplicatedStorage:WaitForChild("Modules")
local ClassMod do
    local BaseClassMod = ReplicatedModules:WaitForChild("BaseClass")
    if BaseClassMod then
        ClassMod = BaseClassMod:WaitForChild("Class")
    end
end
local InternalMod do
    local Mod = ClassMod:WaitForChild("Internal")
    if Mod then
        InternalMod = require(Mod)
    end
end
local ExternalMod do
    local Mod = nil--ClassMod:WaitForChild("External")
    if Mod then
        ExternalMod = require(Mod)
    end
end
local Output = {
    Internal = InternalMod;
    External = ExternalMod;
}
return Output