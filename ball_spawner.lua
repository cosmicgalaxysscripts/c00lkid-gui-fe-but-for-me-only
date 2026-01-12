-- FE Ball Spawner GUI
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Create the ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "BallSpawnerGUI"
gui.Parent = game.CoreGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 255)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 15)
uicorner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "FE Ball Spawner"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- Made by text
local madeBy = Instance.new("TextLabel")
madeBy.Size = UDim2.new(0, 150, 0, 30)
madeBy.Position = UDim2.new(0, 10, 0, 0)
madeBy.Text = "made by cosmicgalaxysscripts"
madeBy.TextColor3 = Color3.fromRGB(255, 255, 255)
madeBy.Font = Enum.Font.SourceSans
madeBy.TextSize = 14
madeBy.BackgroundTransparency = 1
madeBy.Position = UDim2.new(0, 10, 0, 5)
madeBy.Parent = mainFrame

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -40, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 20
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Parent = mainFrame

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame:TweenSize(UDim2.new(0, 300, 0, 30), Enum.EasingDirection.In, Enum.EasingStyle.Quint, 0.3)
    else
        mainFrame:TweenSize(UDim2.new(0, 300, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.3)
    end
end)

-- Draggable
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

-- Scrolling frame
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -50)
scrollingFrame.Position = UDim2.new(0, 10, 0, 40)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 300)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = scrollingFrame

-- Function to spawn FE balls
local spawnedBalls = {}
local function spawnBalls(amount)
    for i = 1, amount do
        local ball = Instance.new("Part")
        ball.Shape = Enum.PartType.Ball
        ball.Size = Vector3.new(4, 4, 4)
        ball.Position = player.Character.PrimaryPart.Position + Vector3.new(math.random(-10,10),5,math.random(-10,10))
        ball.Anchored = false
        ball.CanCollide = true
        ball.Material = Enum.Material.Neon
        ball.Color = Color3.fromRGB(math.random(50,255), math.random(50,255), math.random(50,255))
        ball.Parent = workspace
        table.insert(spawnedBalls, ball)
    end
end

local function clearAllBalls()
    for _, ball in pairs(spawnedBalls) do
        if ball and ball.Parent then
            ball:Destroy()
        end
    end
    spawnedBalls = {}
end

-- Spawn buttons
local buttonData = {10,50,100,200,250}
for _, amount in ipairs(buttonData) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(math.random(100,255), math.random(100,255), math.random(100,255))
    button.Text = "Spawn "..amount
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 20
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.Parent = scrollingFrame

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 10)
    uicorner.Parent = button

    button.MouseButton1Click:Connect(function()
        spawnBalls(amount)
    end)
end

-- Clear all button
local clearButton = Instance.new("TextButton")
clearButton.Size = UDim2.new(0.8,0,0,40)
clearButton.BackgroundColor3 = Color3.fromRGB(255,50,50)
clearButton.Text = "Clear All"
clearButton.Font = Enum.Font.SourceSansBold
clearButton.TextSize = 20
clearButton.TextColor3 = Color3.fromRGB(255,255,255)
clearButton.Parent = scrollingFrame

local clearUICorner = Instance.new("UICorner")
clearUICorner.CornerRadius = UDim.new(0,10)
clearUICorner.Parent = clearButton

clearButton.MouseButton1Click:Connect(function()
    clearAllBalls()
end)
