return function(self)
    local ArcaneumGlobals = self.ArcaneumGlobals
    local Ballistics = ArcaneumGlobals.Ballistics
    local Utilities = Ballistics.Utilities
    local DesiredPrecision = 2
    local PrecisionVector = Vector3.new(1,1,1)*DesiredPrecision
    local function CompareNumbers(N1: number, N2: number, Precision: number?)
        return Utilities:CompareNumbers(N1, N2, Precision)
    end
    local function CompareVectors(V1: Vector3, V2: Vector3)
        if V1 == V2 then
            return true
        end
        local V1L = V1 - PrecisionVector/2
        local V1G = V1 + PrecisionVector/2
        return (V1L.X <= V2.X and V2.X <= V1G.X) and (V1L.Y <= V2.Y and V2.Y <= V1G.Y) and (V1L.Z <= V2.Z and V2.Z <= V1G.Z)
    end
    local function RemoveDuplicatesFromTable(InputTable: table)
        return Utilities:RemoveDuplicatesFromTable(InputTable)
    end
    local ThisTest = self.TesterClass:New("Balistics Functions")
    ThisTest:AddTest("Simple Linear Hitable Check", false, function()
        local ProjecitleSpeed = 100
        local ShooterPosition = Vector3.new()
        local TargetPosition = Vector3.new(0,0,100)
        local TargetVelocity = Vector3.new(0,0,1)
        print("Hit a target with a projectile that moves",ProjecitleSpeed,"studs per second, where the target is at",TargetPosition,"\nwith a velocity of",TargetVelocity,"studs per second")
        local results = table.pack(Ballistics:GetHitTimes(ProjecitleSpeed, ShooterPosition, nil, nil, TargetPosition, TargetVelocity))
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
    local CubicTestData = {
        --[[
            Coefficients = {T0,T1,T2,T3}; --such that 0 = T0 + T1x + T2x^2 + T3x^3
            Solutions = {S0,S1,S2}; --order doesn't matter, NaN should not be included, avoid duplicate numbers
        ]]
        {
            Coefficients = {-6,-11,3,2};
            Solutions = {2, -.5, -3};
        };
        {
            Coefficients = {12,4,-7,1};
            Solutions = {-1, 2, 6};
        };
        {
            Coefficients = {-6,11,-6,1};
            Solutions = {1,2,3};
        };
        {
            Coefficients = {-4,8,-5,1};
            Solutions = {1,2}
        };
        {
            Coefficients = {-1,3,-3,1};
            Solutions = {1}
        };
        {
            Coefficients = {-3,1,1,1};
            Solutions = {1}
        };
    }
    ThisTest:AddTest("Cubic Polynomial Check", true, function()
        for DataNumber,TestData in pairs(CubicTestData) do
            local Coefficients = TestData.Coefficients
            local Solutions = TestData.Solutions
            print(string.format("Find the roots of f(x) = %d + %dx + %dx^2 + %dx^3.",table.unpack(Coefficients)))
            local GeneratedSolutions = RemoveDuplicatesFromTable(table.pack(Utilities:SolvePolynomial(table.unpack(Coefficients))))
            table.sort(Solutions)
            table.sort(GeneratedSolutions)
            print("Generated Solutions:",table.unpack(GeneratedSolutions))
            print("Actual Solutions:",table.unpack(Solutions))
            assert(#Solutions == #GeneratedSolutions, "Number of Generated Solutions don't match Actual Solutions of Test " .. tostring(DataNumber) .."!")
            for i=1, #Solutions do
                assert(CompareNumbers(GeneratedSolutions[i],Solutions[i],DesiredPrecision), "Generated Solutions don't match Actual Solutions of Test " .. tostring(DataNumber) .."!")
            end
        end
        return true
    end)
    ThisTest:AddTest("Intercept Accelerating Object Check", false, function()
        local ProjecitleSpeed = 100
        local ShooterPosition = Vector3.new()
        local TargetPosition = Vector3.new(0,0,100)
        local TargetVelocity = Vector3.new(0,0,1)
        local TargetAcceleration = Vector3.new(0,0,1)
        print("Hit a target with a projectile that moves",ProjecitleSpeed,"studs per second, where the target is at",TargetPosition,"\nwith a velocity of",TargetVelocity,"studs per second \nand an acceleration of",TargetAcceleration,"studs per second per second")
        local results = table.pack(Ballistics:GetHitTimes(ProjecitleSpeed, ShooterPosition, nil, nil, TargetPosition, TargetVelocity, TargetAcceleration))
        print("Hitable Check Results:", table.unpack(results))
        print("What it should be close to:", 1.01531, 196.98469)
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
    ThisTest:AddTest("Small Intercept Jerk Object Check", false, function()
        local ProjecitleSpeed = 10
        local ShooterPosition = Vector3.new()
        local TargetPosition = Vector3.new(0,0,10)
        local TargetVelocity = Vector3.new(0,0,1)
        local TargetAcceleration = Vector3.new(0,0,1)
        local TargetJerk = Vector3.new(0,0,1)
        print("Hit a target with a projectile that moves",ProjecitleSpeed,"studs per second, where the target is at",TargetPosition,"\nwith a velocity of",TargetVelocity,"studs per second \nand an acceleration of",TargetAcceleration,"studs per second per second \nand jerk of",TargetJerk)
        local results = table.pack(Ballistics:GetHitTimesWithJerk(ProjecitleSpeed, ShooterPosition, nil, nil, nil, TargetPosition, TargetVelocity, TargetAcceleration, TargetJerk))
        print("Hitable Check Results:", table.unpack(results))
        print("What it should be close to:", 1.28)-- 12.797, 36.475
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
    ThisTest:AddTest("Large Fast Intercept Jerk Object Check", false, function()
        local ProjecitleSpeed = 100
        local ShooterPosition = Vector3.new()
        local TargetPosition = Vector3.new(0,0,100)
        local TargetVelocity = Vector3.new(0,0,1)
        local TargetAcceleration = Vector3.new(0,0,1)
        local TargetJerk = Vector3.new(0,0,1)
        print("Hit a target with a projectile that moves",ProjecitleSpeed,"studs per second, where the target is at",TargetPosition,"\nwith a velocity of",TargetVelocity,"studs per second \nand an acceleration of",TargetAcceleration,"studs per second per second \nand jerk of",TargetJerk)
        local results = table.pack(Ballistics:GetHitTimesWithJerk(ProjecitleSpeed, ShooterPosition, nil, nil, nil, TargetPosition, TargetVelocity, TargetAcceleration, TargetJerk))
        print("Hitable Check Results:", table.unpack(results))
        print("What it should be close to:", 1.019)
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
    ThisTest:AddTest("Complex Fast Intercept Jerk Object Check", false, function()
        local ProjecitleSpeed = 100
        local ShooterPosition = Vector3.new()
        local TargetPosition = Vector3.new(10,0,100)
        local TargetVelocity = Vector3.new(34,15,1)
        local TargetAcceleration = Vector3.new(20,3,1)
        local TargetJerk = Vector3.new(-1,5,1)
        print("Hit a target with a projectile that moves",ProjecitleSpeed,"studs per second, where the target is at",TargetPosition,"\nwith a velocity of",TargetVelocity,"studs per second \nand an acceleration of",TargetAcceleration,"studs per second per second \nand jerk of",TargetJerk)
        local results = table.pack(Ballistics:GetHitTimesWithJerk(ProjecitleSpeed, ShooterPosition, nil, nil, nil, TargetPosition, TargetVelocity, TargetAcceleration, TargetJerk))
        print("Hitable Check Results:", table.unpack(results))
        --print("What it should be close to:", 1.019)
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