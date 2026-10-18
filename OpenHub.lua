local OpenHubUI = {}
OpenHubUI.Version = "2.0.0"
OpenHubUI.Themes = {
    Midnight = {
        Background = Color3.fromRGB(9, 10, 15),
        Panel = Color3.fromRGB(14, 16, 24),
        Surface = Color3.fromRGB(20, 23, 33),
        Accent = Color3.fromRGB(139, 110, 255),
        Accent2 = Color3.fromRGB(90, 190, 255),
        Text = Color3.fromRGB(245, 247, 255),
        Muted = Color3.fromRGB(150, 156, 175),
        Stroke = Color3.fromRGB(70, 76, 100),
        Transparency = 0.12,
        Acrylic = 0.22
    },
    Obsidian = {
        Background = Color3.fromRGB(4, 5, 7),
        Panel = Color3.fromRGB(10, 11, 14),
        Surface = Color3.fromRGB(16, 17, 21),
        Accent = Color3.fromRGB(235, 235, 242),
        Accent2 = Color3.fromRGB(150, 155, 168),
        Text = Color3.fromRGB(250, 250, 252),
        Muted = Color3.fromRGB(140, 142, 150),
        Stroke = Color3.fromRGB(55, 58, 68),
        Transparency = 0.08,
        Acrylic = 0.18
    },
    Aurora = {
        Background = Color3.fromRGB(4, 11, 14),
        Panel = Color3.fromRGB(8, 18, 22),
        Surface = Color3.fromRGB(12, 26, 32),
        Accent = Color3.fromRGB(70, 230, 185),
        Accent2 = Color3.fromRGB(80, 175, 255),
        Text = Color3.fromRGB(235, 255, 250),
        Muted = Color3.fromRGB(130, 170, 165),
        Stroke = Color3.fromRGB(45, 110, 105),
        Transparency = 0.12,
        Acrylic = 0.22
    },
    Crimson = {
        Background = Color3.fromRGB(12, 5, 7),
        Panel = Color3.fromRGB(20, 9, 12),
        Surface = Color3.fromRGB(30, 14, 18),
        Accent = Color3.fromRGB(255, 70, 100),
        Accent2 = Color3.fromRGB(255, 140, 100),
        Text = Color3.fromRGB(255, 245, 248),
        Muted = Color3.fromRGB(175, 135, 145),
        Stroke = Color3.fromRGB(110, 50, 65),
        Transparency = 0.12,
        Acrylic = 0.22
    },
    Sapphire = {
        Background = Color3.fromRGB(4, 7, 14),
        Panel = Color3.fromRGB(8, 13, 24),
        Surface = Color3.fromRGB(13, 20, 35),
        Accent = Color3.fromRGB(70, 140, 255),
        Accent2 = Color3.fromRGB(95, 215, 255),
        Text = Color3.fromRGB(240, 247, 255),
        Muted = Color3.fromRGB(130, 150, 185),
        Stroke = Color3.fromRGB(45, 80, 140),
        Transparency = 0.12,
        Acrylic = 0.22
    },
    Sakura = {
        Background = Color3.fromRGB(13, 7, 12),
        Panel = Color3.fromRGB(21, 12, 20),
        Surface = Color3.fromRGB(32, 18, 30),
        Accent = Color3.fromRGB(255, 125, 195),
        Accent2 = Color3.fromRGB(185, 140, 255),
        Text = Color3.fromRGB(255, 245, 252),
        Muted = Color3.fromRGB(180, 140, 170),
        Stroke = Color3.fromRGB(115, 65, 105),
        Transparency = 0.12,
        Acrylic = 0.22
    },
    Ember = {
        Background = Color3.fromRGB(12, 8, 4),
        Panel = Color3.fromRGB(22, 14, 8),
        Surface = Color3.fromRGB(34, 22, 12),
        Accent = Color3.fromRGB(255, 155, 60),
        Accent2 = Color3.fromRGB(255, 210, 110),
        Text = Color3.fromRGB(255, 248, 235),
        Muted = Color3.fromRGB(180, 150, 120),
        Stroke = Color3.fromRGB(120, 80, 40),
        Transparency = 0.12,
        Acrylic = 0.22
    }
}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        pcall(function() obj[k] = v end)
    end
    if parent then obj.Parent = parent end
    return obj
