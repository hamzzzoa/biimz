--==========================================================
-- DELTA SCRIPT v3 - Full Feature
-- Support: Delta Executor (Android/iOS)
-- Fitur: Invisible, Silent Aim, Silent Veil, Auto Parry, Radiasi, ESP Multi-Warna
--==========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--==========================================================
-- KONFIGURASI
--==========================================================
local Config = {
    ESP_Enabled = true,
    ESP_Survivor_Mode = 1,  -- 1=Biru, 2=Merah, 3=Hijau, 4=Kuning, 5=Pink
    ESP_Killer_Mode = 2,    -- 1=Biru, 2=Merah, 3=Hijau, 4=Kuning, 5=Pink
    SilentAim_Enabled = false,
    SilentAim_Range = 250,
    AutoParry_Enabled = false,
    Invisible_Enabled = false,
    SilentVeil_Enabled = false,
    SilentVeil_Range = 280,
    Radiation_Enabled = false,
}

-- Palet warna ESP
local ColorPalette = {
    [1] = {Name = "Biru", Color = Color3.fromRGB(0, 170, 255)},
    [2] = {Name = "Merah", Color = Color3.fromRGB(255, 50, 50)},
    [3] = {Name = "Hijau", Color = Color3.fromRGB(50, 255, 50)},
    [4] = {Name = "Kuning", Color = Color3.fromRGB(255, 255, 0)},
    [5] = {Name = "Pink", Color = Color3.fromRGB(255, 105, 180)},
}

--==========================================================
-- UI DRAGGABLE
--==========================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 480)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.2
UIStroke.Parent = MainFrame

--==========================================================
-- DRAG SYSTEM (Custom, support Touch & Mouse)
--==========================================================
local dragging = false
local dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

-- Drag dari MainFrame
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement 
    or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

--==========================================================
-- TITLE BAR
--==========================================================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TitleBar.BackgroundTransparency = 0.75
TitleBar.BorderSizePixel = 0
TitleBar.Active = true
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ DELTA SCRIPT v3 ⚡"
TitleLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--==========================================================
-- SCROLLING FRAME
--==========================================================
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -50)
ScrollFrame.Position = UDim2.new(0, 5, 0, 45)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollFrame

--==========================================================
-- TOGGLE FUNCTION
--==========================================================
local function CreateToggle(name, defaultState, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 38)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    ToggleFrame.BackgroundTransparency = 0.3
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ScrollFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Color3.fromRGB(0, 170, 255)
    ToggleStroke.Thickness = 1
    ToggleStroke.Transparency = 0.5
    ToggleStroke.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 55, 0, 24)
    ToggleBtn.Position = UDim2.new(1, -67, 0.5, -12)
    ToggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(70, 70, 90)
    ToggleBtn.Text = defaultState and "ON" or "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 12
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Parent = ToggleFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = ToggleBtn

    local state = defaultState
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(70, 70, 90)
        }):Play()
        ToggleBtn.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)

    return ToggleFrame
end

