local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- Interface
local Screen = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MiniBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")
local Content = Instance.new("Frame")
local SavePosBtn = Instance.new("TextButton")
local TpPosBtn = Instance.new("TextButton")
local GodBtn = Instance.new("TextButton")
local EspBtn = Instance.new("TextButton")
local FlyBtn = Instance.new("TextButton")
local NoclipBtn = Instance.new("TextButton")
local Status = Instance.new("TextLabel")

-- Propriedades visuais
Screen.Name = "TavinxHub"
Screen.Parent = game.CoreGui
Main.Size = UDim2.new(0, 240, 0, 300)
Main.Position = UDim2.new(0.5, -120, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Draggable = true
Main.Active = true
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "@tavinx  Hub"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
MiniBtn.Size = UDim2.new(0, 30, 1, 0)
MiniBtn.Position = UDim2.new(1, -60, 0, 0)
MiniBtn.Text = "-"
MiniBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)

-- Conteúdo
Content.Size = UDim2.new(1, 0, 1, -30)
Content.Position = UDim2.new(0, 0, 0, 30)
Content.BackgroundTransparency = 1
local function newBtn(name, pos, parent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 200, 0, 35)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BorderSizePixel = 0
    return btn
end
SavePosBtn = newBtn("Salvar Pos", UDim2.new(0, 20, 0, 10), Content)
TpPosBtn = newBtn("TP Salvo", UDim2.new(0, 20, 0, 50), Content)
GodBtn = newBtn("God Mode", UDim2.new(0, 20, 0, 90), Content)
EspBtn = newBtn("ESP Brainrot", UDim2.new(0, 20, 0, 130), Content)
FlyBtn = newBtn("Fly", UDim2.new(0, 20, 0, 170), Content)
NoclipBtn = newBtn("Noclip", UDim2.new(0, 20, 0, 210), Content)
Status = Instance.new("TextLabel", Content)
Status.Size = UDim2.new(1, -20, 0, 30)
Status.Position = UDim2.new(0, 10, 0, 250)
Status.Text = "Status: OK"
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1

-- Lógica
local SavedPos = nil
local God = false
local Esp = false
local Fly = false
local Noclip = false
local FlySpeed = 50
local WindowMinimized = false

-- Funções
local function setStatus(msg) Status.Text = "Status: " .. msg end
local function noclipLoop()
    while Noclip do
        for _, v in pairs(LP.Character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
        RunService.Stepped:Wait()
    end
end
local function espLoop()
    while Esp do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p:FindFirstChild("Head") then
                if not p.Character.Head:FindFirstChild("ESP") then
                    local b = Instance.new("BillboardGui", p.Character.Head)
                    b.Name = "ESP"
                    b.Size = UDim2.new(0, 200, 0, 50)
                    b.Adornee = p.Character.Head
                    b.StudsOffset = Vector3.new(0, 3, 0)
                    local t = Instance.new("TextLabel", b)
                    t.Size = UDim2.new(1, 0, 1, 0)
                    t.Text = p.Name .. (p.Backpack:FindFirstChild("Brainrot") and "  BRAINROT" or "")
                    t.BackgroundTransparency = 1
                    t.TextColor3 = Color3.new(1, 1, 0)
                end
            end
        end
        wait(1)
    end
end
local function flyFunc()
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new()
    bv.Parent = LP.Character.HumanoidRootPart
    while Fly do
        local dir = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
        bv.Velocity = dir * FlySpeed
        RunService.RenderStepped:Wait()
    end
    bv:Destroy()
end

-- Botões
SavePosBtn.MouseButton1Click:Connect(function()
    SavedPos = LP.Character.HumanoidRootPart.CFrame
    setStatus("Pos salvo")
end)
TpPosBtn.MouseButton1Click:Connect(function()
    if SavedPos then
        LP.Character.HumanoidRootPart.CFrame = SavedPos
        setStatus("TP executado")
    else
        setStatus("Nenhuma pos salva")
    end
end)
GodBtn.MouseButton1Click:Connect(function()
    God = not God
    if God then
        LP.Character.Humanoid.Name = "HD"
        local newH = Instance.new("Humanoid", LP.Character)
        newH.MaxHealth = math.huge
        newH.Health = math.huge
        LP.Character.HD:Destroy()
        setStatus("God ON")
    else
        setStatus("God OFF")
    end
end)
EspBtn.MouseButton1Click:Connect(function()
    Esp = not Esp
    if Esp then
        espLoop()
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character.Head:FindFirstChild("ESP") then
                p.Character.Head.ESP:Destroy()
            end
        end
        setStatus("ESP OFF")
    end
end)
FlyBtn.MouseButton1Click:Connect(function()
    Fly = not Fly
    if Fly then
        flyFunc()
        setStatus("Fly ON")
    else
        setStatus("Fly OFF")
    end
end)
NoclipBtn.MouseButton1Click:Connect(function()
    Noclip = not Noclip
    if Noclip then
        noclipLoop()
        setStatus("Noclip ON")
    else
        setStatus("Noclip OFF")
    end
end)
MiniBtn.MouseButton1Click:Connect(function()
    WindowMinimized = not WindowMinimized
    Content.Visible = not WindowMinimized
    MiniBtn.Text = WindowMinimized and "+" or "-"
end)
CloseBtn.MouseButton1Click:Connect(function() Screen:Destroy() end)

-- Anti-kick simples
LP.PlayerGui.ChildAdded:Connect(function(c)
    if c.Name:find("kick") or c.Name:find("ban") then c:Destroy() end
end)

setStatus("Tavinx Hub carregado")
