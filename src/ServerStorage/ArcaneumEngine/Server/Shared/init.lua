local ServerGlobals = {}
function ServerGlobals.Setup(_output: table, ArcaneumGlobals: table): table
    local Utilities = ArcaneumGlobals.Utilities
    ServerGlobals = Utilities:ModulesToTable(script:GetChildren())
    return ServerGlobals
end;
return ServerGlobals