--==========================================================
-- COLOR PICKER BUTTON (untuk ESP warna)
--==========================================================
local function CreateColorPicker(title, currentMode, callback)
    local PickerFrame = Instance.new("Frame")
    PickerFrame.Size = UDim2.new(1, -10, 0, 65)
    PickerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    PickerFrame.BackgroundTransparency = 0.3
    PickerFrame.BorderSizePixel = 0
    PickerFrame.Parent = ScrollFrame

    local PickerCorner = Instance.new("UICorner")
    PickerCorner.CornerRadius = UDim.new(0, 8)
    PickerCorner.Parent = PickerFrame

    local PickerStroke = Instance.new("UIStroke")
    PickerStroke.Color = Color3.fromRGB(0, 170, 255)
    PickerStroke.Thickness = 1
    PickerStroke.Transparency = 0.5
    PickerStroke.Parent = PickerFrame

    local PickerTitle = Instance.new("TextLabel")
    PickerTitle.Size = UDim2.new(1, -20, 0, 20)
    PickerTitle.Position = UDim2.new(0, 12, 0, 4)
    PickerTitle.BackgroundTransparency = 1
    PickerTitle.Text = title
    PickerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    PickerTitle.TextSize = 12
    PickerTitle.Font = Enum.Font.GothamBold
    PickerTitle.TextXAlignment = Enum.TextXAlignment.Left
    PickerTitle.Parent = PickerFrame

    -- Container tombol warna
    local ButtonHolder = Instance.new("Frame")
    ButtonHolder.Size = UDim2.new(1, -20, 0, 30)
    ButtonHolder.Position = UDim2.new(0, 10, 0, 28)
    ButtonHolder.BackgroundTransparency = 1
    ButtonHolder.Parent = PickerFrame

    local HolderLayout = Instance.new("UIListLayout")
    HolderLayout.FillDirection = Enum.FillDirection.Horizontal
    HolderLayout.Padding = UDim.new(0, 5)
    HolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
    HolderLayout.Parent = ButtonHolder

    local colorButtons = {}
    local selectedMode = currentMode

    for i = 1, 5 do
        local colorBtn = Instance.new("TextButton")
        colorBtn.Size = UDim2.new(0, 46, 0, 26)
        colorBtn.BackgroundColor3 = ColorPalette[i].Color
        colorBtn.Text = ""
        colorBtn.BorderSizePixel = 0
        colorBtn.Parent = ButtonHolder

        local BtnCorner2 = Instance.new("UICorner")
        BtnCorner2.CornerRadius = UDim.new(0, 5)
        BtnCorner2.Parent = colorBtn

        local BtnStroke = Instance.new("UIStroke")
        BtnStroke.Color = Color3.fromRGB(255, 255, 255)
        BtnStroke.Thickness = 0
        BtnStroke.Transparency = 0
        BtnStroke.Parent = colorBtn

        colorButtons[i] = {Button = colorBtn, Stroke = BtnStroke}

        colorBtn.MouseButton1Click:Connect(function()
            selectedMode = i
            for j, btn in pairs(colorButtons) do
                btn.Stroke.Thickness = (j == i) and 2 or 0
                btn.Stroke.Transparency = (j == i) and 0 or 1
            end
            if callback then callback(i) end
        end)
    end

    -- Set default selected
    if colorButtons[selectedMode] then
        colorButtons[selectedMode].Stroke.Thickness = 2
        colorButtons[selectedMode].Stroke.Transparency = 0
    end

    return PickerFrame
end

--==========================================================
-- FITUR TOGGLE
--==========================================================
CreateToggle("ESP Player (On/Off)", Config.ESP_Enabled, function(state)
    Config.ESP_Enabled = state
end)

CreateToggle("Invisible (Survivor & Killer)", Config.Invisible_Enabled, function(state)
    Config.Invisible_Enabled = state
end)

CreateToggle("Silent Aim (250m)", Config.SilentAim_Enabled, function(state)
    Config.SilentAim_Enabled = state
end)

CreateToggle("Silent Veil (280m)", Config.SilentVeil_Enabled, function(state)
    Config.SilentVeil_Enabled = state
end)

CreateToggle("Auto Parry + Stun Killer", Config.AutoParry_Enabled, function(state)
    Config.AutoParry_Enabled = state
end)

CreateToggle("Radiasi (Circle Biru)", Config.Radiation_Enabled, function(state)
    Config.Radiation_Enabled = state
end)

-- Color picker untuk Survivor & Killer
CreateColorPicker("ESP Warna Survivor", Config.ESP_Survivor_Mode, function(mode)
    Config.ESP_Survivor_Mode = mode
end)

CreateColorPicker("ESP Warna Killer", Config.ESP_Killer_Mode, function(mode)
    Config.ESP_Killer_Mode = mode
end)

--==========================================================
-- ESP SYSTEM
--==========================================================
local ESPObjects = {}

local function CreateESP(player)
    if ESPObjects[player] then return end
    if player == LocalPlayer then return end
    
    local ESP = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        Highlight = nil
    }
    
    ESP.Box.Thickness = 1.5
    ESP.Box.Filled = false
    ESP.Box.Transparency = 1
    
    ESP.Name.Size = 14
    ESP.Name.Center = true
    ESP.Name.Outline = true
    
    if player.Character then
        local hl = Instance.new("Highlight")
        hl.FillTransparency = 0.7
        hl.OutlineTransparency = 0.3
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = player.Character
        ESP.Highlight = hl
    end
    
    ESPObjects[player] = ESP
end

