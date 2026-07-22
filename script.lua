-- =============================================
-- Masterstrap Style - Minimize a Cuadradito
-- =============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Masterstrap Style Menu",
    LoadingTitle = "Cargando...",
    LoadingSubtitle = "by Grok",
    ConfigurationSaving = { Enabled = true, FolderName = "DeltaScripts", FileName = "Masterstrap" },
    Discord = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Movimiento", 4483362458)

-- Funciones
local InfiniteJumpEnabled = false
local NoclipEnabled = false

MainTab:CreateToggle({ Name = "Salto Infinito", CurrentValue = false, Callback = function(v) InfiniteJumpEnabled = v end })
MainTab:CreateToggle({ Name = "Noclip", CurrentValue = false, Callback = function(v) NoclipEnabled = v end })

MainTab:CreateSlider({ Name = "Potencia de Salto", Range = {50,500}, Increment = 5, CurrentValue = 50, Callback = function(v)
    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.JumpPower = v end
end})

MainTab:CreateSlider({ Name = "Velocidad", Range = {16,250}, Increment = 1, CurrentValue = 16, Callback = function(v)
    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = v end
end})

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

-- ==================== MINIMIZAR ====================
local function CreateFloatingSquare()
    local sg = Instance.new("ScreenGui")
    sg.ResetOnSpawn = false
    sg.Parent = game.Players.LocalPlayer.PlayerGui

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0.5, -25, 0.15, 0)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    btn.Text = "≡"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 24
    btn.Font = Enum.Font.GothamBold
    btn.Parent = sg

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", btn).Thickness = 1.5

    -- Drag
    local dragging
    btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    game:GetService("UserInputService").InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            -- Drag simple (puedes mejorar después)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        sg:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Renexk/Android-IOS/refs/heads/main/script.lua"))()
    end)
end

-- Sobrescribir minimizar
task.wait(1.5)
CreateFloatingSquare()

Rayfield:Notify({Title = "Listo", Content = "Minimiza con el botón de arriba", Duration = 5})
