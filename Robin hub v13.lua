-- Robin Hub v13 (Com Abas, Teleporte para Spawn/Servidor Vazio, LED Vermelho e Início Fechado)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

local noclipEnabled = false
local flyEnabled = false
local playerGodModeEnabled = false
local mainGodModeEnabled = false
local killAuraEnabled = false
local infiniteJumpEnabled = false
local antiPushEnabled = false
local autoFarmEnabled = false
local customSpeed = 16
local hubVisible = false -- << Inicia fechado por padrão
local isExpanded = true

local bv, bg
local protegido = gethui or function(v) return v end

local colorOff = Color3.fromRGB(160, 40, 40) -- Vermelho Escuro
local colorOn = Color3.fromRGB(46, 204, 113)  -- Verde

-- Sistema Anti-Duplicado
if CoreGui:FindFirstChild("RobinHub_Delta") then
    CoreGui:FindFirstChild("RobinHub_Delta"):Destroy()
end
if player.PlayerGui:FindFirstChild("RobinHub_Delta") then
    player.PlayerGui:FindFirstChild("RobinHub_Delta"):Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RobinHub_Delta"
local success = pcall(function()
    screenGui.Parent = protegido(CoreGui)
end)
if not success then
    screenGui.Parent = player:WaitForChild("PlayerGui")
end
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- Botão Flutuante Principal (Com LED Vermelho Neon)
local toggleHubButton = Instance.new("TextButton", screenGui)
toggleHubButton.Size = UDim2.new(0, 130, 0, 36)
toggleHubButton.Position = UDim2.new(0.05, 0, 0.05, 0)
toggleHubButton.Text = "🦇 ROBIN HUB"
toggleHubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleHubButton.TextSize = 12
toggleHubButton.Font = Enum.Font.GothamBold
toggleHubButton.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
toggleHubButton.Active = true
toggleHubButton.Draggable = true
Instance.new("UICorner", toggleHubButton).CornerRadius = UDim.new(0, 8)
local tStroke = Instance.new("UIStroke", toggleHubButton)
tStroke.Color = Color3.fromRGB(255, 0, 0) -- LED Vermelho Brilhante
tStroke.Thickness = 2.0

-- Janela Principal (Com LED Vermelho Neon e inicialmente fechada)
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 380, 0, 560) -- Altura ajustada para caber o novo botão
mainFrame.Position = UDim2.new(0.5, -190, 0.4, -280)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 8, 8)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false -- << Começa fechado para o jogador
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
local mStroke = Instance.new("UIStroke", mainFrame)
mStroke.Color = Color3.fromRGB(255, 0, 0) -- LED Vermelho Brilhante na Borda
mStroke.Thickness = 2.5

-- Barra Superior
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 42)
topBar.BackgroundColor3 = Color3.fromRGB(30, 12, 12)
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 14)

local coverFix = Instance.new("Frame", topBar)
coverFix.Size = UDim2.new(1, 0, 0, 10)
coverFix.Position = UDim2.new(0, 0, 1, -10)
coverFix.BackgroundColor3 = Color3.fromRGB(30, 12, 12)
coverFix.BorderSizePixel = 0

local animeIcon = Instance.new("ImageLabel", topBar)
animeIcon.Size = UDim2.new(0, 28, 0, 28)
animeIcon.Position = UDim2.new(0, 8, 0.5, -14)
animeIcon.Image = "rbxassetid://6034229566"
animeIcon.BackgroundTransparency = 1

local titleLabel = Instance.new("TextLabel", topBar)
titleLabel.Size = UDim2.new(1, -170, 1, 0)
titleLabel.Position = UDim2.new(0, 44, 0, 0)
titleLabel.Text = "🦇 ROBIN HUB"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.BackgroundTransparency = 1

-- Mostrador de FPS e MS
local statsLabel = Instance.new("TextLabel", topBar)
statsLabel.Size = UDim2.new(0, 95, 0, 26)
statsLabel.Position = UDim2.new(1, -164, 0.5, -13)
statsLabel.Text = "FPS: 60 | MS: 0"
statsLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
statsLabel.TextSize = 9
statsLabel.Font = Enum.Font.GothamBold
statsLabel.BackgroundTransparency = 1
statsLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Botão Minimizar ([ ])
local resizeButton = Instance.new("TextButton", topBar)
resizeButton.Size = UDim2.new(0, 26, 0, 26)
resizeButton.Position = UDim2.new(1, -66, 0.5, -13)
resizeButton.Text = "[ ]"
resizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resizeButton.TextSize = 11
resizeButton.Font = Enum.Font.GothamBold
resizeButton.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
Instance.new("UICorner", resizeButton).CornerRadius = UDim.new(0, 6)

