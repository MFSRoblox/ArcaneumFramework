local Module = script.Parent
return {
    InitName = Module.Name;
    BootOrder = 1;
    Version = "1.0.0";
    Dependacies = {
        
    };
    __call = require(Module).Setup
}