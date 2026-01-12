-- Full Ball Spawner GUI + Fly Button (Regular Script)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

-- Folder for balls
local ballFolder = Instance.new("Folder")
ballFolder.Name = "FEBalls"
ballFolder.Parent = Workspace

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "BallSpawnerGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 280)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.Parent = gui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0,12)
uicorner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 30)
title.Position = UDim2.new(0,10,0,0)
title.Text = "Ball Spawner FE"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- Minimize button
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1,-35,0,0)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(200,200,50)
minimize.Parent = mainFrame

minimize.MouseButton1Click:Connect(function()
    if mainFrame.Size.Y.Offset == 280 then
        mainFrame:TweenSize(UDim2.new(0,300,0,30), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.3)
    else
        mainFrame:TweenSize(UDim2.new(0,300,0,280), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad, 0.3)
    end
end)

-- Buttons
local buttonNames = {10,50,100,200,250,"Clear All","Fly"}
for i, name in pairs(buttonNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 250, 0, 30)
    btn.Position = UDim2.new(0, 25, 0, 40 + (i-1)*35)
    btn.Text = (name=="Clear All" or name=="Fly") and name or "Spawn "..name.." Balls"
    btn.BackgroundColor3 = Color3.fromRGB(100,100,255)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Parent = mainFrame

    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0,8)
    uic.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if name == "Clear All" then
            for _,v in pairs(ballFolder:GetChildren()) do
                v:Destroy()
            end
        elseif name == "Fly" then
            -- Fly script load
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        else
            for i=1,name do
                local ball = Instance.new("Part")
                ball.Shape = Enum.PartType.Ball
                ball.Material = Enum.Material.SmoothPlastic
                ball.Size = Vector3.new(4,4,4)
                ball.Position = player.Character.Head.Position + Vector3.new(math.random(-10,10),10,math.random(-10,10))
                ball.Anchored = false
                ball.CanCollide = true
                ball.Parent = ballFolder

                -- BodyVelocity for initial movement
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(math.random(-20,20),math.random(5,20),math.random(-20,20))
                bv.MaxForce = Vector3.new(400000,400000,400000)
                bv.P = 1000
                bv.Parent = ball
                Debris:AddItem(bv,0.2)
            end
        end
    end)
end

-- Draggable GUI
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
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

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
