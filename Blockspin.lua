

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local player = game.Players.LocalPlayer

local Window = WindUI:CreateWindow({
    Title = "Ranx HUB | Premium PVP[ BLOCK SPIN] ",
    Folder = "HUB",
    Size = UDim2.fromOffset(700, 540),
    Transparent = true,
    Resizable = true
})

Window:EditOpenButton({
    Enabled = false
})

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WindUI_Toggle"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.fromOffset(40, 40)
ToggleBtn.Position = UDim2.new(0.5, -20, 0, 10)

ToggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
ToggleBtn.BackgroundTransparency = 0
ToggleBtn.Image = "rbxassetid://110538801742199"

ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.AutoButtonColor = false

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10) -- กลมเต็ม
Corner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    ToggleBtn:TweenSize(
        UDim2.fromOffset(44, 44),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.12,
        true,
        function()
            ToggleBtn:TweenSize(
                UDim2.fromOffset(40, 40),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.12,
                true
            )
        end
    )

    Window:Toggle()
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.T then
        Window:Toggle()
    end
end)

local HomeTab = Window:Tab({Title = "Home", Icon = "house"})
local GeneralTab = Window:Tab({Title = "General", Icon = "menu"})
local CombatTab = Window:Tab({Title = "Combat", Icon = "sword"})
local GunmodsTab    = Window:Tab({Title = "Gunmods", Icon = "crosshair"})
local VisualTab    = Window:Tab({Title = "Visual", Icon = "eye"})
local carTab    = Window:Tab({Title = "Car", Icon = "car"})
local MiscTab   = Window:Tab({Title = "MISC", Icon = "settings"})
local ServerTab    = Window:Tab({Title = "Server", Icon = "server"})


HomeTab:Section(
    {
        Title = "My Name is x2nyx solo Developer"
    }
)

HomeTab:Section(
    {
        Title = "Good luck🍀​"
    }
)

local Players = game:GetService("Players")
local Client = Players.LocalPlayer
local PlayerGui = Client:WaitForChild("PlayerGui")

local BankBalance =
    GeneralTab:Button(
    {
        Title = "เงินในธนาคาร",
        Desc = "N/A"
    }
)
local HandBalance =
    GeneralTab:Button(
    {
        Title = "เงินในมือ",
        Desc = "N/A"
    }
)

local function HandMoney()
    return tonumber(PlayerGui.TopRightHud.Holder.Frame.MoneyTextLabel.Text:match("%$(%d+)"))
end