-- Botão Fechar (X)
local closeButton = Instance.new("TextButton", topBar)
closeButton.Size = UDim2.new(0, 26, 0, 26)
closeButton.Position = UDim2.new(1, -34, 0.5, -13)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 13
closeButton.Font = Enum.Font.GothamBold
closeButton.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

resizeButton.MouseButton1Click:Connect(function()
    isExpanded = not isExpanded
    if isExpanded then
        mainFrame.Size = UDim2.new(0, 380, 0, 560)
        resizeButton.Text = "[ ]"
    else
        mainFrame.Size = UDim2.new(0, 380, 0, 42)
        resizeButton.Text = "[+]"
    end
end)

toggleHubButton.MouseButton1Click:Connect(function()
    hubVisible = not hubVisible
    mainFrame.Visible = hubVisible
end)

-- Atualização em tempo real de FPS e MS
local lastTick = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTick = tick()
    if currentTick - lastTick >= 1 then
        local fps = math.floor(frameCount / (currentTick - lastTick))
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        statsLabel.Text = "FPS: " .. fps .. " | MS: " .. ping
        frameCount = 0
        lastTick = currentTick
    end
end)

-- Abas de Navegação (MAIN / PLAYER)
local tabNavFrame = Instance.new("Frame", mainFrame)
tabNavFrame.Size = UDim2.new(0, 356, 0, 32)
tabNavFrame.Position = UDim2.new(0, 12, 0, 50)
tabNavFrame.BackgroundTransparency = 1

local mainTabBtn = Instance.new("TextButton", tabNavFrame)
mainTabBtn.Size = UDim2.new(0.48, 0, 1, 0)
mainTabBtn.Position = UDim2.new(0, 0, 0, 0)
mainTabBtn.Text = "MAIN"
mainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mainTabBtn.TextSize = 11
mainTabBtn.Font = Enum.Font.GothamBold
mainTabBtn.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
Instance.new("UICorner", mainTabBtn).CornerRadius = UDim.new(0, 6)

local playerTabBtn = Instance.new("TextButton", tabNavFrame)
playerTabBtn.Size = UDim2.new(0.48, 0, 1, 0)
playerTabBtn.Position = UDim2.new(0.52, 0, 0, 0)
playerTabBtn.Text = "PLAYER"
playerTabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
playerTabBtn.TextSize = 11
playerTabBtn.Font = Enum.Font.GothamBold
playerTabBtn.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
Instance.new("UICorner", playerTabBtn).CornerRadius = UDim.new(0, 6)

-- Containers das Páginas
local mainContainer = Instance.new("Frame", mainFrame)
mainContainer.Size = UDim2.new(0, 356, 0, 440)
mainContainer.Position = UDim2.new(0, 12, 0, 92)
mainContainer.BackgroundTransparency = 1
mainContainer.Visible = true

local playerContainer = Instance.new("Frame", mainFrame)
playerContainer.Size = UDim2.new(0, 356, 0, 440)
playerContainer.Position = UDim2.new(0, 12, 0, 92)
playerContainer.BackgroundTransparency = 1
playerContainer.Visible = false

