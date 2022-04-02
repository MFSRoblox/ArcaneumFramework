local ModuleInfo =  {
    InitName = script.Name;
    BootOrder = 1;
    Version = "1.0.0";
    Dependacies = {
        Utilities = "1.0.0"
    };
}
local ClientGlobals = {}
function ClientGlobals.Setup(_output: table, ArcaneumGlobals: table): table
    local Utilities = ArcaneumGlobals.Utilities
    ClientGlobals = Utilities:ModulesToTable(script:GetChildren())
    return ClientGlobals
end;
ModuleInfo.__call = ClientGlobals.Setup
return ModuleInfo