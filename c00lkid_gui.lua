-- SERVICES
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ChaosAdminGui"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(600, 400)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.fromOffset(20, 5)
title.BackgroundTransparency = 1
title.Text = "CHAOS ADMIN PANEL"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

-- SCROLL
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -20, 1, -50)
scroll.Position = UDim2.fromOffset(10, 40)
scroll.CanvasSize = UDim2.new(0,0,0,1400)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIGridLayout", scroll)
layout.CellSize = UDim2.fromOffset(180, 40)
layout.CellPadding = UDim2.fromOffset(10,10)

-- BUTTON CREATOR
local function makeButton(name)
	local b = Instance.new("TextButton")
	b.Text = name
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 16
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(90,90,90)
	b.Parent = scroll
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

-- FUNCTIONS
local function Walkspeed() hum.WalkSpeed = 50 end
local function JP() hum.JumpPower = 120 end
local function Suicide() char:BreakJoints() end

local flying = false
local bv
local function Fly()
	flying = not flying
	if flying then
		bv = Instance.new("BodyVelocity", hrp)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	else
		if bv then bv:Destroy() end
	end
end

local function Fling()
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local v = Instance.new("BodyVelocity", p.Character.HumanoidRootPart)
			v.MaxForce = Vector3.new(1e5,1e5,1e5)
			v.Velocity = Vector3.new(0,200,0)
			Debris:AddItem(v,0.2)
		end
	end
end

local antifling = false
local function Antifling()
	antifling = not antifling
	hrp:GetPropertyChangedSignal("Velocity"):Connect(function()
		if antifling and hrp.Velocity.Magnitude > 60 then
			hrp.Velocity = Vector3.zero
		end
	end)
end

local function BALLZ()
	for i=1,6 do
		local p = Instance.new("Part")
		p.Shape = Enum.PartType.Ball
		p.Size = Vector3.new(3,3,3)
		p.Position = hrp.Position + Vector3.new(math.random(-5,5),5,math.random(-5,5))
		p.BrickColor = BrickColor.Random()
		p.Parent = workspace
		Debris:AddItem(p,8)
	end
end

local function Sky()
	local sky = Instance.new("Sky")
	sky.Name = "ChaosSky"
	local id = "133939598138266"
	sky.SkyboxBk = "rbxassetid://"..id
	sky.SkyboxDn = "rbxassetid://"..id
	sky.SkyboxFt = "rbxassetid://"..id
	sky.SkyboxLf = "rbxassetid://"..id
	sky.SkyboxRt = "rbxassetid://"..id
	sky.SkyboxUp = "rbxassetid://"..id
	if Lighting:FindFirstChild("ChaosSky") then
		Lighting.ChaosSky:Destroy()
	end
	sky.Parent = Lighting
end

-- SAFE SEX BUTTON EFFECT (NON‑SEXUAL)
local function Sex()
	local p = Instance.new("Part")
	p.Size = Vector3.new(4,4,4)
	p.Position = hrp.Position + Vector3.new(0,6,0)
	p.BrickColor = BrickColor.new("Hot pink")
	p.Anchored = false
	p.Parent = workspace
	Debris:AddItem(p,6)
end

-- BUTTON LIST (ALL OF THEM)
local buttons = {
"Right","Left","SaveConfig","JP","Fling","Pad","Antifling","meme","Suicide",
"BackFlip","BALLZ","Empty","Fly","Empty_2","Walkspeed","Space","Skydive",
"Nameless","Elysian","RC7","Sex","Wedge","ChaosGui","Cloudy","Rzer",
"Empty_3","Empty_4","Empty_5","InfYield","Rock4usAdmin","Dex",
"ShapeShifter","Empty_6","GaleFighter","Empty_7","Empty_8","Empty_9",
"Classic","MemeDancer","Dash","DepressedLMAO","Sonic","Empty_10",
"ButitiOffender","Silly","pres1","pres2","pres3","pres4","pres5",
"pres6","pres7","pres8","pres9","pres10","big","bgase","Empty_11",
"Empty_12","Empty_13","Empty_14","Empty_15","Empty_16","Empty_17",
"Empty_18","troll","Sky","fiyah","t3am","ITSRAININGMEN","Empty_19",
"decalspa","diediedie","CloseOpen","BUGS"
}

-- FUNCTION MAP
local map = {
Walkspeed = Walkspeed,
JP = JP,
Fly = Fly,
Suicide = Suicide,
Fling = Fling,
Antifling = Antifling,
BALLZ = BALLZ,
Sky = Sky,
decalspa = Sky,
diediedie = Suicide,
Sex = Sex
}

-- CREATE BUTTONS
for _,name in ipairs(buttons) do
	local b = makeButton(name)
	b.MouseButton1Click:Connect(function()
		if map[name] then
			map[name]()
		else
			BALLZ()
		end
	end)
end

print("CHAOS ADMIN LOADED")
