--[[
    AX HUB - Local Client Controller & Advanced UI System
    Creator: S2lhz | Assistant: j4ra77
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local function resolveGuiParent()
	local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
	if pg then
		return pg
	end
	local ok, cg = pcall(function()
		return game:GetService("CoreGui")
	end)
	return (ok and cg) or workspace
end

local ThemePresets = {
	["أبيض وأسود"] = {
		Primary = Color3.fromRGB(235, 235, 240),
		Bright = Color3.fromRGB(255, 255, 255),
		Idle = Color3.fromRGB(28, 28, 34),
		Hover = Color3.fromRGB(48, 48, 56),
		Active = Color3.fromRGB(225, 225, 232),
		ActiveText = Color3.fromRGB(14, 14, 17),
		ActiveSub = Color3.fromRGB(36, 36, 44),
	},
	["أحمر"] = {
		Primary = Color3.fromRGB(220, 32, 48),
		Bright = Color3.fromRGB(255, 86, 102),
		Idle = Color3.fromRGB(52, 18, 22),
		Hover = Color3.fromRGB(85, 26, 34),
		Active = Color3.fromRGB(205, 28, 44),
		ActiveText = Color3.fromRGB(255, 255, 255),
		ActiveSub = Color3.fromRGB(255, 230, 235),
	},
	["أزرق"] = {
		Primary = Color3.fromRGB(32, 122, 245),
		Bright = Color3.fromRGB(92, 172, 255),
		Idle = Color3.fromRGB(18, 34, 64),
		Hover = Color3.fromRGB(28, 54, 98),
		Active = Color3.fromRGB(32, 122, 245),
		ActiveText = Color3.fromRGB(255, 255, 255),
		ActiveSub = Color3.fromRGB(230, 242, 255),
	},
	["أصفر"] = {
		Primary = Color3.fromRGB(225, 172, 24),
		Bright = Color3.fromRGB(255, 214, 58),
		Idle = Color3.fromRGB(60, 48, 14),
		Hover = Color3.fromRGB(92, 74, 20),
		Active = Color3.fromRGB(225, 172, 24),
		ActiveText = Color3.fromRGB(16, 16, 18),
		ActiveSub = Color3.fromRGB(38, 32, 12),
	},
	["أخضر"] = {
		Primary = Color3.fromRGB(34, 192, 96),
		Bright = Color3.fromRGB(84, 236, 138),
		Idle = Color3.fromRGB(16, 52, 30),
		Hover = Color3.fromRGB(24, 78, 46),
		Active = Color3.fromRGB(34, 192, 96),
		ActiveText = Color3.fromRGB(255, 255, 255),
		ActiveSub = Color3.fromRGB(228, 255, 238),
	},
	["بنفسجي"] = {
		Primary = Color3.fromRGB(152, 56, 245),
		Bright = Color3.fromRGB(196, 116, 255),
		Idle = Color3.fromRGB(40, 18, 66),
		Hover = Color3.fromRGB(62, 28, 100),
		Active = Color3.fromRGB(152, 56, 245),
		ActiveText = Color3.fromRGB(255, 255, 255),
		ActiveSub = Color3.fromRGB(242, 228, 255),
	},
	["سماوي"] = {
		Primary = Color3.fromRGB(20, 184, 214),
		Bright = Color3.fromRGB(76, 230, 255),
		Idle = Color3.fromRGB(16, 48, 58),
		Hover = Color3.fromRGB(22, 72, 86),
		Active = Color3.fromRGB(20, 184, 214),
		ActiveText = Color3.fromRGB(255, 255, 255),
		ActiveSub = Color3.fromRGB(228, 250, 255),
	},
}

local ColorNames = { "أبيض وأسود", "أحمر", "أزرق", "أصفر", "أخضر", "بنفسجي", "سماوي" }

local CancelPalette = {
	Idle = Color3.fromRGB(82, 26, 34),
	Hover = Color3.fromRGB(116, 36, 46),
	Active = Color3.fromRGB(215, 60, 80),
	Border = Color3.fromRGB(255, 130, 148),
	Text = Color3.fromRGB(255, 255, 255),
	SubText = Color3.fromRGB(255, 214, 220),
}

local Config = {
	HubName = "AX HUB",
	Version = "الإصدار 4.3",
	WelcomeMessage = "مرحباً بك في AX HUB — تم صنع هذا السكربت من أجل وناستك",
	DedicatedLine = "تم صنع هذا السكربت من أجل وناستك",
	Creator = "S2lhz",
	Assistant = "j4ra77",
	VenomImage = "rbxassetid://13999116405",
	ToggleKey = Enum.KeyCode.RightShift,
}

local State = {
	ThemeName = "أبيض وأسود",
	WalkSpeed = 16,
	JumpPower = 50,
	JumpHeight = 7.2,
	FlyEnabled = false,
	FlySpeed = 90,
	EspEnabled = false,
	HandToolEnabled = true,
	TargetName = "",
	FollowTarget = false,
	SpectateTarget = false,
	SitOnHead = false,
	FrontBack = false,
	FrontBackSpeed = 220,
	FrontBackDist = 2.6,
	AnimSpeed = 1.0,
	CurrentTrack = nil,
	ActiveTab = "Home",
	Visible = true,
	SavedSnapshot = nil,
}

local Theme = {
	BgMain = Color3.fromRGB(12, 12, 15),
	BgCard = Color3.fromRGB(21, 21, 26),
	Primary = ThemePresets["أبيض وأسود"].Primary,
	Bright = ThemePresets["أبيض وأسود"].Bright,
	Idle = ThemePresets["أبيض وأسود"].Idle,
	Hover = ThemePresets["أبيض وأسود"].Hover,
	Active = ThemePresets["أبيض وأسود"].Active,
	ActiveText = ThemePresets["أبيض وأسود"].ActiveText,
	ActiveSub = ThemePresets["أبيض وأسود"].ActiveSub,
	Text = Color3.fromRGB(255, 255, 255),
	SubText = Color3.fromRGB(222, 222, 232),
	Muted = Color3.fromRGB(165, 165, 178),
}

local Core = {
	ScreenGui = nil,
	MainWindow = nil,
	FloatingBtn = nil,
	Banner = nil,
	BannerTitle = nil,
	BannerBody = nil,
	Content = nil,
	Pages = {},
	TabBtns = {},
	Refreshers = {},
	ControlSyncs = {},
	EspTags = {},
	HandTool = nil,
	FlyAtt = nil,
	FlyLV = nil,
	FlyAO = nil,
	FlyPhase = 0,
	TargetUI = {
		Avatar = nil,
		UserId = nil,
		Display = nil,
		Joined = nil,
		Box = nil,
	},
}

local Animations = {
	{ Name = "رقصة الإيقاع", Desc = "تشغيل رقصة إيقاعية متواصلة للشخصية", Id = "rbxassetid://507771019" },
	{ Name = "رقصة الموجة", Desc = "تشغيل حركة الموجة الانسيابية", Id = "rbxassetid://507776043" },
	{ Name = "رقصة القمر", Desc = "تشغيل حركة القمر الكلاسيكية", Id = "rbxassetid://507772104" },
	{ Name = "هتاف الاحتفال", Desc = "إظهار حركة احتفال وحماس", Id = "rbxassetid://507770677" },
	{ Name = "تحية التلويح", Desc = "التلويح باليد للترحيب باللاعبين", Id = "rbxassetid://507770239" },
	{ Name = "إشارة التصويب", Desc = "اتخاذ وضعية إشارة وتصويب", Id = "rbxassetid://507770453" },
	{ Name = "حركة الضحك", Desc = "تشغيل حركة ضحك تفاعلية", Id = "rbxassetid://507770818" },
	{ Name = "تمايل الملعب", Desc = "تشغيل حركة تمايل إيقاعية", Id = "rbxassetid://507773531" },
}

local function addCorner(parent, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 6)
	c.Parent = parent
	return c
end

local function addStroke(parent, col, thick, trans)
	local s = Instance.new("UIStroke")
	s.Color = col or Theme.Primary
	s.Thickness = thick or 1.6
	s.Transparency = trans or 0.05
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	return s
end

local function tween(inst, info, props)
	if not inst or not inst.Parent then
		return nil
	end
	local ok, tw = pcall(function()
		local t = TweenService:Create(inst, info, props)
		t:Play()
		return t
	end)
	return ok and tw or nil
end

local function showMessage(titleText, bodyText)
	if not Core.Banner or not Core.Banner.Parent then
		return
	end
	Core.BannerTitle.Text = tostring(titleText or Config.HubName)
	Core.BannerBody.Text = tostring(bodyText or "")
	Core.Banner.Visible = true
	Core.Banner.Position = UDim2.new(0.5, -190, 0, -76)
	tween(Core.Banner, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -190, 0, 14)
	})
	task.delay(3.2, function()
		if Core.Banner and Core.Banner.Parent and Core.Banner.Visible then
			local outT = tween(Core.Banner, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
				Position = UDim2.new(0.5, -190, 0, -76)
			})
			if outT then
				outT.Completed:Wait()
			end
			if Core.Banner and Core.Banner.Parent then
				Core.Banner.Visible = false
			end
		end
	end)
