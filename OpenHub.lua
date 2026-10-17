local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local PGui = LP:WaitForChild("PlayerGui")

local safeParent = PGui
pcall(function()
	if gethui then
		safeParent = gethui()
	elseif protectgui or (syn and syn.protect_gui) then
		safeParent = game:GetService("CoreGui")
	end
end)

local THEMES = {
	Void = {
		Background   = Color3.fromRGB(8, 7, 12),
		Panel        = Color3.fromRGB(13, 11, 20),
		Sidebar      = Color3.fromRGB(10, 9, 16),
		Row          = Color3.fromRGB(19, 17, 29),
		Field        = Color3.fromRGB(14, 12, 22),
		Border       = Color3.fromRGB(40, 35, 62),
		Text         = Color3.fromRGB(232, 226, 255),
		Muted        = Color3.fromRGB(138, 128, 168),
		Faint        = Color3.fromRGB(72, 66, 96),
		Accent       = Color3.fromRGB(110, 68, 214),
		AccentHover  = Color3.fromRGB(130, 90, 230),
		AccentMuted  = Color3.fromRGB(55, 34, 107),
		TopBar       = Color3.fromRGB(11, 9, 17),
		NavActive    = Color3.fromRGB(22, 18, 36),
		NavHover     = Color3.fromRGB(16, 14, 26),
		Thumb        = Color3.fromRGB(240, 236, 255),
		SliderTrack  = Color3.fromRGB(28, 24, 42),
		ToggleOff    = Color3.fromRGB(30, 26, 48),
		Notification = Color3.fromRGB(16, 13, 26),
	},
	Ash = {
		Background   = Color3.fromRGB(12, 10, 8),
		Panel        = Color3.fromRGB(19, 16, 13),
		Sidebar      = Color3.fromRGB(15, 13, 10),
		Row          = Color3.fromRGB(26, 22, 17),
		Field        = Color3.fromRGB(16, 14, 11),
		Border       = Color3.fromRGB(52, 43, 34),
		Text         = Color3.fromRGB(245, 234, 218),
		Muted        = Color3.fromRGB(152, 136, 114),
		Faint        = Color3.fromRGB(80, 68, 54),
		Accent       = Color3.fromRGB(210, 96, 32),
		AccentHover  = Color3.fromRGB(228, 116, 52),
		AccentMuted  = Color3.fromRGB(105, 48, 16),
		TopBar       = Color3.fromRGB(16, 14, 11),
		NavActive    = Color3.fromRGB(30, 25, 19),
		NavHover     = Color3.fromRGB(22, 19, 15),
		Thumb        = Color3.fromRGB(248, 238, 224),
		SliderTrack  = Color3.fromRGB(34, 28, 21),
		ToggleOff    = Color3.fromRGB(34, 28, 21),
		Notification = Color3.fromRGB(20, 17, 13),
	},
	Frost = {
		Background   = Color3.fromRGB(230, 236, 248),
		Panel        = Color3.fromRGB(248, 250, 255),
		Sidebar      = Color3.fromRGB(220, 228, 244),
		Row          = Color3.fromRGB(210, 220, 240),
		Field        = Color3.fromRGB(240, 244, 252),
		Border       = Color3.fromRGB(186, 198, 222),
		Text         = Color3.fromRGB(16, 20, 38),
		Muted        = Color3.fromRGB(88, 105, 144),
		Faint        = Color3.fromRGB(148, 162, 194),
		Accent       = Color3.fromRGB(42, 124, 210),
		AccentHover  = Color3.fromRGB(62, 144, 228),
		AccentMuted  = Color3.fromRGB(180, 208, 240),
		TopBar       = Color3.fromRGB(216, 224, 242),
		NavActive    = Color3.fromRGB(198, 212, 238),
		NavHover     = Color3.fromRGB(210, 220, 240),
		Thumb        = Color3.fromRGB(255, 255, 255),
		SliderTrack  = Color3.fromRGB(200, 212, 234),
		ToggleOff    = Color3.fromRGB(192, 206, 230),
		Notification = Color3.fromRGB(238, 242, 252),
	},
}

local function ti(t, s, d)
	return TweenInfo.new(t or 0.18, s or Enum.EasingStyle.Quart, d or Enum.EasingDirection.Out)
end

local function tween(obj, props, t, s, d)
	TweenService:Create(obj, ti(t, s, d), props):Play()
end

local function n(class, props, parent)
	local inst = Instance.new(class)
	if props then
		for k, v in pairs(props) do
			inst[k] = v
		end
	end
	if parent then inst.Parent = parent end
	return inst
end

local function corner(obj, r)
	n("UICorner", { CornerRadius = UDim.new(0, r or 8) }, obj)
end

local function pad(obj, x, y)
	n("UIPadding", {
		PaddingLeft   = UDim.new(0, x or 8),
		PaddingRight  = UDim.new(0, x or 8),
		PaddingTop    = UDim.new(0, y or 4),
		PaddingBottom = UDim.new(0, y or 4),
	}, obj)
end

local function listLayout(obj, dir, gap, ha, va)
	return n("UIListLayout", {
		FillDirection       = dir or Enum.FillDirection.Vertical,
		SortOrder           = Enum.SortOrder.LayoutOrder,
		Padding             = UDim.new(0, gap or 4),
		HorizontalAlignment = ha or Enum.HorizontalAlignment.Left,
		VerticalAlignment   = va or Enum.VerticalAlignment.Top,
	}, obj)
end

