local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedModules = ReplicatedStorage:WaitForChild("Modules")
local ScriptUtilities do
    local Mod = ReplicatedModules:WaitForChild("ScriptUtilities")
    if Mod then
        ScriptUtilities = require(Mod)
    end
end

return ScriptUtilities:ModulesToTable(script:GetChildren())
--[[
    {
    Version = {
        Release = 0; --Public
        Test = 0; --Testing/Private
        Development = 0; --Studio
    };
    DefaultLanguage = "en-us";
    IsPublic = false;
    IsTesting = false;
    IsStudio = RunService:IsStudio();
    Perspective = GetPerspective();
    
}
]]