local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Rain x Hub | Prisonlife",
    Folder = "Mybabeee",
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    HideSearchBar = true,
    ScrollBarEnabled = false,
})

local CombatTab = Window:Tab({
    Title = "Combat",
    Icon = "crosshair"
})

local FOVEnabled = false
local SafeTeam = false
local SafeFriends = false
local FOVSize = 120
local AimPart = "Head"
local FOVMode = "Center"

local fov_circle = Drawing.new("Circle")
fov_circle.Visible = true
fov_circle.Color = Color3.fromRGB(255,255,255)
fov_circle.Radius = FOVSize
fov_circle.Transparency = 1
fov_circle.Filled = false
fov_circle.NumSides = 64

local target_line = Drawing.new("Line")
target_line.Visible = false
target_line.Thickness = 1.5
target_line.Color = Color3.fromRGB(255,0,0)
target_line.Transparency = 1

CombatTab:Toggle({
    Title = "Show FOV",
    Default = false,
    Callback = function(v)
        FOVEnabled = v
        fov_circle.Visible = v
    end
})

CombatTab:Toggle({
    Title = "Safe Team",
    Default = false,
    Callback = function(v)
        SafeTeam = v
    end
})

CombatTab:Toggle({
    Title = "Safe Friends",
    Default = false,
    Callback = function(v)
        SafeFriends = v
    end
})

CombatTab:Slider({
    Title = "FOV Size",
    Flag = "fov_size",
    Step = 1,
    Value = {
        Min = 50,
        Max = 500,
        Default = 120
    },
    Callback = function(v)
        FOVSize = v
        fov_circle.Radius = v
    end
})

CombatTab:Dropdown({
    Title = "Aim Part",
    Values = {"Head","HumanoidRootPart","Torso"},
    Default = "Head",
    Multi = false,
    Callback = function(v)
        AimPart = v
    end
})

CombatTab:Dropdown({
    Title = "FOV Mode",
    Values = {"Mouse","Center"},
    Default = "Center",
    Multi = false,
    Callback = function(v)
        FOVMode = v
    end
})

local function get_center()
    if FOVMode == "Mouse" then
        local pos = UserInputService:GetMouseLocation()
        return Vector2.new(pos.X, pos.Y)
    else
        local viewport = Camera.ViewportSize
        return Vector2.new(viewport.X / 2, viewport.Y / 2)
    end
end

local function get_closest_player()
    local closest_player = nil
    local closest_position = nil
    local closest_screen = nil
    local closest_distance = FOVSize

    local center = get_center()

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then
            continue
        end

        if SafeTeam and player.Team == LocalPlayer.Team then
            continue
        end

        if SafeFriends and LocalPlayer:IsFriendsWith(player.UserId) then
            continue
        end

        local character = player.Character
        if not character then
            continue
        end

        local part = character:FindFirstChild(AimPart)
        if not part then
            continue
        end

        local screen_pos, visible = Camera:WorldToViewportPoint(part.Position)

        if not visible or screen_pos.Z <= 0 then
            continue
        end

        local pos2d = Vector2.new(screen_pos.X, screen_pos.Y)
        local distance = (pos2d - center).Magnitude

        if distance < closest_distance then
            closest_distance = distance
            closest_player = player
            closest_position = part.Position
            closest_screen = pos2d
        end
    end

    return closest_player, closest_position, closest_screen
end

RunService.RenderStepped:Connect(function()
    local center = get_center()

    fov_circle.Position = center
    fov_circle.Radius = FOVSize
    fov_circle.Visible = FOVEnabled

    local player, _, screen_pos = get_closest_player()

    if player and screen_pos then
        target_line.Visible = true
        target_line.From = center
        target_line.To = screen_pos
    else
        target_line.Visible = false
    end
end)

LPH_NO_UPVALUES = function(fn)
    return function(...)
        return fn(...)
    end
end

local castRay = filtergc("function", {Name = "castRay"}, true)

local old
old = hookfunction(castRay, LPH_NO_UPVALUES(function(...)
    local player, position = get_closest_player()

    if player and position then
        return player.Character[AimPart], position
    end

    return old(...)
end))


local MainTab = Window:Tab({
    Title = "Main",
    Icon = "menu"
})

getgenv().SpeedEnabled = false
getgenv().JumpEnabled = false
getgenv().InfiniteJump = false

getgenv().SpeedValue = 5
getgenv().JumpValue = 50

MainTab:Toggle({
    Title = "Speed",
    Default = false,
    Callback = function(v)
        getgenv().SpeedEnabled = v
    end
})

