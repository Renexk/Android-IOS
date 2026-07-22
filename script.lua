-- =============================================
-- Masterstrap Style + Minimize to Small Square
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

-- Toggles y Sliders
MainTab:CreateToggle({
    Name = "Salto Infinito",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        InfiniteJumpEnabled = Value
    end,
})

MainTab:CreateToggle({
    Name = "Noclip (Atravesar Paredes)",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        NoclipEnabled = Value
    end,
})

MainTab:CreateSlider({
    Name = "Potencia de Salto",
    Range = {50, 500},
    Increment = 5,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        JumpPowerValue = Value
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.JumpPower = Value end
    end,
})

MainTab:CreateSlider({
    Name = "Velocidad de Movimiento",
    Range = {16, 250},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        WalkSpeedValue = Value
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = Value end
    end,
})

-- Lógica Infinite Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum:ChangeState("Jumping") end
    end
end)

-- Lógica Noclip
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- ==================== MINIMIZAR A CUADRITO ====================
local minimized = false
local originalWindow = Window

-- Función para minimizar
local function MinimizeToSquare()
    minimized = true
    -- Rayfield no tiene minimize nativo fácil, así que ocultamos la ventana
    pcall(function()
        Window:Destroy() -- Cerramos temporalmente la ventana Rayfield
    end)
    
    -- Creamos botón flotante pequeño
    local FloatGui = Instance.new("ScreenGui")
    FloatGui.Name = "MiniSquare"
    FloatGui.ResetOnSpawn = false
    FloatGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local Square = Instance.new("TextButton")
    Square.Size = UDim2.new(0, 50, 0, 50)
    Square.Position = UDim2.new(0.5, -25, 0.1, 0)
    Square.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Square.Text = "≡"
    Square.TextColor3 = Color3.fromRGB(255, 255, 255)
    Square.TextSize = 24
    Square.Font = Enum.Font.GothamBold
    Square.Parent = FloatGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = Square
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(80, 80, 120)
    stroke.Parent = Square
    
    -- Drag
    local dragging
    Square.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            -- Drag logic aquí
        end
    end)
    
    Square.MouseButton1Click:Connect(function()
        FloatGui:Destroy()
        minimized = false
        -- Recargamos el menú completo
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Renexk/Android-IOS/refs/heads/main/script.lua"))()
    end)
end

-- Agregamos botón de minimizar en Rayfield (usando un botón extra)
MainTab:CreateButton({
    Name = "⬇ Minimizar a Cuadrado",
    Callback = function()
        MinimizeToSquare()
    end,
})

Rayfield:Notify({
    Title = "Script Cargado",
    Content = "Menú listo - Usa 'Minimizar a Cuadrado'",
    Duration = 5
})