local function ATMMoney()
    for _, v in ipairs(PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") and string.find(v.Text, "Bank Balance") then
            return tonumber(v.Text:match("%$(%d+)"))
        end
    end
    return 0
end

task.spawn(
    function()
        while task.wait(0.2) do
            BankBalance:SetDesc('<b><font color="#00FF00">$' .. (ATMMoney() or 0) .. "</font></b>")
            HandBalance:SetDesc('<b><font color="#00f2ff">$' .. (HandMoney() or 0) .. "</font></b>")
        end
    end
)


GeneralTab:Section(
    {
        Title = "Players"
    }
)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local SpeedMultiplier = 0.1
local Enabled = false

Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

GeneralTab:Toggle({
    Title = "วิ่งไว",
    Value = false,
    Callback = function(v)
        Enabled = v
    end
})

GeneralTab:Slider({
    Title = "ความไว",
    Step = 0.5,
    Value = {
        Min = 0,
        Max = 3,
        Default = 1,
    },
    Callback = function(value)
        SpeedMultiplier = value
    end
})

RunService.Heartbeat:Connect(function()
    if Enabled and Humanoid and RootPart then
        if Humanoid.MoveDirection.Magnitude > 0 then
            RootPart.CFrame = RootPart.CFrame + (Humanoid.MoveDirection * (SpeedMultiplier / 10))
        end
    end
end)

local HighJump = false
local JumpPower = 1

GeneralTab:Toggle({
    Title = "กระโดดสูง",
    Default = false,
    Callback = function(v)
        HighJump = v
    end
})

GeneralTab:Slider({
    Title = "ความสูง",
    Step = 0.5,
    Value = {
        Min = 1,
        Max = 5,
        Default = 1
    },
    Callback = function(v)
        JumpPower = v
    end
})

RunService.Heartbeat:Connect(function()
    local char = Players.LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if HighJump then
                hum.UseJumpPower = true
                hum.JumpPower = 15* JumpPower
            else
                hum.JumpPower = 10
            end
        end
    end
end)

GeneralTab:Toggle({
    Title = "สเตมิน่าไม่จำกัด",
    Default = false,
    Callback = function(state)
        if state then
            if not getgenv().Bypassed then
                local NetModule = require(ReplicatedStorage.Modules.Core.Net)
                local func = debug.getupvalue(NetModule.get, 2)
                debug.setconstant(func, 3, '__Bypass')
                debug.setconstant(func, 4, '__Bypass')
                getgenv().Bypassed = true
            end

            repeat task.wait() until getgenv().Bypassed

            local NetModule = require(ReplicatedStorage.Modules.Core.Net)
            local SprintModule = require(ReplicatedStorage.Modules.Game.Sprint)

            if staminaConnection then staminaConnection:Disconnect() end

            staminaConnection = RunService.Heartbeat:Connect(function()
                NetModule.send("set_sprinting_1", true)
            end)

            local consume_stamina = SprintModule.consume_stamina
            local SprintBar = debug.getupvalue(consume_stamina, 2).sprint_bar

            if not oldUpdate then
                oldUpdate = SprintBar.update
            end

            SprintBar.update = function(...)
                if getgenv().InfiniteStamina then
                    return 1
                end
                return oldUpdate(...)
            end

            getgenv().InfiniteStamina = true

        else
            getgenv().InfiniteStamina = false

            if staminaConnection then
                staminaConnection:Disconnect()
                staminaConnection = nil
            end

            
            if oldUpdate then
                local SprintModule = require(ReplicatedStorage.Modules.Game.Sprint)
                local consume_stamina = SprintModule.consume_stamina
                local SprintBar = debug.getupvalue(consume_stamina, 2).sprint_bar
                SprintBar.update = oldUpdate
            end
        end
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Client = Players.LocalPlayer
local Char = require(game.ReplicatedStorage.Modules.Core.Char)

getgenv().AntiAimAssiant = false

GeneralTab:Toggle({
    Title = "กันล็อค",
    Value = false,
    Callback = function(v)
        getgenv().AntiAimAssiant = v
        print("Anti Aim Status:", v)
    end
})

RunService.Heartbeat:Connect(function()
    if getgenv().AntiAimAssiant then
        local HumanoidModule = Char.get_hum()
        if HumanoidModule and not HumanoidModule:GetAttribute("HasBeenDowned") then
            local RootPartModule = Char.get_hrp()
            if not RootPartModule then return end
            local oldVelocity = RootPartModule.Velocity
            local oldLinear = RootPartModule.AssemblyLinearVelocity
            local oldAngular = RootPartModule.AssemblyAngularVelocity
            local randomVec = Vector3.new(
                math.random(-99999999, 99999999),
                math.random(-99999999, 99999999),
                math.random(-99999999, 99999999)
            )

            RootPartModule.Velocity = randomVec
            RootPartModule.AssemblyLinearVelocity = randomVec
            RootPartModule.AssemblyAngularVelocity = randomVec
            RunService.RenderStepped:Wait()
            RootPartModule.Velocity = oldVelocity
            RootPartModule.AssemblyLinearVelocity = oldLinear
            RootPartModule.AssemblyAngularVelocity = oldAngular
        end
    end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")


local CharModule = require(game.ReplicatedStorage.Modules.Core.Char)


local enabled = false
local flickering = false
local undergroundBaseCFrame = nil


local DROP_DEPTH = -55
local MOVE_RADIUS = 10
local FLICKER_RATE = 0.1


local function isDowned()
    local hum = CharModule.get_hum()
    
    return hum and (hum:GetAttribute("HasBeenDowned") or hum:GetAttribute("IsDead") or hum.Health <= 0)
end


local function getHRP()
    local char = CharModule.current_char.get()
    if not char then return end
    return char:FindFirstChild("HumanoidRootPart")
end


local function teleportUnderground()
    local hrp = getHRP()
    if not hrp then return end
    local original = hrp.CFrame
    undergroundBaseCFrame = original + Vector3.new(0, DROP_DEPTH, 0)
    hrp.CFrame = undergroundBaseCFrame
end


local function flickerAndMove()
    if flickering then return end
    flickering = true
    task.spawn(function()
        while flickering and enabled and isDowned() do
            local hrp = getHRP()
            if hrp and undergroundBaseCFrame then
                local angle = math.random() * math.pi * 2
                local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * MOVE_RADIUS
                local randomPos = undergroundBaseCFrame.Position + offset
                hrp.CFrame = CFrame.new(randomPos)
                task.wait(0.05)
                hrp.CFrame = undergroundBaseCFrame
            end
            task.wait(FLICKER_RATE)
        end
        flickering = false
    end)
end

GeneralTab:Toggle({
    Title = "กันตาย",
    Value = false,
    Callback = function(v)
        enabled = v
        if not v then
            undergroundBaseCFrame = nil
            flickering = false
        end
    end
})

RunService.Heartbeat:Connect(function()
    if not enabled then return end
    
    if isDowned() then
        local hrp = getHRP()
        if hrp and not undergroundBaseCFrame then
            teleportUnderground()
        end
        flickerAndMove()
    else
        if undergroundBaseCFrame then
            local hrp = getHRP()
            if hrp then
                hrp.CFrame = undergroundBaseCFrame + Vector3.new(0, -DROP_DEPTH, 0)
            end
        end
        undergroundBaseCFrame = nil
        flickering = false
    end
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Client = Players.LocalPlayer
local Network = require(ReplicatedStorage.Modules.Core.Net)

local DroppedFolder = workspace:FindFirstChild("DroppedItems")

local pickupEnabled = false

GeneralTab:Toggle({
    Title = "ดูดของ",
    Default = false,
    Callback = function(state)
        pickupEnabled = state
    end
})

task.spawn(function()
    while task.wait() do
        if pickupEnabled and DroppedFolder then
            for _, v in pairs(DroppedFolder:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("PickUpZone") then

                    local char = Client.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")

                    if hrp and (v:GetPivot().Position - hrp.Position).Magnitude < 15 then
                        Network.get("pickup_dropped_item", v)
                    end
                end
            end
        end
    end
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = require(ReplicatedStorage.Modules.Core.Net)
local RagdollModule = require(ReplicatedStorage.Modules.Game.Ragdoll)

local AntiRagdoll = false

GeneralTab:Toggle({
    Title = "กันล้ม",
    Default = false,
    Callback = function(v)
        AntiRagdoll = v
    end
})

local Get_Ragdolling = RagdollModule.is_ragdolling.get

RagdollModule.is_ragdolling.get = function(...)
    local result = Get_Ragdolling(...)

    if result == true and AntiRagdoll then
        RagdollModule.is_ragdolling.set(false)
        Network.send("end_ragdoll_early")
        Network.send("clear_ragdoll")
    end

    return result
end

GeneralTab:Section(
    {
        Title = "Ett"
    }
)

local plsraknet = Raknet or raknet
if not plsraknet then return end

GeneralTab:Toggle({
    Title = "ล่องหน",
    Default = false,
    Callback = function(state)
        if plsraknet and plsraknet.desync then
            plsraknet.desync(state)
        end
    end
})

GeneralTab:Section(
    {
        Title = "Snap:"
    }
)
local SnapEnabled = false
local SnapDepth = 10
local snapThread = nil

local function StartSnap()
    if SnapEnabled then return end
    SnapEnabled = true

    if snapThread then
        task.cancel(snapThread)
    end

    snapThread = task.spawn(function()
        local baseY = nil

        while SnapEnabled do
            task.wait(0.01)

            local char = Char.get()
            local hrp = Char.get_hrp()

            if char and hrp then
                if not baseY then
                    baseY = hrp.Position.Y
                end

                local deltaY = (baseY - SnapDepth) - hrp.Position.Y
                char:PivotTo(hrp.CFrame * CFrame.new(0, deltaY, 0))
            else
                baseY = nil
            end
        end
    end)
end

local function StopSnap()
    SnapEnabled = false

    if snapThread then
        task.cancel(snapThread)
        snapThread = nil
    end
end

GeneralTab:Toggle({
    Title = "มุดดิน",
    Default = false,
    Callback = function(v)
        if v then
            StartSnap()
        else
            StopSnap()
        end
    end
})

GeneralTab:Slider({
    Title = "ความลึก",
    Step = 1,
    Value = {
        Min = 5,
        Max = 50,
        Default = 10
    },
    Callback = function(v)
        SnapDepth = v
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Network = require(game.ReplicatedStorage.Modules.Core.Net)

local TargetHistory = {}

local FOV = 150
local ShowFOV = false
local AimPart = "Head"

local fovCircle = Drawing.new("Circle")
fovCircle.Radius = FOV
fovCircle.Thickness = 1
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(255,255,255)
fovCircle.Visible = ShowFOV

local tracer = Drawing.new("Line")
tracer.Thickness = 2
tracer.Color = Color3.fromRGB(255,0,0)
tracer.Visible = false

CombatTab:Toggle({
	Title = "Show FOV",
	Default = ShowFOV,
	Callback = function(v)
		ShowFOV = v
		fovCircle.Visible = v
	end
})

CombatTab:Slider({
	Title = "FOV Size",
	Step = 1,
	Value = {
		Min = 50,
		Max = 500,
		Default = FOV
	},
	Callback = function(v)
		FOV = v
		fovCircle.Radius = v
	end
})

local function GetPlayerNames()
	local t = {}

	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			table.insert(t,plr.Name)
		end
	end

	return t
end

CombatTab:Dropdown({
	Title = "Save Friend",
	Values = GetPlayerNames(),
	Multi = true,
	Default = {},
	Callback = function(selected)

		for _,plr in pairs(Players:GetPlayers()) do
			plr:SetAttribute("SilentAimIgnore",false)
		end

		for _,name in pairs(selected) do
			local plr = Players:FindFirstChild(name)

			if plr then
				plr:SetAttribute("SilentAimIgnore",true)
			end
		end
	end
})

CombatTab:Dropdown({
	Title = "Aim Part",
	Values = {"Head","Body"},
	Multi = false,
	Default = "Head",
	Callback = function(v)
		AimPart = v
	end
})

local function CreateCurvedTracer(startPos,endPos)
	local segments = 20

	local randomDir = Vector3.new(
		math.random(-20,20),
		math.random(10,25),
		math.random(-20,20)
	)

	local mid = (startPos + endPos)/2

	local control1 = mid + randomDir

	local control2 = mid + Vector3.new(
		math.random(-15,15),
		math.random(-5,20),
		math.random(-15,15)
	)

	local lastPos = startPos

	for i = 1,segments do
		local t = i/segments

		local p =
			(1-t)^3 * startPos +
			3*(1-t)^2*t * control1 +
			3*(1-t)*t^2 * control2 +
			t^3 * endPos

		local dist = (p - lastPos).Magnitude

		local part = Instance.new("Part")
		part.Size = Vector3.new(0.12,0.12,dist)
		part.CFrame = CFrame.new(lastPos,p) * CFrame.new(0,0,-dist/2)
		part.Anchored = true
		part.CanCollide = false
		part.Material = Enum.Material.Neon
		part.Color = Color3.fromRGB(255,0,0)
		part.Parent = workspace

		Debris:AddItem(part,0.25)

		lastPos = p
	end
end

local function GetDistanceStart(a,b)
	return (a-b).Magnitude
end

local function WorldToViewPoint(pos)
	local vp,onScreen = Camera:WorldToViewportPoint(pos)
	return vp,onScreen
end

local function IsAlive(model)
	local hum = model:FindFirstChildOfClass("Humanoid")
	local root = model:FindFirstChild("HumanoidRootPart")
	return hum and root and hum.Health > 0
end

local function IsBehindWall(startPos,endPos,ignore)
	local ray = Ray.new(startPos,endPos-startPos)
	local hit = workspace:FindPartOnRayWithIgnoreList(ray,ignore or {})
	return hit ~= nil
end

local function GetClosestTarget()
	local closest = nil
	local dist = math.huge

	for _,v in pairs(Players:GetPlayers()) do
		if v ~= LocalPlayer and v.Character and IsAlive(v.Character) then
			if not v:GetAttribute("SilentAimIgnore") then

				local root = v.Character:FindFirstChild("HumanoidRootPart")

				if root then
					local pos,onScreen = WorldToViewPoint(root.Position)

					if onScreen then
						local d = GetDistanceStart(
							Vector2.new(pos.X,pos.Y),
							Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
						)

						if d < FOV and d < dist then
							closest = v.Character
							dist = d
						end
					end
				end
			end
		end
	end

	return closest
end

RunService.RenderStepped:Connect(function()
	fovCircle.Position = Vector2.new(
		Camera.ViewportSize.X/2,
		Camera.ViewportSize.Y/2
	)

	fovCircle.Radius = FOV
	fovCircle.Visible = ShowFOV

	local target = GetClosestTarget()

	if target then
		local part = target:FindFirstChild(
			AimPart == "Body" and "HumanoidRootPart" or "Head"
		)

		if part then
			local pos,onScreen = WorldToViewPoint(part.Position)

			if onScreen then
				tracer.From = Vector2.new(
					Camera.ViewportSize.X/2,
					Camera.ViewportSize.Y/2
				)

				tracer.To = Vector2.new(pos.X,pos.Y)
				tracer.Visible = true
			else
				tracer.Visible = false
			end
		else
			tracer.Visible = false
		end
	else
		tracer.Visible = false
	end
end)

local function GetVelocity(target,pos)
	local t = tick()

	TargetHistory[target] = TargetHistory[target] or {}

	local hist = TargetHistory[target]

	if #hist >= 3 then
		table.remove(hist,1)
	end

	table.insert(hist,{
		pos = pos,
		time = t
	})

	if #hist < 2 then
		return Vector3.zero
	end

	local p1 = hist[#hist - 1]
	local p2 = hist[#hist]

	local dt = math.max(p2.time - p1.time,0.000001)

	return (p2.pos - p1.pos) / dt
end

local OldSend

OldSend = hookfunction(Network.send,function(...)
	local args = {...}

	if args[1] == "shoot_gun" then
		local target = GetClosestTarget()

		if target then
			local part = target:FindFirstChild(
				AimPart == "Body" and "HumanoidRootPart" or "Head"
			)

			if part then
				local char = LocalPlayer.Character
				if not char then
					return OldSend(...)
				end

				local root = char:FindFirstChild("HumanoidRootPart")

				if not root then
					return OldSend(...)
				end

				local myPos = root.Position
				local targetPos = part.Position

				local vel = GetVelocity(target,targetPos)
				local speed = vel.Magnitude

				local predictedPos = targetPos

				if speed <= 250 then
					if speed >= 2 then
						local moveDir = vel.Unit
						predictedPos = targetPos + (moveDir * (speed * 0.15))
					end
				end

				local ignore = {
					LocalPlayer.Character,
					target
				}

				local behind = IsBehindWall(
					myPos,
					predictedPos,
					ignore
				)

				if behind then
					args[3] = CFrame.new(
						math.huge,
						math.huge,
						math.huge
					)
				else
					args[3] = CFrame.new(
						myPos,
						predictedPos
					)
				end

				for _,v in pairs(args[4] or {}) do
					for _,x in pairs(v) do
						x.Position = predictedPos
						x.Instance = part
					end
				end

				CreateCurvedTracer(
					myPos,
					predictedPos
				)
			end
		end
	end

	return OldSend(table.unpack(args))
end)

GunmodsTab:Section(
    {
        Title = "Gunmods"
    }
)

GunmodsTab:Button({
    Title = "ยืนยันการแต่งปืน(แต่งแล้วต้องกดตรงนี้)",
    Callback = function()
        local tool = Character:FindFirstChildWhichIsA("Tool")
        if not tool then return end

        for _,v in pairs(ReplicatedStorage.Items.gun:GetChildren()) do
            if tool.Name == v.Name then
                tool:SetAttribute("fire_rate", FireRateGun or tool:GetAttribute("fire_rate"))
                tool:SetAttribute("accuracy", AccuracyGun or tool:GetAttribute("accuracy"))
                tool:SetAttribute("Recoil", RecoilGun or tool:GetAttribute("Recoil"))
                tool:SetAttribute("Durability", DurabilityGun or tool:GetAttribute("Durability"))
                tool:SetAttribute("automatic", AutomaticGun or tool:GetAttribute("automatic"))
            end
        end
    end
})


GunmodsTab:Toggle({
    Title = "Auto Gun(แนะนำให้กดมันจะแต่งปืนให้เอง)",
    Default = false,
    Callback = function(v)
        AutomaticGun = v
    end
})


GunmodsTab:Slider({
    Title = "อัตราการยิง",
    Step = 1,
    Value = {
        Min = 100,
        Max = 3000,
        Default = 1000
    },
    Callback = function(v)
        FireRateGun = v
    end
})

GunmodsTab:Slider({
    Title = "แรงดีด",
    Step = 0.1,
    Value = {
        Min = 0,
        Max = 10,
        Default = 0
    },
    Callback = function(v)
        RecoilGun = v
    end
})

GunmodsTab:Slider({
    Title = "ความแม่นยำ",
    Step = 0.01,
    Value = {
        Min = 0,
        Max = 1,
        Default = 1
    },
    Callback = function(v)
        AccuracyGun = v
    end
})

GunmodsTab:Slider({
    Title = "ความทนทาน",
    Step = 1,
    Value = {
        Min = 100,
        Max = 3000,
        Default = 1000
    },
    Callback = function(v)
        DurabilityGun = v
    end
})


VisualTab:Section(
    {
        Title = "Visual"
    }
)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

ESP = ESP or {}
ESP.Name = false

local ESPs = {}

local function RemoveESP(plr)
	if ESPs[plr] then
		ESPs[plr]:Destroy()
		ESPs[plr] = nil
	end
end

local function CreateESP(plr)
	if plr == LocalPlayer then
		return
	end

	local function Setup(char)
		RemoveESP(plr)

		local head = char:FindFirstChild("Head")
		if not head then
			return
		end

		local gui = Instance.new("BillboardGui")
		gui.Name = "NameESP"
		gui.Adornee = head
		gui.Size = UDim2.new(0, 200, 0, 30)
		gui.StudsOffset = Vector3.new(0, 2, 0)
		gui.AlwaysOnTop = true
		gui.MaxDistance = 250
		gui.Enabled = ESP.Name

		local text = Instance.new("TextLabel")
		text.BackgroundTransparency = 1
		text.Size = UDim2.new(1,0,1,0)
		text.Font = Enum.Font.SourceSansBold
		text.TextSize = 12
		text.TextColor3 = Color3.new(1,1,1)
		text.TextStrokeTransparency = 0.5
		text.Text = plr.Name
		text.Parent = gui

		gui.Parent = head
		ESPs[plr] = gui
	end

	if plr.Character then
		Setup(plr.Character)
	end

	plr.CharacterAdded:Connect(Setup)
end

for _,plr in ipairs(Players:GetPlayers()) do
	CreateESP(plr)
end

Players.PlayerAdded:Connect(CreateESP)

Players.PlayerRemoving:Connect(function(plr)
	RemoveESP(plr)
end)

VisualTab:Toggle({
    Title = "มองชื่อ",
    Value = false,
    Callback = function(v)
        ESP.Name = v

        for _,esp in pairs(ESPs) do
            if esp then
                esp.Enabled = v
            end
        end
    end
})

ESP.Box = false

local BoxESPs = {}

local function RemoveBox(plr)
	if BoxESPs[plr] then
		BoxESPs[plr]:Destroy()
		BoxESPs[plr] = nil
	end
end

local function CreateBox(plr)
	if plr == LocalPlayer then
		return
	end

	local function Setup(char)
		RemoveBox(plr)

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")

		if not hrp or not hum then
			return
		end

		local gui = Instance.new("BillboardGui")
		gui.Name = "BoxESP"
		gui.Adornee = hrp
		gui.Size = UDim2.new(4,0,6,0)
		gui.StudsOffset = Vector3.new(0,0,0)
		gui.AlwaysOnTop = true
		gui.MaxDistance = 250
		gui.Enabled = ESP.Box

		local frame = Instance.new("Frame")
		frame.BackgroundTransparency = 1
		frame.Size = UDim2.new(1,0,1,0)
		frame.Parent = gui

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.new(1,1,1)
		stroke.Thickness = 1
		stroke.Parent = frame

		gui.Parent = hrp
		BoxESPs[plr] = gui
	end

	if plr.Character then
		Setup(plr.Character)
	end

	plr.CharacterAdded:Connect(Setup)
end

for _,plr in ipairs(Players:GetPlayers()) do
	CreateBox(plr)
end

Players.PlayerAdded:Connect(CreateBox)

Players.PlayerRemoving:Connect(function(plr)
	RemoveBox(plr)
end)

VisualTab:Toggle({
    Title = "มองคนเป็นกล่อง",
    Value = false,
    Callback = function(v)
        ESP.Box = v

        for _,esp in pairs(BoxESPs) do
            if esp then
                esp.Enabled = v
            end
        end
    end
})

ESP.Health = false

local HealthESPs = {}

local function RemoveHealth(plr)
	if HealthESPs[plr] then
		HealthESPs[plr]:Destroy()
		HealthESPs[plr] = nil
	end
end

local function CreateHealth(plr)
	if plr == LocalPlayer then
		return
	end

	local function Setup(char)
		RemoveHealth(plr)

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")

		if not hrp or not hum then
			return
		end

		local gui = Instance.new("BillboardGui")
		gui.Name = "HealthESP"
		gui.Adornee = hrp
		gui.Size = UDim2.new(0, 8, 0, 50)
		gui.StudsOffset = Vector3.new(-3, 0, 0)
		gui.AlwaysOnTop = true
		gui.MaxDistance = 250
		gui.Enabled = ESP.Health

		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(1,0,1,0)
		bg.BackgroundColor3 = Color3.new(0,0,0)
		bg.BorderSizePixel = 0
		bg.Parent = gui

		local bar = Instance.new("Frame")
		bar.AnchorPoint = Vector2.new(0,1)
		bar.Position = UDim2.new(0,0,1,0)
		bar.Size = UDim2.new(1,0,1,0)
		bar.BackgroundColor3 = Color3.fromRGB(0,255,0)
		bar.BorderSizePixel = 0
		bar.Parent = bg

		local function Update()
			local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)

			bar.Size = UDim2.new(1,0,hp,0)

			bar.BackgroundColor3 = Color3.fromRGB(
				255 * (1 - hp),
				255 * hp,
				0
			)
		end

		Update()

		hum.HealthChanged:Connect(Update)

		gui.Parent = hrp
		HealthESPs[plr] = gui
	end

	if plr.Character then
		Setup(plr.Character)
	end

	plr.CharacterAdded:Connect(Setup)
end

for _,plr in ipairs(Players:GetPlayers()) do
	CreateHealth(plr)
end

Players.PlayerAdded:Connect(CreateHealth)

Players.PlayerRemoving:Connect(function(plr)
	RemoveHealth(plr)
end)

VisualTab:Toggle({
    Title = "มองเลือด",
    Value = false,
    Callback = function(v)
        ESP.Health = v

        for _,esp in pairs(HealthESPs) do
            if esp then
                esp.Enabled = v
            end
        end
    end
})

ESP.Distance = false

local DistanceESPs = {}

local function RemoveDistance(plr)
	if DistanceESPs[plr] then
		DistanceESPs[plr]:Destroy()
		DistanceESPs[plr] = nil
	end
end

local function CreateDistance(plr)
	if plr == LocalPlayer then
		return
	end

	local function Setup(char)
		RemoveDistance(plr)

		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			return
		end

		local gui = Instance.new("BillboardGui")
		gui.Name = "DistanceESP"
		gui.Adornee = hrp
		gui.Size = UDim2.new(0,100,0,20)
		gui.StudsOffset = Vector3.new(0,-3,0)
		gui.AlwaysOnTop = true
		gui.MaxDistance = 250
		gui.Enabled = ESP.Distance

		local text = Instance.new("TextLabel")
		text.BackgroundTransparency = 1
		text.Size = UDim2.new(1,0,1,0)
		text.Font = Enum.Font.SourceSansBold
		text.TextSize = 12
		text.TextColor3 = Color3.new(1,1,1)
		text.TextStrokeTransparency = 0.5
		text.Parent = gui

		gui.Parent = hrp
		DistanceESPs[plr] = gui

		task.spawn(function()
			while gui.Parent and hrp.Parent do
				if ESP.Distance and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					local myhrp = LocalPlayer.Character.HumanoidRootPart
					local dist = math.floor((myhrp.Position - hrp.Position).Magnitude)
					text.Text = dist .. "m"
				end

				task.wait(0.15)
			end
		end)
	end

	if plr.Character then
		Setup(plr.Character)
	end

	plr.CharacterAdded:Connect(Setup)
end

for _,plr in ipairs(Players:GetPlayers()) do
	CreateDistance(plr)
end

Players.PlayerAdded:Connect(CreateDistance)

Players.PlayerRemoving:Connect(function(plr)
	RemoveDistance(plr)
end)

VisualTab:Toggle({
    Title = "ระยะ",
    Value = false,
    Callback = function(v)
        ESP.Distance = v

        for _,esp in pairs(DistanceESPs) do
            if esp then
                esp.Enabled = v
            end
        end
    end
})

ESP.Trace = false

local Camera = workspace.CurrentCamera
local Traces = {}

local function RemoveTrace(plr)
	if Traces[plr] then
		Traces[plr]:Remove()
		Traces[plr] = nil
	end
end

local function CreateTrace(plr)
	if plr == LocalPlayer then
		return
	end

	local line = Drawing.new("Line")
	line.Visible = false
	line.Thickness = 1
	line.Transparency = 1
	line.Color = Color3.new(1,1,1)

	Traces[plr] = line
end

for _,plr in ipairs(Players:GetPlayers()) do
	CreateTrace(plr)
end

Players.PlayerAdded:Connect(CreateTrace)

Players.PlayerRemoving:Connect(function(plr)
	RemoveTrace(plr)
end)

task.spawn(function()
	while task.wait(0.03) do
		if not ESP.Trace then
			for _,line in pairs(Traces) do
				line.Visible = false
			end
			continue
		end

		local centerX = Camera.ViewportSize.X / 2

		for plr,line in pairs(Traces) do
			local char = plr.Character

			if char then
				local head = char:FindFirstChild("Head")
				local hum = char:FindFirstChildOfClass("Humanoid")

				if head and hum and hum.Health > 0 then
					local pos, visible = Camera:WorldToViewportPoint(head.Position)

					if visible then
						line.From = Vector2.new(centerX,0)
						line.To = Vector2.new(pos.X,pos.Y)
						line.Visible = true
					else
						line.Visible = false
					end
				else
					line.Visible = false
				end
			else
				line.Visible = false
			end
		end
	end
end)

VisualTab:Toggle({
    Title = "เส้นโยง",
    Value = false,
    Callback = function(v)
        ESP.Trace = v
    end
})

VisualTab:Toggle({
	Title = 'มองของ',
	Default = false,
	Callback = function(Value)
		_G.InventoryViewerEnabled = Value
		local Players = game:GetService('Players')
		local ReplicatedStorage = game:GetService('ReplicatedStorage')
		local Client = Players.LocalPlayer
		local function GetColorFromRarity(rarityName)
			local colors = {
				['Common'] = Color3.fromRGB(255, 255, 255),
				['UnCommon'] = Color3.fromRGB(99, 255, 52),
				['Rare'] = Color3.fromRGB(51, 170, 255),
				['Legendary'] = Color3.fromRGB(255, 150, 0),
				['Epic'] = Color3.fromRGB(237, 44, 255),
				['Omega'] = Color3.fromRGB(255, 20, 51),
			}
			return colors[rarityName] or Color3.fromRGB(255, 255, 255)
		end
		if Value then
			if not _G.ViewerRunning then
				_G.ViewerRunning = true
				task.spawn(function()
					while task.wait(0.2) do
						if not _G.InventoryViewerEnabled then
							continue
						end
						pcall(function()
							for _, v in pairs(Players:GetPlayers()) do
								if v ~= Client and v.Character and v.Character:FindFirstChild('HumanoidRootPart') then
									local root = v.Character.HumanoidRootPart
									local gui = root:FindFirstChild('ItemBillboard')
									if not gui then
										gui = Instance.new('BillboardGui')
										gui.Name = 'ItemBillboard'
										gui.AlwaysOnTop = true
										gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
										gui.Size = UDim2.new(0, 200, 0, 50)
										gui.StudsOffset = Vector3.new(0, -5, 0)
										gui.ExtentsOffset = Vector3.new(0, 1, 0)
										gui.LightInfluence = 1
										gui.Parent = root
										local bg = Instance.new('Frame')
										bg.Name = 'BG'
										bg.BackgroundTransparency = 1
										bg.Size = UDim2.new(1, 0, 1, 0)
										bg.AnchorPoint = Vector2.new(0.5, 0.5)
										bg.Position = UDim2.new(0.5, 0, 0.5, 0)
										bg.Parent = gui
										local layout = Instance.new('UIListLayout')
										layout.FillDirection = Enum.FillDirection.Horizontal
										layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
										layout.VerticalAlignment = Enum.VerticalAlignment.Center
										layout.Padding = UDim.new(0, 5)
										layout.Parent = bg
									end
									local bg = gui:FindFirstChild('BG')
									if not bg then
										continue
									end
									local Items = {}

                                    
									for _, child in pairs(bg:GetChildren()) do
										if child:IsA('Frame') then
											child:Destroy()
										end
									end

                                    -- loop item ใน backpack + character
									for _, container in pairs({
										v:FindFirstChild('Backpack'),
										v.Character
									}) do
										if container then
											for _, tool in pairs(container:GetChildren()) do
												if tool:IsA('Tool') and not tool:GetAttribute('JobTool') and not tool:GetAttribute('Locked') then
													local itemFolder = tool:GetAttribute('AmmoType') and ReplicatedStorage.Items.gun or ReplicatedStorage.Items.melee
													for _, z in pairs(itemFolder:GetChildren()) do
														if tool:GetAttribute('RarityName') == z:GetAttribute('RarityName') and tool:GetAttribute('RarityPrice') == z:GetAttribute('RarityPrice') then
															local imageId = z:GetAttribute('ImageId')
															if imageId then
																Items[z.Name] = true
																if not bg:FindFirstChild(z.Name .. '_bg') then
																	local iconBg = Instance.new('Frame')
																	iconBg.Name = z.Name .. '_bg'
																	iconBg.Size = UDim2.new(0, 34, 0, 34)
																	iconBg.BackgroundColor3 = GetColorFromRarity(z:GetAttribute('RarityName'))
																	iconBg.BackgroundTransparency = 1
																	iconBg.BorderSizePixel = 0
																	iconBg.Parent = bg
																	local bgImage = Instance.new('ImageLabel')
																	bgImage.Name = 'Background'
																	bgImage.Size = UDim2.new(1, 0, 1, 0)
																	bgImage.BackgroundTransparency = 1
																	bgImage.Image = 'rbxassetid://137066731814190'
																	bgImage.ImageColor3 = GetColorFromRarity(z:GetAttribute('RarityName'))
																	bgImage.ZIndex = 0
																	bgImage.Parent = iconBg
																	local corner = Instance.new('UICorner')
																	corner.CornerRadius = UDim.new(0.15, 0)
																	corner.Parent = iconBg
																	local icon = Instance.new('ImageLabel')
																	icon.Name = z.Name
																	icon.Image = imageId
																	icon.BackgroundTransparency = 1
																	icon.BorderSizePixel = 0
																	icon.Size = UDim2.new(0.85, 0, 0.85, 0)
																	icon.Position = UDim2.new(0.075, 0, 0.075, 0)
																	icon.Parent = iconBg
																	local corner2 = Instance.new('UICorner')
																	corner2.CornerRadius = UDim.new(0, 9)
																	corner2.Parent = icon
																end
															end
														end
													end
												end
											end
										end
									end
									gui.Enabled = _G.InventoryViewerEnabled
									for _, child in pairs(bg:GetChildren()) do
										if child:IsA('Frame') then
											local itemName = child.Name:gsub('_bg$', '')
											if not Items[itemName] then
												child:Destroy()
											end
										end
									end
								end
							end
						end)
					end
				end)
			end
		else
            
			for _, v in pairs(Players:GetPlayers()) do
				if v.Character and v.Character:FindFirstChild('HumanoidRootPart') then
					local gui = v.Character.HumanoidRootPart:FindFirstChild('ItemBillboard')
					if gui then
						gui:Destroy()
					end
				end
			end
		end
	end  
})  ​

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local DroppedFolder = workspace:WaitForChild("DroppedItems")

local ItemESPs = {}
local ShowItemESP = true

local BlueColor = Color3.fromRGB(0,150,255)
local GreenColor = Color3.fromRGB(0,255,0)

local function getItemColor(item)
    if item.Name:lower():find("money") then
        return GreenColor
    end

    return BlueColor
end

local function createItemESP(item)
    if ItemESPs[item] then
        return
    end

    local color = getItemColor(item)
    local highlights = {}
    local label

    local function addHighlight(part)
        local hl = Instance.new("Highlight")
        hl.Adornee = part
        hl.FillColor = color
        hl.OutlineColor = color
        hl.FillTransparency = 0.8
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = true
        hl.Parent = part

        table.insert(highlights, hl)
    end

    if item:IsA("BasePart") then
        addHighlight(item)

    elseif item:IsA("Model") then
        for _,v in ipairs(item:GetDescendants()) do
            if v:IsA("BasePart") then
                addHighlight(v)
            end
        end
    end

    local basePart =
        item:IsA("BasePart") and item
        or item.PrimaryPart
        or item:FindFirstChildWhichIsA("BasePart")

    if basePart then
        local bb = Instance.new("BillboardGui")
        bb.Adornee = basePart
        bb.Size = UDim2.new(0,55,0,9)
        bb.StudsOffset = Vector3.new(0, basePart.Size.Y / 2 + 0.6, 0)
        bb.AlwaysOnTop = true
        bb.Parent = basePart

        label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.Text = "[" .. item.Name .. "]"
        label.Font = Enum.Font.GothamBold
        label.TextScaled = false
        label.TextSize = 8
        label.TextColor3 = color
        label.TextStrokeTransparency = 0.5
        label.Visible = true
        label.Parent = bb
    end

    ItemESPs[item] = {
        highlights = highlights,
        label = label
    }
end

local function removeItemESP(item)
    local data = ItemESPs[item]

    if not data then
        return
    end

    for _,hl in ipairs(data.highlights) do
        if hl then
            hl:Destroy()
        end
    end

    if data.label and data.label.Parent then
        data.label.Parent:Destroy()
    end

    ItemESPs[item] = nil
end

for _,item in ipairs(DroppedFolder:GetChildren()) do
    createItemESP(item)
end

DroppedFolder.ChildAdded:Connect(createItemESP)
DroppedFolder.ChildRemoved:Connect(removeItemESP)

carTab:Section(
    {
        Title = "Vehicle"
    }
)

carTab:Button({
        Title = "ดึงรถของตัวเองมาหา",
        Desc = "",
        Callback = function()
            local Players = game:GetService("Players")
local Client = Players.LocalPlayer

local Character = Client.Character or Client.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

local Vehicles = workspace:WaitForChild("Vehicles")

for _, vehicle in pairs(Vehicles:GetChildren()) do
    if vehicle:IsA("Model") then
        local ownerId = vehicle:GetAttribute("OwnerUserId")
        
        if ownerId and ownerId == Client.UserId then
            local offset = CFrame.new(math.random(-5,5), 3, math.random(-15,-5))
            
            if vehicle.PrimaryPart then
                vehicle:SetPrimaryPartCFrame(RootPart.CFrame * offset)
            else
                local part = vehicle:FindFirstChildWhichIsA("BasePart")
                if part then
                    part.CFrame = RootPart.CFrame * offset
                end
            end
        end
    end
end
            Window:Notify({
                Title = "Button",
                Desc = "Action performed successfully.",
                Time = 3
            })
        end
    })

MiscTab:Section(
    {
        Title = "Misc"
    }
)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local SPEED = 250
local SPEED_MIN = 10
local SPEED_MAX = 500
local DEBOUNCE = 0.35
local SMOOTH = 0

local UI_WIDTH = 132
local UI_HEIGHT = 44
local SPEEDBOX_W = 56
local SPEEDBOX_H = 14

local freecam = false
local dummy = nil
local char, humanoid, hrp = nil, nil, nil
local saved = {}
local pendingStamp = 0
local allowMovement = false
local initialDummyCFrame = nil
local initialCameraCFrame = nil
local savedCameraFOV = nil
local initialDistance = nil
local savedPartAnchors = {}
local savedPlatformStand = nil
local yaw = 0
local pitch = 0
local ROT_SENS = 0.0025
local lastInputPos = Vector2.new(0,0)
local ignoreNextInput = false

local function safeSet(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then warn("Spectator: safeSet error:", err) end
end

local function createGui()
    if playerGui:FindFirstChild("SpectatorCleanGUI") then
        local g = playerGui.SpectatorCleanGUI
        return {Gui = g, Frame = g.Container, Toggle = g.Container.Toggle, SpeedBox = g.Container.SpeedBox, Info = g.Container.Info}
    end
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SpectatorCleanGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    local frame = Instance.new("Frame")
    frame.Name = "Container"
    frame.Size = UDim2.new(0, UI_WIDTH, 0, UI_HEIGHT)
    frame.Position = UDim2.new(0, 8, 0, 8)
    frame.BackgroundColor3 = Color3.fromRGB(18,20,24)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(45,50,60); stroke.Transparency = 0.7; stroke.Thickness = 1
    local title = Instance.new("TextLabel", frame)
    title.Name = "Title"
    title.Size = UDim2.new(0.64, 0, 0, 22)
    title.Position = UDim2.new(0, 8, 0, 6)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextColor3 = Color3.fromRGB(235,235,235)
    title.Text = "Free camera"
    title.TextXAlignment = Enum.TextXAlignment.Left
    local toggle = Instance.new("TextButton", frame)
    toggle.Name = "Toggle"
    toggle.Size = UDim2.new(0.32, -8, 0, 22)
    toggle.Position = UDim2.new(0.62, 0, 0, 6)
    toggle.BackgroundColor3 = Color3.fromRGB(36,40,48)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 12
    toggle.Text = "OFF"
    toggle.TextColor3 = Color3.fromRGB(220,220,220)
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,6)
    Instance.new("UIStroke", toggle).Color = Color3.fromRGB(60,70,80)
    local speedBox = Instance.new("TextBox", frame)
    speedBox.Name = "SpeedBox"
    speedBox.Size = UDim2.new(0, SPEEDBOX_W, 0, SPEEDBOX_H)
    speedBox.Position = UDim2.new(0, 8, 1, -18)
    speedBox.BackgroundColor3 = Color3.fromRGB(34,38,46)
    speedBox.PlaceholderText = tostring(SPEED)
    speedBox.Text = ""
    speedBox.Font = Enum.Font.Gotham
    speedBox.TextSize = 12
    speedBox.TextColor3 = Color3.fromRGB(235,235,235)
    Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0,5)
    local sbstroke = Instance.new("UIStroke", speedBox)
    sbstroke.Color = Color3.fromRGB(55,65,75); sbstroke.Transparency = 0.8
    local info = Instance.new("TextLabel", frame)
    info.Name = "Info"
    info.Size = UDim2.new(1, -10, 0, 10)
    info.Position = UDim2.new(0, 5, 1, -10)
    info.BackgroundTransparency = 1
    info.Font = Enum.Font.Gotham
    info.TextSize = 10
    info.TextColor3 = Color3.fromRGB(210,195,110)
    info.Text = ""
    return {Gui = screenGui, Frame = frame, Toggle = toggle, SpeedBox = speedBox, Info = info}
end

local gui = createGui()
local toggleBtn = gui.Toggle
local speedBox = gui.SpeedBox
local infoLabel = gui.Info

local function makeDummy()
    local name = "SpecDummy_" .. player.UserId
    local ex = workspace:FindFirstChild(name)
    if ex then
        safeSet(function()
            if ex:IsA("BasePart") then
                ex.Anchored = true
                ex.CanCollide = false
                ex.Transparency = 1
            end
        end)
        return ex
    end
    local p = Instance.new("Part")
    p.Name = name
    p.Size = Vector3.new(1,1,1)
    p.Anchored = true
    p.CanCollide = false
    p.Transparency = 1
    p.Parent = workspace
    return p
end

local function saveHumanoidValues(h)
    if not h then return end
    saved.WalkSpeed = h.WalkSpeed
    saved.JumpPower = h.JumpPower
    saved.AutoRotate = h.AutoRotate
end

local function restoreHumanoidValues(h)
    if not h then return end
    safeSet(function() if saved.WalkSpeed then h.WalkSpeed = saved.WalkSpeed end end)
    safeSet(function() if saved.JumpPower then h.JumpPower = saved.JumpPower end end)
    safeSet(function() if saved.AutoRotate ~= nil then h.AutoRotate = saved.AutoRotate end end)
end

local function setInfo(text)
    if infoLabel and infoLabel.Parent then
        infoLabel.Text = tostring(text or "")
        delay(1.2, function()
            if infoLabel and infoLabel.Parent then infoLabel.Text = "" end
        end)
    end
end

local function tryApplySpeed(txt)
    if not txt or txt == "" then return end
    local n = tonumber(txt)
    if not n then setInfo("Invalid number"); return end
    n = math.clamp(n, SPEED_MIN, SPEED_MAX)
    SPEED = n
    speedBox.PlaceholderText = tostring(SPEED)
    speedBox.Text = ""
    setInfo("Speed set: " .. tostring(SPEED))
end

local function anchorAllCharacterParts(character)
    savedPartAnchors = {}
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            savedPartAnchors[part] = part.Anchored
            safeSet(function()
                if part.AssemblyLinearVelocity then part.AssemblyLinearVelocity = Vector3.new(0,0,0) end
                if part.AssemblyAngularVelocity then part.AssemblyAngularVelocity = Vector3.new(0,0,0) end
                part.Anchored = true
            end)
        end
    end
end

local function restoreAllCharacterParts()
    for part, prev in pairs(savedPartAnchors) do
        safeSet(function()
            if part and part.Parent then
                part.Anchored = (prev == true)
            end
        end)
    end
    savedPartAnchors = {}
end

UserInputService.InputChanged:Connect(function(input, processed)
    if not freecam then return end
    if allowMovement then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local pos
        if input.Position and typeof(input.Position) == "Vector2" then
            pos = input.Position
        else
            pos = UserInputService:GetMouseLocation()
        end
        if ignoreNextInput then
            lastInputPos = pos
            ignoreNextInput = false
            return
        end
        local d = pos - lastInputPos
        lastInputPos = pos
        yaw = yaw - d.X * ROT_SENS
        pitch = math.clamp(pitch - d.Y * ROT_SENS, -math.rad(89), math.rad(89))
    end
end)

local function startSpectator()
    char = player.Character or player.CharacterAdded:Wait()
    humanoid = char:FindFirstChildOfClass("Humanoid")
    hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then warn("Spectator: no humanoid/hrp"); return end
    dummy = makeDummy()
    local camCFrame = camera.CFrame
    dummy.CFrame = camCFrame
    initialDummyCFrame = dummy.CFrame
    initialCameraCFrame = camCFrame
    local rel = (camera.CFrame.Position - dummy.Position)
    local r = rel.Magnitude
    initialDistance = math.max(r, 1)
    local look = rel.Unit
    yaw = math.atan2(look.X, look.Z)
    pitch = math.asin(math.clamp(look.Y, -1, 1))
    saveHumanoidValues(humanoid)
    anchorAllCharacterParts(char)
    savedPlatformStand = humanoid.PlatformStand
    safeSet(function() humanoid.PlatformStand = true end)
    safeSet(function() humanoid.WalkSpeed = 0 end)
    safeSet(function() humanoid.JumpPower = 0 end)
    safeSet(function() humanoid.AutoRotate = false end)
    savedCameraFOV = camera.FieldOfView or 70
    camera.CameraType = Enum.CameraType.Scriptable
    camera.FieldOfView = savedCameraFOV
    lastInputPos = UserInputService:GetMouseLocation()
    ignoreNextInput = true
    freecam = true
    toggleBtn.Text = "ON"
    toggleBtn.TextColor3 = Color3.fromRGB(120,235,120)
    allowMovement = false
    setInfo("Locked. Move to unlock.")
end

local function stopSpectator()
    freecam = false
    local targetHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if targetHum then
        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = targetHum
    else
        camera.CameraType = Enum.CameraType.Custom
    end
    if savedCameraFOV then
        safeSet(function() camera.FieldOfView = savedCameraFOV end)
        savedCameraFOV = nil
    end
    initialDistance = nil
    initialDummyCFrame = nil
    initialCameraCFrame = nil
    lastInputPos = Vector2.new(0,0)
    ignoreNextInput = false
    safeSet(function()
        if humanoid and humanoid.Parent then
            if savedPlatformStand ~= nil then
                humanoid.PlatformStand = savedPlatformStand
            else
                humanoid.PlatformStand = false
            end
        end
    end)
    savedPlatformStand = nil
    restoreAllCharacterParts()
    if dummy and dummy.Parent then
        safeSet(function() dummy:Destroy() end)
        dummy = nil
    end
    if humanoid then restoreHumanoidValues(humanoid) end
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(220,220,220)
    setInfo("Disabled")
end

RunService.RenderStepped:Connect(function(dt)
    if not freecam then return end
    if not dummy then return end
    if not allowMovement and initialDummyCFrame and initialCameraCFrame and initialDistance then
        safeSet(function() dummy.CFrame = initialDummyCFrame end)
        for part, _ in pairs(savedPartAnchors) do
            safeSet(function()
                if part and part.Parent then
                    if part.AssemblyLinearVelocity then part.AssemblyLinearVelocity = Vector3.new(0,0,0) end
                    if part.AssemblyAngularVelocity then part.AssemblyAngularVelocity = Vector3.new(0,0,0) end
                    part.Anchored = true
                end
            end)
        end
        local lx = math.sin(yaw) * math.cos(pitch)
        local ly = math.sin(pitch)
        local lz = math.cos(yaw) * math.cos(pitch)
        local lookFromDummy = Vector3.new(lx, ly, lz)
        local camPos = dummy.Position + lookFromDummy * initialDistance
        safeSet(function() camera.CFrame = CFrame.new(camPos, dummy.Position) end)
        if savedCameraFOV and camera.FieldOfView > savedCameraFOV then
            camera.FieldOfView = savedCameraFOV
        end
        local md = (humanoid and humanoid.MoveDirection) or Vector3.new()
        local mdMag = md.Magnitude
        local kbVec = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then kbVec = kbVec + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then kbVec = kbVec - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then kbVec = kbVec - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then kbVec = kbVec + camera.CFrame.RightVector end
        local kbMag = kbVec.Magnitude
        local JOYSTICK_THRESHOLD = 0.14
        if mdMag > JOYSTICK_THRESHOLD or kbMag > 0.01 then
            allowMovement = true
            camera.CameraType = Enum.CameraType.Custom
            camera.CameraSubject = dummy
            setInfo("Unlocked")
        end
        return
    end
    if camera.CameraSubject ~= dummy then safeSet(function() camera.CameraSubject = dummy end) end
    if savedCameraFOV and camera.FieldOfView > savedCameraFOV then camera.FieldOfView = savedCameraFOV end
    local md = (humanoid and humanoid.MoveDirection) or Vector3.new()
    local mdMag = md.Magnitude
    local kbVec = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then kbVec = kbVec + camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then kbVec = kbVec - camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then kbVec = kbVec - camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then kbVec = kbVec + camera.CFrame.RightVector end
    local kbMag = kbVec.Magnitude
    local moveVec
    if mdMag > 0.001 and humanoid then
        local camForward = camera.CFrame.LookVector
        local forwardFlat = Vector3.new(camForward.X, 0, camForward.Z)
        if forwardFlat.Magnitude < 1e-6 then forwardFlat = Vector3.new(0,0,-1) end
        forwardFlat = forwardFlat.Unit
        local camRight = camera.CFrame.RightVector
        local xAxis = md:Dot(camRight)
        local zAxis = md:Dot(forwardFlat)
        moveVec = (camRight * xAxis) + (camera.CFrame.LookVector * zAxis)
    else
        moveVec = kbVec
    end
    if moveVec.Magnitude < 1e-6 then return end
    local appliedSpeed = math.clamp(SPEED, SPEED_MIN, SPEED_MAX)
    local displacement = moveVec.Unit * appliedSpeed * dt * math.clamp(mdMag, 0, 1)
    local newC = dummy.CFrame + displacement
    if SMOOTH and SMOOTH > 0 then
        dummy.CFrame = dummy.CFrame:Lerp(newC, math.clamp(SMOOTH*60*dt, 0, 1))
    else
        dummy.CFrame = newC
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    if freecam then stopSpectator() else startSpectator() end
end)

speedBox:GetPropertyChangedSignal("Text"):Connect(function()
    pendingStamp = tick()
    local stamp = pendingStamp
    delay(DEBOUNCE, function()
        if pendingStamp == stamp then tryApplySpeed(speedBox.Text) end
    end)
end)
speedBox.FocusLost:Connect(function()
    tryApplySpeed(speedBox.Text)
end)

player.CharacterAdded:Connect(function(c)
    if savedPlatformStand ~= nil and humanoid and humanoid.Parent then
        safeSet(function() humanoid.PlatformStand = savedPlatformStand end)
        savedPlatformStand = nil
    end
    if next(savedPartAnchors) then restoreAllCharacterParts() end
    char = c
    humanoid = c:FindFirstChildOfClass("Humanoid")
    hrp = c:FindFirstChild("HumanoidRootPart")
    if freecam then stopSpectator() end
end)

speedBox.PlaceholderText = tostring(SPEED)

MiscTab:Button({
    Title = "FPS Boost",
    Callback = function()

        local Lighting = game:GetService("Lighting")
        local Terrain = workspace:FindFirstChildOfClass("Terrain")

        -- Lighting
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        Lighting.ClockTime = 14
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.ShadowSoftness = 0

        -- ลบ Effects
        for _,v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect")
            or v:IsA("BloomEffect")
            or v:IsA("BlurEffect")
            or v:IsA("SunRaysEffect")
            or v:IsA("ColorCorrectionEffect")
            or v:IsA("DepthOfFieldEffect") then
                v:Destroy()
            end
        end

        -- Terrain
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
        end

        -- เปลี่ยนทุกอย่างเป็น Low Poly
        for _,v in pairs(workspace:GetDescendants()) do

            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
                v.Color = Color3.fromRGB(90,90,90)

                if not v:IsDescendantOf(game.Players.LocalPlayer.Character) then
                    v.TextureID = ""
                end
            end

            if v:IsA("Decal")
            or v:IsA("Texture") then
                v:Destroy()
            end

            if v:IsA("ParticleEmitter")
            or v:IsA("Trail")
            or v:IsA("Smoke")
            or v:IsA("Fire")
            or v:IsA("Sparkles")
            or v:IsA("Explosion") then
                v:Destroy()
            end

            if v:IsA("MeshPart") then
                v.TextureID = ""
                v.Material = Enum.Material.SmoothPlastic
                v.Color = Color3.fromRGB(90,90,90)
            end
        end

        -- FPS Cap
        if setfpscap then
            setfpscap(999)
        end

        print("FPS BOOST ENABLED")
    end
})

local CrateController = require(game:GetService("ReplicatedStorage").Modules.Game.CrateSystem.Crate)

local EnabledSkip = false

MiscTab:Toggle({
    Title = "ข้ามสุ่มของ",
    Default = EnabledSkip,
    Callback = function(v)
        EnabledSkip = v

        if v then
            task.spawn(function()
                while EnabledSkip do
                    task.wait()

                    for _, crate in pairs(CrateController.class.objects) do
                        pcall(function()
                            crate.states.open.set(true)
                            CrateController.skipping.set(true)
                        end)
                    end

                    if not CrateController.spinning.get() then
                        pcall(function()
                            CrateController.skip_spin()
                        end)
                    end
                end
            end)
        end
    end
})

local function GetJobID()
    return game.JobId or "Unknown"
end

local ServerCodeLabel =
    ServerTab:Code(
    {
        Title = "Current Server",
        Code = " " .. GetJobID()
    }
)

ServerTab:Divider()

ServerTab:Section(
    {
        Title = "Server Utilities:"
    }
)


local ServerCode = ""

ServerTab:Input(
    {
        Title = "Enter Server Code",
        Placeholder = "Paste server JobId here...",
        Callback = function(Value)
            ServerCode = Value
        end
    }
)


ServerTab:Button(
    {
        Title = "Join Code",
        Icon = "log-in",
        Callback = function()
            if ServerCode == "" then
                warn("ใส่codeดิน้อง")
                return
            end
            local TeleportService = game:GetService("TeleportService")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, ServerCode, game.Players.LocalPlayer)
        end
    }
)

ServerTab:Button(
    {
        Title = "Rejoin",
        Icon = "refresh-ccw",
        Callback = function()
            local TeleportService = game:GetService("TeleportService")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
        end
    }
)

ServerTab:Button(
    {
        Title = "Hop Server (Low Player)​",
        Icon = "shuffle",
        Callback = function()
            local HttpService = game:GetService("HttpService")
            local TeleportService = game:GetService("TeleportService")
            local servers = {}
            local req =
                game:HttpGet(
                string.format(
                    "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
                    game.PlaceId
                )
            )
            local data = HttpService:JSONDecode(req)
            if data and data.data then
                for _, v in pairs(data.data) do
                    if v.playing < v.maxPlayers then
                        table.insert(servers, v.id)
                    end
                end
            end
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(
                    game.PlaceId,
                    servers[math.random(1, #servers)],
                    game.Players.LocalPlayer
                )
            end
        end
    }
)
