-- =============================================
-- Delta Executor - iOS Dark Glass Menu (Versión Mejorada)
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
        flyBodyVelocity = Instance.new("BodyVelocity", rootPart)
        flyBodyVelocity.Name = "FlyBV"
        flyBodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
        flyBodyGyro = Instance.new("BodyGyro", rootPart)
        flyBodyGyro.Name = "FlyBG"
        flyBodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
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
                for _, v in pairs(character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
    end
end

-- === UI Mejorada ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Botón flotante (mejor draggable)
local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 55, 0, 55)
FloatBtn.Position = UDim2.new(0, 30, 1, -100)
FloatBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
FloatBtn.BackgroundTransparency = 0.2
FloatBtn.Text = "≡"
FloatBtn.TextColor3 = Color3.fromRGB(255,255,255)
FloatBtn.TextSize = 28
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.Parent = ScreenGui

Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", FloatBtn).Thickness = 1.5

-- Menú principal (más compacto y oscuro)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 480)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BackgroundTransparency = 0.15
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 20)
Instance.new("UIStroke", MainFrame).Thickness = 1.5

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundTransparency = 1
Title.Text = "Delta iOS"
Title.TextColor3 = Color3.fromRGB(200, 220, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBlack

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0,35,0,35)
CloseBtn.Position = UDim2.new(1,-40,0,8)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255,80,80)
CloseBtn.TextSize = 22

local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0,35,0,35)
MinBtn.Position = UDim2.new(1,-75,0,8)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(255,220,80)
MinBtn.TextSize = 24

local Scrolling = Instance.new("ScrollingFrame", MainFrame)
Scrolling.Size = UDim2.new(1,-20,1,-70)
Scrolling.Position = UDim2.new(0,10,0,60)
Scrolling.BackgroundTransparency = 1
Scrolling.ScrollBarThickness = 5
Scrolling.CanvasSize = UDim2.new(0,0,0,520)

-- Func