-- Alternar Abas
mainTabBtn.MouseButton1Click:Connect(function()
    mainContainer.Visible = true
    playerContainer.Visible = false
    mainTabBtn.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
    mainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    playerTabBtn.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
    playerTabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

playerTabBtn.MouseButton1Click:Connect(function()
    mainContainer.Visible = false
    playerContainer.Visible = true
    playerTabBtn.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
    playerTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainTabBtn.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
    mainTabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

-- ==================== CONTEÚDO DA ABA MAIN ====================
local mLeftX = UDim2.new(0, 0, 0, 0)
local mRightX = UDim2.new(0, 184, 0, 0)
local mElemSize = UDim2.new(0, 172, 0, 32)
local mStep = 38

local godButton = Instance.new("TextButton", mainContainer)
godButton.Size = mElemSize; godButton.Position = mLeftX
godButton.Text = "GOD MODE: OFF"; godButton.TextColor3 = Color3.fromRGB(255, 255, 255); godButton.TextSize = 11; godButton.Font = Enum.Font.GothamBold; godButton.BackgroundColor3 = colorOff
Instance.new("UICorner", godButton).CornerRadius = UDim.new(0, 8)

local killAuraButton = Instance.new("TextButton", mainContainer)
killAuraButton.Size = mElemSize; killAuraButton.Position = mRightX
killAuraButton.Text = "KILL AURA: OFF"; killAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255); killAuraButton.TextSize = 11; killAuraButton.Font = Enum.Font.GothamBold; killAuraButton.BackgroundColor3 = colorOff
Instance.new("UICorner", killAuraButton).CornerRadius = UDim.new(0, 8)

local infJumpButton = Instance.new("TextButton", mainContainer)
infJumpButton.Size = mElemSize; infJumpButton.Position = UDim2.new(0, 0, 0, mStep)
infJumpButton.Text = "PULO INFINITO: OFF"; infJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255); infJumpButton.TextSize = 11; infJumpButton.Font = Enum.Font.GothamBold; infJumpButton.BackgroundColor3 = colorOff
Instance.new("UICorner", infJumpButton).CornerRadius = UDim.new(0, 8)

local antiPushButton = Instance.new("TextButton", mainContainer)
antiPushButton.Size = mElemSize; antiPushButton.Position = UDim2.new(0, 184, 0, mStep)
antiPushButton.Text = "ANTI-EMPURRÃO: OFF"; antiPushButton.TextColor3 = Color3.fromRGB(255, 255, 255); antiPushButton.TextSize = 10; antiPushButton.Font = Enum.Font.GothamBold; antiPushButton.BackgroundColor3 = colorOff
Instance.new("UICorner", antiPushButton).CornerRadius = UDim.new(0, 8)

local getToolButton = Instance.new("TextButton", mainContainer)
getToolButton.Size = UDim2.new(0, 356, 0, 32); getToolButton.Position = UDim2.new(0, 0, 0, mStep * 2)
getToolButton.Text = "⚔️ PEGAR EQUIPAMENTO"; getToolButton.TextColor3 = Color3.fromRGB(255, 255, 255); getToolButton.TextSize = 11; getToolButton.Font = Enum.Font.GothamBold; getToolButton.BackgroundColor3 = colorOff
Instance.new("UICorner", getToolButton).CornerRadius = UDim.new(0, 8)

local spawnTpButton = Instance.new("TextButton", mainContainer)
spawnTpButton.Size = UDim2.new(0, 356, 0, 32); spawnTpButton.Position = UDim2.new(0, 0, 0, mStep * 3)
spawnTpButton.Text = "📍 TELEPORTAR PARA SPAWN"; spawnTpButton.TextColor3 = Color3.fromRGB(255, 255, 255); spawnTpButton.TextSize = 11; spawnTpButton.Font = Enum.Font.GothamBold; spawnTpButton.BackgroundColor3 = colorOff
Instance.new("UICorner", spawnTpButton).CornerRadius = UDim.new(0, 8)

-- Botão de Servidor Vazio / Poucos Jogadores
local lowServerButton = Instance.new("TextButton", mainContainer)
lowServerButton.Size = UDim2.new(0, 356, 0, 32); lowServerButton.Position = UDim2.new(0, 0, 0, mStep * 4)
lowServerButton.Text = "🌐 ENTRAR EM SERVIDOR VAZIO"; lowServerButton.TextColor3 = Color3.fromRGB(255, 255, 255); lowServerButton.TextSize = 11; lowServerButton.Font = Enum.Font.GothamBold; lowServerButton.BackgroundColor3 = colorOff
Instance.new("UICorner", lowServerButton).CornerRadius = UDim.new(0, 8)

local autoFarmButton = Instance.new("TextButton", mainContainer)
autoFarmButton.Size = UDim2.new(0, 356, 0, 34); autoFarmButton.Position = UDim2.new(0, 0, 0, (mStep * 5) + 2)
autoFarmButton.Text = "🌾 AUTO FARM LEVEL: OFF"
autoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoFarmButton.TextSize = 12
autoFarmButton.Font = Enum.Font.GothamBold
autoFarmButton.BackgroundColor3 = colorOff
Instance.new("UICorner", autoFarmButton).CornerRadius = UDim.new(0, 8)