MainTab:Slider({
    Title = "Speed Value",
    Flag = "speed_value",
    Step = 1,
    Value = {
        Min = 5,
        Max = 200,
        Default = 5
    },
    Callback = function(v)
        getgenv().SpeedValue = v
    end
})

MainTab:Toggle({
    Title = "High Jump",
    Default = false,
    Callback = function(v)
        getgenv().JumpEnabled = v

        local Character = LocalPlayer.Character
        if Character then
            local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
            if Humanoid then
                Humanoid.UseJumpPower = true
                Humanoid.JumpPower = v and getgenv().JumpValue or 50
            end
        end
    end
})

MainTab:Slider({
    Title = "Jump Power",
    Flag = "jump_power",
    Step = 1,
    Value = {
        Min = 50,
        Max = 300,
        Default = 50
    },
    Callback = function(v)
        getgenv().JumpValue = v

        local Character = LocalPlayer.Character
        if Character then
            local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
            if Humanoid and getgenv().JumpEnabled then
                Humanoid.UseJumpPower = true
                Humanoid.JumpPower = v
            end
        end
    end
})

MainTab:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(v)
        getgenv().InfiniteJump = v
    end
})

UserInputService.JumpRequest:Connect(function()
    if getgenv().InfiniteJump then
        local Character = LocalPlayer.Character

        if Character then
            local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")

            if Humanoid then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local Character = LocalPlayer.Character
    if not Character then return end

    local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")

    if not Humanoid or not RootPart then return end

    if getgenv().SpeedEnabled then
        local MoveDirection = Humanoid.MoveDirection

        if MoveDirection.Magnitude > 0 then
            RootPart.CFrame = RootPart.CFrame + (MoveDirection * (getgenv().SpeedValue / 10))
        end
    end

    if getgenv().JumpEnabled then
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = getgenv().JumpValue
    end
end)

LocalPlayer.CharacterAdded:Connect(function(Character)
    local Humanoid = Character:WaitForChild("Humanoid")

    task.wait(1)

    if getgenv().JumpEnabled then
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = getgenv().JumpValue
    end
end)

local function applyNoclip()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local parts = workspace:GetPartBoundsInRadius(root.Position, radius)
    local currentParts = {}

    for _, part in pairs(parts) do
        if part:IsA("BasePart") and part ~= root then
            local underFoot = part.Position.Y + part.Size.Y/2 < root.Position.Y
            if not underFoot then
                part.CanCollide = false
                trackedParts[part] = true
                currentParts[part] = true
            end
        end
    end

    for part,_ in pairs(trackedParts) do
        if not currentParts[part] then
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
            trackedParts[part] = nil
        end
    end
end
local accumulator = 0
RunService.RenderStepped:Connect(function(dt)
    if not frontNoclip then return end
    accumulator = accumulator + dt
    if accumulator >= 0.1 then
        applyNoclip()
        accumulator = 0
    end
end)

MainTab:Toggle({
    Title = "Noclip",
    Callback = function(state)
        frontNoclip = state
        if not frontNoclip then
            for part,_ in pairs(trackedParts) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            trackedParts = {}
        end
    end
})

getgenv().AutoArrest = false
local ArrestDistance = 10
local ArrestCooldown = 0.01
local LastArrest = 0

MainTab:Toggle({
    Title = "Auto Arrest",
    Default = false,
    Callback = function(v)
        getgenv().AutoArrest = v
    end
})

RunService.Heartbeat:Connect(function()
    if not getgenv().AutoArrest then
        return
    end

    if tick() - LastArrest < ArrestCooldown then
        return
    end

    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not RootPart then
        return
    end

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local TargetCharacter = Player.Character
            local TargetRoot = TargetCharacter and TargetCharacter:FindFirstChild("HumanoidRootPart")

            if TargetRoot then
                local Distance = (RootPart.Position - TargetRoot.Position).Magnitude

                if Distance <= ArrestDistance then
                    LastArrest = tick()

                    pcall(function()
                        game:GetService("ReplicatedStorage")
                            :WaitForChild("Remotes")
                            :WaitForChild("ArrestPlayer")
                            :InvokeServer(Player, 1)
                    end)
                end
            end
        end
    end
end)

local plsraknet = Raknet or raknet
if not plsraknet then return end

MainTab:Toggle({
    Title = "Invisible",
    Default = false,
    Callback = function(state)
        if plsraknet and plsraknet.desync then
            plsraknet.desync(state)
        end
    end
})


local TeleportTab = Window:Tab({
    Title = "Teleport",
    Icon = "map-pin"
})

