local ShieldBase = game.ReplicatedStorage.Assets.Abilities.CylinderShield

local Ability = {
	Effect = "CylinderShield", --Required
	RealName = "Shield Torpedoes", 
	ChargeTime = 0,
	Duration = 30,
	Recharge = 45,
	Range = 1500,
	Deployment = {
		Type = "Missile",
		RateOfFire = 0.1,
		DeployedPerShot = 2,
		InheritVelocity = true,
		LookVectorMod = {
			Pitch = {
				Min = 0,
				Max = math.pi,
			},
			Yaw = {
				Min = 0,
				Max = math.pi,
			},
			Roll = {
				Min = 0,
				Max = math.pi,
			}
		},
		Stats = script.Missile
	},
	Barriers = {
		{
			Base = ShieldBase,
			CanCollide = false,
			DeployTweenData = TweenInfo.new(1, Enum.EasingStyle.Sine),
			Scale = Vector3.new(30,30,1),
			Health = 0,
			Shield = 15000,
			DecayTime = 5,
			Location = Vector3.new(-57.5, -16.25, 1.25),

		},
		{
			Base = ShieldBase,
			CanCollide = false,
			DeployTweenData = TweenInfo.new(1, Enum.EasingStyle.Sine),
			Scale = Vector3.new(30,30,1),
			Health = 0,
			Shield = 15000,
			DecayTime = 5,
			Location = Vector3.new(57.5, -16.25, 1.25),
		},
		{
			Base = ShieldBase,
			CanCollide = false,
			DeployTweenData = TweenInfo.new(1, Enum.EasingStyle.Sine),
			Scale = Vector3.new(40,40,1),
			Health = 0,
			Shield = 22500,
			DecayTime = 5,
			Location = Vector3.new(21.25, -21.25, 0),
		},
		{
			Base = ShieldBase,
			CanCollide = false,
			DeployTweenData = TweenInfo.new(1, Enum.EasingStyle.Sine),
			Scale = Vector3.new(40,40,1),
			Health = 0,
			Shield = 22500,
			DecayTime = 5,
			Location = Vector3.new(-21.25, -21.25, 0),

		},
		{
			Base = ShieldBase,
			CanCollide = false,
			DeployTweenData = TweenInfo.new(1, Enum.EasingStyle.Sine),
			Scale = Vector3.new(30,30,1),
			Health = 0,
			Shield = 15000,
			DecayTime = 5,
			Location = Vector3.new(57.5, 16.25, 1.25),
		},
		{
			Base = ShieldBase,
			CanCollide = false,
			DeployTweenData = TweenInfo.new(1, Enum.EasingStyle.Sine),
			Scale = Vector3.new(40,40,1),
			Health = 0,
			Shield = 22500,
			DecayTime = 5,
			Location = Vector3.new(21.25, 21.25, 0),
		},
		{
			Base = ShieldBase,
			CanCollide = false,
			DeployTweenData = TweenInfo.new(1, Enum.EasingStyle.Sine),
			Scale = Vector3.new(40,40,1),
			Health = 0,
			Shield = 22500,
			DecayTime = 5,
			Location = Vector3.new(-21.25, 21.25, 0),
		},
		{
			Base = ShieldBase,
			CanCollide = false,
			DeployTweenData = TweenInfo.new(1, Enum.EasingStyle.Sine),
			Scale = Vector3.new(30,30,1),
			Health = 0,
			Shield = 15000,
			DecayTime = 5,
			Location = Vector3.new(-57.5, 16.25, 1.25),
		},
	}
}

return Ability
--[[
Deployment Method:
-Type (Missile)
-LookVectorMod (CFrameMultiplier)
-Speed
-Color
-Size
-Sound
-TrailEffects
-Damage?

Shield Stats:
-Shape (Flat Cylinder)
-Radius
-Durability
-Locations (Relative to Ship, looking towards deployment range)

Ability Stats:
-Charge
-Duration
-Recharge
]]