end

local function syncControls()
	for _, fn in ipairs(Core.ControlSyncs) do
		pcall(fn)
	end
end

local function getChar(plr)
	local p = plr or LocalPlayer
	return p and p.Character
end

local function getHum(plr)
	local c = getChar(plr)
	return c and c:FindFirstChildOfClass("Humanoid")
end

local function getRoot(plr)
	local c = getChar(plr)
	return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso"))
end

local function computeJumpHeightFromPower(power)
	local g = (workspace.Gravity > 0) and workspace.Gravity or 196.2
	return math.clamp((power * power) / (2 * g), 1, 500)
end

local function applyJumpToHumanoid(hum)
	if not hum then
		return
	end
	pcall(function()
		hum.UseJumpPower = true
	end)
	pcall(function()
		hum.JumpPower = State.JumpPower
	end)
	pcall(function()
		hum.JumpHeight = State.JumpHeight
	end)
end

local function findTargetPlayer(query)
	if typeof(query) ~= "string" then
		return nil
	end
	local trimmed = string.lower(string.match(query, "^%s*(.-)%s*$") or "")
	if trimmed == "" then
		return nil
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and (string.lower(p.Name) == trimmed or string.lower(p.DisplayName) == trimmed) then
			return p
		end
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and (string.find(string.lower(p.Name), trimmed, 1, true) or string.find(string.lower(p.DisplayName), trimmed, 1, true)) then
			return p
		end
	end
	return nil
end

local function getPlayerFromHit(hit)
	if not hit or typeof(hit) ~= "Instance" then
		return nil
	end
	local cur = hit
	while cur and cur ~= workspace do
		if cur:IsA("Model") then
			local plr = Players:GetPlayerFromCharacter(cur)
			if plr and plr ~= LocalPlayer then
				return plr
			end
		end
		cur = cur.Parent
	end
	return nil
end

local function refreshTargetCard()
	local plr = findTargetPlayer(State.TargetName)
	if Core.TargetUI.Box then
		Core.TargetUI.Box.Text = State.TargetName
	end
	if not Core.TargetUI.UserId then
		return
	end
	if plr then
		Core.TargetUI.UserId.Text = "رقم الحساب: " .. tostring(plr.UserId)
		Core.TargetUI.Display.Text = "الاسم الظاهر: " .. tostring(plr.DisplayName)
		local joined = os.date("!%Y-%m-%d", os.time() - (plr.AccountAge * 86400))
		Core.TargetUI.Joined.Text = "تاريخ الانضمام: " .. tostring(joined)
		task.spawn(function()
			local ok, img = pcall(function()
				return Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
			end)
			if ok and img and Core.TargetUI.Avatar then
				Core.TargetUI.Avatar.Image = img
			end
		end)
	else
		Core.TargetUI.UserId.Text = "رقم الحساب: ---"
		Core.TargetUI.Display.Text = "الاسم الظاهر: ---"
		Core.TargetUI.Joined.Text = "تاريخ الانضمام: ---"
		if Core.TargetUI.Avatar then
			Core.TargetUI.Avatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
		end
	end
end

local function confirmTargetSelection(queryText, sourceLabel)
	State.TargetName = tostring(queryText or "")
	local found = findTargetPlayer(State.TargetName)
	if found then
		State.TargetName = found.Name
		refreshTargetCard()
		syncControls()
		showMessage(
			"تم تحديد اللاعب (" .. (sourceLabel or "تحديد") .. ")",
			"الاسم: " .. found.Name .. " | الاسم الظاهر: " .. found.DisplayName
		)
	else
		refreshTargetCard()
		syncControls()
		if string.match(State.TargetName, "^%s*(.-)%s*$") == "" then
			showMessage("تنبيه التحديد", "اكتب اسم اللاعب أولاً أو استخدم أداة اليد ✋")
		else
			showMessage("لم يتم العثور على اللاعب", "تأكد من كتابة اسم اللاعب الموجود في السيرفر: " .. State.TargetName)
		end
	end
end

local function selectTargetPlayer(plr)
	if not plr or plr == LocalPlayer then
		return
	end
	State.TargetName = plr.Name
	refreshTargetCard()
	syncControls()
	showMessage("تم تحديد اللاعب عبر أداة اليد", "الهدف: " .. plr.Name .. " (" .. plr.DisplayName .. ")")
end

local function pickTargetAtScreenPos(pos)
	local cam = workspace.CurrentCamera
	if not cam then
		return
	end
	local ray = cam:ViewportPointToRay(pos.X, pos.Y)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	local ignore = {}
	if LocalPlayer.Character then
		table.insert(ignore, LocalPlayer.Character)
	end
	params.FilterDescendantsInstances = ignore
	local res = workspace:Raycast(ray.Origin, ray.Direction * 1500, params)
	if res and res.Instance then
		local picked = getPlayerFromHit(res.Instance)
		if picked then
			selectTargetPlayer(picked)
		end
	end
end

local function removeHandTool()
	if Core.HandTool and Core.HandTool.Parent then
		pcall(function()
			Core.HandTool:Destroy()
		end)
	end
	Core.HandTool = nil
	local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
	if bp then
		local old = bp:FindFirstChild("أداة_اليد_للتحديد")
		if old then pcall(function() old:Destroy() end) end
	end
	local ch = LocalPlayer.Character
	if ch then
		local oldEq = ch:FindFirstChild("أداة_اليد_للتحديد")
		if oldEq then pcall(function() oldEq:Destroy() end) end
	end
end