local mainStatusLabel = Instance.new("TextLabel", mainContainer)
mainStatusLabel.Size = UDim2.new(0, 356, 0, 25); mainStatusLabel.Position = UDim2.new(0, 0, 0, (mStep * 6) + 6)
mainStatusLabel.Text = "Status: Robin Hub v13 ativo."
mainStatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
mainStatusLabel.TextSize = 11
mainStatusLabel.Font = Enum.Font.GothamMedium
mainStatusLabel.BackgroundTransparency = 1

-- ==================== CONTEÚDO DA ABA PLAYER ====================
local playerGodButton = Instance.new("TextButton", playerContainer)
playerGodButton.Size = UDim2.new(0, 356, 0, 32); playerGodButton.Position = UDim2.new(0, 0, 0, 0)
playerGodButton.Text = "PLAYER GOD MODE: OFF"; playerGodButton.TextColor3 = Color3.fromRGB(255, 255, 255); playerGodButton.TextSize = 11; playerGodButton.Font = Enum.Font.GothamBold; playerGodButton.BackgroundColor3 = colorOff
Instance.new("UICorner", playerGodButton).CornerRadius = UDim.new(0, 8)

local flyButton = Instance.new("TextButton", playerContainer)
flyButton.Size = UDim2.new(0, 356, 0, 32); flyButton.Position = UDim2.new(0, 0, 0, mStep)
flyButton.Text = "VOO: OFF"; flyButton.TextColor3 = Color3.fromRGB(255, 255, 255); flyButton.TextSize = 11; flyButton.Font = Enum.Font.GothamBold; flyButton.BackgroundColor3 = colorOff
Instance.new("UICorner", flyButton).CornerRadius = UDim.new(0, 8)

local noclipButton = Instance.new("TextButton", playerContainer)
noclipButton.Size = UDim2.new(0, 356, 0, 32); noclipButton.Position = UDim2.new(0, 0, 0, mStep * 2)
noclipButton.Text = "NOCLIP: OFF"; noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255); noclipButton.TextSize = 11; noclipButton.Font = Enum.Font.GothamBold; noclipButton.BackgroundColor3 = colorOff
Instance.new("UICorner", noclipButton).CornerRadius = UDim.new(0, 8)

local tpPlayerButton = Instance.new("TextButton", playerContainer)
tpPlayerButton.Size = UDim2.new(0, 356, 0, 32); tpPlayerButton.Position = UDim2.new(0, 0, 0, mStep * 3)
tpPlayerButton.Text = "👥 TELEPORTAR PARA JOGADOR"; tpPlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255); tpPlayerButton.TextSize = 11; tpPlayerButton.Font = Enum.Font.GothamBold; tpPlayerButton.BackgroundColor3 = colorOff
Instance.new("UICorner", tpPlayerButton).CornerRadius = UDim.new(0, 8)

local speedBox = Instance.new("TextBox", playerContainer)
speedBox.Size = UDim2.new(0, 356, 0, 32); speedBox.Position = UDim2.new(0, 0, 0, mStep * 4)
speedBox.Text = "50"; speedBox.PlaceholderText = "Velocidade (1-1000)"; speedBox.TextColor3 = Color3.fromRGB(255, 255, 255); speedBox.TextSize = 11; speedBox.Font = Enum.Font.GothamBold; speedBox.BackgroundColor3 = Color3.fromRGB(25, 10, 10); speedBox.ClearTextOnFocus = false
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

local speedButton = Instance.new("TextButton", playerContainer)
speedButton.Size = mElemSize; speedButton.Position = UDim2.new(0, 0, 0, mStep * 5)
speedButton.Text = "LIGAR VELOCIDADE"; speedButton.TextColor3 = Color3.fromRGB(255, 255, 255); speedButton.TextSize = 11; speedButton.Font = Enum.Font.GothamBold; speedButton.BackgroundColor3 = colorOff
Instance.new("UICorner", speedButton).CornerRadius = UDim.new(0, 8)

local offSpeedButton = Instance.new("TextButton", playerContainer)
offSpeedButton.Size = mElemSize; offSpeedButton.Position = UDim2.new(0, 184, 0, mStep * 5)
offSpeedButton.Text = "DESLIGAR VEL."; offSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255); offSpeedButton.TextSize = 10; offSpeedButton.Font = Enum.Font.GothamBold; offSpeedButton.BackgroundColor3 = colorOff
Instance.new("UICorner", offSpeedButton).CornerRadius = UDim.new(0, 8)

