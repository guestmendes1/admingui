--// FAVELA TTIRO DESTROYER v4.2 – ONE-LINER READY
--// loadstring(game:HttpGet("https://raw.githubusercontent.com/guestmendes1/admingui/main/FavelaTTiroPvP.lua"))()

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "FAVELA TTIRO DESTROYER",
    SubTitle = "v4.2 PvP Edition",
    Size = UDim2.fromOffset(620, 460),
    Theme = "Dark",
    Acrylic = true,
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Aim = Window:AddTab({ Title = "Aimbot", Icon = "crosshair" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Weapon = Window:AddTab({ Title = "Armas", Icon = "swords" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" })
}

local Players, WS, RS = game:GetService("Players"), game:GetService("Workspace"), game:GetService("RunService")
local LP = Players.LocalPlayer
local Mouse, Camera = LP:GetMouse(), WS.CurrentCamera

local CFG = {
    Aimbot = { Enabled = false, FOV = 120, Smooth = 1, TargetPart = "Head", VisibleCheck = true, Prediction = 0.12, FOVVisible = true, FOVColor = Color3.fromRGB(255,50,50) },
    Visual = { ESP = false, BoxESP = false, Tracers = false, Chams = false, ChamsColor = Color3.fromRGB(0,255,127) },
    Weapon = { InfiniteAmmo = false, NoRecoil = false, NoSpread = false, RapidFire = false, UnlockAll = false, Damage = 100 },
    Misc = { AllKill = false, AimKill = false, Fly = false, Noclip = false, Speed = 100, Jump = 200 }
}

local Target, ESPObjects = nil, {}

local FOVring = Drawing.new("Circle"); FOVring.Color = CFG.Aimbot.FOVColor; FOVring.Thickness = 2
FOVring.NumSides = 64; FOVring.Radius = CFG.Aimbot.FOV; FOVring.Visible = CFG.Aimbot.FOVVisible; FOVring.Filled = false

local function Notify(txt) Fluent:Notify({ Title = "DESTROYER", Content = txt, Duration = 2 }) end
local function GetClosest()
    local closest, dist = nil, math.huge
    for _,v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local head = v.Character:FindFirstChild(CFG.Aimbot.TargetPart)
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local mag = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if mag < dist and mag <= CFG.Aimbot.FOV then dist, closest = mag, v end
                end
            end
        end
    end
    return closest
end

RS.RenderStepped:Connect(function()
    if CFG.Aimbot.Enabled then
        Target = GetClosest()
        if Target and Target.Character and Target.Character:FindFirstChild(CFG.Aimbot.TargetPart) then
            local head = Target.Character[CFG.Aimbot.TargetPart]
            local pos = head.Position + (head.Velocity * CFG.Aimbot.Prediction)
            local screenPos = Camera:WorldToViewportPoint(pos)
            mousemoverel((screenPos.X - Mouse.X) * CFG.Aimbot.Smooth, (screenPos.Y - Mouse.Y) * CFG.Aimbot.Smooth)
        end
    end
    FOVring.Visible = CFG.Aimbot.FOVVisible; FOVring.Radius = CFG.Aimbot.FOV; FOVring.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
end)

spawn(function() while wait() do
    if CFG.Misc.AllKill then for _,v in pairs(Players:GetPlayers()) do if v ~= LP and v.Character and v.Character:FindFirstChild("Humanoid") then v.Character.Humanoid.Health = 0 end end end
    if CFG.Misc.AimKill and Target then if Target.Character and Target.Character:FindFirstChild("Humanoid") then Target.Character.Humanoid.Health = 0 Target = nil end end
end end)

spawn(function() while wait(.1) do
    if CFG.Weapon.InfiniteAmmo or CFG.Weapon.NoRecoil or CFG.Weapon.NoSpread or CFG.Weapon.RapidFire or CFG.Weapon.Damage > 100 then
        for _,v in pairs(LP.Backpack:GetChildren()) do if v:IsA("Tool") and v:FindFirstChild("Ammo") then v.Ammo.Value = 999 end end
        for _,v in pairs(WS:GetDescendants()) do if v:IsA("Tool") then
                if CFG.Weapon.InfiniteAmmo and v:FindFirstChild("Ammo") then v.Ammo.Value = 999 end
                if CFG.Weapon.NoRecoil and v:FindFirstChild("Recoil") then v.Recoil.Value = 0 end
                if CFG.Weapon.NoSpread and v:FindFirstChild("Spread") then v.Spread.Value = 0 end
                if CFG.Weapon.RapidFire and v:FindFirstChild("Auto") then v:FindFirstChild("FireRate").Value = 0.01 v.Auto.Value = true end
                if CFG.Weapon.Damage > 100 and v:FindFirstChild("Damage") then v.Damage.Value = CFG.Weapon.Damage end
        end end
    end
end end)

local AimbotToggle = Tabs.Aim:AddToggle("AimbotToggle", { Title = "Aimbot", Default = false }); AimbotToggle:OnChanged(function(v) CFG.Aimbot.Enabled = v end)
local FOVToggle = Tabs.Aim:AddToggle("FOVToggle", { Title = "Mostrar FOV", Default = true }); FOVToggle:OnChanged(function(v) CFG.Aimbot.FOVVisible = v end)
local FOVSlider = Tabs.Aim:AddSlider("FOVSlider", { Title = "FOV", Default = 120, Min = 10, Max = 500 }); FOVSlider:OnChanged(function(v) CFG.Aimbot.FOV = v end)
local TargetPartDropdown = Tabs.Aim:AddDropdown("TargetPart", { Title = "Alvo", Values = {"Head", "HumanoidRootPart", "UpperTorso"}, Default = "Head" })
TargetPartDropdown:OnChanged(function(v) CFG.Aimbot.TargetPart = v end)

local InfiniteAmmoToggle = Tabs.Weapon:AddToggle("InfiniteAmmoToggle", { Title = "Munição Infinita", Default = false }); InfiniteAmmoToggle:OnChanged(function(v) CFG.Weapon.InfiniteAmmo = v end)
local NoRecoilToggle = Tabs.Weapon:AddToggle("NoRecoilToggle", { Title = "Sem Recoil", Default = false }); NoRecoilToggle:OnChanged(function(v) CFG.Weapon.NoRecoil = v end)
local NoSpreadToggle = Tabs.Weapon:AddToggle("NoSpreadToggle", { Title = "Sem Spread", Default = false }); NoSpreadToggle:OnChanged(function(v) CFG.Weapon.NoSpread = v end)
local RapidFireToggle = Tabs.Weapon:AddToggle("RapidFireToggle", { Title = "Tiro Rápido", Default = false }); RapidFireToggle:OnChanged(function(v) CFG.Weapon.RapidFire = v end)
local DamageSlider = Tabs.Weapon:AddSlider("DamageSlider", { Title = "Dano", Default = 100, Min = 100, Max = 99999 }); DamageSlider:OnChanged(function(v) CFG.Weapon.Damage = v end)

local AllKillToggle = Tabs.Misc:AddToggle("AllKillToggle", { Title = "All Kill", Default = false }); AllKillToggle:OnChanged(function(v) CFG.Misc.AllKill = v end)
local AimKillToggle = Tabs.Misc:AddToggle("AimKillToggle", { Title = "Aim Kill", Default = false }); AimKillToggle:OnChanged(function(v) CFG.Misc.AimKill = v end)
local FlyEnabled = false; local FLY = nil
local FlyToggle = Tabs.Player:AddToggle("FlyToggle", { Title = "Voar", Default = false }); FlyToggle:OnChanged(function(v)
    FlyEnabled = v
    if v then
        FLY = Instance.new("BodyVelocity"); FLY.Velocity = Vector3.new(); FLY.MaxForce = Vector3.new(4000,4000,4000)
        FLY.Parent = LP.Character.HumanoidRootPart
        spawn(function() while FlyEnabled and RS.Heartbeat:Wait() do FLY.Velocity = Camera.CFrame.LookVector * 50 end FLY:Destroy() end)
    else FLY:Destroy() end
end)
local NoclipEnabled = false
local NoclipToggle = Tabs.Player:AddToggle("NoclipToggle", { Title = "NoClip", Default = false }); NoclipToggle:OnChanged(function(v)
    NoclipEnabled = v
    spawn(function() while NoclipEnabled and wait() do for _,x in pairs(LP.Character:GetDescendants()) do if x:IsA("BasePart") then x.CanCollide = false end end end end)
end)
local SpeedSlider = Tabs.Player:AddSlider("SpeedSlider", { Title = "Velocidade", Default = 100, Min = 16, Max = 500 }); SpeedSlider:OnChanged(function(v) LP.Character.Humanoid.WalkSpeed = v end)
local JumpSlider = Tabs.Player:AddSlider("JumpSlider", { Title = "Pulo", Default = 200, Min = 50, Max = 1000 }); JumpSlider:OnChanged(function(v) LP.Character.Humanoid.JumpPower = v end)

Fluent:Notify({ Title = "DESTROYER", Content = "Carregado! Use Ctrl para minimizar.", Duration = 5 })