local function ensureHandTool()
	if not State.HandToolEnabled then
		removeHandTool()
		return
	end
	local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
	if not bp then
		return
	end
	if Core.HandTool and Core.HandTool.Parent and (Core.HandTool.Parent == bp or Core.HandTool.Parent == LocalPlayer.Character) then
		return
	end
	removeHandTool()

	local tool = Instance.new("Tool")
	tool.Name = "أداة_اليد_للتحديد"
	tool.ToolTip = "اضغط على لاعب لتحديده"
	tool.RequiresHandle = true
	tool.CanBeDropped = false

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(0.45, 0.9, 0.45)
	handle.Color = Color3.fromRGB(235, 235, 240)
	handle.Material = Enum.Material.SmoothPlastic
	handle.Parent = tool

	local palm = Instance.new("Part")
	palm.Name = "HandPalm"
	palm.Size = Vector3.new(0.85, 0.85, 0.35)
	palm.Color = Color3.fromRGB(255, 255, 255)
	palm.Material = Enum.Material.SmoothPlastic
	palm.Parent = tool

	local w0 = Instance.new("WeldConstraint")
	w0.Part0 = handle
	w0.Part1 = palm
	w0.Parent = palm
	palm.CFrame = handle.CFrame * CFrame.new(0, 0.72, 0)

	local fingerOffsets = {
		{ -0.28, 1.32, 0.25 },
		{ -0.10, 1.36, 0.22 },
		{ 0.10, 1.36, 0.22 },
		{ 0.28, 1.32, 0.25 },
	}
	for i, off in ipairs(fingerOffsets) do
		local f = Instance.new("Part")
		f.Name = "Finger_" .. tostring(i)
		f.Size = Vector3.new(0.15, 0.48, 0.18)
		f.Color = Color3.fromRGB(255, 255, 255)
		f.Material = Enum.Material.SmoothPlastic
		f.Parent = tool

		local w = Instance.new("WeldConstraint")
		w.Part0 = palm
		w.Part1 = f
		w.Parent = f
		f.CFrame = handle.CFrame * CFrame.new(off[1], off[2], off[3])
	end

	tool.Activated:Connect(function()
		local loc = UserInputService:GetMouseLocation()
		pickTargetAtScreenPos(loc)
	end)

	tool.Parent = bp
	Core.HandTool = tool
end

local function destroyFlyRig()
	if Core.FlyLV then pcall(function() Core.FlyLV:Destroy() end) end
	if Core.FlyAO then pcall(function() Core.FlyAO:Destroy() end) end
	if Core.FlyAtt then pcall(function() Core.FlyAtt:Destroy() end) end
	Core.FlyLV, Core.FlyAO, Core.FlyAtt = nil, nil, nil
	local hum = getHum()
	if hum then hum.PlatformStand = false end
	local root = getRoot()
	if root then
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
	end
end

local function ensureFlyRig()
	local root = getRoot()
	local hum = getHum()
	if not root or not hum then return false end
	hum.PlatformStand = true
	if not Core.FlyAtt or not Core.FlyAtt.Parent then
		local att = Instance.new("Attachment")
		att.Parent = root
		Core.FlyAtt = att
	end
	if not Core.FlyLV or not Core.FlyLV.Parent then
		local lv = Instance.new("LinearVelocity")
		lv.Attachment0 = Core.FlyAtt
		lv.MaxForce = math.huge
		lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
		lv.VectorVelocity = Vector3.zero
		lv.Parent = root
		Core.FlyLV = lv
	end
	if not Core.FlyAO or not Core.FlyAO.Parent then
		local ao = Instance.new("AlignOrientation")
		ao.Attachment0 = Core.FlyAtt
		ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
		ao.MaxTorque = math.huge
		ao.Responsiveness = 28
		ao.CFrame = root.CFrame
		ao.Parent = root
		Core.FlyAO = ao
	end
	return true
end

local function updateFly()
	if not State.FlyEnabled or not ensureFlyRig() then return end
	local hum = getHum()
	local cam = workspace.CurrentCamera
	if not hum or not cam then return end
	local camCF = cam.CFrame
	local moveDir = hum.MoveDirection
	local vel = Vector3.zero
	local forwardDot = 0

	if moveDir.Magnitude > 0.01 then
		local fFlat = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
		if fFlat.Magnitude > 0.001 then fFlat = fFlat.Unit end
		local rFlat = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z)
		if rFlat.Magnitude > 0.001 then rFlat = rFlat.Unit end
		forwardDot = moveDir:Dot(fFlat)
		local rightDot = moveDir:Dot(rFlat)
		local dir = (camCF.LookVector * forwardDot) + (rFlat * rightDot)
		if dir.Magnitude > 0.001 then
			vel = dir.Unit * State.FlySpeed
		end
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
		vel = vel + Vector3.new(0, State.FlySpeed * 0.85, 0)
	elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
		vel = vel - Vector3.new(0, State.FlySpeed * 0.85, 0)
	end

	if Core.FlyLV then Core.FlyLV.VectorVelocity = vel end
	if Core.FlyAO then
		local lookFlat = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
		if lookFlat.Magnitude < 0.001 then lookFlat = Vector3.new(0, 0, -1) else lookFlat = lookFlat.Unit end
		local base = CFrame.lookAt(Vector3.zero, lookFlat)
		local tilt = math.rad(-26 * math.max(0, forwardDot))
		Core.FlyAO.CFrame = base * CFrame.Angles(tilt, 0, 0)
	end
end

local function clearEsp()
	for plr, gui in pairs(Core.EspTags) do
		if gui and gui.Parent then pcall(function() gui:Destroy() end) end
		Core.EspTags[plr] = nil
	end
end

local function refreshEsp()
	if not State.EspEnabled then
		clearEsp()
		return
	end
	local myRoot = getRoot()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local root = getRoot(plr)
			if root then
				local gui = Core.EspTags[plr]
				if not gui or not gui.Parent then
					gui = Instance.new("BillboardGui")
					gui.Adornee = root
					gui.Size = UDim2.new(0, 160, 0, 38)
					gui.StudsOffset = Vector3.new(0, 3, 0)
					gui.AlwaysOnTop = true
					gui.Parent = Core.ScreenGui

					local lbl = Instance.new("TextLabel")
					lbl.Name = "Info"
					lbl.Size = UDim2.new(1, 0, 1, 0)
					lbl.BackgroundColor3 = Color3.fromRGB(14, 14, 17)
					lbl.BackgroundTransparency = 0.2
					lbl.TextColor3 = Theme.Bright
					lbl.TextSize = 11
					lbl.Font = Enum.Font.GothamBold
					lbl.Parent = gui
					addCorner(lbl, 6)
					addStroke(lbl, Theme.Primary, 1.2, 0.1)
					Core.EspTags[plr] = gui
				end
				local lbl = gui:FindFirstChild("Info")
				if lbl and myRoot then
					local d = math.floor((root.Position - myRoot.Position).Magnitude)
					lbl.Text = plr.DisplayName .. " (@" .. plr.Name .. ") [" .. tostring(d) .. "]"
				end
			end
		end
	end
end

local function stopAnim()
	if State.CurrentTrack then
		pcall(function()
			State.CurrentTrack:Stop(0.15)
			State.CurrentTrack:Destroy()
		end)
		State.CurrentTrack = nil
	end
	local hum = getHum()
	if hum then
		for _, tr in ipairs(hum:GetPlayingAnimationTracks()) do
			pcall(function() tr:Stop(0.15) end)
		end
	end
end

local function playAnim(id)
	stopAnim()
	local hum = getHum()
	if not hum then return end
	local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
	local anim = Instance.new("Animation")
	anim.AnimationId = id
	local ok, tr = pcall(function() return animator:LoadAnimation(anim) end)
	if ok and tr then
		tr.Looped = true
		tr:Play(0.15)
		tr:AdjustSpeed(State.AnimSpeed)
		State.CurrentTrack = tr
	end
end

local function stopAllTargetModes()
	State.FollowTarget = false
	State.SpectateTarget = false
	State.SitOnHead = false
	State.FrontBack = false
	local hum = getHum()
	if hum then hum.Sit = false end
	local cam = workspace.CurrentCamera
	if hum and cam then
		cam.CameraType = Enum.CameraType.Custom
		cam.CameraSubject = hum
	end
	syncControls()
end

