--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local mouse = player:GetMouse()

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "BallNoclipGUI"
gui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 20)
uicorner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Ball & Noclip GUI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- Made by label
local madeBy = Instance.new("TextLabel")
madeBy.Size = UDim2.new(0, 180, 0, 30)
madeBy.Position = UDim2.new(1, -230, 0, 0)
madeBy.BackgroundTransparency = 1
madeBy.Text = "Made by cosmicgalaxysscripts"
madeBy.TextColor3 = Color3.fromRGB(255, 255, 255)
madeBy.Font = Enum.Font.SourceSansItalic
madeBy.TextSize = 14
madeBy.TextXAlignment = Enum.TextXAlignment.Left
madeBy.Parent = mainFrame

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 20
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = mainFrame
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 10)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -80, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 20
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Parent = mainFrame
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 10)

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame:TweenSize(UDim2.new(0, 350, 0, 30), Enum.EasingDirection.In, Enum.EasingStyle.Quint, 0.5)
    else
        mainFrame:TweenSize(UDim2.new(0, 350, 0, 450), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5)
    end
end)

-- Draggable GUI
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

-- Scrolling Frame
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -50)
scrollingFrame.Position = UDim2.new(0, 10, 0, 40)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 350)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.Parent = mainFrame
local layout = Instance.new("UIListLayout", scrollingFrame)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

--// Balls
local balls = {}

local function spawnBalls(amount)
    for i = 1, amount do
        local ball = Instance.new("Part")
        ball.Shape = Enum.PartType.Ball
        ball.Size = Vector3.new(2,2,2)
        ball.Position = player.Character.HumanoidRootPart.Position + Vector3.new(math.random(-10,10),5,math.random(-10,10))
        ball.Anchored = false
        ball.Parent = workspace
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(math.random(-5,5), math.random(5,15), math.random(-5,5))
        bodyVelocity.MaxForce = Vector3.new(400000,400000,400000)
        bodyVelocity.Parent = ball
        table.insert(balls, ball)
    end
end

local function clearBalls()
    for _, b in ipairs(balls) do
        if b and b.Parent then
            b:Destroy()
        end
    end
    balls = {}
end

--// Buttons
local buttonData = {
    {text="Spawn 50 Balls", func=function() spawnBalls(50) end},
    {text="Spawn 100 Balls", func=function() spawnBalls(100) end},
    {text="Spawn 200 Balls", func=function() spawnBalls(200) end},
    {text="Spawn 250 Balls", func=function() spawnBalls(250) end},
    {text="Clear All Balls", func=clearBalls},
    {text="Fly GUI", func=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end},
    {text="Noclip", func=function()
        RunService.Stepped:Connect(function()
            if character and character:FindFirstChild("HumanoidRootPart") then
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end},
    {text="Change Skybox", func=function()
        local sky = Instance.new("Sky")
        sky.SkyboxBk = "rbxassetid://133939598138266"
        sky.SkyboxDn = "rbxassetid://133939598138266"
        sky.SkyboxFt = "rbxassetid://133939598138266"
        sky.SkyboxLf = "rbxassetid://133939598138266"
        sky.SkyboxRt = "rbxassetid://133939598138266"
        sky.SkyboxUp = "rbxassetid://133939598138266"
        sky.Parent = Lighting
    end},
}

for _, data in ipairs(buttonData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(math.random(100,255), math.random(100,255), math.random(100,255))
    btn.Text = data.text
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = scrollingFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    btn.MouseButton1Click:Connect(data.func)
end
