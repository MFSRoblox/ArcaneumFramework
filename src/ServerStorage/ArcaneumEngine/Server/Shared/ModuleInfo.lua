local Module = script.Parent
return {
    InitName = Module.Name;
    BootOrder = 1;
    Version = "1.0.0";
    Dependacies = {
        Utilities = "1.0.0"
    };
    __call = require(Module).Setup
}