local function stroke(obj, color, thick)
	return n("UIStroke", {
		Color     = color,
		Thickness = thick or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, obj)
end

local function lbl(parent, txt, size, color, props)
	local l = n("TextLabel", {
		BackgroundTransparency = 1,
		Text     = txt or "",
		TextSize = size or 12,
		Font     = Enum.Font.GothamMedium,
		TextColor3 = color,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		Size     = UDim2.fromScale(1, 1),
	}, parent)
	if props then
		for k, v in pairs(props) do l[k] = v end
	end
	return l
end

local function icon(parent, txt, size, color)
	return n("TextLabel", {
		BackgroundTransparency = 1,
		Text     = txt or "",
		TextSize = size or 14,
		Font     = Enum.Font.GothamBold,
		TextColor3 = color,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		Size     = UDim2.fromScale(1, 1),
	}, parent)
end

local function scrollFrame(parent, props)
	local f = n("ScrollingFrame", {
		BackgroundTransparency = 1,
		ScrollBarThickness     = 3,
		ScrollBarImageColor3   = Color3.fromRGB(255, 255, 255),
		ScrollBarImageTransparency = 0.7,
		CanvasSize             = UDim2.fromScale(0, 0),
		AutomaticCanvasSize    = Enum.AutomaticSize.Y,
		BorderSizePixel        = 0,
		Size                   = UDim2.fromScale(1, 1),
	}, parent)
	if props then
		for k, v in pairs(props) do f[k] = v end
	end
	return f
end

local Control = {}
Control.__index = Control

function Control:Set(v, silent)
	self._value = v
	if self._apply then self._apply(v) end
	if not silent and self._callback then
		pcall(self._callback, v)
	end
	return self
end

function Control:Get()
	return self._value
end

function Control:Lock()
	self._locked = true
	if self._lockVisual then self._lockVisual(true) end
	return self
end

function Control:Unlock()
	self._locked = false
	if self._lockVisual then self._lockVisual(false) end
	return self
end

function Control:SetVisible(v)
	if self._root then self._root.Visible = v == true end
	return self
end

function Control:Show() return self:SetVisible(true) end
function Control:Hide() return self:SetVisible(false) end

function Control:Destroy()
	if self._root then self._root:Destroy() end
end

local Tab = {}
Tab.__index = Tab

local function makeControl(tab, height)
	local C = tab._window._C
	local row = n("Frame", {
		BackgroundColor3 = C.Row,
		BackgroundTransparency = 0.36,
		Size = UDim2.new(1, 0, 0, height or 38),
		BorderSizePixel = 0,
		ClipsDescendants = false,
		LayoutOrder = tab._order,
	}, tab._list)
	tab._order = tab._order + 1
	corner(row, 9)
	local ctrl = setmetatable({ _root = row, _locked = false, _window = tab._window }, Control)
	return ctrl, row
end

function Tab:Button(opts)
	local o = opts or {}
	local C = self._window._C
	local ctrl, row = makeControl(self, 38)
	row.BackgroundTransparency = 0.28

	local hit = n("TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Text = "",
	}, row)

	local leftBar = n("Frame", {
		BackgroundColor3 = C.Accent,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 3, 0.6, 0),
		Position = UDim2.new(0, 0, 0.2, 0),
		BorderSizePixel = 0,
	}, row)
	corner(leftBar, 4)

	local title = lbl(row, o.Title or "Button", 13, C.Text, {
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(1, -42, 1, 0),
	})

	local arrow = lbl(row, "›", 16, C.Muted, {
		Position = UDim2.new(1, -28, 0, 0),
		Size = UDim2.fromOffset(20, 38),
		TextXAlignment = Enum.TextXAlignment.Center,
		Font = Enum.Font.GothamBold,
	})

	hit.MouseEnter:Connect(function()
		if ctrl._locked then return end
		tween(row, { BackgroundColor3 = C.Row, BackgroundTransparency = 0.1 }, 0.12)
		tween(leftBar, { BackgroundTransparency = 0 }, 0.12)
		tween(arrow, { TextColor3 = C.Accent }, 0.12)
	end)
	hit.MouseLeave:Connect(function()
		tween(row, { BackgroundTransparency = 0.28 }, 0.15)
		tween(leftBar, { BackgroundTransparency = 1 }, 0.15)
		tween(arrow, { TextColor3 = C.Muted }, 0.15)
	end)
	hit.MouseButton1Down:Connect(function()
		if ctrl._locked then return end
		tween(row, { BackgroundColor3 = C.AccentMuted, BackgroundTransparency = 0.1 }, 0.08)
	end)
	hit.MouseButton1Up:Connect(function()
		if ctrl._locked then return end
		tween(row, { BackgroundColor3 = C.Row, BackgroundTransparency = 0.28 }, 0.12)
		if o.Callback then pcall(o.Callback) end
	end)

	ctrl._callback = o.Callback
	ctrl._apply = function()
		title.Text = o.Title or "Button"
	end

	function ctrl:SetTitle(t)
		title.Text = t
	end

	return ctrl
end

function Tab:Toggle(opts)
	local o = opts or {}
	local C = self._window._C
	local ctrl, row = makeControl(self, 38)

	local hit = n("TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Text = "",
	}, row)

	local title = lbl(row, o.Title or "Toggle", 13, C.Text, {
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(1, -60, 1, 0),
	})

	local pill = n("Frame", {
		BackgroundColor3 = C.ToggleOff,
		Size = UDim2.fromOffset(36, 20),
		Position = UDim2.new(1, -46, 0.5, -10),
		BorderSizePixel = 0,
	}, row)
	corner(pill, 10)
	stroke(pill, C.Border, 1)

	local thumb = n("Frame", {
		BackgroundColor3 = C.Thumb,
		Size = UDim2.fromOffset(14, 14),
		Position = UDim2.fromOffset(3, 3),
		BorderSizePixel = 0,
	}, pill)
	corner(thumb, 7)

	local val = o.Default == true

	local function applyToggle(v, silent)
		val = v
		if v then
			tween(pill, { BackgroundColor3 = C.Accent }, 0.18)
			tween(thumb, { Position = UDim2.fromOffset(19, 3), BackgroundColor3 = Color3.fromRGB(255, 255, 255) }, 0.18, Enum.EasingStyle.Back)
		else
			tween(pill, { BackgroundColor3 = C.ToggleOff }, 0.18)
			tween(thumb, { Position = UDim2.fromOffset(3, 3), BackgroundColor3 = C.Thumb }, 0.18, Enum.EasingStyle.Quart)
		end
		if not silent and o.Callback then pcall(o.Callback, v) end
	end

	applyToggle(val, true)

	hit.MouseButton1Up:Connect(function()
		if ctrl._locked then return end
		applyToggle(not val)
	end)
	hit.MouseEnter:Connect(function()
		if not val then tween(pill, { BackgroundColor3 = C.Faint }, 0.12) end
	end)
	hit.MouseLeave:Connect(function()
		if not val then tween(pill, { BackgroundColor3 = C.ToggleOff }, 0.12) end
	end)

	ctrl._value = val
	ctrl._apply = function(v) applyToggle(v, true) end
	ctrl._callback = o.Callback

	function ctrl:Set(v, silent)
		applyToggle(v == true, silent)
		self._value = val
		return self
	end
	function ctrl:Get() return val end

	return ctrl
end