-- ==================== JANELA SELETORA DE JOGADORES (TELEPORTE) ====================
local tpWindow = Instance.new("Frame", screenGui)
tpWindow.Size = UDim2.new(0, 240, 0, 260)
tpWindow.Position = UDim2.new(0.5, -120, 0.5, -130)
tpWindow.BackgroundColor3 = Color3.fromRGB(15, 8, 8)
tpWindow.Visible = false
tpWindow.Active = true
tpWindow.Draggable = true
Instance.new("UICorner", tpWindow).CornerRadius = UDim.new(0, 10)
local tpStroke = Instance.new("UIStroke", tpWindow)
tpStroke.Color = Color3.fromRGB(255, 0, 0)
tpStroke.Thickness = 2

local tpTopBar = Instance.new("Frame", tpWindow)
tpTopBar.Size = UDim2.new(1, 0, 0, 30)
tpTopBar.BackgroundColor3 = Color3.fromRGB(30, 12, 12)
Instance.new("UICorner", tpTopBar).CornerRadius = UDim.new(0, 10)

local tpTitle = Instance.new("TextLabel", tpTopBar)
tpTitle.Size = UDim2.new(1, -35, 1, 0)
tpTitle.Position = UDim2.new(0, 10, 0, 0)
tpTitle.Text = "SELECIONE O JOGADOR"
tpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
tpTitle.TextSize = 10
tpTitle.Font = Enum.Font.GothamBold
tpTitle.BackgroundTransparency = 1
tpTitle.TextXAlignment = Enum.TextXAlignment.Left

local closeTpBtn = Instance.new("TextButton", tpTopBar)
closeTpBtn.Size = UDim2.new(0, 24, 0, 24)
closeTpBtn.Position = UDim2.new(1, -28, 0.5, -12)
closeTpBtn.Text = "✕"
closeTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeTpBtn.TextSize = 10
closeTpBtn.Font = Enum.Font.GothamBold
closeTpBtn.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
Instance.new("UICorner", closeTpBtn).CornerRadius = UDim.new(0, 6)

closeTpBtn.MouseButton1Click:Connect(function()
    tpWindow.Visible = false
end)

local scrollingList = Instance.new("ScrollingFrame", tpWindow)
scrollingList.Size = UDim2.new(1, -12, 1, -40)
scrollingList.Position = UDim2.new(0, 6, 0, 34)
scrollingList.BackgroundTransparency = 1
scrollingList.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingList.ScrollBarThickness = 4

local uiListLayout = Instance.new("UIListLayout", scrollingList)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 5)

tpPlayerButton.MouseButton1Click:Connect(function()
    tpWindow.Visible = not tpWindow.Visible
    if tpWindow.Visible then
        for _, child in ipairs(scrollingList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                local pBtn = Instance.new("TextButton", scrollingList)
                pBtn.Size = UDim2.new(1, 0, 0, 30)
                pBtn.Text = "  " .. p.Name
                pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                pBtn.TextSize = 11
                pBtn.Font = Enum.Font.GothamBold
                pBtn.BackgroundColor3 = Color3.fromRGB(30, 12, 12)
                pBtn.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)
                
                pBtn.MouseButton1Click:Connect(function()
                    pcall(function()
                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                            tpWindow.Visible = false
                        end
                    end)
                end)
            end
        end
        scrollingList.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 35)
    end
end)

-- ==================== LÓGICA DAS DEMAIS FUNÇÕES ====================

-- Teleporte para Servidor Vazio / Baixo número de jogadores
lowServerButton.MouseButton1Click:Connect(function()
    pcall(function()
        mainStatusLabel.Text = "Procurando servidor vazio..."
        lowServerButton.BackgroundColor3 = colorOn
        
        local servers = {}
        local cursor = ""
        
        repeat
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
            local success, response = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(url))
            end)
            
            if success and response and response.data then
                for _, s in ipairs(response.data) do
                    if type(s) == "table" and s.playing and s.maxPlayers and s.playing < s.maxPlayers then
                        table.insert(servers, s)
                    end
                end
                cursor = response.nextPageCursor
            else
                break
            end
        until not cursor or #servers > 0
        
        if #servers > 0 then
            table.sort(servers, function(a, b)
                return a.playing < b.playing
            end)
            
            mainStatusLabel.Text = "Entrando em servidor com " .. servers[1].playing .. " jogadores..."
            task.wait(1)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[1].id, player)
        else
            mainStatusLabel.Text = "Nenhum servidor vazio encontrado."
            task.delay(2, function() 
                mainStatusLabel.Text = "Status: Robin Hub v13 ativo."
                lowServerButton.BackgroundColor3 = colorOff
            end)
        end
    end)