local function applyTheme(colorName)
	local preset = ThemePresets[colorName] or ThemePresets["أبيض وأسود"]
	State.ThemeName = ThemePresets[colorName] and colorName or "أبيض وأسود"
	Theme.Primary = preset.Primary
	Theme.Bright = preset.Bright
	Theme.Idle = preset.Idle
	Theme.Hover = preset.Hover
	Theme.Active = preset.Active
	Theme.ActiveText = preset.ActiveText
	Theme.ActiveSub = preset.ActiveSub

	for _, fn in ipairs(Core.Refreshers) do
		pcall(fn)
	end
	syncControls()
end

-- بناء الواجهة
local parentGui = resolveGuiParent()
local prev = parentGui:FindFirstChild("AX_HUB_V4_3")
if prev then prev:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "AX_HUB_V4_3"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.DisplayOrder = 120
sg.Parent = parentGui
Core.ScreenGui = sg

-- رسالة التنبيه العلوية الواضحة
local banner = Instance.new("Frame")
banner.Name = "AlertBanner"
banner.Size = UDim2.new(0, 380, 0, 62)
banner.Position = UDim2.new(0.5, -190, 0, -76)
banner.BackgroundColor3 = Theme.BgCard
banner.BorderSizePixel = 0
banner.Visible = false
banner.ZIndex = 20
banner.Parent = sg
addCorner(banner, 8)
local bannerStroke = addStroke(banner, Theme.Bright, 1.8, 0.05)

local bannerTitle = Instance.new("TextLabel")
bannerTitle.Size = UDim2.new(1, -18, 0, 22)
bannerTitle.Position = UDim2.new(0, 9, 0, 6)
bannerTitle.BackgroundTransparency = 1
bannerTitle.Text = ""
bannerTitle.TextColor3 = Theme.Text
bannerTitle.TextSize = 13
bannerTitle.Font = Enum.Font.GothamBlack
bannerTitle.TextXAlignment = Enum.TextXAlignment.Right
bannerTitle.ZIndex = 21
bannerTitle.Parent = banner

local bannerBody = Instance.new("TextLabel")
bannerBody.Size = UDim2.new(1, -18, 0, 24)
bannerBody.Position = UDim2.new(0, 9, 0, 30)
bannerBody.BackgroundTransparency = 1
bannerBody.Text = ""
bannerBody.TextColor3 = Theme.SubText
bannerBody.TextSize = 11
bannerBody.Font = Enum.Font.GothamBold
bannerBody.TextWrapped = true
bannerBody.TextXAlignment = Enum.TextXAlignment.Right
bannerBody.ZIndex = 21
bannerBody.Parent = banner

Core.Banner = banner
Core.BannerTitle = bannerTitle
Core.BannerBody = bannerBody

local floatBtn = Instance.new("TextButton")
floatBtn.Name = "FloatingToggle"
floatBtn.Size = UDim2.new(0, 130, 0, 44)
floatBtn.Position = UDim2.new(0, 22, 0.5, -22)
floatBtn.BackgroundColor3 = Theme.BgCard
floatBtn.Text = "AX HUB"
floatBtn.TextColor3 = Theme.Text
floatBtn.TextSize = 14
floatBtn.Font = Enum.Font.GothamBlack
floatBtn.Visible = false
floatBtn.AutoButtonColor = false
floatBtn.Parent = sg
addCorner(floatBtn, 10)
local floatStroke = addStroke(floatBtn, Theme.Bright, 2, 0.05)
Core.FloatingBtn = floatBtn

local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Size = UDim2.new(0, 740, 0, 495)
main.Position = UDim2.new(0.5, -370, 0.5, -247)
main.BackgroundColor3 = Theme.BgMain
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = sg
addCorner(main, 8)
local mainStroke = addStroke(main, Theme.Primary, 2.2, 0.04)
Core.MainWindow = main

local function setVisible(vis)
	State.Visible = vis
	if vis then
		floatBtn.Visible = false
		main.Visible = true
		main.Size = UDim2.new(0, 680, 0, 440)
		tween(main, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 740, 0, 495)
		})
	else
		main.Visible = false
		floatBtn.Visible = true
		floatBtn.Size = UDim2.new(0, 106, 0, 36)
		tween(floatBtn, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 130, 0, 44)
		})
	end
end

floatBtn.MouseButton1Click:Connect(function()
	setVisible(true)
end)

local function makeDraggable(handle, target)
	local dragging = false
	local startPos, dragStart
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

makeDraggable(floatBtn, floatBtn)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 54)
topBar.BackgroundColor3 = Theme.BgCard
topBar.BorderSizePixel = 0
topBar.Parent = main
makeDraggable(topBar, main)

local topLine = Instance.new("Frame")
topLine.Size = UDim2.new(1, 0, 0, 2)
topLine.Position = UDim2.new(0, 0, 1, -2)
topLine.BackgroundColor3 = Theme.Primary
topLine.BorderSizePixel = 0
topLine.Parent = topBar

-- صورة فينوم في الزاوية اليسرى العلوية
local venomBadge = Instance.new("ImageLabel")
venomBadge.Name = "VenomCornerIcon"
venomBadge.Size = UDim2.new(0, 42, 0, 42)
venomBadge.Position = UDim2.new(0, 10, 0.5, -21)
venomBadge.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
venomBadge.Image = Config.VenomImage
venomBadge.ScaleType = Enum.ScaleType.Crop
venomBadge.Parent = topBar
addCorner(venomBadge, 21)
local venomStroke = addStroke(venomBadge, Theme.Bright, 1.8, 0.04)

local venomFallback = Instance.new("TextLabel")
venomFallback.Size = UDim2.new(1, 0, 1, 0)
venomFallback.BackgroundTransparency = 1
venomFallback.Text = "V"
venomFallback.TextColor3 = Color3.fromRGB(255, 255, 255)
venomFallback.TextSize = 17
venomFallback.Font = Enum.Font.GothamBlack
venomFallback.Visible = (venomBadge.IsLoaded == false)
venomFallback.Parent = venomBadge
venomBadge:GetPropertyChangedSignal("IsLoaded"):Connect(function()
	venomFallback.Visible = not venomBadge.IsLoaded
end)

local topTitle = Instance.new("TextLabel")
topTitle.Size = UDim2.new(1, -150, 1, 0)
topTitle.Position = UDim2.new(0, 62, 0, 0)
topTitle.BackgroundTransparency = 1
topTitle.Text = Config.HubName .. " — " .. Config.Version
topTitle.TextColor3 = Theme.Text
topTitle.TextSize = 15
topTitle.Font = Enum.Font.GothamBlack
topTitle.TextXAlignment = Enum.TextXAlignment.Left
topTitle.Parent = topBar

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 68, 0, 34)
hideBtn.Position = UDim2.new(1, -78, 0.5, -17)
hideBtn.BackgroundColor3 = Theme.Idle
hideBtn.Text = "إخفاء"
hideBtn.TextColor3 = Theme.Text
hideBtn.TextSize = 13
hideBtn.Font = Enum.Font.GothamBold
hideBtn.AutoButtonColor = false
hideBtn.Parent = topBar
addCorner(hideBtn, 5)
local hideStroke = addStroke(hideBtn, Theme.Primary, 1.5, 0.08)
hideBtn.MouseButton1Click:Connect(function()
	setVisible(false)
end)

-- شريط القوائم على اليسار
local side = Instance.new("Frame")
side.Name = "LeftSidebar"
side.Size = UDim2.new(0, 184, 1, -58)
side.Position = UDim2.new(0, 4, 0, 56)
side.BackgroundColor3 = Theme.BgCard
side.BorderSizePixel = 0
side.Parent = main
addCorner(side, 6)

local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 12)
sidePad.PaddingBottom = UDim.new(0, 12)
sidePad.PaddingLeft = UDim.new(0, 10)
sidePad.PaddingRight = UDim.new(0, 10)
sidePad.Parent = side

local sideList = Instance.new("UIListLayout")
sideList.Padding = UDim.new(0, 10)
sideList.SortOrder = Enum.SortOrder.LayoutOrder
sideList.Parent = side