function Tab:Slider(opts)
	local o = opts or {}
	local C = self._window._C
	local ctrl, row = makeControl(self, 52)

	local minV    = o.Min or 0
	local maxV    = o.Max or 100
	local step    = o.Step or 1
	local suffix  = o.Suffix or ""

	local function snap(v)
		local snapped = math.round((v - minV) / step) * step + minV
		return math.clamp(snapped, minV, maxV)
	end

	local current = snap(o.Default or minV)

	local title = lbl(row, o.Title or "Slider", 13, C.Text, {
		Position = UDim2.fromOffset(14, 4),
		Size = UDim2.new(1, -80, 0, 20),
	})

	local valBox = n("Frame", {
		BackgroundColor3 = C.Field,
		Size = UDim2.fromOffset(52, 20),
		Position = UDim2.new(1, -64, 0, 6),
		BorderSizePixel = 0,
	}, row)
	corner(valBox, 6)
	stroke(valBox, C.Border, 1)

	local valLbl = lbl(valBox, tostring(current) .. suffix, 11, C.Text, {
		Size = UDim2.fromScale(1, 1),
		TextXAlignment = Enum.TextXAlignment.Center,
		Font = Enum.Font.GothamMedium,
	})

	local trackBg = n("Frame", {
		BackgroundColor3 = C.SliderTrack,
		Size = UDim2.new(1, -28, 0, 4),
		Position = UDim2.new(0, 14, 1, -14),
		BorderSizePixel = 0,
	}, row)
	corner(trackBg, 4)
	stroke(trackBg, C.Border, 1)

	local fill = n("Frame", {
		BackgroundColor3 = C.Accent,
		Size = UDim2.fromScale(0, 1),
		BorderSizePixel = 0,
	}, trackBg)
	corner(fill, 4)

	local thumbF = n("Frame", {
		BackgroundColor3 = C.Thumb,
		Size = UDim2.fromOffset(14, 14),
		Position = UDim2.new(0, -7, 0.5, -7),
		BorderSizePixel = 0,
		ZIndex = 4,
	}, fill)
	corner(thumbF, 7)
	stroke(thumbF, C.Border, 1)

	local hitArea = n("TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 24),
		Position = UDim2.new(0, 0, 0, -10),
		Text = "",
		ZIndex = 5,
	}, trackBg)

	local function applyValue(v, silent)
		current = v
		local pct = (v - minV) / (maxV - minV)
		tween(fill, { Size = UDim2.fromScale(pct, 1) }, 0.06)
		valLbl.Text = tostring(v) .. suffix
		if not silent and o.Callback then pcall(o.Callback, v) end
	end

	applyValue(current, true)

	local dragging = false
	local function updateFromInput(input)
		local abs = trackBg.AbsolutePosition
		local sz  = trackBg.AbsoluteSize
		if sz.X < 1 then return end
		local pct = math.clamp((input.Position.X - abs.X) / sz.X, 0, 1)
		applyValue(snap(minV + pct * (maxV - minV)))
	end

	hitArea.MouseButton1Down:Connect(function(x, y)
		if ctrl._locked then return end
		dragging = true
		updateFromInput({ Position = Vector3.new(x, y, 0) })
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateFromInput(input)
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	ctrl._value = current
	ctrl._apply = function(v) applyValue(snap(v), true) end
	ctrl._callback = o.Callback
	function ctrl:Set(v, silent)
		applyValue(snap(v), silent)
		self._value = current
		return self
	end
	function ctrl:Get() return current end

	return ctrl
end

function Tab:Dropdown(opts)
	local o = opts or {}
	local C = self._window._C
	local ctrl, row = makeControl(self, 38)

	local options = o.Options or {}
	local current = o.Default or (options[1])
	local open = false
	local optionFrames = {}

	local title = lbl(row, o.Title or "Dropdown", 13, C.Text, {
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(1, -140, 1, 0),
	})

	local box = n("Frame", {
		BackgroundColor3 = C.Field,
		Size = UDim2.fromOffset(120, 26),
		Position = UDim2.new(1, -130, 0.5, -13),
		BorderSizePixel = 0,
		ClipsDescendants = false,
		ZIndex = 10,
	}, row)
	corner(box, 7)
	stroke(box, C.Border, 1)

	local boxHit = n("TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Text = "",
		ZIndex = 11,
	}, box)

	local boxLbl = lbl(box, tostring(current or ""), 12, C.Text, {
		Position = UDim2.fromOffset(8, 0),
		Size = UDim2.new(1, -28, 1, 0),
		ZIndex = 11,
	})

	local chevron = lbl(box, "▾", 13, C.Muted, {
		Position = UDim2.new(1, -22, 0, 0),
		Size = UDim2.fromOffset(18, 26),
		TextXAlignment = Enum.TextXAlignment.Center,
		Font = Enum.Font.GothamBold,
		ZIndex = 11,
	})

	local dropdown = n("Frame", {
		BackgroundColor3 = C.Panel,
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.new(0, 0, 1, 4),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 20,
		Visible = false,
	}, box)
	corner(dropdown, 7)
	stroke(dropdown, C.Border, 1)

	local dList = n("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 21,
	}, dropdown)
	listLayout(dList, nil, 2)
	pad(dList, 4, 4)

	local function closeDropdown()
		open = false
		tween(dropdown, { Size = UDim2.new(1, 0, 0, 0) }, 0.15)
		tween(chevron, { Rotation = 0 }, 0.15)
		task.delay(0.16, function()
			dropdown.Visible = false
		end)
	end

	local function selectOption(v, silent)
		current = v
		boxLbl.Text = tostring(v)
		closeDropdown()
		if not silent and o.Callback then pcall(o.Callback, v) end
	end

	local function buildOptions()
		for _, f in ipairs(optionFrames) do f:Destroy() end
		optionFrames = {}
		for _, opt in ipairs(options) do
			local optRow = n("Frame", {
				BackgroundColor3 = C.Row,
				BackgroundTransparency = 0.5,
				Size = UDim2.new(1, 0, 0, 28),
				BorderSizePixel = 0,
				ZIndex = 22,
			}, dList)
			corner(optRow, 6)
			local optHit = n("TextButton", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Text = "",
				ZIndex = 23,
			}, optRow)
			local optLbl = lbl(optRow, tostring(opt), 12, opt == current and C.Accent or C.Text, {
				Position = UDim2.fromOffset(8, 0),
				ZIndex = 23,
			})
			optHit.MouseEnter:Connect(function()
				tween(optRow, { BackgroundTransparency = 0.1 }, 0.1)
				tween(optLbl, { TextColor3 = C.AccentHover }, 0.1)
			end)
			optHit.MouseLeave:Connect(function()
				tween(optRow, { BackgroundTransparency = 0.5 }, 0.1)
				tween(optLbl, { TextColor3 = opt == current and C.Accent or C.Text }, 0.1)
			end)
			optHit.MouseButton1Up:Connect(function()
				if ctrl._locked then return end
				selectOption(opt)
				buildOptions()
			end)
			table.insert(optionFrames, optRow)
		end
	end

	buildOptions()

	local function openDropdown()
		open = true
		buildOptions()
		dropdown.Visible = true
		local contentH = dList.AbsoluteSize.Y > 0 and dList.AbsoluteSize.Y or (#options * 32 + 8)
		tween(dropdown, { Size = UDim2.new(1, 0, 0, contentH) }, 0.18, Enum.EasingStyle.Back)
		tween(chevron, { Rotation = 180 }, 0.15)
	end

	boxHit.MouseButton1Up:Connect(function()
		if ctrl._locked then return end
		if open then closeDropdown() else openDropdown() end
	end)

	ctrl._value = current
	ctrl._apply = function(v) selectOption(v, true) end
	ctrl._callback = o.Callback
	function ctrl:Set(v, silent)
		selectOption(v, silent)
		self._value = current
		return self
	end
	function ctrl:Get() return current end
	function ctrl:Refresh(newOptions)
		options = newOptions
		buildOptions()
	end

	return ctrl
end

function Tab:Input(opts)
	local o = opts or {}
	local C = self._window._C
	local ctrl, row = makeControl(self, 38)

	local title = lbl(row, o.Title or "Input", 13, C.Text, {
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(0.42, 0, 1, 0),
	})

	local fieldBg = n("Frame", {
		BackgroundColor3 = C.Field,
		Size = UDim2.new(0, 160, 0, 26),
		Position = UDim2.new(1, -170, 0.5, -13),
		BorderSizePixel = 0,
	}, row)
	corner(fieldBg, 7)
	local fStroke = stroke(fieldBg, C.Border, 1)

	local box = n("TextBox", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -16, 1, 0),
		Position = UDim2.fromOffset(8, 0),
		Text = o.Default or "",
		PlaceholderText = o.Placeholder or "...",
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		TextColor3 = C.Text,
		PlaceholderColor3 = C.Muted,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = o.ClearOnFocus ~= false,
	}, fieldBg)

	box.Focused:Connect(function()
		tween(fStroke, { Color = C.Accent }, 0.15)
	end)
	box.FocusLost:Connect(function(enter)
		tween(fStroke, { Color = C.Border }, 0.15)
		if o.Callback then pcall(o.Callback, box.Text) end
	end)
	if o.Live then
		box:GetPropertyChangedSignal("Text"):Connect(function()
			if o.Callback then pcall(o.Callback, box.Text) end
		end)
	end

	ctrl._value = box.Text
	ctrl._apply = function(v) box.Text = tostring(v or "") end
	ctrl._callback = o.Callback
	function ctrl:Set(v, silent)
		box.Text = tostring(v or "")
		self._value = box.Text
		if not silent and o.Callback then pcall(o.Callback, box.Text) end
		return self
	end
	function ctrl:Get() return box.Text end

	return ctrl