local function TouchPart(part)
    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not RootPart or not part then
        return
    end

    local OldCFrame = RootPart.CFrame

    RootPart.CFrame = part.CFrame + Vector3.new(0,2,0)

    task.wait(0.15)

    firetouchinterest(RootPart, part, 0)
    firetouchinterest(RootPart, part, 1)

    task.wait(0.15)

    RootPart.CFrame = OldCFrame
end

TeleportTab:Button({
    Title = "Get Remington",
    Callback = function()
        local Part = workspace:GetChildren()[207]:GetChildren()[2].TouchGiver
        TouchPart(Part)
    end
})

TeleportTab:Button({
    Title = "Get AK47",
    Callback = function()
        local Part = workspace:GetChildren()[207].TouchGiver.TouchGiver
        TouchPart(Part)
    end
})

TeleportTab:Button({
    Title = "Get MP5",
    Callback = function()
        local Part = workspace:GetChildren()[188].TouchGiver
        TouchPart(Part)
    end
})

TeleportTab:Button({
    Title = "Tower",
    Callback = function()
        local Character = LocalPlayer.Character
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if RootPart then
            RootPart.CFrame = CFrame.new(
                827.3194580078125,
                101.74959564208984,
                2280.176025390625
            )
        end
    end
})

TeleportTab:Button({
    Title = "Police",
    Callback = function()
        local Character = LocalPlayer.Character
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if RootPart then
            RootPart.CFrame = CFrame.new(
                -934.7346801757812,
                128.3131866455078,
                2057.7734375
            )
        end
    end
})

TeleportTab:Button({
    Title = "Thieves' Nest",
    Callback = function()
        local Character = LocalPlayer.Character
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if RootPart then
            RootPart.CFrame = CFrame.new(
                822.1361083984375,
                135.62796020507812,
                2593.3291015625
            )
        end
    end
})

local EspTab = Window:Tab({
    Title = "ESP",
    Icon = "eye"
})

getgenv().NameESP = false
getgenv().InventoryViewer = false

local ESPObjects = {}

local function ClearESP(player)
    if ESPObjects[player] then
        for _,v in pairs(ESPObjects[player]) do
            pcall(function()
                v:Remove()
            end)
        end

        ESPObjects[player] = nil
    end
end

local function CreateESP(player)
    if player == LocalPlayer then
        return
    end

    ClearESP(player)

    local NameText = Drawing.new("Text")
    NameText.Size = 12
    NameText.Center = true
    NameText.Outline = true
    NameText.Font = 2
    NameText.Visible = false

    local InventoryText = Drawing.new("Text")
    InventoryText.Size = 12
    InventoryText.Center = true
    InventoryText.Outline = true
    InventoryText.Font = 2
    InventoryText.Visible = false

    ESPObjects[player] = {
        Name = NameText,
        Inventory = InventoryText
    }
end

for _,player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    ClearESP(player)
end)

EspTab:Toggle({
    Title = "ESP Name",
    Default = false,
    Callback = function(v)
        getgenv().NameESP = v
    end
})

EspTab:Toggle({
    Title = "Inventory Viewer",
    Default = false,
    Callback = function(v)
        getgenv().InventoryViewer = v
    end
})

RunService.RenderStepped:Connect(function()
    for _,player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local esp = ESPObjects[player]

            if not esp then
                continue
            end

            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")

            if character and root and humanoid and humanoid.Health > 0 then
                local pos, visible = Camera:WorldToViewportPoint(root.Position)

                if visible then
                    local TeamColor = Color3.new(1,1,1)

                    if player.Team and player.Team.TeamColor then
                        TeamColor = player.Team.TeamColor.Color
                    end

                    if getgenv().NameESP then
                        esp.Name.Visible = true
                        esp.Name.Text = player.Name
                        esp.Name.Position = Vector2.new(pos.X, pos.Y - 35)
                        esp.Name.Color = TeamColor
                    else
                        esp.Name.Visible = false
                    end

                    if getgenv().InventoryViewer then
                        local Items = {}

                        for _,tool in ipairs(player.Backpack:GetChildren()) do
                            if tool:IsA("Tool") then
                                table.insert(Items, tool.Name)
                            end
                        end

                        for _,tool in ipairs(character:GetChildren()) do
                            if tool:IsA("Tool") then
                                table.insert(Items, tool.Name)
                            end
                        end

                        esp.Inventory.Visible = true
                        esp.Inventory.Text = table.concat(Items, "\n")
                        esp.Inventory.Position = Vector2.new(pos.X, pos.Y + 25)
                        esp.Inventory.Color = TeamColor
                    else
                        esp.Inventory.Visible = false
                    end
                else
                    esp.Name.Visible = false
                    esp.Inventory.Visible = false
                end
            else
                esp.Name.Visible = false
                esp.Inventory.Visible = false
            end
        end
    end
end)