-- منطقة المحتوى على اليمين
local content = Instance.new("Frame")
content.Name = "RightContent"
content.Size = UDim2.new(1, -196, 1, -58)
content.Position = UDim2.new(0, 192, 0, 56)
content.BackgroundColor3 = Theme.BgMain
content.BorderSizePixel = 0
content.Parent = main
Core.Content = content

local function switchTab(tabId)
	State.ActiveTab = tabId
	for k, pg in pairs(Core.Pages) do
		pg.Visible = (k == tabId)
	end
	for k, info in pairs(Core.TabBtns) do
		local active = (k == tabId)
		info.Btn.BackgroundColor3 = active and Theme.Active or Theme.Idle
		info.Btn.TextColor3 = active and Theme.ActiveText or Theme.Text
	end
end

local function createTab(id, title, order)
	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 5
	page.ScrollBarImageColor3 = Theme.Primary
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.Visible = (id == State.ActiveTab)
	page.Parent = content
	Core.Pages[id] = page

	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 10)
	pad.PaddingBottom = UDim.new(0, 22)
	pad.PaddingLeft = UDim.new(0, 10)
	pad.PaddingRight = UDim.new(0, 10)
	pad.Parent = page

	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0, 12)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Parent = page

	local tBtn = Instance.new("TextButton")
	tBtn.Size = UDim2.new(1, 0, 0, 48)
	tBtn.LayoutOrder = order
	local initActive = (id == State.ActiveTab)
	tBtn.BackgroundColor3 = initActive and Theme.Active or Theme.Idle
	tBtn.Text = title
	tBtn.TextColor3 = initActive and Theme.ActiveText or Theme.Text
	tBtn.TextSize = 14
	tBtn.Font = Enum.Font.GothamBold
	tBtn.AutoButtonColor = false
	tBtn.Parent = side
	addCorner(tBtn, 6)
	local tStroke = addStroke(tBtn, Theme.Primary, 1.5, 0.08)

	Core.TabBtns[id] = { Btn = tBtn, Stroke = tStroke }

	table.insert(Core.Refreshers, function()
		page.ScrollBarImageColor3 = Theme.Primary
		tStroke.Color = Theme.Primary
		local isSel = (id == State.ActiveTab)
		tBtn.BackgroundColor3 = isSel and Theme.Active or Theme.Idle
		tBtn.TextColor3 = isSel and Theme.ActiveText or Theme.Text
	end)

	tBtn.MouseButton1Click:Connect(function()
		switchTab(id)
	end)

	return page
end

local function createRow(parent, h, order)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, h or 58)
	row.LayoutOrder = order or 1
	row.BackgroundTransparency = 1
	row.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0.03, 0)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = row
	return row
end

local function createBtn(parent, titleText, descText, cb, isCancel)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.485, 0, 1, 0)
	b.BackgroundColor3 = isCancel and CancelPalette.Idle or Theme.Idle
	b.Text = ""
	b.AutoButtonColor = false
	b.Parent = parent
	addCorner(b, 6)
	local s = addStroke(b, isCancel and CancelPalette.Border or Theme.Primary, 1.7, 0.04)

	local topLbl = Instance.new("TextLabel")
	topLbl.Size = UDim2.new(1, -14, 0, 22)
	topLbl.Position = UDim2.new(0, 7, 0, 6)
	topLbl.BackgroundTransparency = 1
	topLbl.Text = titleText
	topLbl.TextColor3 = isCancel and CancelPalette.Text or Theme.Text
	topLbl.TextSize = 13
	topLbl.Font = Enum.Font.GothamBlack
	topLbl.TextXAlignment = Enum.TextXAlignment.Right
	topLbl.Parent = b

	local subLbl = Instance.new("TextLabel")
	subLbl.Size = UDim2.new(1, -14, 0, 22)
	subLbl.Position = UDim2.new(0, 7, 0, 29)
	subLbl.BackgroundTransparency = 1
	subLbl.Text = descText or ""
	subLbl.TextColor3 = isCancel and CancelPalette.SubText or Theme.SubText
	subLbl.TextSize = 11
	subLbl.Font = Enum.Font.GothamBold
	subLbl.TextWrapped = true
	subLbl.TextXAlignment = Enum.TextXAlignment.Right
	subLbl.Parent = b

	table.insert(Core.Refreshers, function()
		if not isCancel then
			b.BackgroundColor3 = Theme.Idle
			topLbl.TextColor3 = Theme.Text
			subLbl.TextColor3 = Theme.SubText
			s.Color = Theme.Primary
		end
	end)

	b.MouseEnter:Connect(function()
		tween(b, TweenInfo.new(0.12), {
			BackgroundColor3 = isCancel and CancelPalette.Hover or Theme.Hover
		})
	end)
	b.MouseLeave:Connect(function()
		tween(b, TweenInfo.new(0.12), {
			BackgroundColor3 = isCancel and CancelPalette.Idle or Theme.Idle
		})
	end)
	b.MouseButton1Click:Connect(function()
		b.BackgroundColor3 = isCancel and CancelPalette.Active or Theme.Active
		topLbl.TextColor3 = isCancel and CancelPalette.Text or Theme.ActiveText
		subLbl.TextColor3 = isCancel and CancelPalette.SubText or Theme.ActiveSub
		task.delay(0.18, function()
			if b and b.Parent then
				b.BackgroundColor3 = isCancel and CancelPalette.Idle or Theme.Idle
				topLbl.TextColor3 = isCancel and CancelPalette.Text or Theme.Text
				subLbl.TextColor3 = isCancel and CancelPalette.SubText or Theme.SubText
			end
		end)
		cb()
	end)
	return b
end

local function createToggle(parent, titleText, descText, getter, setter)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.485, 0, 1, 0)
	b.Text = ""
	b.AutoButtonColor = false
	b.Parent = parent
	addCorner(b, 6)
	local s = addStroke(b, Theme.Primary, 1.7, 0.04)

	local topLbl = Instance.new("TextLabel")
	topLbl.Size = UDim2.new(1, -66, 0, 22)
	topLbl.Position = UDim2.new(0, 7, 0, 6)
	topLbl.BackgroundTransparency = 1
	topLbl.Text = titleText
	topLbl.TextSize = 13
	topLbl.Font = Enum.Font.GothamBlack
	topLbl.TextXAlignment = Enum.TextXAlignment.Right
	topLbl.Parent = b

	local stateLbl = Instance.new("TextLabel")
	stateLbl.Size = UDim2.new(0, 52, 0, 22)
	stateLbl.Position = UDim2.new(1, -58, 0, 6)
	stateLbl.BackgroundTransparency = 1
	stateLbl.Text = ""
	stateLbl.TextSize = 11
	stateLbl.Font = Enum.Font.GothamBlack
	stateLbl.TextXAlignment = Enum.TextXAlignment.Left
	stateLbl.Parent = b

	local subLbl = Instance.new("TextLabel")
	subLbl.Size = UDim2.new(1, -14, 0, 22)
	subLbl.Position = UDim2.new(0, 7, 0, 29)
	subLbl.BackgroundTransparency = 1
	subLbl.Text = descText or ""
	subLbl.TextSize = 11
	subLbl.Font = Enum.Font.GothamBold
	subLbl.TextWrapped = true
	subLbl.TextXAlignment = Enum.TextXAlignment.Right
	subLbl.Parent = b

	local function sync()
		local active = getter()
		b.BackgroundColor3 = active and Theme.Active or Theme.Idle
		topLbl.TextColor3 = active and Theme.ActiveText or Theme.Text
		stateLbl.Text = active and "مفعل" or "مغلق"
		stateLbl.TextColor3 = active and Theme.ActiveText or Theme.Bright
		subLbl.TextColor3 = active and Theme.ActiveSub or Theme.SubText
		s.Color = active and Theme.Bright or Theme.Primary
	end

	table.insert(Core.Refreshers, sync)
	table.insert(Core.ControlSyncs, sync)
	sync()

	b.MouseButton1Click:Connect(function()
		setter(not getter())
		sync()
	end)
	return b
