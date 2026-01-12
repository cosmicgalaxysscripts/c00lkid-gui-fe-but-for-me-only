local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "BallSpawnerGUI"
gui.Parent = game.CoreGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
frame.Parent = gui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 15)
uicorner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Ball Spawner"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = frame

-- Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0.5, -20)
button.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
button.Text = "Spawn Balls"
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = frame

local uicornerBtn = Instance.new("UICorner")
uicornerBtn.CornerRadius = UDim.new(0, 10)
uicornerBtn.Parent = button

-- Function to spawn balls
local function spawnBalls()
    for i = 1, 50 do -- spawn 50 balls
        local ball = Instance.new("Part")
        ball.Shape = Enum.PartType.Ball
        ball.Size = Vector3.new(2, 2, 2)
        ball.Position = player.Character.HumanoidRootPart.Position + Vector3.new(math.random(-10, 10), 5, math.random(-10, 10))
        ball.Anchored = false
        ball.BrickColor = BrickColor.Random()
        ball.Parent = workspace

        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(math.random(-50,50), math.random(20,50), math.random(-50,50))
        bv.P = 500
        bv.MaxForce = Vector3.new(4000,4000,4000)
        bv.Parent = ball
    end
end

button.MouseButton1Click:Connect(spawnBalls)

