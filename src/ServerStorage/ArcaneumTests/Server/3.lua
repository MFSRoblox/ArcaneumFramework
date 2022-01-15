return function(self)
    local ArcaneumGlobals = self.ArcaneumGlobals
    local BalisticsFunctions = ArcaneumGlobals.Balistics
    local DesiredPrecision = 1e-4/2
    local PrecisionVector = Vector3.new(1,1,1)*DesiredPrecision
    local function CompareVectors(V1: Vector3, V2: Vector3)
        local V1L = V1 - PrecisionVector
        local V1G = V1 + PrecisionVector
        return (V1L.X <= V2.X and V2.X <= V1G.X) and (V1L.Y <= V2.Y and V2.Y <= V1G.Y) and (V1L.Z <= V2.Z and V2.Z <= V1G.Z)
    end
    local ThisTest = self.TesterClass:New("Balistics Functions")
    ThisTest:AddTest("Simple Linear Hitable Check", false, function()
        local ProjecitleSpeed = 100
        local ShooterPosition = Vector3.new()
        local TargetPosition = Vector3.new(0,0,100)
        local TargetVelocity = Vector3.new(0,0,1)
        local results = table.pack(BalisticsFunctions:GetTargetTimes(ProjecitleSpeed, ShooterPosition, nil, nil, TargetPosition, TargetVelocity))
        print("Hitable Check Results:", table.unpack(results))
        assert(#results > 0, "Hitable Check failure! Not enough numbers were returned!")
        table.sort(results,function(a,b)
            if a >= 0 then
                if b >= 0 then
                    return a < b
                else
                    return true
                end
            else
                return false
            end
        end)
        local MinimalTime = results[1]
        --MinimalTime = tonumber(string.format(PrecisionString,MinimalTime))
        print("Minimal Time to hit the target:",MinimalTime)
        assert(MinimalTime ~= nil and MinimalTime >= 0, "Minimal Time is negative or doesn't exist!")
        local ProjectedHitPosition = TargetPosition + TargetVelocity * MinimalTime
        print("Target Intercept Position:", ProjectedHitPosition)
        local SimulationLookVector = (ProjectedHitPosition - ShooterPosition).Unit
        print("Simulated Look Vector to hit target:", SimulationLookVector)
        local SimulatedHitPosition = ShooterPosition + SimulationLookVector * ProjecitleSpeed * MinimalTime
        print("Simulated Hit Position:", SimulatedHitPosition)
        assert(CompareVectors(SimulatedHitPosition,ProjectedHitPosition),"Target Intercept and Simulated Hit don't equal each other!")
        --assert(SimulatedHitPosition - PrecisionVector <= ProjectedHitPosition and ProjectedHitPosition <= SimulatedHitPosition + PrecisionVector, "Target Intercept and Simulated Hit don't equal each other!")
        return true
    end)
    ThisTest:AddTest("Intercept Accelerating Object Check", false, function()
        local ProjecitleSpeed = 100
        local ShooterPosition = Vector3.new()
        local TargetPosition = Vector3.new(0,0,100)
        local TargetVelocity = Vector3.new(0,0,1)
        local TargetAcceleration = Vector3.new(0,0,1)
        local results = table.pack(BalisticsFunctions:GetTargetTimes(ProjecitleSpeed, ShooterPosition, nil, nil, TargetPosition, TargetVelocity, TargetAcceleration))
        print("Hitable Check Results:", table.unpack(results))
        assert(#results > 0, "Hitable Check failure! Not enough numbers were returned!")
        table.sort(results,function(a,b)
            if a >= 0 then
                if b >= 0 then
                    return a < b
                else
                    return true
                end
            else
                return false
            end
        end)
        local MinimalTime = results[1]
        --MinimalTime = tonumber(string.format(PrecisionString,MinimalTime))
        print("Minimal Time to hit the target:",MinimalTime)
        assert(MinimalTime ~= nil and MinimalTime >= 0, "Minimal Time is negative or doesn't exist!")
        local ProjectedHitPosition = TargetPosition + TargetVelocity * MinimalTime + 0.5 * TargetAcceleration * MinimalTime*MinimalTime
        print("Target Intercept Position:", ProjectedHitPosition)
        local SimulationLookVector = (ProjectedHitPosition - ShooterPosition).Unit
        print("Simulated Look Vector to hit target:", SimulationLookVector)
        local SimulatedHitPosition = ShooterPosition + SimulationLookVector * ProjecitleSpeed * MinimalTime
        print("Simulated Hit Position:", SimulatedHitPosition)
        assert(CompareVectors(SimulatedHitPosition,ProjectedHitPosition),"Target Intercept and Simulated Hit don't equal each other!")
        --assert(SimulatedHitPosition - PrecisionVector <= ProjectedHitPosition and ProjectedHitPosition <= SimulatedHitPosition + PrecisionVector, "Target Intercept and Simulated Hit don't equal each other!")
        return true
    end)
    return ThisTest
end