end

function Tab:Keybind(opts)
	local o = opts or {}
	local C = self._window._C
	local ctrl, row = makeControl(self, 38)

	local listening = false
	local current = o.Default

	local title = lbl(row, o.Title or "Keybind", 13, C.Text, {
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(1, -110, 1, 0),
	})

	local kBox = n("Frame", {
		BackgroundColor3 = C.Field,
		Size = UDim2.fromOffset(88, 26),
		Position = UDim2.new(1, -98, 0.5, -13),
		BorderSizePixel = 0,
	}, row)
	corner(kBox, 7)
	local kStroke = stroke(kBox, C.Border, 1)

	local kHit = n("TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Text = "",
	}, kBox)

	local kLbl = lbl(kBox, "None", 12, C.Text, {
		Size = UDim2.fromScale(1, 1),
		TextXAlignment = Enum.TextXAlignment.Center,
		Font = Enum.Font.GothamMedium,
	})

	local keyNames = {
		LeftControl = "LCtrl", RightControl = "RCtrl",
		LeftShift = "LShift", RightShift = "RShift",
		LeftAlt = "LAlt", RightAlt = "RAlt",
		MouseButton1 = "M1", MouseButton2 = "M2", MouseButton3 = "M3",
		Return = "Enter", BackSpace = "Back",
	}

	local function keyName(k)
		if typeof(k) ~= "EnumItem" then return "None" end
		return keyNames[k.Name] or k.Name
	end

	local function applyKey(k, silent)
		current = k
		kLbl.Text = keyName(k)
		kLbl.TextColor3 = C.Text
		tween(kStroke, { Color = C.Border }, 0.12)
		if not silent and o.Callback then pcall(o.Callback, k) end
	end

	applyKey(current, true)

	kHit.MouseButton1Up:Connect(function()
		if ctrl._locked or listening then return end
		listening = true
		kLbl.Text = "..."
		kLbl.TextColor3 = C.Muted
		tween(kStroke, { Color = C.Accent }, 0.12)
		local conn
		conn = UIS.InputBegan:Connect(function(input, proc)
			if proc then return end
			local key = input.KeyCode
			if key == Enum.KeyCode.Unknown or key == Enum.KeyCode.Escape then
				listening = false
				applyKey(current, true)
				if conn then conn:Disconnect() end
				return
			end
			listening = false
			applyKey(key)
			if conn then conn:Disconnect() end
		end)
	end)

	if o.Callback and (o.Mode == "Toggle" or o.Hold) then
		local active = false
		UIS.InputBegan:Connect(function(input, proc)
			if proc then return end
			if current and input.KeyCode == current then
				if o.Mode == "Toggle" then
					active = not active
					pcall(o.Callback, active)
				elseif o.Hold then
					pcall(o.Callback, true)
				end
			end
		end)
		if o.Hold then
			UIS.InputEnded:Connect(function(input)
				if current and input.KeyCode == current then
					pcall(o.Callback, false)
				end
			end)
		end
	end

	ctrl._value = current
	ctrl._apply = function(v) applyKey(v, true) end
	ctrl._callback = o.Callback
	function ctrl:Set(v, silent)
		local k = v
		if type(v) == "string" and Enum.KeyCode[v] then k = Enum.KeyCode[v] end
		applyKey(k, silent)
		self._value = current
		return self
	end
	function ctrl:Get() return current end

	return ctrl
end

