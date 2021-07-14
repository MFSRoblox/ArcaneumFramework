local RunService = game:GetService("RunService")
if RunService:IsServer() then return "Server" else return "Client" end