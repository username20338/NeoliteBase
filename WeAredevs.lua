-- NeoLiteBase - Open Source para Murder Mystery 2 com ESP, Speed e Auto-Respawn

-- Carregar dependências
local NeoLiteBase = {}

-- Função para criar uma janela básica
function NeoLiteBase:CreateWindow(Name, Width, Height)
    local window = Instance.new("ScreenGui")
    window.Name = Name
    window.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, Width, 0, Height)
    frame.Position = UDim2.new(0.5, -Width/2, 0.5, -Height/2)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.Parent = window

    window.Parent = game.Players.LocalPlayer.PlayerGui
    return window
end

-- Função para adicionar um botão à janela
function NeoLiteBase:AddButton(window, Name, Callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Position = UDim2.new(0.5, -100, 0.5, -25)
    button.Text = Name
    button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    button.Parent = window

    button.MouseButton1Click:Connect(Callback)
end

-- Função para adicionar ESP com cores específicas para Murder e Sheriff
function NeoLiteBase:ESPPlayers(window)
    local esp = {}
    
    -- Função para determinar a cor do ESP
    local function getPlayerRoleColor(player)
        local character = player.Character
        if character then
            local role = character:FindFirstChild("Role") -- Supondo que o papel esteja armazenado em "Role"
            if role then
                if role.Value == "Murder" then
                    return Color3.fromRGB(255, 0, 0) -- Vermelho para Murder
                elseif role.Value == "Sheriff" then
                    return Color3.fromRGB(0, 128, 0) -- Verde escuro para Sheriff
                end
            end
        end
        return Color3.fromRGB(255, 255, 255) -- Branco por padrão
    end

    -- Criar uma etiqueta para cada jogador
    game.Players.PlayerAdded:Connect(function(player)
        local label = Instance.new("BillboardGui")
        label.Adornee = player.Character.Head
        label.Size = UDim2.new(0, 100, 0, 50)
        label.StudsOffset = Vector3.new(0, 3, 0)
        label.AlwaysOnTop = true
        label.Parent = player.Character.Head

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = player.Name
        textLabel.TextColor3 = getPlayerRoleColor(player)  -- Define a cor conforme o papel
        textLabel.Parent = label
    end)

    -- Remover ESP quando o jogador sair
    game.Players.PlayerRemoving:Connect(function(player)
        if player.Character and player.Character.Head then
            for _, child in pairs(player.Character.Head:GetChildren()) do
                if child:IsA("BillboardGui") then
                    child:Destroy()
                end
            end
        end
    end)
end

-- Função para Auto-Respawn (reaparece após morrer)
function NeoLiteBase:AutoRespawn()
    -- Monitorando se o jogador morreu
    game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid").Died:Connect(function()
            -- Respawn após 2 segundos
            wait(2)
            game.Players.LocalPlayer:LoadCharacter()
        end)
    end)
end

-- Função para aumentar a velocidade do jogador para 70
function NeoLiteBase:IncreaseSpeed()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = 70  -- Define a velocidade de caminhada para 70
    end
end

-- Função para restaurar a velocidade padrão
function NeoLiteBase:ResetSpeed()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = 16  -- Restaura a velocidade padrão para 16
    end
end

-- Exemplo de uso
local window = NeoLiteBase:CreateWindow("Murder Mystery Hub", 400, 300)

-- Botão para ativar/desativar o aumento de velocidade
NeoLiteBase:AddButton(window, "Aumentar Velocidade", function()
    NeoLiteBase:IncreaseSpeed()
    print("Velocidade aumentada para 70!")
end)

-- Botão para restaurar a velocidade
NeoLiteBase:AddButton(window, "Restaurar Velocidade", function()
    NeoLiteBase:ResetSpeed()
    print("Velocidade restaurada para 16!")
end)

-- Botões para ativar ESP e Auto-Respawn
NeoLiteBase:AddButton(window, "Ativar ESP", function()
    NeoLiteBase:ESPPlayers(window)
    print("ESP ativado!")
end)

NeoLiteBase:AddButton(window, "Ativar Auto-Respawn", function()
    NeoLiteBase:AutoRespawn()
    print("Auto-Respawn ativado!")
end)

return NeoLiteBase