function Tab:Colorpicker(opts)
	local o = opts or {}
	local C = self._window._C
	local ctrl, row = makeControl(self, 38)

	local current = o.Default or Color3.fromRGB(255, 255, 255)

	local title = lbl(row, o.Title or "Color", 13, C.Text, {
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(1, -68, 1, 0),
	})

	local swatch = n("Frame", {
		BackgroundColor3 = current,
		Size = UDim2.fromOffset(36, 22),
		Position = UDim2.new(1, -50, 0.5, -11),
		BorderSizePixel = 0,
	}, row)
	corner(swatch, 7)
	stroke(swatch, C.Border, 1)

	local hit = n("TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Text = "",
		ZIndex = 5,
	}, row)

	local popupOpen = false
	local popup = nil
	local popupConns = {}

	local function cleanPopup()
		popupOpen = false
		for _, c in ipairs(popupConns) do pcall(function() c:Disconnect() end) end
		popupConns = {}
		if popup then
			tween(popup, { BackgroundTransparency = 1 }, 0.14)
			task.delay(0.15, function()
				if popup then popup:Destroy(); popup = nil end
			end)
		end
	end

	hit.MouseButton1Up:Connect(function()
		if ctrl._locked then return end
		if popupOpen then cleanPopup(); return end
		popupOpen = true

		local gui = row:FindFirstAncestorOfClass("ScreenGui")
		if not gui then return end

		popup = n("Frame", {
			BackgroundColor3 = C.Panel,
			Size = UDim2.fromOffset(220, 210),
			Position = UDim2.new(0, row.AbsolutePosition.X, 0, row.AbsolutePosition.Y + 40),
			BorderSizePixel = 0,
			ZIndex = 50,
			BackgroundTransparency = 0,
		}, gui)
		corner(popup, 10)
		stroke(popup, C.Border, 1)
		pad(popup, 10, 10)

		local h, s, v = current:ToHSV()
		if s < 0.001 then h = 0 end

		local sv = n("Frame", {
			BackgroundColor3 = Color3.fromHSV(h, 1, 1),
			Size = UDim2.new(1, 0, 0, 140),
			BorderSizePixel = 0,
			ZIndex = 51,
		}, popup)
		corner(sv, 7)

		local white = n("Frame", { BackgroundColor3 = Color3.new(1,1,1), Size = UDim2.fromScale(1,1), ZIndex = 52 }, sv)
		corner(white, 7)
		n("UIGradient", { Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1)), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}) }, white)

		local black = n("Frame", { BackgroundColor3 = Color3.new(0,0,0), Size = UDim2.fromScale(1,1), ZIndex = 53 }, sv)
		corner(black, 7)
		n("UIGradient", { Rotation = 90, Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(0,0,0)), Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0)}) }, black)

		local cursor = n("Frame", {
			BackgroundColor3 = Color3.new(1,1,1),
			Size = UDim2.fromOffset(10, 10),
			Position = UDim2.new(s, -5, 1-v, -5),
			BorderSizePixel = 0,
			ZIndex = 60,
		}, sv)
		corner(cursor, 5)
		stroke(cursor, Color3.new(0,0,0), 1)

		local hueBar = n("Frame", {
			Size = UDim2.new(1, 0, 0, 14),
			Position = UDim2.new(0, 0, 1, 10),
			BorderSizePixel = 0,
			ZIndex = 51,
		}, sv)
		corner(hueBar, 7)
		local hueGrad = n("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0,    Color3.fromHSV(0,1,1)),
				ColorSequenceKeypoint.new(0.166,Color3.fromHSV(0.166,1,1)),
				ColorSequenceKeypoint.new(0.333,Color3.fromHSV(0.333,1,1)),
				ColorSequenceKeypoint.new(0.5,  Color3.fromHSV(0.5,1,1)),
				ColorSequenceKeypoint.new(0.666,Color3.fromHSV(0.666,1,1)),
				ColorSequenceKeypoint.new(0.833,Color3.fromHSV(0.833,1,1)),
				ColorSequenceKeypoint.new(1,    Color3.fromHSV(1,1,1)),
			}),
		}, hueBar)

		local hueCursor = n("Frame", {
			BackgroundColor3 = Color3.new(1,1,1),
			Size = UDim2.fromOffset(10, 14),
			Position = UDim2.new(h, -5, 0, 0),
			BorderSizePixel = 0,
			ZIndex = 60,
		}, hueBar)
		corner(hueCursor, 3)
		stroke(hueCursor, Color3.new(0,0,0), 1)

		local previewRow = n("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 24),
			Position = UDim2.new(0, 0, 1, 34),
			ZIndex = 51,
		}, sv)

		local previewSwatch = n("Frame", {
			BackgroundColor3 = current,
			Size = UDim2.fromOffset(24, 24),
			BorderSizePixel = 0,
			ZIndex = 52,
		}, previewRow)
		corner(previewSwatch, 6)
		stroke(previewSwatch, C.Border, 1)

		local hexBox = n("TextBox", {
			BackgroundColor3 = C.Field,
			Size = UDim2.new(1, -32, 1, 0),
			Position = UDim2.fromOffset(30, 0),
			Text = string.format("#%02X%02X%02X", math.floor(current.R*255+0.5), math.floor(current.G*255+0.5), math.floor(current.B*255+0.5)),
			TextSize = 12,
			Font = Enum.Font.GothamMedium,
			TextColor3 = C.Text,
			TextXAlignment = Enum.TextXAlignment.Center,
			BorderSizePixel = 0,
			ZIndex = 52,
		}, previewRow)
		corner(hexBox, 6)
		stroke(hexBox, C.Border, 1)

		local function applyHSV()
			local col = Color3.fromHSV(h, s, v)
			current = col
			swatch.BackgroundColor3 = col
			previewSwatch.BackgroundColor3 = col
			sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			cursor.Position = UDim2.new(s, -5, 1-v, -5)
			hueCursor.Position = UDim2.new(h, -5, 0, 0)
			hexBox.Text = string.format("#%02X%02X%02X", math.floor(col.R*255+0.5), math.floor(col.G*255+0.5), math.floor(col.B*255+0.5))
			if o.Callback then pcall(o.Callback, col) end
		end

		local svDrag = false
		local hueDrag = false

		local c1 = sv.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				svDrag = true
				local abs = sv.AbsolutePosition
				local sz = sv.AbsoluteSize
				if sz.X < 1 then return end
				s = math.clamp((input.Position.X - abs.X) / sz.X, 0, 1)
				v = 1 - math.clamp((input.Position.Y - abs.Y) / sz.Y, 0, 1)
				applyHSV()
			end
		end)
		local c2 = hueBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				hueDrag = true
				local abs = hueBar.AbsolutePosition
				local sz = hueBar.AbsoluteSize
				if sz.X < 1 then return end
				h = math.clamp((input.Position.X - abs.X) / sz.X, 0, 1)
				applyHSV()
			end
		end)
		local c3 = UIS.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				if svDrag then
					local abs = sv.AbsolutePosition
					local sz = sv.AbsoluteSize
					if sz.X < 1 then return end
					s = math.clamp((input.Position.X - abs.X) / sz.X, 0, 1)
					v = 1 - math.clamp((input.Position.Y - abs.Y) / sz.Y, 0, 1)
					applyHSV()
				elseif hueDrag then
					local abs = hueBar.AbsolutePosition
					local sz = hueBar.AbsoluteSize
					if sz.X < 1 then return end
					h = math.clamp((input.Position.X - abs.X) / sz.X, 0, 1)
					applyHSV()
				end
			end
		end)
		local c4 = UIS.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				svDrag = false
				hueDrag = false
			end
		end)
		local c5 = hexBox.FocusLost:Connect(function()
			local hex = hexBox.Text:gsub("#", "")
			if #hex == 6 and hex:match("^%x+$") then
				local col = Color3.fromHex("#" .. hex)
				local nh, ns, nv = col:ToHSV()
				h, s, v = nh, ns, nv
				applyHSV()
			end
		end)

		local c6 = UIS.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				local pos = input.Position
				local pabs = popup.AbsolutePosition
				local psz  = popup.AbsoluteSize
				if pos.X < pabs.X or pos.X > pabs.X + psz.X or pos.Y < pabs.Y or pos.Y > pabs.Y + psz.Y then
					cleanPopup()
				end
			end
		end)

		popupConns = {c1,c2,c3,c4,c5,c6}
	end)

	ctrl._value = current
	ctrl._apply = function(v)
		current = v
		swatch.BackgroundColor3 = v
	end
	ctrl._callback = o.Callback
	function ctrl:Set(v, silent)
		current = v
		swatch.BackgroundColor3 = v
		self._value = v
		if not silent and o.Callback then pcall(o.Callback, v) end
		return self
	end
	function ctrl:Get() return current end

	return ctrl
