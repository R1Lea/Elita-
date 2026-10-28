local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer

local Settings = {
    PlayerESP = true,
    DroneESP = true,
    BoxESP = true
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Elita_Hack_Clean"
ScreenGui.ResetOnSpawn = false

local success, err = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = localPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 200)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(240, 240, 240)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 8)
FrameCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ELITA HACK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Title.BorderSizePixel = 0
Title.Font = Enum.Font.Code
Title.TextSize = 18
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

local function createToggle(text, pos, settingKey)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 35)
    btn.Position = UDim2.new(0, 20, 0, pos)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(50, 50, 50)
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local function updateVisuals()
        if Settings[settingKey] then
            btn.Text = text .. "   //   ON"
            btn.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
            btn.TextColor3 = Color3.fromRGB(10, 10, 10)
        else
            btn.Text = text .. "   //   OFF"
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end
    
    btn.MouseButton1Click:Connect(function()
        Settings[settingKey] = not Settings[settingKey]
        updateVisuals()
    end)
    
    updateVisuals()
    btn.Parent = MainFrame
end

createToggle("ESP PLAYERS", 60, "PlayerESP")
createToggle("ESP DRONES", 105, "DroneESP")
createToggle("ESP BOXES", 150, "BoxESP")

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

local function applyHighlight(object, color)
    if not object:FindFirstChild("ElitaHighlight") then
        local hl = Instance.new("Highlight")
        hl.Name = "ElitaHighlight"
        hl.FillColor = color
        hl.FillTransparency = 0.4
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = object
    end
end

local function removeHighlight(object)
    if object and object:FindFirstChild("ElitaHighlight") then
        object.ElitaHighlight:Destroy()
    end
end

task.spawn(function()
    while task.wait(0.4) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character then
                if Settings.PlayerESP then 
                    applyHighlight(p.Character, Color3.fromRGB(255, 45, 45)) 
                else
                    removeHighlight(p.Character)
                end
            end
        end

        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("BasePart") then
                local nameLower = string.lower(obj.Name)
                
                if string.find(nameLower, "box") or string.find(nameLower, "crate") or string.find(nameLower, "loot") then
                    if Settings.BoxESP then 
                        applyHighlight(obj, Color3.fromRGB(50, 205, 50)) 
                    else
                        removeHighlight(obj)
                    end
                end

                if string.find(nameLower, "drone") or string.find(nameLower, "fpv") or obj:FindFirstChild("Propeller") then
                    if Settings.DroneESP and obj:IsA("Model") then 
                        applyHighlight(obj, Color3.fromRGB(0, 180, 255)) 
                    else
                        removeHighlight(obj)
                    end
                end
            end
        end
    end
end)
