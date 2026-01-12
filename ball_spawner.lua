local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- Folder to hold all spawned balls
local ballsFolder = Workspace:FindFirstChild("SpawnedBalls") or Instance.new("Folder", Workspace)
ballsFolder.Name = "SpawnedBalls"

-- GUI setup
local gui = Instance.new("ScreenGui")
gui.Name = "BallGui"
gui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
mainFrame.Active = true
mainFrame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎾 Ball Spawner"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- Make draggable
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Scroll frame for buttons
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -50)
scrollingFrame.Position = UDim2.new(0, 10, 0, 40)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollingFrame

-- Function to spawn balls
local function spawnBalls(amount)
    for i = 1, amount do
        local ball = Instance.new("Part")
        ball.Shape = Enum.PartType.Ball
        ball.Size = Vector3.new(2,2,2)
        ball.Position = player.Character and player.Character.PrimaryPart.Position + Vector3.new(0,5,0) or Vector3.new(0,5,0)
        ball.Anchored = false
        ball.CanCollide = true
        ball.Material = Enum.Material.Neon
        ball.Color = Color3.fromRGB(math.random(50,255), math.random(50,255), math.random(50,255))
        ball.Parent = ballsFolder
    end
end

-- Clear all balls
local function clearBalls()
    for _, ball in ipairs(ballsFolder:GetChildren()) do
        ball:Destroy()
    end
end

-- Button names & amounts
local buttons = {
    ["Spawn 10"] = 10,
    ["Spawn 50"] = 50,
    ["Spawn 100"] = 100,
    ["Spawn 200"] = 200,
    ["Spawn 250"] = 250,
    ["Clear All Balls"] = "clear"
}

-- Create buttons
for name, value in pairs(buttons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,35)
    btn.BackgroundColor3 = Color3.fromRGB(math.random(100,255),math.random(100,255),math.random(100,255))
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.Text = name
    btn.Parent = scrollingFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if value == "clear" then
            clearBalls()
        else
            spawnBalls(value)
        end
    end)
end