end

function Tab:Label(text)
	local C = self._window._C
	local row = n("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 22),
		BorderSizePixel = 0,
		LayoutOrder = self._order,
	}, self._list)
	self._order = self._order + 1

	local l = lbl(row, tostring(text or ""), 12, C.Muted, {
		Position = UDim2.fromOffset(14, 0),
		Size = UDim2.new(1, -28, 1, 0),
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Center,
	})

	local ctrl = setmetatable({ _root = row, _window = self._window }, Control)
	function ctrl:SetText(t) l.Text = tostring(t or "") end
	return ctrl
end

function Tab:Section(name)
	local C = self._window._C
	local row = n("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 28),
		BorderSizePixel = 0,
		LayoutOrder = self._order,
	}, self._list)
	self._order = self._order + 1

	local lineL = n("Frame", {
		BackgroundColor3 = C.Border,
		Size = UDim2.new(0.3, -40, 0, 1),
		Position = UDim2.new(0, 14, 0.5, 0),
		BorderSizePixel = 0,
	}, row)

	local sect = lbl(row, string.upper(tostring(name or "")), 10, C.Faint, {
		Size = UDim2.new(0.4, 0, 1, 0),
		Position = UDim2.new(0.3, -30, 0, 0),
		TextXAlignment = Enum.TextXAlignment.Center,
		Font = Enum.Font.GothamBold,
		LetterSpacing = 1,
	})

	local lineR = n("Frame", {
		BackgroundColor3 = C.Border,
		Size = UDim2.new(0.3, -40, 0, 1),
		Position = UDim2.new(0.7, 26, 0.5, 0),
		BorderSizePixel = 0,
	}, row)

	local ctrl = setmetatable({ _root = row, _window = self._window }, Control)
	function ctrl:SetText(t)
		sect.Text = string.upper(tostring(t or ""))
	end
	return ctrl
end

function Tab:Divider()
	local C = self._window._C
	local row = n("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 12),
		BorderSizePixel = 0,
		LayoutOrder = self._order,
	}, self._list)
	self._order = self._order + 1

	n("Frame", {
		BackgroundColor3 = C.Border,
		BackgroundTransparency = 0.4,
		Size = UDim2.new(1, -28, 0, 1),
		Position = UDim2.new(0, 14, 0.5, 0),
		BorderSizePixel = 0,
	}, row)
end

local Window = {}
Window.__index = Window

function Window:Tab(name)
	local C = self._C
	local tabData = {
		_window = self,
		_order  = 0,
	}

	local navBtn = n("TextButton", {
		BackgroundColor3 = C.Panel,
		BackgroundTransparency = 0.5,
		Size = UDim2.new(1, -8, 0, 32),
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		LayoutOrder = #self._tabs + 1,
	}, self._navList)
	corner(navBtn, 8)

	local indicator = n("Frame", {
		BackgroundColor3 = C.Accent,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(3, 16),
		Position = UDim2.new(0, 4, 0.5, -8),
		BorderSizePixel = 0,
	}, navBtn)
	corner(indicator, 3)

	local navLbl = lbl(navBtn, tostring(name), 12, C.Muted, {
		Position = UDim2.fromOffset(18, 0),
		Size = UDim2.new(1, -22, 1, 0),
		Font = Enum.Font.GothamMedium,
	})

	local page = n("ScrollingFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = C.Faint,
		ScrollBarImageTransparency = 0,
		CanvasSize = UDim2.fromScale(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		Visible = false,
	}, self._pages)

	listLayout(page, nil, 5)
	pad(page, 8, 6)

	tabData._list = page
	tabData._navBtn = navBtn
	tabData._indicator = indicator
	tabData._navLbl = navLbl

	local tabObj = setmetatable(tabData, Tab)
	table.insert(self._tabs, tabObj)

	local function selectTab(t)
		for _, other in ipairs(self._tabs) do
			other._navBtn.BackgroundTransparency = 0.5
			tween(other._indicator, { BackgroundTransparency = 1 }, 0.15)
			tween(other._navLbl, { TextColor3 = C.Muted }, 0.15)
			other._list.Visible = false
		end
		t._navBtn.BackgroundTransparency = 0.15
		t._navBtn.BackgroundColor3 = C.NavActive
		tween(t._indicator, { BackgroundTransparency = 0 }, 0.2)
		tween(t._navLbl, { TextColor3 = C.Text }, 0.15)
		t._list.Visible = true
		self._currentTab = t
	end

	navBtn.MouseButton1Up:Connect(function()
		selectTab(tabObj)
	end)
	navBtn.MouseEnter:Connect(function()
		if self._currentTab ~= tabObj then
			tween(navBtn, { BackgroundColor3 = C.NavHover, BackgroundTransparency = 0.3 }, 0.12)
		end
	end)
	navBtn.MouseLeave:Connect(function()
		if self._currentTab ~= tabObj then
			tween(navBtn, { BackgroundColor3 = C.Panel, BackgroundTransparency = 0.5 }, 0.12)
		end
	end)

	if #self._tabs == 1 then
		selectTab(tabObj)
	end

	return tabObj
