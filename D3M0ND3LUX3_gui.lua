--// BALL SPAWNER & SKYBOX GUI
local player = game.Players.LocalPlayer
local workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "BallSpawnerGui"
gui.Parent = game.CoreGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 400)
frame.Position = UDim2.new(0.5, -125, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Parent = gui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 10)
uicorner.Parent = frame

-- Draggable GUI
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 20
minimizeButton.TextColor3 = Color3.fromRGB(255,255,255)
minimizeButton.Parent = frame

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        frame:TweenSize(UDim2.new(0, 250, 0, 40), Enum.EasingDirection.In, Enum.EasingStyle.Quint, 0.3)
    else
        frame:TweenSize(UDim2.new(0, 250, 0, 400), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.3)
    end
end)

-- Scrolling Frame for buttons
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -50)
scroll.Position = UDim2.new(0, 10, 0, 40)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 500)
scroll.ScrollBarThickness = 6
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = scroll

-- Ball spawning function
local function spawnBalls(amount)
    for i = 1, amount do
        local ball = Instance.new("Part")
        ball.Shape = Enum.PartType.Ball
        ball.Size = Vector3.new(2,2,2)
        ball.Position = player.Character and player.Character.HumanoidRootPart.Position + Vector3.new(math.random(-5,5),5,math.random(-5,5)) or Vector3.new(0,10,0)
        ball.Anchored = false
        ball.CanCollide = true
        ball.Material = Enum.Material.SmoothPlastic
        ball.BrickColor = BrickColor.Random()
        ball.Parent = workspace

        -- Small push to scatter
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(math.random(-5,5),0,math.random(-5,5))
        bv.MaxForce = Vector3.new(4000,0,4000)
        bv.P = 1000
        bv.Parent = ball
        Debris:AddItem(bv,0.1)
    end
end

-- Buttons for different spawn amounts
local buttonAmounts = {10, 50, 100, 200, 250}
for _, amount in ipairs(buttonAmounts) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(math.random(50,255), math.random(50,255), math.random(50,255))
    btn.Text = "Spawn "..amount
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = scroll

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,10)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        spawnBalls(amount)
    end)
end

-- Skybox changer button
local skyBtn = Instance.new("TextButton")
skyBtn.Size = UDim2.new(0.8, 0, 0, 40)
skyBtn.BackgroundColor3 = Color3.fromRGB(100,100,255)
skyBtn.Text = "Change Skybox"
skyBtn.Font = Enum.Font.SourceSansBold
skyBtn.TextSize = 20
skyBtn.TextColor3 = Color3.fromRGB(255,255,255)
skyBtn.Parent = scroll

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,10)
corner.Parent = skyBtn

skyBtn.MouseButton1Click:Connect(function()
    local decalId = "133939598138266"
    local sky = workspace:FindFirstChildOfClass("Sky") or Instance.new("Sky", workspace)
    sky.SkyboxBk = "rbxassetid://"..decalId
    sky.SkyboxDn = "rbxassetid://"..decalId
    sky.SkyboxFt = "rbxassetid://"..decalId
    sky.SkyboxLf = "rbxassetid://"..decalId
    sky.SkyboxRt = "rbxassetid://"..decalId
    sky.SkyboxUp = "rbxassetid://"..decalId
end)

