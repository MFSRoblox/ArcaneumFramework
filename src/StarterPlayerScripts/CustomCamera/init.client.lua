local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local CFrame = CFrame
local CFramenew = CFrame.new
local CFrameAngles = CFrame.Angles
local CFrameOrientation = CFrame.fromOrientation
local CFramelookAt = CFrame.lookAt
local math = math
local mathrad = math.rad
local mathmin = math.min
local print = print
local CustomCamera = Enum.CameraType.Custom
local ScriptableCamera = Enum.CameraType.Scriptable

local Config = {
	Yaw = 0;
	Pitch = 0;
	Radius = 750;
	Speed = 10;
	SpawnOffset = CFramenew(0, 5, 12);
	DefaultLerpPercent = 0.15;
	IncreaseLerpPercent = 0.005;
}
local TargetYaw = Config.Yaw
script.TargetYaw.Changed:Connect(function(V)
	TargetYaw = V
end)
script.TargetYaw.Value = Config.Yaw

local TargetZoom = Config.Radius
script.TargetZoom.Changed:Connect(function(V)
	TargetZoom = V
end)
script.TargetZoom.Value = Config.Radius

local TargetPitch = Config.Radius
script.TargetPitch.Changed:Connect(function(V)
	TargetPitch = V
end)
script.TargetPitch.Value = Config.Radius

local LerpPercent = Config.DefaultLerpPercent
local function FocusPosition(FocusFrame,OffsetFrame,Pitch,Yaw,Roll,Rate)
	FocusFrame = FocusFrame or CFramenew()
	OffsetFrame = OffsetFrame or CFramenew(0, 0, TargetZoom)
	--local CF = Frame * CFrameAngles(0, math.rad(R), 0) * CFrameAngles(math.rad(-30), 0, 0) * CFramenew(0, 0, TargetZoom)
	Pitch = CFrameAngles(Pitch or 0,0,0)
	Yaw = CFrameAngles(0,Yaw or 0,0)
	Roll = CFrameAngles(0,0,Roll or 0)
	Rate = Rate or 0.015
	local CF = FocusFrame * Yaw * Pitch * Roll * OffsetFrame
	Camera.CFrame = Camera.CFrame:Lerp(CF, mathmin(Rate,1))
	return CF
end

local R = 0
local Modes
Modes = {
	function(dT) -- 1, orbit part
		local Subject = Camera.CameraSubject
		Camera.CameraType = ScriptableCamera
		local Frame
		if Subject and Subject:IsA("BasePart") then
			Frame = CFramenew(Subject.Position)
		else
			Frame = CFramenew()
		end
		Camera.Focus = Frame
		R += dT*Config.Speed
		FocusPosition(Frame,nil,mathrad(-30),mathrad(R),0)
	end;
	function(dT) -- 2, focus ship part
		local Subject = Camera.CameraSubject
		Camera.CameraType = ScriptableCamera
		if Subject:IsA("BasePart") then
			local Frame = Subject.CFrame
			Camera.Focus = Frame
			FocusPosition(Frame,nil,mathrad(-85),mathrad(TargetYaw),0,LerpPercent)
			LerpPercent += Config.IncreaseLerpPercent
		else
			Modes[1](dT)
		end
	end;
	function(dT) -- 3, focus player
		if Camera.CameraType ~= CustomCamera then
			local CameraSubject = Camera.CameraSubject
			local Character = CameraSubject.Parent
			local Subject = Character.PrimaryPart
			local PFrame = Subject.CFrame
			--print(Subject,Subject.Name == "Humanoid", Character == Player.Character)
			if Subject.Name == "HumanoidRootPart" and Character == Player.Character then
				local CF = FocusPosition(PFrame,Config.SpawnOffset,mathrad(-15),0,0,LerpPercent)
				LerpPercent += Config.IncreaseLerpPercent
				if (Camera.CFrame.Position - CF.Position).Magnitude < 10 then --if near player, transfer control.
					Camera.CFrame = CFramelookAt((PFrame* Config.SpawnOffset).Position, PFrame.Position)
					local D = (Camera.CFrame.Position - PFrame.Position).Magnitude
					Player.CameraMaxZoomDistance = D --reset the zoom level
					Player.CameraMinZoomDistance = D
					Camera.CameraType = CustomCamera
					Player.CameraMaxZoomDistance = StarterPlayer.CameraMaxZoomDistance
					Player.CameraMinZoomDistance = StarterPlayer.CameraMinZoomDistance
				end
			else
				FocusPosition(PFrame,Config.SpawnOffset+Vector3.new(0,0,-TargetZoom),mathrad(-15+TargetPitch),0,0,LerpPercent) --FocusPosition(PFrame,Config.SpawnOffset,mathrad(-15),mathrad(R),0)
				LerpPercent += Config.IncreaseLerpPercent
			end
		end
	end;
	
}
--Modes.__index = function(self, index) return rawget(self,index) or rawget(self,1) end
local Mode = script.Mode.Value
local function CustomCameraFunction(deltaTime)
	Modes[Mode](deltaTime)
end
RunService:BindToRenderStep("CustomCamera",199,CustomCameraFunction)

Camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
	LerpPercent = Config.DefaultLerpPercent
end)

script.Mode.Changed:Connect(function(V)
	_,_,R = Camera.CFrame:ToEulerAnglesXYZ()--:ToEulerAnglesXYZ()
	R = math.deg(R)
	Mode = V
end)

Player.CharacterAdded:Connect(function(character)
	local Humanoid = character:WaitForChild("Humanoid")
	Camera.CameraSubject = Humanoid
	script.Mode.Value = 3
end)