local function UpdateESP()
    for player, esp in pairs(ESPObjects) do
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            esp.Box.Visible = false
            esp.Name.Visible = false
            continue
        end
        
        local hrp = player.Character.HumanoidRootPart
        local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        
        if onScreen then
            local size = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
            local height = math.abs(size.Y - screenPos.Y) * 2
            local width = height * 0.6
            
            esp.Box.Size = Vector2.new(width, height)
            esp.Box.Position = Vector2.new(screenPos.X - width/2, screenPos.Y - height/2)
            esp.Box.Visible = Config.ESP_Enabled
            
            esp.Name.Text = player.Name
            esp.Name.Position = Vector2.new(screenPos.X, screenPos.Y - height/2 - 15)
            esp.Name.Visible = Config.ESP_Enabled
        else
            esp.Box.Visible = false
            esp.Name.Visible = false
        end
    end
end

local function UpdateESPColors()
    for player, esp in pairs(ESPObjects) do
        local isKiller = false
        
        -- Deteksi role
        if player.Team then
            local teamName = player.Team.Name:lower()
            if teamName:find("killer") or teamName:find("murderer") 
            or teamName:find("veil") or teamName:find("abyss") then
                isKiller = true
            end
        end
        
        if player.Character then
            if player.Character:FindFirstChild("Knife") 
            or player.Character:FindFirstChild("Spear")
            or player.Character:FindFirstChild("Weapon") then
                isKiller = true
            end
        end
        
        -- Pilih warna berdasarkan mode
        local colorMode = isKiller and Config.ESP_Killer_Mode or Config.ESP_Survivor_Mode
        local color = ColorPalette[colorMode].Color
        
        esp.Box.Color = color
        esp.Name.Color = color
        if esp.Highlight then
            esp.Highlight.FillColor = color
            esp.Highlight.OutlineColor = color
        end
    end
end

-- Inisialisasi ESP
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            task.wait(1)
            CreateESP(player)
        end)
        if player.Character then
            CreateESP(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        task.wait(1)
        CreateESP(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player].Box:Remove()
        ESPObjects[player].Name:Remove()
        if ESPObjects[player].Highlight then
            ESPObjects[player].Highlight:Destroy()
        end
        ESPObjects[player] = nil
    end
end)

--==========================================================
-- INVISIBLE SYSTEM (Tidak kelihatan Killer & Survivor)
--==========================================================
local function ApplyInvisible()
    if not LocalPlayer.Character then return end
    
    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            if Config.Invisible_Enabled then
                if part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 1
                    part.CanCollide = false
                end
            else
                -- Kembalikan transparency asli
                if part.Name == "Head" or part.Name == "Torso" 
                or part.Name == "UpperTorso" or part.Name == "LowerTorso" then
                    part.Transparency = 0
                end
                part.CanCollide = true
            end
        elseif part:IsA("Decal") then
            part.Transparency = Config.Invisible_Enabled and 1 or 0
        elseif part:IsA("Accessory") then
            for _, child in pairs(part:GetDescendants()) do
                if child:IsA("BasePart") then
                    child.Transparency = Config.Invisible_Enabled and 1 or 0
                end
            end
        end
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    CreateESP(LocalPlayer)
    if Config.Invisible_Enabled then
        ApplyInvisible()
    end
end)

--==========================================================
-- SILENT AIM (250m - Dekat atau Jauh ke Killer)
--==========================================================
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall

setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if Config.SilentAim_Enabled and method == "FindPartOnRayWithIgnoreList" then
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return oldNamecall(self, ...)
        end
        
        local myPos = LocalPlayer.Character.HumanoidRootPart.Position
        local target = nil
        local closest = Config.SilentAim_Range
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                
                if humanoid and hrp and humanoid.Health > 0 then
                    local dist = (hrp.Position - myPos).Magnitude
                    if dist < closest then
                        closest = dist
                        target = hrp
                    end
                end
            end
        end
        
        if target then
            args[2] = target.Position
        end
    end
    
    return oldNamecall(self, unpack(args))
end)
setreadonly(mt, true)

--==========================================================
-- AUTO PARRY + RADIASI (Circle Biru)
--==========================================================
local RadiationCircle = Drawing.new("Circle")
RadiationCircle.Radius = 20
RadiationCircle.Thickness = 2
RadiationCircle.Color = Color3.fromRGB(0, 170, 255)
RadiationCircle.Filled = false
RadiationCircle.Transparency = 0.8
RadiationCircle.NumSides = 60
RadiationCircle.Vis
