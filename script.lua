-- =============================================
-- Delta Executor - iOS Dark Glass Menu
-- Fly, Noclip, Infinity Jump, Speed, Jump Power
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local flyEnabled = false
local noclipEnabled = false
local infJumpEnabled = false
local walkSpeed = 16
local jumpPower = 50
local flySpeed = 50

local character, humanoid, rootPart
local flyBodyVelocity, flyBodyGyro
local noclipConnection

local function setupCharacter()
    character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    humanoid.WalkSpeed = walkSpeed
    humanoid.JumpPower = jumpPower
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)
if LocalPlayer.Character then setupCharacter() end

local function toggleFly(state)
    flyEnabled = state
    if flyEnabled then
        if not rootPart then return end
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Name = "FlyBV"
        flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBodyVelocity.Velocity = Vector3.new(0,0,0)
        flyBodyVelocity.Parent = rootPart
        
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.Name = "FlyBG"
        flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        flyBodyGyro.P = 12500
        flyBodyGyro.Parent = rootPart
    else
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
    end
end

local function toggleNoclip(state)
    noclipEnabled = state
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
    end
end

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "iOSDeltaMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 65, 0, 65)
FloatBtn.Position = UDim2.new(0, 20, 1, -90)
FloatBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
FloatBtn.BackgroundTransparency = 0.25
FloatBtn.Text = "≡"
FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatBtn.TextSize = 34
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.Parent = ScreenGui

Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 20)
local fs = Instance.new("UIStroke", FloatBtn)
fs.Thickness = 1.5; fs.Color = Color3.fromRGB(100,100,120)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 520)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BackgroundTransparency = 0.25
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 24)
local ms = Instance.new("UIStroke", MainFrame)
ms.Thickness = 1.8; ms.Color = Color3.fromRGB(80,80,100)

-- Título y botones (X y -)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,60)
Title.BackgroundTransparency = 1
Title.Text = "Delta iOS"
Title.TextColor3 = Color3.fromRGB(240,240,255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBlack

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0,40,0,40)
CloseBtn.Position = UDim2.new(1,-45,0,10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255,90,90)
CloseBtn.TextSize = 24

local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0,40,0,40)
MinBtn.Position = UDim2.new(1,-90,0,10)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(255,255,100)
MinBtn.TextSize = 28

-- Contenido
local Scrolling = Instance.new("ScrollingFrame", MainFrame)
Scrolling.Size = UDim2.new(1,-20,1,-80)
Scrolling.Position = UDim2.new(0,10,0,70)
Scrolling.BackgroundTransparency = 1
Scrolling.ScrollBarThickness = 6
Scrolling.CanvasSize = UDim2.new(0,0,0,600)

local function CreateToggle(name, y, callback)
    local f = Instance.new("Frame", Scrolling)
    f.Size = UDim2.new(1,-20,0,60)
    f.Position = UDim2.new(0,10,0,y)
    f.BackgroundColor3 = Color3.fromRGB(35,35,45)
    f.BackgroundTransparency = 0.4
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,16)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.65,0,1,0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.TextColor3 = Color3.fromRGB(240,240,255)
    l.TextSize = 18
    l.Font = Enum.Font.GothamSemibold
    l.TextXAlignment = Enum.TextXAlignment.Left
    
    local status = Instance.new("TextLabel", f)
    status.Size = UDim2.new(0.3,0,1,0)
    status.Position = UDim2.new(0.68,0,0,0)
    status.BackgroundTransparency = 1
    status.Text = "OFF"
    status.TextColor3 = Color3.fromRGB(180,180,180)
    status.TextSize = 16
    
    local on = false
    f.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            on = not on
            callback(on)
            if on then
                f.BackgroundColor3 = Color3.fromRGB(55,75,100)
                status.Text = "ON"
                status.TextColor3 = Color3.fromRGB(100,255,140)
            else
                f.BackgroundColor3 = Color3.fromRGB(35,35,45)
                status.Text = "OFF"
                status.TextColor3 = Color3.fromRGB(180,180,180)
            end
        end
    end)
end

CreateToggle("Fly", 10, toggleFly)
CreateToggle("Noclip", 80, toggleNoclip)
CreateToggle("Infinity Jump", 150, function(s) infJumpEnabled = s end)

-- Sliders
local function CreateSlider(name, y, minv, maxv, default, step, callback)
    local f = Instance.new("Frame", Scrolling)
    f.Size = UDim2.new(1,-20,0,85)
    f.Position = UDim2.new(0,10,0,y)
    f.BackgroundColor3 = Color3.fromRGB(35,35,45)
    f.BackgroundTransparency = 0.4
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,16)
    
    local label = Instance.new("TextLabel", f)
    label.Size = UDim2.new(1,0,0,35)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(240,240,255)
    label.TextSize = 17
    label.Font = Enum.Font.GothamSemibold
    
    local minus = Instance.new("TextButton", f)
    minus.Size = UDim2.new(0,55,0,38)
    minus.Position = UDim2.new(0,25,0,42)
    minus.BackgroundColor3 = Color3.fromRGB(50,50,60)
    minus.Text = "-"
    minus.TextColor3 = Color3.new(1,1,1)
    minus.TextSize = 22
    Instance.new("UICorner", minus).CornerRadius = UDim.new(0,12)
    
    local plus = minus:Clone()
    plus.Position = UDim2.new(1,-80,0,42)
    plus.Text = "+"
    plus.Parent = f
    
    local val = default
    minus.MouseButton1Click:Connect(function()
        val = math.max(minv, val - step)
        label.Text = name .. ": " .. val
        callback(val)
    end)
    plus.MouseButton1Click:Connect(function()
        val = math.min(maxv, val + step)
        label.Text = name .. ": " .. val
        callback(val)
    end)
end

CreateSlider("Velocidad", 230, 16, 200, 16, 4, function(v)
    walkSpeed = v
    if humanoid then humanoid.WalkSpeed = v end
end)

CreateSlider("Potencia de Salto", 320, 50, 300, 50, 10, function(v)
    jumpPower = v
    if humanoid then humanoid.JumpPower = v end
end)

-- Controles
FloatBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatBtn.Visible = false
end)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatBtn.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Drag
local dragging
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        local dragStart = input.Position
        local startPos = MainFrame.Position
        
        local conn
        conn = UserInputService.InputChanged:Connect(function(inp)
            if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                local delta = inp.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                conn:Disconnect()
            end
        end)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

StarterGui:SetCore("SendNotification", {Title="Delta iOS", Text="Menú cargado correctamente", Duration=5})