end

function Window:SetTheme(name)
	local def = THEMES[name]
	if not def then return self end
	self._themeName = name
	self._C = def

	local C = def
	self._root.BackgroundColor3 = C.Background
	self._topBar.BackgroundColor3 = C.TopBar
	self._sidebar.BackgroundColor3 = C.Sidebar
	self._titleLbl.TextColor3 = C.Text
	stroke(self._root, C.Border, 1)

	for _, t in ipairs(self._tabs) do
		tween(t._navLbl, { TextColor3 = self._currentTab == t and C.Text or C.Muted }, 0.1)
		if self._currentTab == t then
			t._indicator.BackgroundColor3 = C.Accent
		end
	end
	return self
end

function Window:Notify(opts)
	local o = opts or {}
	local C = self._C
	local gui = self._gui

	local holder = n("Frame", {
		BackgroundColor3 = C.Notification,
		Size = UDim2.fromOffset(240, 54),
		Position = UDim2.new(1, 260, 0, 16),
		BorderSizePixel = 0,
		ZIndex = 100,
		AnchorPoint = Vector2.new(1, 0),
	}, gui)
	corner(holder, 10)
	stroke(holder, C.Border, 1)
	pad(holder, 12, 0)

	local accentBar = n("Frame", {
		BackgroundColor3 = C.Accent,
		Size = UDim2.fromOffset(3, 34),
		Position = UDim2.new(0, -12, 0.5, -17),
		BorderSizePixel = 0,
		ZIndex = 101,
	}, holder)
	corner(accentBar, 4)

	lbl(holder, o.Title or "Aviso", 12, C.Text, {
		Size = UDim2.new(1, 0, 0, 22),
		Position = UDim2.fromOffset(6, 6),
		Font = Enum.Font.GothamBold,
		ZIndex = 101,
	})
	lbl(holder, o.Content or "", 11, C.Muted, {
		Size = UDim2.new(1, 0, 0, 16),
		Position = UDim2.fromOffset(6, 28),
		ZIndex = 101,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	local bar = n("Frame", {
		BackgroundColor3 = C.Accent,
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		ZIndex = 102,
	}, n("Frame", {
		BackgroundColor3 = C.Border,
		Size = UDim2.new(1, 0, 0, 2),
		Position = UDim2.new(0, 0, 1, -2),
		BorderSizePixel = 0,
		ZIndex = 101,
	}, holder))

	local dur = o.Duration or 4
	table.insert(self._notices or {}, holder)
	self._notices = self._notices or {}

	local function layoutNotices()
		local y = 16
		local notices = self._notices
		for i = #notices, 1, -1 do
			local item = notices[i]
			if item and item.Parent then
				tween(item, { Position = UDim2.new(1, -16, 0, y) }, 0.2)
				y = y + 64
			else
				table.remove(notices, i)
			end
		end
	end

	task.defer(function()
		layoutNotices()
		tween(bar, { Size = UDim2.fromScale(0, 1) }, dur, Enum.EasingStyle.Linear)
	end)

	local closed = false
	local function close()
		if closed then return end
		closed = true
		tween(holder, { Position = UDim2.new(1, 260, 0, holder.Position.Y.Offset), BackgroundTransparency = 1 }, 0.18)
		task.delay(0.2, function()
			if holder.Parent then holder:Destroy() end
			for i, item in ipairs(self._notices or {}) do
				if item == holder then table.remove(self._notices, i); break end
			end
			layoutNotices()
		end)
	end

	task.delay(dur, close)
	return { Close = close }
end

function Window:Open()
	if self._destroyed then return self end
	self._open = true
	self._root.Visible = true
	tween(self._root, { BackgroundTransparency = 0 }, 0.2, Enum.EasingStyle.Quart)
	if self._scale then
		self._scale.Scale = 0.92
		tween(self._scale, { Scale = 1 }, 0.28, Enum.EasingStyle.Back)
	end
	return self
end

function Window:Close()
	if self._destroyed then return self end
	self._open = false
	tween(self._root, { BackgroundTransparency = 1 }, 0.16)
	if self._scale then
		tween(self._scale, { Scale = 0.92 }, 0.16)
	end
	task.delay(0.17, function()
		if not self._open then self._root.Visible = false end
	end)
	return self
end

function Window:Toggle()
	if self._open then return self:Close() else return self:Open() end
end

function Window:Minimize()
	if self._minimized then
		self._minimized = false
		self._sidebar.Visible = true
		self._pages.Visible = true
		tween(self._root, { Size = UDim2.fromOffset(self._width, self._height) }, 0.22, Enum.EasingStyle.Back)
	else
		self._minimized = true
		tween(self._root, { Size = UDim2.fromOffset(self._width, 34) }, 0.18, Enum.EasingStyle.Quart)
		task.delay(0.18, function()
			if self._minimized then
				self._sidebar.Visible = false
				self._pages.Visible = false
			end
		end)
	end
	return self
end

function Window:SetTitle(t)
	self._titleLbl.Text = tostring(t or "")
	return self
end

function Window:Destroy()
	if self._destroyed then return end
	self._destroyed = true
	if self._gui then self._gui:Destroy() end
end

local Hub = {}
Hub.__index = Hub

function Hub:Window(opts)
	local o = opts or {}
	local themeName = o.Theme or "Void"
	local C = THEMES[themeName] or THEMES.Void

	local env = (getgenv and getgenv()) or _G
	if env.__OPENHUB_WIN and not env.__OPENHUB_WIN._destroyed then
		pcall(function() env.__OPENHUB_WIN:Destroy() end)
	end

	local gui = n("ScreenGui", {
		Name           = "OpenHub",
		ResetOnSpawn   = false,
		IgnoreGuiInset = true,
		DisplayOrder   = 2147483000,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, safeParent)
	pcall(function() gui.ScreenInsets = Enum.ScreenInsets.None end)
	pcall(function()
		if protectgui then protectgui(gui)
		elseif syn and syn.protect_gui then syn.protect_gui(gui) end
	end)

	local W = o.Width  or 640
	local H = o.Height or 420

	local root = n("Frame", {
		Name             = "OpenHubRoot",
		BackgroundColor3 = C.Background,
		AnchorPoint      = Vector2.new(0.5, 0.5),
		Position         = UDim2.fromScale(0.5, 0.5),
		Size             = UDim2.fromOffset(W, H),
		BorderSizePixel  = 0,
		ClipsDescendants = true,
	}, gui)
	corner(root, 12)
	local rootStroke = stroke(root, C.Border, 1)
	local sc = n("UIScale", { Scale = 1 }, root)

	local topBar = n("Frame", {
		Name             = "TopBar",
		BackgroundColor3 = C.TopBar,
		Size             = UDim2.new(1, 0, 0, 34),
		BorderSizePixel  = 0,
	}, root)

	local topRule = n("Frame", {
		BackgroundColor3 = C.Border,
		Size             = UDim2.new(1, 0, 0, 1),
		Position         = UDim2.new(0, 0, 1, 0),
		BorderSizePixel  = 0,
	}, topBar)

	local titleLbl = lbl(topBar, o.Title or "OpenHub", 13, C.Text, {
		Position = UDim2.fromOffset(14, 0),
		Size     = UDim2.new(1, -100, 1, 0),
		Font     = Enum.Font.GothamBold,
	})

	local dotHolder = n("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position    = UDim2.fromScale(0.5, 0.5),
		Size        = UDim2.fromOffset(50, 10),
	}, topBar)

	for i = 1, 5 do
		n("Frame", {
			BackgroundColor3    = C.Faint,
			BackgroundTransparency = 0.3,
			Size                = UDim2.fromOffset(3, 3),
			Position            = UDim2.fromOffset((i-1) * 10, 3),
			BorderSizePixel     = 0,
		}, dotHolder)
	end

	local controls = n("Frame", {
		BackgroundTransparency = 1,
		Size     = UDim2.fromOffset(70, 34),
		Position = UDim2.new(1, -74, 0, 0),
	}, topBar)

	local function ctrlBtn(char, xOffset)
		local b = n("TextButton", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(28, 28),
			Position = UDim2.new(0, xOffset, 0.5, -14),
			Text = char,
			TextSize = 14,
			Font = Enum.Font.GothamBold,
			TextColor3 = C.Muted,
			AutoButtonColor = false,
		}, controls)
		b.MouseEnter:Connect(function() tween(b, { TextColor3 = C.Text }, 0.1) end)
		b.MouseLeave:Connect(function() tween(b, { TextColor3 = C.Muted }, 0.1) end)
		return b
	end

	local minBtn   = ctrlBtn("—", 0)
	local closeBtn = ctrlBtn("×", 34)

	local body = n("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 34),
		Size     = UDim2.new(1, 0, 1, -34),
	}, root)

	local sidebar = n("Frame", {
		BackgroundColor3 = C.Sidebar,
		Size             = UDim2.new(0, 130, 1, 0),
		BorderSizePixel  = 0,
	}, body)

	local sideRule = n("Frame", {
		BackgroundColor3 = C.Border,
		Size             = UDim2.new(0, 1, 1, 0),
		Position         = UDim2.new(1, 0, 0, 0),
		BorderSizePixel  = 0,
	}, sidebar)

	local navScroll = scrollFrame(sidebar, {
		Size              = UDim2.new(1, 0, 1, -8),
		Position          = UDim2.fromOffset(0, 4),
		ScrollBarThickness = 0,
	})

	local navList = n("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
	}, navScroll)
	listLayout(navList, nil, 3)
	pad(navList, 4, 4)

	local pages = n("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(130, 0),
		Size     = UDim2.new(1, -130, 1, 0),
	}, body)

	local resizeGrip = n("TextButton", {
		BackgroundTransparency = 1,
		Size     = UDim2.fromOffset(20, 20),
		Position = UDim2.new(1, -20, 1, -20),
		Text     = "",
		ZIndex   = 10,
	}, root)

	for i = 1, 3 do
		n("Frame", {
			BackgroundColor3    = C.Faint,
			BackgroundTransparency = 0.2,
			Size                = UDim2.fromOffset(i * 3, 1),
			Position            = UDim2.new(1, -(i * 3 + 2), 1, -(i * 3)),
			BorderSizePixel     = 0,
			ZIndex              = 11,
		}, root)
	end

	local win = setmetatable({
		_gui        = gui,
		_root       = root,
		_topBar     = topBar,
		_sidebar    = sidebar,
		_pages      = pages,
		_navList    = navList,
		_titleLbl   = titleLbl,
		_scale      = sc,
		_C          = C,
		_themeName  = themeName,
		_tabs       = {},
		_currentTab = nil,
		_notices    = {},
		_open       = true,
		_minimized  = false,
		_destroyed  = false,
		_width      = W,
		_height     = H,
	}, Window)

	env.__OPENHUB_WIN = win

	minBtn.MouseButton1Up:Connect(function()
		win:Minimize()
	end)
	closeBtn.MouseButton1Up:Connect(function()
		win:Close()
	end)

	local dragging = false
	local dragStart
	local startPos

	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if input.Position.X > controls.AbsolutePosition.X then return end
			dragging = true
			dragStart = input.Position
			startPos = root.Position
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			local parentSz = gui.AbsoluteSize
			local rx = startPos.X.Scale * parentSz.X + startPos.X.Offset + delta.X
			local ry = startPos.Y.Scale * parentSz.Y + startPos.Y.Offset + delta.Y
			rx = math.clamp(rx, W/2, parentSz.X - W/2)
			ry = math.clamp(ry, H/2, parentSz.Y - H/2)
			root.Position = UDim2.new(0, rx, 0, ry)
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	local resizing = false
	local resizeStart
	local resizeStartW
	local resizeStartH

	resizeGrip.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = true
			resizeStart = input.Position
			resizeStartW = root.AbsoluteSize.X
			resizeStartH = root.AbsoluteSize.Y
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - resizeStart
			local nw = math.clamp(resizeStartW + delta.X, 400, 900)
			local nh = math.clamp(resizeStartH + delta.Y, 280, 700)
			win._width  = nw
			win._height = nh
			root.Size = UDim2.fromOffset(nw, nh)
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = false
		end
	end)

	local toggleKey = o.ToggleKey or Enum.KeyCode.RightShift
	UIS.InputBegan:Connect(function(input, proc)
		if proc then return end
		if input.KeyCode == toggleKey then
			win:Toggle()
		end
	end)

	return win
end

local OpenHub = setmetatable({}, Hub)

return OpenHub