end

local function createSlider(parent, label, descText, minV, maxV, stepDecimals, getter, setter)
	local mult = 10 ^ (stepDecimals or 0)
	local function round(v)
		return math.floor(math.clamp(v, minV, maxV) * mult + 0.5) / mult
	end

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.485, 0, 1, 0)
	frame.BackgroundColor3 = Theme.BgCard
	frame.Parent = parent
	addCorner(frame, 6)
	local s = addStroke(frame, Theme.Primary, 1.5, 0.08)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -84, 0, 20)
	title.Position = UDim2.new(0, 8, 0, 6)
	title.BackgroundTransparency = 1
	title.Text = label
	title.TextColor3 = Theme.Text
	title.TextSize = 12
	title.Font = Enum.Font.GothamBlack
	title.TextXAlignment = Enum.TextXAlignment.Right
	title.Parent = frame

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0, 60, 0, 22)
	box.Position = UDim2.new(1, -68, 0, 5)
	box.BackgroundColor3 = Theme.Idle
	box.TextColor3 = Theme.Text
	box.TextSize = 12
	box.Font = Enum.Font.GothamBold
	box.ClearTextOnFocus = false
	box.Parent = frame
	addCorner(box, 4)
	local bs = addStroke(box, Theme.Primary, 1.2, 0.1)

	local desc = Instance.new("TextLabel")
	desc.Size = UDim2.new(1, -16, 0, 18)
	desc.Position = UDim2.new(0, 8, 0, 28)
	desc.BackgroundTransparency = 1
	desc.Text = descText or ""
	desc.TextColor3 = Theme.SubText
	desc.TextSize = 11
	desc.Font = Enum.Font.GothamBold
	desc.TextXAlignment = Enum.TextXAlignment.Right
	desc.Parent = frame

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, -20, 0, 9)
	track.Position = UDim2.new(0, 10, 0, 50)
	track.BackgroundColor3 = Theme.BgMain
	track.BorderSizePixel = 0
	track.Parent = frame
	addCorner(track, 4)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Theme.Bright
	fill.BorderSizePixel = 0
	fill.Parent = track
	addCorner(fill, 4)

	local function sync()
		local v = round(getter())
		local alpha = (maxV > minV) and math.clamp((v - minV) / (maxV - minV), 0, 1) or 0
		box.Text = tostring(v)
		fill.Size = UDim2.new(alpha, 0, 1, 0)
	end

	table.insert(Core.Refreshers, function()
		s.Color = Theme.Primary
		bs.Color = Theme.Primary
		box.BackgroundColor3 = Theme.Idle
		box.TextColor3 = Theme.Text
		title.TextColor3 = Theme.Text
		desc.TextColor3 = Theme.SubText
		fill.BackgroundColor3 = Theme.Bright
	end)
	table.insert(Core.ControlSyncs, sync)
	sync()

	local dragging = false
	local function setFromX(x)
		local alpha = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
		setter(round(minV + alpha * (maxV - minV)))
		sync()
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setFromX(input.Position.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			setFromX(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	box.FocusLost:Connect(function()
		local n = tonumber(box.Text)
		if n then setter(round(n)) end
		sync()
	end)

	return frame
end

local function createInfoCard(parent, title, body, h, order)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, h or 92)
	card.LayoutOrder = order or 1
	card.BackgroundColor3 = Theme.BgCard
	card.Parent = parent
	addCorner(card, 6)
	local s = addStroke(card, Theme.Primary, 1.5, 0.08)

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(0, 4, 1, -20)
	bar.Position = UDim2.new(1, -12, 0, 10)
	bar.BackgroundColor3 = Theme.Bright
	bar.BorderSizePixel = 0
	bar.Parent = card
	addCorner(bar, 2)

	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -28, 0, 24)
	t.Position = UDim2.new(0, 10, 0, 10)
	t.BackgroundTransparency = 1
	t.Text = title
	t.TextColor3 = Theme.Text
	t.TextSize = 14
	t.Font = Enum.Font.GothamBlack
	t.TextXAlignment = Enum.TextXAlignment.Right
	t.Parent = card

	local b = Instance.new("TextLabel")
	b.Size = UDim2.new(1, -28, 1, -42)
	b.Position = UDim2.new(0, 10, 0, 36)
	b.BackgroundTransparency = 1
	b.Text = body
	b.TextColor3 = Theme.SubText
	b.TextSize = 12
	b.Font = Enum.Font.GothamBold
	b.TextWrapped = true
	b.TextXAlignment = Enum.TextXAlignment.Right
	b.TextYAlignment = Enum.TextYAlignment.Top
	b.Parent = card

	table.insert(Core.Refreshers, function()
		s.Color = Theme.Primary
		bar.BackgroundColor3 = Theme.Bright
		t.TextColor3 = Theme.Text
		b.TextColor3 = Theme.SubText
	end)
	return card
end

local homePage = createTab("Home", "القائمة الرئيسية", 1)
local playerPage = createTab("Player", "اللاعب", 2)
local targetPage = createTab("Target", "الاستهداف", 3)
local animPage = createTab("Anim", "الحركات", 4)
local otherPage = createTab("Other", "أخرى", 5)

-- 1. القائمة الرئيسية
createInfoCard(
	homePage,
	"مرحباً بك في " .. Config.HubName,
	Config.WelcomeMessage .. "\n" .. Config.DedicatedLine,
	92,
	1
)
createInfoCard(
	homePage,
	"الحقوق والمطورون",
	"الصانع: " .. Config.Creator .. "  |  المساعد: " .. Config.Assistant .. "  |  " .. Config.Version,
	76,
	2
)
createInfoCard(
	homePage,
	"حالة الأنظمة الحالية",
	"اللون الحالي: " .. State.ThemeName .. "  |  الطيران: " .. (State.FlyEnabled and "مفعل" or "مغلق") .. "  |  الهدف: " .. (State.TargetName ~= "" and State.TargetName or "لم يتم التحديد"),
	76,
	3
)

local hRow1 = createRow(homePage, 58, 4)
createBtn(hRow1, "تجهيز أداة اليد", "إضافة أداة تحديد اللاعبين للحقيبة", function()
	State.HandToolEnabled = true
	ensureHandTool()
	showMessage("أداة اليد", "تم تجهيز أداة التحديد اليدوية في الحقيبة")
end, false)
createBtn(hRow1, "الانتقال إلى الاستهداف", "فتح تبويب التحكم بالهدف والضحية", function()
	switchTab("Target")
end, false)

local hRow2 = createRow(homePage, 58, 5)
createBtn(hRow2, "الانتقال إلى الحركات", "فتح قائمة الرقصات والحركات", function()
	switchTab("Anim")
end, false)
createBtn(hRow2, "إيقاف جميع الأوضاع", "إيقاف الطيران والمتابعة والحركات فوراً", function()
	stopAllTargetModes()
	stopAnim()
	State.FlyEnabled = false
	destroyFlyRig()
	syncControls()
	showMessage("إيقاف الكل", "تم إيقاف جميع الأوضاع النشطة")
end, true)

-- 2. اللاعب
local pRow1 = createRow(playerPage, 58, 1)
createToggle(pRow1, "طيران حقيقي", "تحليق حر بالتحرك و Space / Ctrl", function() return State.FlyEnabled end, function(v)
	State.FlyEnabled = v
	if v then ensureFlyRig() else destroyFlyRig() end
end)
createToggle(pRow1, "كشف اللاعبين", "إظهار أسماء ومسافات اللاعبين", function() return State.EspEnabled end, function(v)
	State.EspEnabled = v
	refreshEsp()
end)

