--[[ 
🎭 Admin Troll GUI
Feito para brincar em server privado com amigos.
--]]

local player = game.Players.LocalPlayer
local plrGui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

-- GUI base
local gui = Instance.new("ScreenGui", plrGui)
gui.Name = "AdminTrollGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 420)
frame.Position = UDim2.new(0.5, -125, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true -- ✅ arrastar menu

local uiList = Instance.new("UIListLayout", frame)
uiList.Padding = UDim.new(0, 5)
uiList.FillDirection = Enum.FillDirection.Vertical

-- Marca @tavinxoficial no topo
local titulo = Instance.new("TextLabel", frame)
titulo.Size = UDim2.new(1, 0, 0, 30)
titulo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titulo.TextColor3 = Color3.new(1,1,1)
titulo.Font = Enum.Font.SourceSansBold
titulo.TextSize = 18
titulo.Text = "@tavinxoficial"
titulo.TextYAlignment = Enum.TextYAlignment.Center

-- Toggle menu com letra I
UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.I then
        frame.Visible = not frame.Visible
    end
end)

-- Função util para criar botões
local function criarBotao(nome, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = nome
    btn.MouseButton1Click:Connect(callback)
end

-- 🎭 FUNÇÕES TROLL 🎭

-- Explodir
criarBotao("Explodir", function()
    local char = player.Character
    if char then
        char:BreakJoints()
    end
end)

-- Voar
local flying = false
criarBotao("Toggle Voar", function()
    local char = player.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")
    local cam = workspace.CurrentCamera

    flying = not flying
    if flying then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bv.Velocity = Vector3.zero

        local conn
        conn = game:GetService("RunService").Heartbeat:Connect(function()
            if not flying then
                bv:Destroy()
                conn:Disconnect()
                return
            end
            local move = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
            bv.Velocity = move * 50
        end)
    end
end)

-- Gigante
criarBotao("Virar Gigante", function()
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Size = part.Size * 2
            end
        end
    end
end)

-- Mini
criarBotao("Virar Mini", function()
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.Size = part.Size * 0.5
            end
        end
    end
end)

-- Girar
criarBotao("Girar", function()
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(180), 0)
        end
    end
end)

-- Super Velocidade
criarBotao("Super Velocidade", function()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 100
    end
end)

-- Pulo Infinito
local infJump = false
criarBotao("Toggle Pulo Infinito", function()
    infJump = not infJump
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if infJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end)

-- Ragdoll
criarBotao("Ragdoll", function()
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("Motor6D") then
                part.Enabled = false
            end
        end
    end
end)

-- Tela invertida
local invertida = false
criarBotao("Inverter Tela", function()
    local cam = workspace.CurrentCamera
    invertida = not invertida
    if invertida then
        cam.CFrame = cam.CFrame * CFrame.Angles(math.pi, 0, 0)
    else
        cam.CFrame = cam.CFrame
    end
end)

-- Tremor de tela
criarBotao("Screen Shake", function()
    local cam = workspace.CurrentCamera
    for i = 1,20 do
        cam.CFrame = cam.CFrame * CFrame.new(math.random(-1,1), math.random(-1,1), 0)
        task.wait(0.05)
    end
end)

-- Sentar
criarBotao("Sentar", function()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Sit = true
    end
end)

-- Música local
criarBotao("Tocar Música Local", function()
    local sound = Instance.new("Sound", workspace)
    sound.SoundId = "rbxassetid://1843522058"
    sound.Looped = true
    sound.Volume = 5
    sound:Play()
end)

-- Fake Lag Global (aciona RemoteEvent no server)
criarBotao("Fake Lag Global", function()
    local rs = game:GetService("ReplicatedStorage")
    local ev = rs:FindFirstChild("FakeLagEvent")
    if ev then
        ev:FireServer()
    else
        warn("RemoteEvent FakeLagEvent não encontrado no ReplicatedStorage!")
    end
end)

-- Música global (aciona RemoteEvent no server)
criarBotao("Música Global", function()
    local rs = game:GetService("ReplicatedStorage")
    local ev = rs:FindFirstChild("TocarMusicaGlobal")
    if ev then
        ev:FireServer(2504463529)
    else
        warn("RemoteEvent TocarMusicaGlobal não encontrado no ReplicatedStorage!")
    end
end)

-- ✅ Noclip
local noclipEnabled = false
criarBotao("Toggle Noclip", function()
    noclipEnabled = not noclipEnabled
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not noclipEnabled
        end
    end
end)

-- ✅ Teleport para jogador
criarBotao("Teleportar para Jogador", function()
    local inputGui = Instance.new("ScreenGui", plrGui)
    local textbox = Instance.new("TextBox", inputGui)
    textbox.Size = UDim2.new(0,200,0,30)
    textbox.Position = UDim2.new(0.5,-100,0.5,-15)
    textbox.PlaceholderText = "Digite o nome do jogador"
    textbox.Text = ""
    textbox.FocusLost:Connect(function(enter)
        if enter then
            local target = game.Players:FindFirstChild(textbox.Text)
            local char = player.Character
            if target and target.Character and char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
                if hrp and targetHRP then
                    hrp.CFrame = targetHRP.CFrame + Vector3.new(0,3,0)
                end
            end
            inputGui:Destroy()
        end
    end)
end)

print("✅ Admin Troll GUI carregado com @tavinxoficial, Noclip e TP!")

