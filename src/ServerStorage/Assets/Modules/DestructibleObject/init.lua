local DestructibleObject = {} do
    do
        local Mod = script:WaitForChild("DamageUtil")
        --if Mod then
            DestructibleObject.DamageUtil = require(Mod)
        --end
    end
end
return DestructibleObject