local pRow2 = createRow(playerPage, 72, 2)
createSlider(pRow2, "سرعة المشي", "تعديل سرعة حركة شخصيتك", 8, 120, 0, function() return State.WalkSpeed end, function(v)
	State.WalkSpeed = v
	local h = getHum()
	if h then h.WalkSpeed = v end
end)
createSlider(pRow2, "قوة القفز", "تعديل قوة وارتفاع قفزة الشخصية", 20, 250, 0, function() return State.JumpPower end, function(v)
	State.JumpPower = v
	State.JumpHeight = computeJumpHeightFromPower(v)
	applyJumpToHumanoid(getHum())
end)

local pRow3 = createRow(playerPage, 72, 3)
createSlider(pRow3, "سرعة الطيران", "تعديل سرعة التحليق في الهواء", 20, 250, 0, function() return State.FlySpeed end, function(v)
	State.FlySpeed = v
end)
createBtn(pRow3, "استعادة السرعة والقفز", "إرجاع المشي إلى 16 والقفز إلى 50", function()
	State.WalkSpeed = 16
	State.JumpPower = 50
	State.JumpHeight = computeJumpHeightFromPower(50)
	local h = getHum()
	if h then
		h.WalkSpeed = 16
		applyJumpToHumanoid(h)
	end
	syncControls()
	showMessage("إعادة ضبط الحركة", "تمت استعادة سرعة المشي وقوة القفز الافتراضية")
end, true)

-- 3. الاستهداف
local tCard = Instance.new("Frame")
tCard.Size = UDim2.new(1, 0, 0, 128)
tCard.LayoutOrder = 1
tCard.BackgroundColor3 = Theme.BgCard
tCard.Parent = targetPage
addCorner(tCard, 6)
local tCardStroke = addStroke(tCard, Theme.Primary, 1.6, 0.06)

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 104, 0, 104)
avatar.Position = UDim2.new(0, 12, 0.5, -52)
avatar.BackgroundColor3 = Theme.BgMain
avatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
avatar.Parent = tCard
addCorner(avatar, 6)
local avStroke = addStroke(avatar, Theme.Primary, 1.4, 0.1)

local tBox = Instance.new("TextBox")
tBox.Size = UDim2.new(1, -180, 0, 34)
tBox.Position = UDim2.new(0, 126, 0, 10)
tBox.BackgroundColor3 = Theme.Idle
tBox.PlaceholderText = "اكتب اسم اللاعب أو استعمل اليد..."
tBox.PlaceholderColor3 = Theme.Muted
tBox.Text = ""
tBox.TextColor3 = Theme.Text
tBox.TextSize = 13
tBox.Font = Enum.Font.GothamBold
tBox.ClearTextOnFocus = false
tBox.Parent = tCard
addCorner(tBox, 5)
local boxStroke = addStroke(tBox, Theme.Primary, 1.3, 0.1)

local handBtn = Instance.new("TextButton")
handBtn.Size = UDim2.new(0, 34, 0, 34)
handBtn.Position = UDim2.new(1, -44, 0, 10)
handBtn.BackgroundColor3 = Theme.Idle
handBtn.Text = "✋"
handBtn.TextColor3 = Theme.Text
handBtn.TextSize = 16
handBtn.Font = Enum.Font.GothamBold
handBtn.AutoButtonColor = false
handBtn.Parent = tCard
addCorner(handBtn, 5)
local handStroke = addStroke(handBtn, Theme.Bright, 1.4, 0.08)

local uidLbl = Instance.new("TextLabel")
uidLbl.Size = UDim2.new(1, -138, 0, 22)
uidLbl.Position = UDim2.new(0, 126, 0, 50)
uidLbl.BackgroundTransparency = 1
uidLbl.Text = "رقم الحساب: ---"
uidLbl.TextColor3 = Theme.Text
uidLbl.TextSize = 12
uidLbl.Font = Enum.Font.GothamBold
uidLbl.TextXAlignment = Enum.TextXAlignment.Right
uidLbl.Parent = tCard

local dispLbl = Instance.new("TextLabel")
dispLbl.Size = UDim2.new(1, -138, 0, 22)
dispLbl.Position = UDim2.new(0, 126, 0, 74)
dispLbl.BackgroundTransparency = 1
dispLbl.Text = "الاسم الظاهر: ---"
dispLbl.TextColor3 = Theme.Text
dispLbl.TextSize = 12
dispLbl.Font = Enum.Font.GothamBold
dispLbl.TextXAlignment = Enum.TextXAlignment.Right
dispLbl.Parent = tCard

local joinLbl = Instance.new("TextLabel")
joinLbl.Size = UDim2.new(1, -138, 0, 22)
joinLbl.Position = UDim2.new(0, 126, 0, 98)
joinLbl.BackgroundTransparency = 1
joinLbl.Text = "تاريخ الانضمام: ---"
joinLbl.TextColor3 = Theme.SubText
joinLbl.TextSize = 12
joinLbl.Font = Enum.Font.GothamBold
joinLbl.TextXAlignment = Enum.TextXAlignment.Right
joinLbl.Parent = tCard

Core.TargetUI.Avatar = avatar
Core.TargetUI.UserId = uidLbl
Core.TargetUI.Display = dispLbl
Core.TargetUI.Joined = joinLbl
Core.TargetUI.Box = tBox

table.insert(Core.Refreshers, function()
	tCardStroke.Color = Theme.Primary
	avStroke.Color = Theme.Primary
	boxStroke.Color = Theme.Primary
	handStroke.Color = Theme.Bright
	tBox.BackgroundColor3 = Theme.Idle
	tBox.TextColor3 = Theme.Text
	handBtn.BackgroundColor3 = Theme.Idle
	handBtn.TextColor3 = Theme.Text
	uidLbl.TextColor3 = Theme.Text
	dispLbl.TextColor3 = Theme.Text
	joinLbl.TextColor3 = Theme.SubText
end)

handBtn.MouseButton1Click:Connect(function()
	State.HandToolEnabled = true
	ensureHandTool()
	showMessage("أداة اليد ✋", "تم تجهيز أداة اليد في الحقيبة، اضغط على أي لاعب لتحديده")
end)

tBox.FocusLost:Connect(function()
	confirmTargetSelection(tBox.Text, "إدخال الاسم")
end)

local tRow1 = createRow(targetPage, 58, 2)
createBtn(tRow1, "تحديد اللاعب", "تأكيد الهدف وإظهار رسالة التحديد", function()
	confirmTargetSelection(tBox.Text, "زر التحديد")
end, false)
createBtn(tRow1, "انتقال للاعب", "الانتقال مباشرة إلى موقع اللاعب", function()
	local plr = findTargetPlayer(State.TargetName)
	local tRoot = plr and getRoot(plr)
	local myRoot = getRoot()
	if tRoot and myRoot then
		myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, -4)
		showMessage("انتقال", "تم الانتقال إلى " .. plr.Name)
	else
		showMessage("تنبيه", "حدد لاعباً صالحاً أولاً")
	end
end, false)

local tRow2 = createRow(targetPage, 58, 3)
createToggle(tRow2, "متابعة", "ملاحقة موقع اللاعب باستمرار", function() return State.FollowTarget end, function(v) State.FollowTarget = v end)
createToggle(tRow2, "مشاهدة", "توجيه الكاميرا نحو اللاعب المحدد", function()
	return State.SpectateTarget
end, function(v)
	State.SpectateTarget = v
	local cam = workspace.CurrentCamera
	local plr = findTargetPlayer(State.TargetName)
	local tHum = plr and getHum(plr)
	local myHum = getHum()
	if cam then
		cam.CameraSubject = (v and tHum) and tHum or myHum
	end
end)