end
local function corner(parent, radius)
    return make("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, parent)
end
local function stroke(parent, color, transparency, thickness)
    return make("UIStroke", {
        Color = color or Color3.new(1, 1, 1),
        Transparency = transparency or 0.7,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, parent)
end
local function pad(parent, x, y, top, bottom)
    return make("UIPadding", {
        PaddingLeft = UDim.new(0, x or 10),
        PaddingRight = UDim.new(0, x or 10),
        PaddingTop = UDim.new(0, top or y or 8),
        PaddingBottom = UDim.new(0, bottom or y or 8)
    }, parent)
end
local function tween(obj, time, props, style, direction)
    local t = TweenService:Create(obj, TweenInfo.new(
        time or 0.2,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    ), props)
    t:Play()
    return t
end
local function assetId(value)
    if typeof(value) == "number" then return "rbxassetid://" .. value end
    if typeof(value) ~= "string" then return "" end
    if value:match("^%d+$") then return "rbxassetid://" .. value end
    return value
end
local function resolveAsset(path)
    if typeof(path) ~= "string" then return nil end
    if path:match("^rbxassetid://") or path:match("^https?://") then return path end
    if getcustomasset then
        local ok, result = pcall(getcustomasset, path)
        if ok then return result end
    end
    return nil
end
local function deepCopy(source)
    local out = {}
    for k, v in pairs(source) do out[k] = v end
    return out
end
local function lerpColor(a, b, t)
    return Color3.new(
        a.R + (b.R - a.R) * t,
        a.G + (b.G - a.G) * t,
        a.B + (b.B - a.B) * t
    )
end
function OpenHubUI:CreateWindow(config)
    config = config or {}
    local themeName = config.Theme or "Obsidian"
    local theme = deepCopy(self.Themes[themeName] or self.Themes.Obsidian)
    local transparency = math.clamp(tonumber(config.Transparency) or theme.Transparency or 0.1, 0, 0.9)
    local acrylic = math.clamp(tonumber(config.Acrylic) or theme.Acrylic or 0.2, 0, 0.85)
    local guiParent = CoreGui
    pcall(function() if gethui then guiParent = gethui() end end)
    local gui = make("ScreenGui", {
        Name = "OpenHubUI_" .. HttpService:GenerateGUID(false):gsub("-", ""),
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, guiParent)
    local state = {
        Theme = theme,
        ThemeName = themeName,
        Transparency = transparency,
        Acrylic = acrylic,
        BackgroundImage = nil,
        Tabs = {},
        Elements = {},
        Connections = {},
        Open = true,
        Destroyed = false
    }
    local scale = make("UIScale", {Scale = 1}, nil)
    local camera = workspace.CurrentCamera
    local function updateScale()
        if camera then
            local width = camera.ViewportSize.X
            scale.Scale = width < 520 and 0.78 or (width < 760 and 0.90 or 1)
        end
    end
    local DEFAULT_W, DEFAULT_H = 600, 480
    local winW = config.Width or DEFAULT_W
    local winH = config.Height or DEFAULT_H
    local root = make("Frame", {
        Name = "Root",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(winW, winH),
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = transparency,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, gui)
    scale.Parent = root
    corner(root, 14)
    local rootStroke = stroke(root, theme.Stroke, 0.35, 1)
    local rootGradient = make("UIGradient", {
        Rotation = 135,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.Panel),
            ColorSequenceKeypoint.new(1, theme.Background)
        })
    }, root)
    local bg = make("ImageLabel", {
        Name = "BackgroundImage",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ImageTransparency = 0.62,
        ScaleType = Enum.ScaleType.Crop,
        Image = "",
        ZIndex = 0
    }, root)
    corner(bg, 14)
    local darkOverlay = make("Frame", {
        Name = "AcrylicOverlay",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = acrylic,
        BorderSizePixel = 0,
        ZIndex = 1
    }, root)
    corner(darkOverlay, 14)
    local shine = make("Frame", {
        Name = "TopShine",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.94,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 0, 1),
        ZIndex = 8
    }, root)
    local header = make("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 52),
        ZIndex = 3
    }, root)
    local logo = make("ImageLabel", {
        Name = "Logo",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(16, 11),
        Size = UDim2.fromOffset(28, 28),
        Image = assetId(config.Icon or ""),
        ImageColor3 = theme.Accent
    }, header)
    local title = make("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(config.Icon and 52 or 18, 8),
        Size = UDim2.new(1, -140, 0, 22),
        Font = Enum.Font.GothamBold,
        Text = config.Title or "OpenHub",
        TextSize = 16,
        TextColor3 = theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4
    }, header)
    local subtitle = make("TextLabel", {
        Name = "Subtitle",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(config.Icon and 53 or 19, 29),
        Size = UDim2.new(1, -150, 0, 15),
        Font = Enum.Font.Gotham,
        Text = config.Subtitle or "Interface Suite",
        TextSize = 11,
        TextColor3 = theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4
    }, header)
    local close = make("TextButton", {
        Name = "Close",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -12, 0, 11),
        Size = UDim2.fromOffset(28, 28),
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.15,
        Text = "×",
        TextSize = 20,
        Font = Enum.Font.Gotham,
        TextColor3 = theme.Text,
        AutoButtonColor = false,
        ZIndex = 5
    }, header)
    corner(close, 8)
    local minimize = make("TextButton", {
        Name = "Minimize",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -46, 0, 11),
        Size = UDim2.fromOffset(28, 28),
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.15,
        Text = "−",
        TextSize = 20,
        Font = Enum.Font.Gotham,
        TextColor3 = theme.Text,
        AutoButtonColor = false,
        ZIndex = 5
    }, header)
    corner(minimize, 8)
    close.MouseEnter:Connect(function()
        tween(close, 0.12, {BackgroundColor3 = Color3.fromRGB(220, 70, 80), BackgroundTransparency = 0})
    end)
    close.MouseLeave:Connect(function()
        tween(close, 0.12, {BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.15})
    end)
    minimize.MouseEnter:Connect(function()
        tween(minimize, 0.12, {BackgroundTransparency = 0})
    end)
    minimize.MouseLeave:Connect(function()
        tween(minimize, 0.12, {BackgroundTransparency = 0.15})
    end)
    local divider = make("Frame", {
        Name = "HeaderLine",
        Position = UDim2.new(0, 12, 0, 51),
        Size = UDim2.new(1, -24, 0, 1),
        BackgroundColor3 = theme.Stroke,
        BackgroundTransparency = 0.55,
        BorderSizePixel = 0,
        ZIndex = 3
    }, root)
    local nav = make("ScrollingFrame", {
        Name = "Tabs",
        Position = UDim2.fromOffset(10, 62),
        Size = UDim2.new(0, 138, 1, -74),
        BackgroundColor3 = theme.Panel,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.Accent,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 3
    }, root)
    corner(nav, 11)
    stroke(nav, theme.Stroke, 0.75, 1)
    pad(nav, 7, 7)
    local navLayout = make("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, nav)
    local content = make("Frame", {
        Name = "Content",
        Position = UDim2.new(0, 156, 0, 62),
        Size = UDim2.new(1, -168, 1, -74),
        BackgroundColor3 = theme.Panel,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 3
    }, root)
    corner(content, 11)
    stroke(content, theme.Stroke, 0.75, 1)
    local contentPages = make("Folder", {Name = "Pages"}, content)
    local openButton = make("TextButton", {
        Name = "OpenButton",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 16, 0.5, 0),
        Size = UDim2.fromOffset(44, 44),
        BackgroundColor3 = theme.Panel,
        BackgroundTransparency = 0.05,
        Text = "",
        AutoButtonColor = false,
        Visible = config.OpenButton ~= false,
        ZIndex = 20
    }, gui)
    corner(openButton, 14)
    stroke(openButton, theme.Accent, 0.25, 1.2)
    local openIcon = make("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(22, 22),
        Image = assetId(config.OpenButtonIcon or config.Icon or "6031097225"),
        ImageColor3 = theme.Text,
        ZIndex = 21
    }, openButton)
    local function setOpen(value)
        state.Open = value
        if value then
            root.Visible = true
            root.Size = UDim2.fromOffset(winW * 0.92, winH * 0.92)
            tween(root, 0.28, {Size = UDim2.fromOffset(winW, winH)}, Enum.EasingStyle.Back)
            tween(openButton, 0.18, {BackgroundTransparency = 0.05})
        else
            tween(root, 0.16, {Size = UDim2.fromOffset(winW * 0.88, winH * 0.88)}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            task.delay(0.17, function()
                if not state.Open and root.Parent then root.Visible = false end
            end)
            tween(openButton, 0.18, {BackgroundTransparency = 0})
        end
    end
    openButton.MouseButton1Click:Connect(function() setOpen(not state.Open) end)
    close.MouseButton1Click:Connect(function() setOpen(false) end)
    minimize.MouseButton1Click:Connect(function()
        local hidden = content.Visible
        content.Visible = not hidden
        nav.Visible = not hidden
        divider.Visible = not hidden
        tween(root, 0.2, {
            Size = hidden and UDim2.fromOffset(winW, 52) or UDim2.fromOffset(winW, winH)
        })
        minimize.Text = hidden and "+" or "−"
    end)
    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = root.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            root.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    if camera then
        camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    end
    updateScale()
    local function applyTheme(newTheme, newName)
        theme = deepCopy(newTheme)
        state.Theme = theme
        state.ThemeName = newName or "Custom"
        root.BackgroundColor3 = theme.Background
        root.BackgroundTransparency = state.Transparency
        rootGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.Panel),
            ColorSequenceKeypoint.new(1, theme.Background)
        })
        darkOverlay.BackgroundColor3 = theme.Background
        darkOverlay.BackgroundTransparency = state.Acrylic
        rootStroke.Color = theme.Stroke
        title.TextColor3 = theme.Text
        subtitle.TextColor3 = theme.Muted
        close.TextColor3 = theme.Text
        minimize.TextColor3 = theme.Text
        close.BackgroundColor3 = theme.Surface
        minimize.BackgroundColor3 = theme.Surface
        nav.ScrollBarImageColor3 = theme.Accent
        content.BackgroundColor3 = theme.Panel
        nav.BackgroundColor3 = theme.Panel
        openButton.BackgroundColor3 = theme.Panel
        openIcon.ImageColor3 = theme.Text
        logo.ImageColor3 = theme.Accent
        divider.BackgroundColor3 = theme.Stroke
        for _, item in ipairs(state.Elements) do
            pcall(function() if item.UpdateTheme then item:UpdateTheme(theme) end end)
        end
        for _, tab in ipairs(state.Tabs) do
            tab:UpdateTheme(theme)
        end
    end
    function state:SetTheme(name)
        local found = OpenHubUI.Themes[name]
        if found then applyTheme(found, name) end
    end
    function state:CreateCustomTheme(name, values)
        local custom = deepCopy(theme)
        for k, v in pairs(values or {}) do
            if custom[k] ~= nil then custom[k] = v end
        end
        OpenHubUI.Themes[name] = custom
        applyTheme(custom, name)
        return custom
    end
    function state:SetTransparency(value)
        state.Transparency = math.clamp(tonumber(value) or state.Transparency, 0, 0.9)
        root.BackgroundTransparency = state.Transparency
    end
    function state:SetAcrylic(value)
        state.Acrylic = math.clamp(tonumber(value) or state.Acrylic, 0, 0.9)
        darkOverlay.BackgroundTransparency = state.Acrylic
    end
    function state:SetBackground(source, options)
        options = options or {}
        local image = source
        if options.Local then
            image = resolveAsset(source) or ""
        else
            image = assetId(source)
        end
        bg.Image = image or ""
        bg.ImageTransparency = math.clamp(tonumber(options.Transparency) or 0.62, 0, 1)
        bg.ScaleType = options.ScaleType == "Fit" and Enum.ScaleType.Fit or Enum.ScaleType.Crop
        state.BackgroundImage = source
        darkOverlay.BackgroundTransparency = state.Acrylic
        return bg.Image ~= ""
    end
    function state:SetBackgroundFile(fileName, url, options)
        if not (writefile and getcustomasset and request) then
            return false, "Executor file functions are unavailable"
        end
        local ok, response = pcall(function()
            return request({Url = url, Method = "GET"})
        end)
        if not ok or not response or not response.Body then
            return false, "Unable to download image"
        end
        local saved = pcall(writefile, fileName, response.Body)
        if not saved then return false, "Unable to save image" end
        local asset = resolveAsset(fileName)
        if not asset then return false, "Unable to load local image" end
        return state:SetBackground(asset, options)
    end
    function state:SetGifFrames(frames, fps)
        if type(frames) ~= "table" or #frames == 0 then return false end
        local alive = true
        local rate = math.clamp(tonumber(fps) or 8, 1, 30)
        task.spawn(function()
            local index = 1
            while alive and bg.Parent do
                local frame = frames[index]
                local resolved = resolveAsset(frame) or assetId(frame)
                bg.Image = resolved
                index = index % #frames + 1
                task.wait(1 / rate)
            end
        end)
        local control = {}
        function control:Stop() alive = false end
        return control
    end
    function state:Notify(notice)
        notice = type(notice) == "table" and notice or {Text = tostring(notice)}
        local holder = gui:FindFirstChild("Notifications")
        if not holder then
            holder = make("Frame", {
                Name = "Notifications",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -16, 0, 16),
                Size = UDim2.fromOffset(280, 420),
                ZIndex = 60
            }, gui)
            make("UIListLayout", {
                Padding = UDim.new(0, 8),
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                SortOrder = Enum.SortOrder.LayoutOrder
            }, holder)
        end
        local card = make("Frame", {
            BackgroundColor3 = theme.Panel,
            BackgroundTransparency = 0.06,
            Size = UDim2.new(1, 0, 0, 68),
            ClipsDescendants = true,
            ZIndex = 61
        }, holder)
        corner(card, 11)
        stroke(card, theme.Accent, 0.4, 1)
        local accentBar = make("Frame", {
            BackgroundColor3 = theme.Accent,
            Size = UDim2.new(0, 3, 1, -16),
            Position = UDim2.fromOffset(0, 8),
            BorderSizePixel = 0,
            ZIndex = 62
        }, card)
        corner(accentBar, 2)
        make("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(14, 8),
            Size = UDim2.new(1, -24, 0, 18),
            Text = notice.Title or "OpenHub",
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 62
        }, card)
        make("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(14, 28),
            Size = UDim2.new(1, -24, 0, 30),
            Text = notice.Content or notice.Text or "",
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextWrapped = true,
            TextColor3 = theme.Muted,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 62
        }, card)
        card.BackgroundTransparency = 1
        tween(card, 0.2, {BackgroundTransparency = 0.06})
        task.delay(tonumber(notice.Duration) or 3.2, function()
            if card.Parent then
                tween(card, 0.18, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0)})
                task.wait(0.2)
                card:Destroy()
            end
        end)
        return card
    end
    function state:Destroy()
        state.Destroyed = true
        for _, conn in ipairs(state.Connections) do
            pcall(function() conn:Disconnect() end)
        end
        gui:Destroy()
    end
    local Window = {Instance = root, GUI = gui, State = state}
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or ("Tab " .. (#state.Tabs + 1))
        local button = make("TextButton", {
            Name = tabName .. "Button",
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = theme.Accent,
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = #state.Tabs + 1,
            ZIndex = 4
        }, nav)
        corner(button, 8)
        local icon = make("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(9, 8),
            Size = UDim2.fromOffset(18, 18),
            Image = assetId(tabConfig.Icon or ""),
            ImageColor3 = theme.Muted,
            ZIndex = 5
        }, button)
        local label = make("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(tabConfig.Icon and 34 or 11, 0),
            Size = UDim2.new(1, tabConfig.Icon and -42 or -16, 1, 0),
            Text = tabName,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            TextColor3 = theme.Muted,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5
        }, button)
        local page = make("ScrollingFrame", {
            Name = tabName,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1),
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = theme.Accent,
            Visible = false,
            ZIndex = 4
        }, contentPages)
        pad(page, 11, 11)
        make("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, page)
        local tab = {
            Name = tabName,
            Button = button,
            Page = page,
            Icon = icon,
            Label = label,
            Elements = {}
        }
        local function selectTab()
            for _, other in ipairs(state.Tabs) do
                other.Page.Visible = false
                tween(other.Button, 0.16, {BackgroundTransparency = 1})
                other.Label.TextColor3 = theme.Muted
                other.Icon.ImageColor3 = theme.Muted
            end
            page.Visible = true
            tween(button, 0.18, {BackgroundTransparency = 0.82})
            label.TextColor3 = theme.Text
            icon.ImageColor3 = theme.Accent
            page.CanvasPosition = Vector2.new(0, 0)
        end
        button.MouseButton1Click:Connect(selectTab)
        function tab:UpdateTheme(newTheme)
            button.BackgroundColor3 = newTheme.Accent
            page.ScrollBarImageColor3 = newTheme.Accent
            if page.Visible then
                label.TextColor3 = newTheme.Text
                icon.ImageColor3 = newTheme.Accent
            else
                label.TextColor3 = newTheme.Muted
                icon.ImageColor3 = newTheme.Muted
            end
            for _, element in ipairs(tab.Elements) do
                pcall(function()
                    if element.UpdateTheme then element:UpdateTheme(newTheme) end
                end)
            end
        end
        function tab:SetIcon(value)
            icon.Image = assetId(value)
            icon.Visible = value ~= nil and value ~= ""
            label.Position = UDim2.fromOffset(icon.Visible and 34 or 11, 0)
        end
        local function elementFrame(name, height)
            local frame = make("Frame", {
                Name = name or "Element",
                Size = UDim2.new(1, 0, 0, height or 50),
                BackgroundColor3 = theme.Surface,
                BackgroundTransparency = 0.1,
                BorderSizePixel = 0,
                ZIndex = 5
            }, page)
            corner(frame, 9)
            stroke(frame, theme.Stroke, 0.78, 1)
            return frame
        end
        local function addElement(item)
            table.insert(tab.Elements, item)
            table.insert(state.Elements, item)
            return item
        end
        function tab:CreateSection(text)
            local frame = make("Frame", {
                Name = "Section",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 22),
                ZIndex = 5
            }, page)
            local lbl = make("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = text or "Section",
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = theme.Accent,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local line = make("Frame", {
                BackgroundColor3 = theme.Stroke,
                BackgroundTransparency = 0.5,
                Position = UDim2.new(0, 0, 1, -1),
                Size = UDim2.new(1, 0, 0, 1),
                BorderSizePixel = 0,
                ZIndex = 6
            }, frame)
            local item = {Instance = frame}
            function item:UpdateTheme(t)
                line.BackgroundColor3 = t.Stroke
                lbl.TextColor3 = t.Accent
            end
            return addElement(item)
        end
        function tab:CreateLabel(cfg)
            cfg = type(cfg) == "table" and cfg or {Text = tostring(cfg or "Label")}
            local frame = elementFrame(cfg.Name or "Label", cfg.Height or 40)
            local textLabel = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 0),
                Size = UDim2.new(1, -24, 1, 0),
                Text = cfg.Text or "Label",
                Font = Enum.Font.Gotham,
                TextSize = cfg.TextSize or 12,
                TextColor3 = theme.Text,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local item = {Instance = frame}
            function item:Set(text) textLabel.Text = tostring(text) end
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
                textLabel.TextColor3 = t.Text
            end
            return addElement(item)
        end
        function tab:CreateParagraph(cfg)
            cfg = cfg or {}
            local frame = elementFrame(cfg.Name or "Paragraph", cfg.Height or 70)
            local head = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 7),
                Size = UDim2.new(1, -24, 0, 18),
                Text = cfg.Title or "Information",
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local body = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 26),
                Size = UDim2.new(1, -24, 1, -32),
                Text = cfg.Content or cfg.Text or "",
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextColor3 = theme.Muted,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                ZIndex = 6
            }, frame)
            local item = {Instance = frame}
            function item:Set(text) body.Text = tostring(text) end
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
                head.TextColor3 = t.Text
                body.TextColor3 = t.Muted
            end
            return addElement(item)
        end
        function tab:CreateButton(cfg)
            cfg = type(cfg) == "table" and cfg or {Name = tostring(cfg or "Button")}
            local frame = elementFrame(cfg.Name or "Button", cfg.Height or 44)
            local btn = make("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 6
            }, frame)
            local ico = make("ImageLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 12),
                Size = UDim2.fromOffset(18, 18),
                Image = assetId(cfg.Icon or ""),
                ImageColor3 = theme.Accent,
                Visible = cfg.Icon ~= nil,
                ZIndex = 7
            }, btn)
            local txt = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(cfg.Icon and 38 or 13, 0),
                Size = UDim2.new(1, cfg.Icon and -50 or -26, 1, 0),
                Text = cfg.Name or "Button",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 7
            }, btn)
            local arrow = make("TextLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(16, 20),
                Text = "›",
                Font = Enum.Font.Gotham,
                TextSize = 20,
                TextColor3 = theme.Muted,
                ZIndex = 7
            }, btn)
            btn.MouseEnter:Connect(function()
                tween(frame, 0.14, {BackgroundColor3 = theme.Accent, BackgroundTransparency = 0.88})
            end)
            btn.MouseLeave:Connect(function()
                tween(frame, 0.14, {BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.1})
            end)
            btn.MouseButton1Click:Connect(function()
                tween(frame, 0.07, {Size = UDim2.new(1, -4, 0, frame.Size.Y.Offset)})
                task.delay(0.08, function()
                    if frame.Parent then
                        tween(frame, 0.12, {Size = UDim2.new(1, 0, 0, frame.Size.Y.Offset)})
                    end
                end)
                if cfg.Callback then task.spawn(cfg.Callback) end
            end)
            local item = {Instance = frame}
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
                txt.TextColor3 = t.Text
                ico.ImageColor3 = t.Accent
                arrow.TextColor3 = t.Muted
            end
            return addElement(item)
        end
        function tab:CreateToggle(cfg)
            cfg = cfg or {}
            local value = cfg.CurrentValue == true
            local frame = elementFrame(cfg.Name or "Toggle", cfg.Description and 62 or 48)
            local name = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, cfg.Description and 7 or 0),
                Size = UDim2.new(1, -70, cfg.Description and 0 or 1, cfg.Description and 18 or 0),
                Text = cfg.Name or "Toggle",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local desc
            if cfg.Description then
                desc = make("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(12, 28),
                    Size = UDim2.new(1, -72, 0, 22),
                    Text = cfg.Description,
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    TextColor3 = theme.Muted,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6
                }, frame)
            end
            local switch = make("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(40, 22),
                BackgroundColor3 = value and theme.Accent or theme.Stroke,
                BackgroundTransparency = value and 0 or 0.4,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 6
            }, frame)
            corner(switch, 11)
            local knob = make("Frame", {
                Position = value and UDim2.new(1, -19, 0, 3) or UDim2.fromOffset(3, 3),
                Size = UDim2.fromOffset(16, 16),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 7
            }, switch)
            corner(knob, 9)
            local function set(v, fire)
                value = v == true
                tween(switch, 0.16, {
                    BackgroundColor3 = value and theme.Accent or theme.Stroke,
                    BackgroundTransparency = value and 0 or 0.4
                })
                tween(knob, 0.16, {
                    Position = value and UDim2.new(1, -19, 0, 3) or UDim2.fromOffset(3, 3)
                })
                if fire and cfg.Callback then task.spawn(cfg.Callback, value) end
            end
            switch.MouseButton1Click:Connect(function() set(not value, true) end)
            local item = {Instance = frame}
            function item:Set(v) set(v, true) end
            function item:Get() return value end
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
                name.TextColor3 = t.Text
                if desc then desc.TextColor3 = t.Muted end
                switch.BackgroundColor3 = value and t.Accent or t.Stroke
            end
            addElement(item)
            if cfg.Callback and cfg.CurrentValue then task.spawn(cfg.Callback, value) end
            return item
        end
        function tab:CreateSlider(cfg)
            cfg = cfg or {}
            local min = tonumber(cfg.Min) or 0
            local max = tonumber(cfg.Max) or 100
            local value = math.clamp(tonumber(cfg.CurrentValue) or min, min, max)
            local frame = elementFrame(cfg.Name or "Slider", 62)
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 6),
                Size = UDim2.new(1, -70, 0, 18),
                Text = cfg.Name or "Slider",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local valLabel = make("TextLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -12, 0, 6),
                Size = UDim2.fromOffset(60, 18),
                Text = tostring(value),
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextColor3 = theme.Accent,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 6
            }, frame)
            local track = make("Frame", {
                Position = UDim2.new(0, 12, 0, 36),
                Size = UDim2.new(1, -24, 0, 5),
                BackgroundColor3 = theme.Stroke,
                BackgroundTransparency = 0.35,
                BorderSizePixel = 0,
                ZIndex = 6
            }, frame)
            corner(track, 4)
            local fill = make("Frame", {
                Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0),
                BackgroundColor3 = theme.Accent,
                BorderSizePixel = 0,
                ZIndex = 7
            }, track)
            corner(fill, 4)
            local knob = make("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new((value - min) / math.max(max - min, 1), 0, 0.5, 0),
                Size = UDim2.fromOffset(12, 12),
                BackgroundColor3 = theme.Text,
                BorderSizePixel = 0,
                ZIndex = 8
            }, track)
            corner(knob, 7)
            stroke(knob, theme.Accent, 0.2, 1)
            local hit = make("TextButton", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, -8),
                Size = UDim2.new(1, 0, 1, 16),
                Text = "",
                ZIndex = 9
            }, track)
            local function set(v, fire)
                value = math.clamp(v, min, max)
                local p = (value - min) / math.max(max - min, 1)
                fill.Size = UDim2.new(p, 0, 1, 0)
                knob.Position = UDim2.new(p, 0, 0.5, 0)
                valLabel.Text = tostring(math.floor(value * 100) / 100)
                if fire and cfg.Callback then task.spawn(cfg.Callback, value) end
            end
            local sliding = false
            hit.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    local p = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    set(min + (max - min) * p, true)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local p = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    set(min + (max - min) * p, true)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)
            local item = {Instance = frame}
            function item:Set(v) set(tonumber(v) or value, true) end
            function item:Get() return value end
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
                label.TextColor3 = t.Text
                valLabel.TextColor3 = t.Accent
                track.BackgroundColor3 = t.Stroke
                fill.BackgroundColor3 = t.Accent
            end
            return addElement(item)
        end
        function tab:CreateInput(cfg)
            cfg = cfg or {}
            local frame = elementFrame(cfg.Name or "Input", cfg.Description and 68 or 54)
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 5),
                Size = UDim2.new(1, -24, 0, 16),
                Text = cfg.Name or "Input",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local box = make("TextBox", {
                Position = UDim2.fromOffset(12, 26),
                Size = UDim2.new(1, -24, 0, 24),
                BackgroundColor3 = theme.Background,
                BackgroundTransparency = 0.2,
                Text = tostring(cfg.Default or ""),
                PlaceholderText = cfg.Placeholder or "Enter value...",
                ClearTextOnFocus = false,
                TextColor3 = theme.Text,
                PlaceholderColor3 = theme.Muted,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 6
            }, frame)
            corner(box, 6)
            pad(box, 8, 0)
            box.FocusLost:Connect(function(enter)
                if (not cfg.Enter or enter) and cfg.Callback then
                    task.spawn(cfg.Callback, box.Text)
                end
            end)
            local item = {Instance = frame}
            function item:Set(v) box.Text = tostring(v) end
            function item:Get() return box.Text end
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
                label.TextColor3 = t.Text
                box.BackgroundColor3 = t.Background
                box.TextColor3 = t.Text
                box.PlaceholderColor3 = t.Muted
            end
            return addElement(item)
        end
        function tab:CreateDropdown(cfg)
            cfg = cfg or {}
            local options = cfg.Options or {"Option 1", "Option 2"}
            local selected = cfg.CurrentOption or options[1]
            if type(selected) == "table" then selected = selected[1] end
            local expanded = false
            local frame = elementFrame(cfg.Name or "Dropdown", 46)
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 0),
                Size = UDim2.new(0.42, 0, 1, 0),
                Text = cfg.Name or "Dropdown",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local chosen = make("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0.55, 0, 0, 28),
                BackgroundColor3 = theme.Background,
                BackgroundTransparency = 0.2,
                Text = tostring(selected),
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextColor3 = theme.Text,
                AutoButtonColor = false,
                ZIndex = 6
            }, frame)
            corner(chosen, 7)
            local list = make("Frame", {
                Name = "DropdownPopup",
                BackgroundColor3 = theme.Panel,
                BackgroundTransparency = 0.02,
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 100,
                Size = UDim2.fromOffset(0, 0)
            }, gui)
            corner(list, 9)
            stroke(list, theme.Stroke, 0.3, 1)
            local scroll = make("ScrollingFrame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 1),
                CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = theme.Accent,
                ZIndex = 101
            }, list)
            pad(scroll, 5, 5)
            make("UIListLayout", {
                Padding = UDim.new(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder
            }, scroll)
            local function rebuild()
                for _, c in ipairs(scroll:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                for i, opt in ipairs(options) do
                    local b = make("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = theme.Accent,
                        BackgroundTransparency = 0.9,
                        Text = tostring(opt),
                        Font = Enum.Font.Gotham,
                        TextSize = 11,
                        TextColor3 = theme.Text,
                        AutoButtonColor = false,
                        LayoutOrder = i,
                        ZIndex = 102
                    }, scroll)
                    corner(b, 6)
                    b.MouseEnter:Connect(function()
                        tween(b, 0.1, {BackgroundTransparency = 0.75})
                    end)
                    b.MouseLeave:Connect(function()
                        tween(b, 0.1, {BackgroundTransparency = 0.9})
                    end)
                    b.MouseButton1Click:Connect(function()
                        selected = opt
                        chosen.Text = tostring(opt)
                        expanded = false
                        tween(list, 0.14, {Size = UDim2.new(0, list.Size.X.Offset, 0, 0)})
                        task.delay(0.15, function() list.Visible = false end)
                        if cfg.Callback then task.spawn(cfg.Callback, opt) end
                    end)
                end
            end
            rebuild()
            local function positionList()
                local abs = chosen.AbsolutePosition
                local absSize = chosen.AbsoluteSize
                local h = math.min(#options, 6) * 31 + 12
                list.Position = UDim2.fromOffset(abs.X, abs.Y + absSize.Y + 4)
                list.Size = UDim2.fromOffset(absSize.X, 0)
                list.Visible = true
                tween(list, 0.18, {Size = UDim2.fromOffset(absSize.X, h)})
            end
            chosen.MouseButton1Click:Connect(function()
                expanded = not expanded
                if expanded then
                    positionList()
                else
                    tween(list, 0.14, {Size = UDim2.new(0, list.Size.X.Offset, 0, 0)})
                    task.delay(0.15, function()
                        if not expanded then list.Visible = false end
                    end)
                end
            end)
            local outsideConn
            outsideConn = UserInputService.InputBegan:Connect(function(input)
                if not expanded then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local pos = input.Position
                    local inList = pos.X >= list.AbsolutePosition.X and pos.X <= list.AbsolutePosition.X + list.AbsoluteSize.X
                        and pos.Y >= list.AbsolutePosition.Y and pos.Y <= list.AbsolutePosition.Y + list.AbsoluteSize.Y
                    local inChosen = pos.X >= chosen.AbsolutePosition.X and pos.X <= chosen.AbsolutePosition.X + chosen.AbsoluteSize.X
                        and pos.Y >= chosen.AbsolutePosition.Y and pos.Y <= chosen.AbsolutePosition.Y + chosen.AbsoluteSize.Y
                    if not inList and not inChosen then
                        expanded = false
                        tween(list, 0.14, {Size = UDim2.new(0, list.Size.X.Offset, 0, 0)})
                        task.delay(0.15, function() list.Visible = false end)
                    end
                end
            end)
            table.insert(state.Connections, outsideConn)
            local item = {Instance = frame}
            function item:Set(v)
                selected = v
                chosen.Text = tostring(v)
                if cfg.Callback then task.spawn(cfg.Callback, v) end
            end
            function item:Get() return selected end
            function item:UpdateOptions(v)
                options = v or {}
                rebuild()
            end
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
                label.TextColor3 = t.Text
                chosen.BackgroundColor3 = t.Background
                chosen.TextColor3 = t.Text
                list.BackgroundColor3 = t.Panel
                for _, b in ipairs(scroll:GetChildren()) do
                    if b:IsA("TextButton") then b.TextColor3 = t.Text end
                end
            end
            return addElement(item)
        end
        function tab:CreateKeybind(cfg)
            cfg = cfg or {}
            local key = cfg.CurrentBind or "RightShift"
            local listening = false
            local frame = elementFrame(cfg.Name or "Keybind", 46)
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 0),
                Size = UDim2.new(1, -96, 1, 0),
                Text = cfg.Name or "Keybind",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local btn = make("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(76, 26),
                BackgroundColor3 = theme.Background,
                BackgroundTransparency = 0.15,
                Text = key,
                Font = Enum.Font.GothamBold,
                TextSize = 10,
                TextColor3 = theme.Accent,
                AutoButtonColor = false,
                ZIndex = 6
            }, frame)
            corner(btn, 7)
            btn.MouseButton1Click:Connect(function()
                listening = true
                btn.Text = "..."
            end)
            local conn = UserInputService.InputBegan:Connect(function(input, processed)
                if processed then return end
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    key = input.KeyCode.Name
                    btn.Text = key
                    listening = false
                elseif not listening and input.KeyCode.Name == key and cfg.Callback then
                    task.spawn(cfg.Callback, key)
                end
            end)
            table.insert(state.Connections, conn)
            local item = {Instance = frame}
            function item:Set(v) key = tostring(v); btn.Text = key end
            function item:Get() return key end
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
                label.TextColor3 = t.Text
                btn.BackgroundColor3 = t.Background
                btn.TextColor3 = t.Accent
            end
            return addElement(item)
        end
        function tab:CreateColorPicker(cfg)
            cfg = cfg or {}
            local color = cfg.Color or theme.Accent
            local h, s, v = color:ToHSV()
            local frame = elementFrame(cfg.Name or "Color", 46)
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 0),
                Size = UDim2.new(1, -64, 1, 0),
                Text = cfg.Name or "Accent Color",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local swatch = make("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(40, 24),
                BackgroundColor3 = color,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 6
            }, frame)
            corner(swatch, 7)
            stroke(swatch, theme.Stroke, 0.4, 1)
            local popup = make("Frame", {
                Name = "ColorPickerPopup",
                Size = UDim2.fromOffset(210, 168),
                BackgroundColor3 = theme.Panel,
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 110
            }, gui)
            corner(popup, 11)
            stroke(popup, theme.Stroke, 0.25, 1)
            pad(popup, 10, 10)
            local svFrame = make("Frame", {
                Size = UDim2.fromOffset(140, 110),
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 111
            }, popup)
            corner(svFrame, 7)
            local whiteGrad = make("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 112
            }, svFrame)
            corner(whiteGrad, 7)
            make("UIGradient", {
                Rotation = 0,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                })
            }, whiteGrad)
            local blackGrad = make("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                ZIndex = 113
            }, svFrame)
            corner(blackGrad, 7)
            make("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                })
            }, blackGrad)
            local svKnob = make("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(s, 0, 1 - v, 0),
                Size = UDim2.fromOffset(12, 12),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 114
            }, svFrame)
            corner(svKnob, 6)
            stroke(svKnob, Color3.new(0, 0, 0), 0.3, 1.5)
            local svHit = make("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = "",
                ZIndex = 115
            }, svFrame)
            local hueTrack = make("Frame", {
                Position = UDim2.fromOffset(150, 0),
                Size = UDim2.fromOffset(16, 110),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 111
            }, popup)
            corner(hueTrack, 5)
            make("UIGradient", {
                Rotation = 90,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                })
            }, hueTrack)
            local hueKnob = make("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, h, 0),
                Size = UDim2.fromOffset(18, 8),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 112
            }, hueTrack)
            corner(hueKnob, 3)
            stroke(hueKnob, Color3.new(0, 0, 0), 0.25, 1)
            local hueHit = make("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = "",
                ZIndex = 113
            }, hueTrack)
            local preview = make("Frame", {
                Position = UDim2.fromOffset(0, 120),
                Size = UDim2.fromOffset(50, 22),
                BackgroundColor3 = color,
                BorderSizePixel = 0,
                ZIndex = 111
            }, popup)
            corner(preview, 6)
            local hexLabel = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(58, 120),
                Size = UDim2.fromOffset(120, 22),
                Text = string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)),
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 111
            }, popup)
            local function applyColor(fire)
                color = Color3.fromHSV(h, s, v)
                swatch.BackgroundColor3 = color
                preview.BackgroundColor3 = color
                svFrame.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svKnob.Position = UDim2.new(s, 0, 1 - v, 0)
                hueKnob.Position = UDim2.new(0.5, 0, h, 0)
                hexLabel.Text = string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
                if fire and cfg.Callback then task.spawn(cfg.Callback, color) end
            end
            local function positionPopup()
                local abs = swatch.AbsolutePosition
                local absSize = swatch.AbsoluteSize
                local screen = camera and camera.ViewportSize or Vector2.new(1920, 1080)
                local px = abs.X + absSize.X - 210
                local py = abs.Y + absSize.Y + 6
                if px < 8 then px = 8 end
                if py + 168 > screen.Y - 8 then py = abs.Y - 174 end
                popup.Position = UDim2.fromOffset(px, py)
            end
            swatch.MouseButton1Click:Connect(function()
                popup.Visible = not popup.Visible
                if popup.Visible then positionPopup() end
            end)
            local svDragging = false
            svHit.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    svDragging = true
                    local rel = input.Position - svFrame.AbsolutePosition
                    s = math.clamp(rel.X / svFrame.AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp(rel.Y / svFrame.AbsoluteSize.Y, 0, 1)
                    applyColor(true)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if svDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local rel = input.Position - svFrame.AbsolutePosition
                    s = math.clamp(rel.X / svFrame.AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp(rel.Y / svFrame.AbsoluteSize.Y, 0, 1)
                    applyColor(true)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    svDragging = false
                end
            end)
            local hueDragging = false
            hueHit.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = true
                    local rel = input.Position - hueTrack.AbsolutePosition
                    h = math.clamp(rel.Y / hueTrack.AbsoluteSize.Y, 0, 1)
                    applyColor(true)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if hueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local rel = input.Position - hueTrack.AbsolutePosition
                    h = math.clamp(rel.Y / hueTrack.AbsoluteSize.Y, 0, 1)
                    applyColor(true)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDragging = false
                end
            end)
            local outsideConn = UserInputService.InputBegan:Connect(function(input)
                if not popup.Visible then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local pos = input.Position
                    local inPopup = pos.X >= popup.AbsolutePosition.X and pos.X <= popup.AbsolutePosition.X + popup.AbsoluteSize.X
                        and pos.Y >= popup.AbsolutePosition.Y and pos.Y <= popup.AbsolutePosition.Y + popup.AbsoluteSize.Y
                    local inSwatch = pos.X >= swatch.AbsolutePosition.X and pos.X <= swatch.AbsolutePosition.X + swatch.AbsoluteSize.X
                        and pos.Y >= swatch.AbsolutePosition.Y and pos.Y <= swatch.AbsolutePosition.Y + swatch.AbsoluteSize.Y
                    if not inPopup and not inSwatch then
                        popup.Visible = false
                    end
                end
            end)
            table.insert(state.Connections, outsideConn)
            local item = {Instance = frame}
            function item:Set(v)
                if typeof(v) == "Color3" then
                    color = v
                    h, s, v = v:ToHSV()
                    applyColor(false)
                    if cfg.Callback then task.spawn(cfg.Callback, v) end
                end
            end
            function item:Get() return color end
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
                label.TextColor3 = t.Text
                popup.BackgroundColor3 = t.Panel
                hexLabel.TextColor3 = t.Text
            end
            return addElement(item)
        end
        function tab:CreateDivider()
            local frame = make("Frame", {
                Name = "Divider",
                BackgroundColor3 = theme.Stroke,
                BackgroundTransparency = 0.55,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 1),
                ZIndex = 5
            }, page)
            local item = {Instance = frame}
            function item:UpdateTheme(t) frame.BackgroundColor3 = t.Stroke end
            return addElement(item)
        end
        function tab:CreateProgressBar(cfg)
            cfg = cfg or {}
            local value = math.clamp(tonumber(cfg.Value) or 0, 0, 100)
            local frame = elementFrame(cfg.Name or "Progress", cfg.Description and 60 or 48)
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 5),
                Size = UDim2.new(1, -70, 0, 18),
                Text = cfg.Name or "Progress",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local amount = make("TextLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -12, 0, 5),
                Size = UDim2.fromOffset(50, 18),
                Text = tostring(value) .. "%",
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextColor3 = theme.Accent,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 6
            }, frame)
            local track = make("Frame", {
                Position = UDim2.new(0, 12, 0, 29),
                Size = UDim2.new(1, -24, 0, 6),
                BackgroundColor3 = theme.Stroke,
                BorderSizePixel = 0,
                ZIndex = 6
            }, frame)
            corner(track, 4)
            local fill = make("Frame", {
                Size = UDim2.new(value / 100, 0, 1, 0),
                BackgroundColor3 = theme.Accent,
                BorderSizePixel = 0,
                ZIndex = 7
            }, track)
            corner(fill, 4)
            local item = {Instance = frame}
            function item:Set(v)
                value = math.clamp(tonumber(v) or value, 0, 100)
                tween(fill, 0.18, {Size = UDim2.new(value / 100, 0, 1, 0)})
                amount.Text = tostring(math.floor(value)) .. "%"
            end
            function item:Get() return value end
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
                label.TextColor3 = t.Text
                amount.TextColor3 = t.Accent
                track.BackgroundColor3 = t.Stroke
                fill.BackgroundColor3 = t.Accent
            end
            return addElement(item)
        end
        function tab:CreateImage(cfg)
            cfg = type(cfg) == "table" and cfg or {Image = cfg}
            local frame = elementFrame(cfg.Name or "Image", cfg.Height or 140)
            local image = make("ImageLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(6, 6),
                Size = UDim2.new(1, -12, 1, -12),
                Image = assetId(cfg.Image or ""),
                ScaleType = cfg.ScaleType == "Fit" and Enum.ScaleType.Fit or Enum.ScaleType.Crop,
                ZIndex = 6
            }, frame)
            corner(image, 7)
            local item = {Instance = frame}
            function item:Set(v) image.Image = assetId(v) end
            function item:UpdateTheme(t) frame.BackgroundColor3 = t.Surface end
            return addElement(item)
        end
        function tab:CreateSearchBox(cfg)
            cfg = cfg or {}
            local frame = elementFrame(cfg.Name or "Search", 54)
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 4),
                Size = UDim2.new(1, -24, 0, 15),
                Text = cfg.Name or "Search",
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextColor3 = theme.Muted,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local box = make("TextBox", {
                Position = UDim2.fromOffset(10, 22),
                Size = UDim2.new(1, -20, 0, 26),
                BackgroundColor3 = theme.Background,
                BackgroundTransparency = 0.18,
                Text = "",
                PlaceholderText = cfg.Placeholder or "Search...",
                ClearTextOnFocus = false,
                TextColor3 = theme.Text,
                PlaceholderColor3 = theme.Muted,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 6
            }, frame)
            corner(box, 7)
            pad(box, 8, 0)
            box:GetPropertyChangedSignal("Text"):Connect(function()
                if cfg.Callback then task.spawn(cfg.Callback, box.Text) end
            end)
            local item = {Instance = frame}
            function item:Set(v) box.Text = tostring(v) end
            function item:Get() return box.Text end
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
                label.TextColor3 = t.Muted
                box.BackgroundColor3 = t.Background
                box.TextColor3 = t.Text
                box.PlaceholderColor3 = t.Muted
            end
            return addElement(item)
        end
        function tab:CreateMultiDropdown(cfg)
            cfg = cfg or {}
            local options = cfg.Options or {}
            local selected = {}
            for _, v in ipairs(cfg.CurrentOptions or {}) do
                selected[tostring(v)] = true
            end
            local frame = elementFrame(cfg.Name or "Multi dropdown", 46)
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 0),
                Size = UDim2.new(0.42, 0, 1, 0),
                Text = cfg.Name or "Multi dropdown",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local chosen = make("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0.55, 0, 0, 28),
                BackgroundColor3 = theme.Background,
                Text = "Select options",
                Font = Enum.Font.Gotham,
                TextSize = 10,
                TextColor3 = theme.Text,
                AutoButtonColor = false,
                ZIndex = 6
            }, frame)
            corner(chosen, 7)
            local popup = make("Frame", {
                BackgroundColor3 = theme.Panel,
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 100,
                Size = UDim2.fromOffset(0, 0)
            }, gui)
            corner(popup, 9)
            stroke(popup, theme.Stroke, 0.3, 1)
            local scroll = make("ScrollingFrame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 1),
                CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 2,
                ZIndex = 101
            }, popup)
            pad(scroll, 5, 5)
            make("UIListLayout", {
                Padding = UDim.new(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder
            }, scroll)
            local function values()
                local out = {}
                for _, v in ipairs(options) do
                    if selected[tostring(v)] then table.insert(out, v) end
                end
                return out
            end
            local function refresh()
                local vals = values()
                chosen.Text = #vals == 0 and "Select options" or table.concat(vals, ", ")
                for _, b in ipairs(scroll:GetChildren()) do
                    if b:IsA("TextButton") then b:Destroy() end
                end
                for i, opt in ipairs(options) do
                    local isOn = selected[tostring(opt)]
                    local b = make("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = isOn and theme.Accent or theme.Surface,
                        BackgroundTransparency = isOn and 0.2 or 0.3,
                        Text = (isOn and "✓  " or "＋  ") .. tostring(opt),
                        Font = Enum.Font.Gotham,
                        TextSize = 11,
                        TextColor3 = theme.Text,
                        AutoButtonColor = false,
                        LayoutOrder = i,
                        ZIndex = 102
                    }, scroll)
                    corner(b, 6)
                    b.MouseButton1Click:Connect(function()
                        selected[tostring(opt)] = not selected[tostring(opt)]
                        refresh()
                        if cfg.Callback then task.spawn(cfg.Callback, values()) end
                    end)
                end
            end
            local function positionPopup()
                local abs = chosen.AbsolutePosition
                local absSize = chosen.AbsoluteSize
                local h = math.min(#options, 6) * 31 + 12
                popup.Position = UDim2.fromOffset(abs.X, abs.Y + absSize.Y + 4)
                popup.Size = UDim2.fromOffset(absSize.X, 0)
                popup.Visible = true
                tween(popup, 0.16, {Size = UDim2.fromOffset(absSize.X, h)})
            end
            local expanded = false
            chosen.MouseButton1Click:Connect(function()
                expanded = not expanded
                if expanded then
                    positionPopup()
                else
                    tween(popup, 0.14, {Size = UDim2.new(0, popup.Size.X.Offset, 0, 0)})
                    task.delay(0.15, function()
                        if not expanded then popup.Visible = false end
                    end)
                end
            end)
            refresh()
            local item = {Instance = frame}
            function item:Set(v)
                selected = {}
                for _, x in ipairs(v or {}) do selected[tostring(x)] = true end
                refresh()
            end
            function item:Get() return values() end
            function item:UpdateOptions(v)
                options = v or {}
                refresh()
            end
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
                label.TextColor3 = t.Text
                chosen.BackgroundColor3 = t.Background
                chosen.TextColor3 = t.Text
                popup.BackgroundColor3 = t.Panel
                refresh()
            end
            return addElement(item)
        end
        function tab:CreateTextBox(cfg)
            return self:CreateInput(cfg)
        end
        local item = {Instance = page}
        function item:Select() selectTab() end
        table.insert(state.Tabs, tab)
        if #state.Tabs == 1 then selectTab() end
        return tab
    end
    function Window:SetTheme(name) state:SetTheme(name) end
    function Window:CreateCustomTheme(name, values) return state:CreateCustomTheme(name, values) end
    function Window:SetBackground(source, options) return state:SetBackground(source, options) end
    function Window:SetBackgroundFile(fileName, url, options) return state:SetBackgroundFile(fileName, url, options) end
    function Window:SetGifFrames(frames, fps) return state:SetGifFrames(frames, fps) end
    function Window:SetTransparency(value) state:SetTransparency(value) end
    function Window:SetAcrylic(value) state:SetAcrylic(value) end
    function Window:Notify(notice) return state:Notify(notice) end
    function Window:Destroy() state:Destroy() end
    function Window:Toggle() setOpen(not state.Open) end
    state.Window = Window
    if config.BackgroundImage then
        state:SetBackground(config.BackgroundImage, {
            Local = config.BackgroundLocal,
            Transparency = config.BackgroundImageTransparency or 0.62
        })
    end
    if config.Intro ~= false then
        root.Size = UDim2.fromOffset(winW * 0.9, winH * 0.9)
        root.BackgroundTransparency = 1
        tween(root, 0.32, {
            Size = UDim2.fromOffset(winW, winH),
            BackgroundTransparency = transparency
        }, Enum.EasingStyle.Back)
    end
    return Window
end
return OpenHubUI
