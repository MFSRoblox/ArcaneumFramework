local Module = script.Parent
return {
    InitName = Module.Name;
    BootOrder = 3;
    Version = "1.0.0";
    Dependacies = {
        Utilities = "1.0.0"
    };
    __call = require(Module).Setup
}