local tRow3 = createRow(targetPage, 58, 4)
createToggle(tRow3, "جلوس في راسه", "الجلوس أعلى رأس اللاعب المحدد", function() return State.SitOnHead end, function(v)
	State.SitOnHead = v
	local h = getHum()
	if not v and h then h.Sit = false end
end)
createToggle(tRow3, "قدام وورا سريع", "تحرك سريع للأمام والخلف قرب الهدف", function() return State.FrontBack end, function(v) State.FrontBack = v end)

local tRow4 = createRow(targetPage, 58, 5)
createToggle(tRow4, "أداة اليد", "تفعيل أو إزالة أداة التحديد اليدوية", function() return State.HandToolEnabled end, function(v)
	State.HandToolEnabled = v
	ensureHandTool()
end)
createBtn(tRow4, "إيقاف الكل", "إيقاف المتابعة والمشاهدة والحركات فوراً", function()
	stopAllTargetModes()
	showMessage("إيقاف الاستهداف", "تم إيقاف جميع أوضاع الاستهداف")
end, true)

local tRow5 = createRow(targetPage, 72, 6)
createSlider(tRow5, "سرعة قدام وورا", "تعديل سرعة حركة قدام وورا", 60, 400, 0, function() return State.FrontBackSpeed end, function(v) State.FrontBackSpeed = v end)
createSlider(tRow5, "قرب الوجه والظهر", "تعديل مسافة القرب من الهدف", 1.5, 6, 1, function() return State.FrontBackDist end, function(v) State.FrontBackDist = v end)

-- 4. الحركات
local aRowTop = createRow(animPage, 72, 1)
createBtn(aRowTop, "إلغاء جميع الحركات", "إيقاف أي حركة أو رقصة شغالة حالياً", function()
	stopAnim()
	showMessage("الحركات", "تم إلغاء جميع الحركات الحالية")
end, true)
createSlider(aRowTop, "سرعة الحركة", "تعديل سرعة تشغيل الحركة", 0.2, 2.5, 1, function() return State.AnimSpeed end, function(v)
	State.AnimSpeed = v
	if State.CurrentTrack then
		State.CurrentTrack:AdjustSpeed(v)
	end
end)

for i = 1, #Animations, 2 do
	local row = createRow(animPage, 58, 1 + math.ceil(i / 2))
	local a1 = Animations[i]
	createBtn(row, a1.Name, a1.Desc, function() playAnim(a1.Id) end, false)
	local a2 = Animations[i + 1]
	if a2 then
		createBtn(row, a2.Name, a2.Desc, function() playAnim(a2.Id) end, false)
	end
end

-- 5. أخرى
createInfoCard(
	otherPage,
	"ألوان الصفحة والإعدادات",
	"الافتراضي أبيض وأسود — اختر اللون المناسب لك، وأزرار الإلغاء تبقى بلون مستقل واضح.",
	74,
	1
)

for i = 1, #ColorNames, 2 do
	local cRow = createRow(otherPage, 58, 1 + math.ceil(i / 2))
	local c1 = ColorNames[i]
	local c2 = ColorNames[i + 1]
	createBtn(cRow, "لون " .. c1, "تطبيق ثيم " .. c1 .. " على الواجهة", function() applyTheme(c1) end, false)
	if c2 then
		createBtn(cRow, "لون " .. c2, "تطبيق ثيم " .. c2 .. " على الواجهة", function() applyTheme(c2) end, false)
	end
end

local oRowSave = createRow(otherPage, 58, 6)
createBtn(oRowSave, "حفظ الإعدادات", "حفظ القيم واللون والهدف الحالي", function()
	State.SavedSnapshot = {
		ThemeName = State.ThemeName,
		WalkSpeed = State.WalkSpeed,
		JumpPower = State.JumpPower,
		JumpHeight = State.JumpHeight,
		FlySpeed = State.FlySpeed,
		TargetName = State.TargetName,
		AnimSpeed = State.AnimSpeed,
	}
	showMessage("الإعدادات", "تم حفظ الإعدادات الحالية")
end, false)
createBtn(oRowSave, "استرجاع الإعدادات", "استعادة آخر إعدادات تم حفظها", function()
	if State.SavedSnapshot then
		for k, v in pairs(State.SavedSnapshot) do
			State[k] = v
		end
		applyTheme(State.ThemeName)
		refreshTargetCard()
		showMessage("الإعدادات", "تم استرجاع الإعدادات المحفوظة")
	end
end, false)

local oRowReset = createRow(otherPage, 58, 7)
createBtn(oRowReset, "إعادة الضبط", "إرجاع كل شيء للأبيض والأسود والقيم الافتراضية", function()
	stopAllTargetModes()
	stopAnim()
	State.FlyEnabled = false
	destroyFlyRig()
	State.WalkSpeed = 16
	State.JumpPower = 50
	State.JumpHeight = computeJumpHeightFromPower(50)
	State.TargetName = ""
	applyTheme("أبيض وأسود")
	refreshTargetCard()
	showMessage("إعادة الضبط", "تمت إعادة الضبط إلى الوضع الافتراضي")
end, true)

table.insert(Core.Refreshers, function()
	mainStroke.Color = Theme.Primary
	floatStroke.Color = Theme.Bright
	floatBtn.TextColor3 = Theme.Text
	topTitle.TextColor3 = Theme.Text
	topLine.BackgroundColor3 = Theme.Primary
	venomStroke.Color = Theme.Bright
	hideBtn.BackgroundColor3 = Theme.Idle
	hideBtn.TextColor3 = Theme.Text
	hideStroke.Color = Theme.Primary
	banner.BackgroundColor3 = Theme.BgCard
	bannerStroke.Color = Theme.Bright
	bannerTitle.TextColor3 = Theme.Text
	bannerBody.TextColor3 = Theme.SubText
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Config.ToggleKey then
		setVisible(not State.Visible)
	end
end)

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.25)
	destroyFlyRig()
	ensureHandTool()
	applyJumpToHumanoid(getHum())
end)

RunService.Heartbeat:Connect(function(dt)
	local hum = getHum()
	local root = getRoot()
	if hum then
		if State.WalkSpeed ~= 16 and hum.WalkSpeed ~= State.WalkSpeed then
			hum.WalkSpeed = State.WalkSpeed
		end
		if State.JumpPower ~= 50 then
			applyJumpToHumanoid(hum)
		end
	end
	if State.FlyEnabled then
		updateFly()
	end
	if State.EspEnabled then
		refreshEsp()
	end

	local targetPlr = findTargetPlayer(State.TargetName)
	local tRoot = targetPlr and getRoot(targetPlr)
	if tRoot and root then
		if State.SitOnHead then
			if hum then hum.Sit = true end
			root.CFrame = tRoot.CFrame * CFrame.new(0, 3.6, 0)
		elseif State.FrontBack then
			Core.FlyPhase = Core.FlyPhase + dt * (State.FrontBackSpeed * 0.14)
			local zOff = math.sin(Core.FlyPhase) * math.max(1.8, State.FrontBackDist)
			local pos = (tRoot.CFrame * CFrame.new(0, 0, zOff)).Position
			root.CFrame = root.CFrame:Lerp(CFrame.lookAt(pos, tRoot.Position), math.clamp(dt * 40, 0.45, 0.98))
			root.AssemblyLinearVelocity = Vector3.zero
		elseif State.FollowTarget then
			root.CFrame = tRoot.CFrame * CFrame.new(0, 0, -4)
		end
	end
end)

ensureHandTool()
applyTheme(State.ThemeName)
showMessage(Config.HubName, Config.WelcomeMessage)