end)

spawnTpButton.MouseButton1Click:Connect(function()
    pcall(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local spawnPoint = Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
            if spawnPoint then
                char.HumanoidRootPart.CFrame = spawnPoint.CFrame + Vector3.new(0, 3, 0)
                mainStatusLabel.Text = "Teletransportado para o Spawn!"
            else
                char.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
                mainStatusLabel.Text = "Spawn padrão (0, 50, 0)"
            end
            task.delay(1.5, function() mainStatusLabel.Text = "Status: Robin Hub v13 ativo." end)
        end
    end)
end)

antiPushButton.MouseButton1Click:Connect(function()
    antiPushEnabled = not antiPushEnabled
    antiPushButton.Text = antiPushEnabled and "ANTI-EMPURRÃO: ON" or "ANTI-EMPURRÃO: OFF"
    antiPushButton.BackgroundColor3 = antiPushEnabled and colorOn or colorOff
end)

RunService.Stepped:Connect(function()
    if antiPushEnabled and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                for _, otherPlayer in ipairs(Players:GetPlayers()) do
                    if otherPlayer ~= player and otherPlayer.Character then
                        for _, otherPart in ipairs(otherPlayer.Character:GetDescendants()) do
                            if otherPart:IsA("BasePart") then
                                pcall(function() part.CanCollide = false end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

speedBox.FocusLost:Connect(function()
    local num = tonumber(speedBox.Text)
    if num then customSpeed = math.clamp(num, 1, 1000) end
end)

speedButton.MouseButton1Click:Connect(function()
    local num = tonumber(speedBox.Text)
    if num then customSpeed = math.clamp(num, 1, 1000) end
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = customSpeed
        speedButton.BackgroundColor3 = colorOn
    end
end)

offSpeedButton.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
        speedButton.BackgroundColor3 = colorOff
    end
end)

getToolButton.MouseButton1Click:Connect(function()
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Tool") and obj.Parent ~= player.Character and not obj.Parent:IsA("Backpack") then
                obj.Parent = player.Backpack
                getToolButton.BackgroundColor3 = colorOn
                mainStatusLabel.Text = "Equipamento coletado!"
                task.delay(1, function() getToolButton.BackgroundColor3 = colorOff end)
                break
            end
        end
    end)
end)

noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipButton.Text = noclipEnabled and "NOCLIP: ON" or "NOCLIP: OFF"
    noclipButton.BackgroundColor3 = noclipEnabled and colorOn or colorOff
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

infJumpButton.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    infJumpButton.Text = infiniteJumpEnabled and "PULO INFINITO: ON" or "PULO INFINITO: OFF"
    infJumpButton.BackgroundColor3 = infiniteJumpEnabled and colorOn or colorOff
end)

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

godButton.MouseButton1Click:Connect(function()
    mainGodModeEnabled = not mainGodModeEnabled
    godButton.Text = mainGodModeEnabled and "GOD MODE: ON" or "GOD MODE: OFF"
    godButton.BackgroundColor3 = mainGodModeEnabled and colorOn or colorOff
end)

playerGodButton.MouseButton1Click:Connect(function()
    playerGodModeEnabled = not playerGodModeEnabled
    playerGodButton.Text = playerGodModeEnabled and "PLAYER GOD MODE: ON" or "PLAYER GOD MODE: OFF"
    playerGodButton.BackgroundColor3 = playerGodModeEnabled and colorOn or colorOff
end)

RunService.Heartbeat:Connect(function()
    if (mainGodModeEnabled or playerGodModeEnabled) and player.Character and player.Character:FindFirstChild("Humanoid") then
        local humanoid = player.Character.Humanoid
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end)

