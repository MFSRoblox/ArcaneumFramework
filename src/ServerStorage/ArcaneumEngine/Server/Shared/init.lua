local ModuleInfo =  {
    InitName = script.Name;
    BootOrder = 1;
    Version = "1.0.0";
    Dependacies = {
        Utilities = "1.0.0"
    };
}
local ServerGlobals = {}
function ServerGlobals.Setup(_output: table, ArcaneumGlobals: table): table
    local Utilities = ArcaneumGlobals.Utilities
    ServerGlobals = Utilities:ModulesToTable(script:GetChildren())
    return ServerGlobals
end;
ModuleInfo.__call = ServerGlobals.Setup
return ModuleInfo