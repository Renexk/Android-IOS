-- =============================================
-- Masterstrap Style - Minimize to Small Square
-- =============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Masterstrap Style Menu",
    LoadingTitle = "Cargando...",
    LoadingSubtitle = "by Grok",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "DeltaScripts",
        FileName = "MasterstrapMenu"
    },
    Discord = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Movimiento", 4483362458)

-- Variables
local InfiniteJumpEnabled = false
local NoclipEnabled = false
local JumpPowerValue = 50
local WalkSpeedValue = 16

MainTab:CreateToggle({
    Name = "Salto Infinito",
    CurrentValue = false,
    Callback = function(Value) InfiniteJumpEnabled = Value end,
})

MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value) NoclipEnabled = Value end,
})

MainTab:CreateSlider({
    Name = "Potencia de Salto",
    Range = {50, 500},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(Value)
        JumpPowerValue = Value
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = Value end
    end,
})

MainTab:CreateSlider({
    Name = "Velocidad",
    Range = {16, 250},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        WalkSpeedValue = Value
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = Value end
    end,
})

-- Lógica
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum:ChangeState("Jumping") end
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled and game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- ==================== MINIMIZAR A CUADRITO ====================
local minimizedSquare = nil

local function CreateMinimizedSquare()
    if minimizedSquare then minimizedSquare:Destroy() end
    
    minimizedSquare = Instance.new("ScreenGui")
    minimizedSquare.ResetOnSpawn = false
    minimizedSquare.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local Square = Instance.new("TextButton")
    Square.Size = UDim2.new(0, 48, 0, 48)
    Square.Position = UDim2.new(0.5, -24, 0.2, 0)
    Square.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Square.Text = "≡"
    Square.TextColor3 = Color3.fromRGB(255, 255, 255)
    Square.TextSize = 22
    Square.Font = Enum.Font.GothamBold
    Square.Parent = minimizedSquare
    
    Instance.new("UICorner", Square).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", Square).Thickness = 1.5
    
    -- Drag
    local dragging, dragInput, dragStart, startPos
    Square.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Square.Position
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Square.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    Square.MouseButton1Click:Connect(function()
        minimizedSquare:Destroy()
        minimizedSquare = nil
        -- Reabrir menú
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Renexk/Android-IOS/refs/heads/main/script.lua"))()
    end)
end

-- Sobrescribir el botón de minimizar de Rayfield
task.spawn(function()
    wait(2) -- Espera a que cargue Rayfield
    CreateMinimizedSquare() -- Por si acaso
end)

Rayfield:Notify({Title = "Listo", Content = "Presiona el botón minimizar para reducir a cuadradito", Duration = 6})