killAuraButton.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    killAuraButton.Text = killAuraEnabled and "KILL AURA: ON" or "KILL AURA: OFF"
    killAuraButton.BackgroundColor3 = killAuraEnabled and colorOn or colorOff
    
    if killAuraEnabled then
        task.spawn(function()
            while killAuraEnabled do
                task.wait(0.2)
                pcall(function()
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local myRoot = player.Character.HumanoidRootPart
                        local tool = player.Character:FindFirstChildOfClass("Tool")
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= player and p.Character then
                                local tRoot = p.Character:FindFirstChild("HumanoidRootPart")
                                local tHum = p.Character:FindFirstChild("Humanoid")
                                if tRoot and tHum and tHum.Health > 0 then
                                    if (myRoot.Position - tRoot.Position).Magnitude <= 20 then
                                        if tool then tool:Activate() end
                                        firetouchinterest(myRoot, tRoot, 0)
                                        firetouchinterest(myRoot, tRoot, 1)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
end)

local function getClosestMob()
    local closestMob = nil
    local shortestDistance = math.huge
    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Parent ~= myChar and obj.Health > 0 then
            local parent = obj.Parent
            local mobRoot = parent:FindFirstChild("HumanoidRootPart") or parent:FindFirstChild("Torso") or parent:FindFirstChild("UpperTorso")
            
            if mobRoot and not Players:GetPlayerFromCharacter(parent) then
                local distance = (myPos - mobRoot.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestMob = mobRoot
                end
            end
        end
    end
    return closestMob
end

autoFarmButton.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    autoFarmButton.Text = autoFarmEnabled and "🌾 AUTO FARM LEVEL: ON" or "🌾 AUTO FARM LEVEL: OFF"
    autoFarmButton.BackgroundColor3 = autoFarmEnabled and colorOn or colorOff

    if autoFarmEnabled then
        mainStatusLabel.Text = "Status: Auto Farm ativado."
        task.spawn(function()
            while autoFarmEnabled do
                task.wait(0.1)
                pcall(function()
                    local mob = getClosestMob()
                    local myChar = player.Character
                    if mob and myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        myChar.HumanoidRootPart.CFrame = mob.CFrame * CFrame.new(0, 6, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                        
                        local tool = myChar:FindFirstChildOfClass("Tool")
                        if not tool then
                            local backpackTool = player.Backpack:FindFirstChildOfClass("Tool")
                            if backpackTool then backpackTool.Parent = myChar end
                        else
                            tool:Activate()
                        end
                    end
                end)
            end
        end)
    else
        mainStatusLabel.Text = "Status: Auto Farm desativado."
    end
end)

flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyButton.Text = flyEnabled and "VOO: ON" or "VOO: OFF"
    flyButton.BackgroundColor3 = flyEnabled and colorOn or colorOff
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        flyEnabled = false
        flyButton.Text = "VOO: OFF"
        flyButton.BackgroundColor3 = colorOff
        return 
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    local humanoid = character:FindFirstChild("Humanoid")

    if flyEnabled then
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end

        bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = humanoidRootPart
        
        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.CFrame = humanoidRootPart.CFrame
        bg.Parent = humanoidRootPart
        
        if humanoid then humanoid.PlatformStand = true end
        
        task.spawn(function()
            while flyEnabled and character and humanoidRootPart and humanoidRootPart.Parent do
                local cam = Workspace.CurrentCamera
                local moveDir = humanoid and humanoid.MoveDirection or Vector3.new(0,0,0)
                local currentFlySpeed = tonumber(speedBox.Text) or 50
                
                if bv and bg and bv.Parent and bg.Parent then
                    if moveDir.Magnitude > 0 then
                        bv.Velocity = (cam.CFrame.LookVector * (moveDir.Z * currentFlySpeed)) + 
                                      (cam.CFrame.RightVector * (moveDir.X * currentFlySpeed)) + 
                                      Vector3.new(0, moveDir.Y * currentFlySpeed, 0)
                    else
                        bv.Velocity = Vector3.new(0, 0.1, 0)
                    end
                    bg.CFrame = cam.CFrame
                end
                task.wait()
            end
            
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            if humanoid then humanoid.PlatformStand = false end
        end)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if humanoid then humanoid.PlatformStand = false end
    end
end)

player.CharacterAdded:Connect(function(newChar)
    flyEnabled = false
    flyButton.Text = "VOO: OFF"
    flyButton.BackgroundColor3 = colorOff
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end)
