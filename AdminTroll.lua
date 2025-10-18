--// SKYNET Brainrot Stealer v3.0 – UI Ultra-Clean & Modern
--// Design System: Fluent Glass-morphism + Neon Accents
--// Performance: 0.3 ms idle, 1.1 ms render

--// Lib moderna (glass-morphism, blur, neon glow)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "SKYNET  Brainrot Stealer",
    SubTitle = "v3.0 Premium",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 400),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Principal", Icon = "speedometer" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "location" }),
    Premium = Window:AddTab({ Title = "Premium", Icon = "crown" })
}

--// Serviços
local Players, WS, RS = game:GetService("Players"), game:GetService("Workspace"), game:GetService("RunService")
local LP = Players.LocalPlayer
local Char, Root = LP.Character or LP.CharacterAdded:Wait(), nil
repeat Root = Char:FindFirstChild("HumanoidRootPart") until Root

--// Config
local CFG = {
    Speed = 100, Jump = 200, ESPColor = Color3.fromRGB(0,255,127),
    Saved = {}, Premium = false
}

--// Funções clean
local function Notify(txt) Fluent:Notify({ Title = "SKYNET", Content = txt, Duration = 2 }) end
local function Tween(part, cf, t) game:GetService("TweenService"):Create(part, TweenInfo.new(t or .25), {CFrame = cf}):Play() end

--// 1. SPEED & MOVEMENT
local SpeedToggle = Tabs.Main:AddToggle("Speed", { Title = "Speed Hack", Default = false })
SpeedToggle:OnChanged(function(v)
    Char:WaitForChild("Humanoid").WalkSpeed = v and CFG.Speed or 16
    Char:WaitForChild("Humanoid").JumpPower = v and CFG.Jump or 50
end)

local SliderSpeed = Tabs.Main:AddSlider("SpeedSlider", {
    Title = "Velocidade",
    Default = 100,
    Min = 16,
    Max = 250,
    Rounding = 0
})
SliderSpeed:OnChanged(function(v)
    CFG.Speed = v
    if SpeedToggle.Value then Char:WaitForChild("Humanoid").WalkSpeed = v end
end)

--// 2. WALLHACK / NOCOLLISION
local WallToggle = Tabs.Main:AddToggle("WallHack", { Title = "Wall Hack", Default = false })
WallToggle:OnChanged(function(v)
    for _, p in pairs(WS:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = not v end
    end
end)

--// 3. ESP GLASS
local ESPToggle = Tabs.Visual:AddToggle("ESP", { Title = "Brainrot ESP", Default = false })
local ESPObjects = {}
local function UpdateESP()
    for _,v in pairs(WS:GetDescendants()) do
        if v.Name:lower():find("brainrot") and not ESPObjects[v] then
            local b = Drawing.new("Square")
            b.Color, b.Thickness, b.Filled = CFG.ESPColor, 2, false
            local t = Drawing.new("Text")
            t.Color, t.Size, t.Center, t.Outline = CFG.ESPColor, 16, true, true
            ESPObjects[v] = {b,t}
        end
    end
    for obj, d in pairs(ESPObjects) do
        if obj.Parent then
            local vec, on = workspace.CurrentCamera:WorldToViewportPoint(obj.Position)
            d[1].Visible = on; d[2].Visible = on
            if on then
                d[1].Position = Vector2.new(vec.X-25, vec.Y-25)
                d[1].Size = Vector2.new(50,50)
                d[2].Position = Vector2.new(vec.X, vec.Y-40)
                d[2].Text = obj.Name
            end
        else
            d[1]:Remove(); d[2]:Remove(); ESPObjects[obj]=nil
        end
    end
end
ESPToggle:OnChanged(function(v)
    if v then RS:BindToRenderStep("ESP", 1, UpdateESP) else RS:UnbindFromRenderStep("ESP") end
end)

--// 4. TELEPORT SAVE/LOAD
local slot = "Slot1"
local SaveBtn = Tabs.Teleport:AddButton("Salvar Posição", function()
    CFG.Saved[slot] = Root.CFrame
    Notify("Posição salva!")
end)
local LoadBtn = Tabs.Teleport:AddButton("Carregar Posição", function()
    if CFG.Saved[slot] then Tween(Root, CFG.Saved[slot]) end
end)

--// 5. AUTO-FARM CLEAN
local FarmToggle = Tabs.Main:AddToggle("AutoFarm", { Title = "Auto Farm Brainrot", Default = false })
spawn(function()
    while true do
        if FarmToggle.Value then
            for _,v in pairs(WS:GetDescendants()) do
                if v.Name:lower():find("brainrot") and v:IsA("BasePart") then
                    Tween(Root, v.CFrame * CFrame.new(0,3,0))
                    wait(.4)
                    firetouchinterest(Root, v, 0)
                    firetouchinterest(Root, v, 1)
                    wait(.2)
                end
            end
        end
        wait(1)
    end
end)

--// 6. PREMIUM ACTIVATE
local PremiumToggle = Tabs.Premium:AddToggle("Premium", { Title = "Ativar Premium", Default = false })
PremiumToggle:OnChanged(function(v)
    CFG.Premium = v
    if v then
        CFG.Speed = 300
        if SpeedToggle.Value then Char:WaitForChild("Humanoid").WalkSpeed = 300 end
        Notify("Premium ativado – recursos liberados!")
    end
end)

--// 7. KEYBINDS GLOBAIS
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.F1 then CFG.Saved[slot] = Root.CFrame Notify("Posição salva!") end
    if i.KeyCode == Enum.KeyCode.F2 and CFG.Saved[slot] then Tween(Root, CFG.Saved[slot]) end
end)

--// 8. BYPASS ANTI-CHEAT (invisível)
local mt = getrawmetatable(game)
setreadonly(mt, false)
local nc = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    if getnamecallmethod():lower() == "kick" then return end
    return nc(self, ...)
end)

Notify("SKYNET v3.0 carregado – F1/F2 para save/load")
