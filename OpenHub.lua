local OpenHubUI = {}
OpenHubUI.Version = "3.0.0"
OpenHubUI.Icons = {}
OpenHubUI.IconSources = {
    "https://raw.githubusercontent.com/Styx-ui/Openhub/refs/heads/main/Icons.lua",
    "https://raw.githubusercontent.com/Styx-ui/Openhub/refs/heads/main/Icons2.lua",
    "https://raw.githubusercontent.com/Styx-ui/Openhub/refs/heads/main/Icons3.lua",
    "https://raw.githubusercontent.com/Styx-ui/Openhub/refs/heads/main/Icons4.lua"
}
OpenHubUI._IconsLoaded = false

local function normalizeIconName(value)
    return tostring(value):lower():gsub("%s+", "-"):gsub("_", "-")
end

local function registerIconCatalog(catalog)
    if type(catalog) ~= "table" then return end
    for name, id in pairs(catalog) do
        if type(name) == "string" and (typeof(id) == "string" or typeof(id) == "number") then
            local asset = typeof(id) == "number" and "rbxassetid://" .. tostring(id) or id
            OpenHubUI.Icons[name] = asset
            OpenHubUI.Icons[normalizeIconName(name)] = asset
        end
    end
end

function OpenHubUI:LoadIcons()
    if self._IconsLoaded then return self.Icons end
    self._IconsLoaded = true
    local compiler = loadstring or load
    if not compiler or not game or not game.HttpGet then return self.Icons end
    for _, source in ipairs(self.IconSources) do
        pcall(function()
            local code = game:HttpGet(source)
            local chunk = compiler(code)
            if type(chunk) == "function" then
                local ok, catalog = pcall(chunk)
                if ok then registerIconCatalog(catalog) end
            end
        end)
    end
    return self.Icons
end

function OpenHubUI:GetIcon(name)
    if typeof(name) ~= "string" then return nil end
    local direct = self.Icons[name] or self.Icons[normalizeIconName(name)]
    if direct then return direct end
    self:LoadIcons()
    return self.Icons[name] or self.Icons[normalizeIconName(name)]
end

OpenHubUI.Themes = {
    Midnight = {
        Background = Color3.fromRGB(8, 9, 16),
        Panel = Color3.fromRGB(14, 16, 26),
        Surface = Color3.fromRGB(22, 25, 38),
        Accent = Color3.fromRGB(130, 105, 255),
        Accent2 = Color3.fromRGB(90, 180, 255),
        Text = Color3.fromRGB(245, 247, 255),
        Muted = Color3.fromRGB(155, 160, 185),
        Stroke = Color3.fromRGB(255, 255, 255),
        Transparency = 0.22,
        Acrylic = 0.45,
        Glass = 0.55
    },
    Obsidian = {
        Background = Color3.fromRGB(4, 5, 7),
        Panel = Color3.fromRGB(10, 11, 14),
        Surface = Color3.fromRGB(16, 17, 22),
        Accent = Color3.fromRGB(235, 235, 242),
        Accent2 = Color3.fromRGB(150, 155, 168),
        Text = Color3.fromRGB(250, 250, 252),
        Muted = Color3.fromRGB(145, 147, 155),
        Stroke = Color3.fromRGB(255, 255, 255),
        Transparency = 0.18,
        Acrylic = 0.40,
        Glass = 0.50
    },
    Aurora = {
        Background = Color3.fromRGB(4, 12, 14),
        Panel = Color3.fromRGB(8, 18, 22),
        Surface = Color3.fromRGB(12, 28, 32),
        Accent = Color3.fromRGB(60, 230, 185),
        Accent2 = Color3.fromRGB(80, 175, 255),
        Text = Color3.fromRGB(235, 255, 250),
        Muted = Color3.fromRGB(130, 170, 165),
        Stroke = Color3.fromRGB(255, 255, 255),
        Transparency = 0.20,
        Acrylic = 0.42,
        Glass = 0.52
    },
    Crimson = {
        Background = Color3.fromRGB(14, 5, 8),
        Panel = Color3.fromRGB(22, 9, 13),
        Surface = Color3.fromRGB(32, 14, 18),
        Accent = Color3.fromRGB(255, 70, 100),
        Accent2 = Color3.fromRGB(255, 140, 100),
        Text = Color3.fromRGB(255, 245, 248),
        Muted = Color3.fromRGB(180, 140, 150),
        Stroke = Color3.fromRGB(255, 255, 255),
        Transparency = 0.20,
        Acrylic = 0.42,
        Glass = 0.52
    },
    Sapphire = {
        Background = Color3.fromRGB(4, 7, 15),
        Panel = Color3.fromRGB(8, 13, 26),
        Surface = Color3.fromRGB(13, 20, 36),
        Accent = Color3.fromRGB(70, 140, 255),
        Accent2 = Color3.fromRGB(100, 210, 255),
        Text = Color3.fromRGB(240, 247, 255),
        Muted = Color3.fromRGB(130, 155, 190),
        Stroke = Color3.fromRGB(255, 255, 255),
        Transparency = 0.20,
        Acrylic = 0.42,
        Glass = 0.52
    },
    Sakura = {
        Background = Color3.fromRGB(14, 7, 13),
        Panel = Color3.fromRGB(22, 12, 21),
        Surface = Color3.fromRGB(34, 18, 32),
        Accent = Color3.fromRGB(255, 125, 195),
        Accent2 = Color3.fromRGB(185, 140, 255),
        Text = Color3.fromRGB(255, 245, 252),
        Muted = Color3.fromRGB(185, 145, 175),
        Stroke = Color3.fromRGB(255, 255, 255),
        Transparency = 0.20,
        Acrylic = 0.42,
        Glass = 0.52
    },
    Light = {
        Background = Color3.fromRGB(244, 246, 250),
        Panel = Color3.fromRGB(255, 255, 255),
        Surface = Color3.fromRGB(235, 238, 245),
        Accent = Color3.fromRGB(76, 105, 220),
        Accent2 = Color3.fromRGB(92, 170, 238),
        Text = Color3.fromRGB(28, 32, 45),
        Muted = Color3.fromRGB(108, 115, 132),
        Stroke = Color3.fromRGB(120, 128, 150),
        Transparency = 0.08,
        Acrylic = 0.18,
        Glass = 0.16
    },
    Ember = {
        Background = Color3.fromRGB(13, 8, 4),
        Panel = Color3.fromRGB(22, 14, 8),
        Surface = Color3.fromRGB(34, 22, 12),
        Accent = Color3.fromRGB(255, 155, 55),
        Accent2 = Color3.fromRGB(255, 205, 100),
        Text = Color3.fromRGB(255, 248, 235),
        Muted = Color3.fromRGB(185, 155, 125),
        Stroke = Color3.fromRGB(255, 255, 255),
        Transparency = 0.20,
        Acrylic = 0.42,
        Glass = 0.52
    }
}

OpenHubUI.DefaultThemes = {
    Midnight = true,
    Obsidian = true,
    Aurora = true,
    Crimson = true,
    Sapphire = true,
    Sakura = true,
    Light = true,
    Ember = true
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        pcall(function() obj[k] = v end)
    end
    if parent then obj.Parent = parent end
    return obj
end

local function getExecutorName()
    local ok, name = pcall(function()
        if type(identifyexecutor) == "function" then return identifyexecutor() end
        if type(getexecutorname) == "function" then return getexecutorname() end
        return nil
    end)
    name = ok and name and tostring(name):gsub("^%s+", ""):gsub("%s+$", "") or ""
    if name ~= "" then return name end
    return RunService:IsStudio() and "Studio" or "Unknown"
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

local function pad(parent, l, r, t, b)
    return make("UIPadding", {
        PaddingLeft = UDim.new(0, l or 10),
        PaddingRight = UDim.new(0, r or l or 10),
        PaddingTop = UDim.new(0, t or 8),
        PaddingBottom = UDim.new(0, b or t or 8)
    }, parent)
end

local function tween(obj, time, props, style, direction)
    time = math.max(0.12, (time or 0.25) * 1.45)
    local t = TweenService:Create(obj, TweenInfo.new(
        time,
        style or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    ), props)
    t:Play()
    return t
end

local function assetId(value)
    if typeof(value) == "number" then return "rbxassetid://" .. value end
    if typeof(value) ~= "string" then return "" end
    if value == "" then return "" end
    if value:match("^rbxassetid://") or value:match("^https?://") then return value end
    if value:match("^%d+$") then return "rbxassetid://" .. value end
    local icon = OpenHubUI:GetIcon(value)
    if icon then return icon end
    return value
end

local function resolveAsset(path)
    if typeof(path) ~= "string" then return nil end
    if path:match("^rbxassetid://") or path:match("^https?://") then return path end
    if getsynasset then
        local ok, result = pcall(getsynasset, path)
        if ok and result and result ~= "" then return result end
    end
    if getcustomasset then
        local ok, result = pcall(getcustomasset, path)
        if ok and result and result ~= "" then return result end
    end
    if getcustomassetmacked then
        local ok, result = pcall(getcustomassetmacked, path)
        if ok and result and result ~= "" then return result end
    end
    return nil
end

local function downloadAsset(path)
    if typeof(path) ~= "string" or not path:match("^https?://") then return nil end
    local data
    local requestFunction = request or http_request or (syn and syn.request)
    if requestFunction then
        local ok, response = pcall(requestFunction, {Url = path, Method = "GET"})
        if ok and type(response) == "table" and (response.Success == nil or response.Success) then
            data = response.Body
        end
    end
    if not data and game and game.HttpGet then
        local ok, response = pcall(function() return game:HttpGet(path) end)
        if ok then data = response end
    end
    if not data or not writefile then return nil end
    local extension = path:match("%.([%a%d]+)") or "jpg"
    extension = extension:lower()
    if extension ~= "png" and extension ~= "jpg" and extension ~= "jpeg" and extension ~= "gif" and extension ~= "webp" then
        extension = "jpg"
    end
    local filename = "OpenHubUI_" .. HttpService:GenerateGUID(false):gsub("-", "") .. "." .. extension
    local ok = pcall(writefile, filename, data)
    if not ok then return nil end
    return resolveAsset(filename)
end

local function loadLocalImage(path, data)
    if typeof(path) == "number" then return assetId(path) end
    if typeof(path) ~= "string" then return "" end
    if path:match("^https?://") then
        return downloadAsset(path) or path
    end
    if path:match("^rbxassetid://") then return path end
    if path:match("%.png$") or path:match("%.jpg$") or path:match("%.jpeg$") or path:match("%.gif$") then
        if data and writefile then
            pcall(writefile, path, data)
        end
        local resolved = resolveAsset(path)
        if resolved then return resolved end
    end
    return assetId(path)
end

local function deepCopy(source)
    local out = {}
    for k, v in pairs(source) do out[k] = v end
    return out
end

local function normalizeColor(value, fallback)
    if typeof(value) == "Color3" then return value end
    if type(value) == "table" then
        local r = tonumber(value.R or value[1])
        local g = tonumber(value.G or value[2])
        local b = tonumber(value.B or value[3])
        if r and g and b then
            if r <= 1 and g <= 1 and b <= 1 then
                return Color3.new(math.clamp(r, 0, 1), math.clamp(g, 0, 1), math.clamp(b, 0, 1))
            end
            return Color3.fromRGB(math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255))
        end
    end
    if type(value) == "string" then
        local hex = value:gsub("#", ""):gsub("%s", "")
        if #hex == 6 then
            local r = tonumber(hex:sub(1, 2), 16)
            local g = tonumber(hex:sub(3, 4), 16)
            local b = tonumber(hex:sub(5, 6), 16)
            if r and g and b then return Color3.fromRGB(r, g, b) end
        end
    end
    return fallback
end

function OpenHubUI:CreateWindow(config)
    config = config or {}
    local themeName = config.Theme or "Midnight"
    local theme = deepCopy(self.Themes[themeName] or self.Themes.Midnight)
    local transparency = math.clamp(tonumber(config.Transparency) or theme.Transparency or 0.22, 0, 0.85)
    local acrylic = math.clamp(tonumber(config.Acrylic) or theme.Acrylic or 0.45, 0, 0.9)
    local glass = math.clamp(tonumber(config.Glass) or theme.Glass or 0.55, 0, 0.9)
    local resizable = config.Resizable ~= false

    local guiParent = CoreGui
    pcall(function() if gethui then guiParent = gethui() end end)

    local gui = make("ScreenGui", {
        Name = "OpenHubUI_" .. HttpService:GenerateGUID(false):gsub("-", ""),
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 1000
    }, guiParent)

    local state = {
        Theme = theme,
        ThemeName = themeName,
        Transparency = transparency,
        Acrylic = acrylic,
        Glass = glass,
        Tabs = {},
        Elements = {},
        Connections = {},
        Open = true,
        Destroyed = false,
        Resizable = resizable,
        Groups = {}
    }

    local scale = make("UIScale", {Scale = 1}, nil)
    local camera = workspace.CurrentCamera

    local function updateScale()
        if camera then
            local width = camera.ViewportSize.X
            scale.Scale = width < 520 and 0.78 or (width < 760 and 0.90 or 1)
        end
    end

    local DEFAULT_W, DEFAULT_H = 620, 500
    local winW = config.Width or DEFAULT_W
    local winH = config.Height or DEFAULT_H
    local MIN_W, MIN_H = 400, 300
    local MAX_W, MAX_H = 1200, 900

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
    corner(root, 16)
    local rootStroke = stroke(root, Color3.new(1, 1, 1), 0.82, 1.2)

    local glassLayer = make("Frame", {
        Name = "GlassLayer",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.94,
        BorderSizePixel = 0,
        ZIndex = 0
    }, root)
    corner(glassLayer, 16)

    local rootGradient = make("UIGradient", {
        Rotation = 140,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.Panel),
            ColorSequenceKeypoint.new(0.5, theme.Background),
            ColorSequenceKeypoint.new(1, theme.Panel)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.15),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 0.2)
        })
    }, root)

    local bg = make("ImageLabel", {
        Name = "BackgroundImage",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Crop,
        Image = "",
        ZIndex = 0
    }, root)
    corner(bg, 16)

    local darkOverlay = make("Frame", {
        Name = "AcrylicOverlay",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = theme.Background,
        BackgroundTransparency = acrylic,
        BorderSizePixel = 0,
        ZIndex = 1
    }, root)
    corner(darkOverlay, 16)

    local topGlow = make("Frame", {
        Name = "TopGlow",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.92,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 1),
        ZIndex = 8
    }, root)

    local header = make("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 54),
        Active = true,
        ZIndex = 3
    }, root)

    local logo = make("ImageLabel", {
        Name = "Logo",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(16, 12),
        Size = UDim2.fromOffset(28, 28),
        Image = assetId(config.Icon or ""),
        ImageColor3 = theme.Accent
    }, header)

    local title = make("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(config.Icon and 52 or 18, 9),
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
        Position = UDim2.fromOffset(config.Icon and 53 or 19, 30),
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
        Position = UDim2.new(1, -12, 0, 12),
        Size = UDim2.fromOffset(28, 28),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.92,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 5
    }, header)
    corner(close, 8)
    stroke(close, Color3.new(1, 1, 1), 0.88, 1)
    local closeIcon = make("ImageLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(15, 15),
        Image = assetId("x"),
        ImageColor3 = theme.Text,
        ZIndex = 6
    }, close)

    local minimize = make("TextButton", {
        Name = "Minimize",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -46, 0, 12),
        Size = UDim2.fromOffset(28, 28),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.92,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 5
    }, header)
    corner(minimize, 8)
    stroke(minimize, Color3.new(1, 1, 1), 0.88, 1)
    local minimizeIcon = make("ImageLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(15, 15),
        Image = assetId("minus"),
        ImageColor3 = theme.Text,
        ZIndex = 6
    }, minimize)

    local searchButton = make("ImageButton", {
        Name = "SearchButton",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -80, 0, 12),
        Size = UDim2.fromOffset(28, 28),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.92,
        Image = "",
        AutoButtonColor = false,
        ZIndex = 5
    }, header)
    corner(searchButton, 8)
    stroke(searchButton, Color3.new(1, 1, 1), 0.88, 1)
    local searchGlyph = make("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(15, 15),
        BackgroundTransparency = 1,
        Image = assetId("search"),
        ImageColor3 = theme.Text,
        ZIndex = 6
    }, searchButton)

    local searchBox = make("TextBox", {
        Name = "SearchBox",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -114, 0, 12),
        Size = UDim2.fromOffset(184, 28),
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 0.08,
        Text = "",
        PlaceholderText = "Search in OpenHub",
        PlaceholderColor3 = theme.Muted,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = theme.Text,
        ClearTextOnFocus = false,
        Visible = false,
        ZIndex = 6
    }, header)
    corner(searchBox, 8)
    stroke(searchBox, theme.Accent, 0.7, 1)
    local searchClear = make("ImageButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -120, 0, 26),
        Size = UDim2.fromOffset(16, 16),
        BackgroundTransparency = 1,
        Image = assetId("x"),
        ImageColor3 = theme.Muted,
        AutoButtonColor = false,
        Visible = false,
        ZIndex = 7
    }, header)
    local statusBar = make("Frame", {
        Name = "StatusBar",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -112, 0, 5),
        Size = UDim2.fromOffset(0, 40),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 6
    }, header)
    make("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, statusBar)
    local statusItems = {}
    local statusFpsConnection
    local function clearStatusItems()
        for _, item in ipairs(statusItems) do
            if item.Frame then item.Frame:Destroy() end
        end
        table.clear(statusItems)
    end
    local function addStatusItem(data, order)
        data = type(data) == "table" and data or {Text = tostring(data)}
        local color = normalizeColor(data.Color, theme.Accent)
        local textColor = normalizeColor(data.TextColor, theme.Text)
        local frame = make("Frame", {
            Name = tostring(data.Name or data.Text or "Status"),
            Size = UDim2.fromOffset(0, 22),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = color,
            BackgroundTransparency = 0.78,
            BorderSizePixel = 0,
            LayoutOrder = order or 1,
            ZIndex = 6
        }, statusBar)
        corner(frame, 8)
        stroke(frame, color, 0.55, 1)
        pad(frame, 7, 7, 0, 0)
        local iconName = data.Icon
        if iconName then
            make("ImageLabel", {
                Name = "Icon",
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(13, 13),
                Image = assetId(iconName),
                ImageColor3 = textColor,
                LayoutOrder = 1,
                ZIndex = 7
            }, frame)
        end
        local label = make("TextLabel", {
            Name = "Text",
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(0, 22),
            AutomaticSize = Enum.AutomaticSize.X,
            Font = Enum.Font.GothamSemibold,
            Text = tostring(data.Text or data.Name or "Status"),
            TextColor3 = textColor,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 2,
            ZIndex = 7
        }, frame)
        table.insert(statusItems, {Frame = frame, Label = label, Data = data})
    end
    local function setStatus(options)
        local showAll = options == true
        options = type(options) == "table" and options or {}
        if statusFpsConnection then statusFpsConnection:Disconnect() statusFpsConnection = nil end
        clearStatusItems()
        local showExecutor = showAll or options.Executor == true or options.ShowExecutor == true
        local showFPS = showAll or options.FPS == true or options.ShowFPS == true
        local tags = options.Tags or options.StatusTags
        if showExecutor then addStatusItem({Name = "Executor", Icon = "terminal", Text = getExecutorName(), Color = theme.Accent}, 1) end
        local fpsLabel
        if showFPS then
            local item = {Name = "FPS", Icon = "activity", Text = "-- FPS", Color = theme.Accent2}
            addStatusItem(item, 2)
            fpsLabel = statusItems[#statusItems].Label
            local frames, elapsed = 0, 0
            statusFpsConnection = RunService.RenderStepped:Connect(function(dt)
                frames = frames + 1
                elapsed = elapsed + dt
                if elapsed >= 0.5 then
                    fpsLabel.Text = tostring(math.floor(frames / elapsed + 0.5)) .. " FPS"
                    frames, elapsed = 0, 0
                end
            end)
            table.insert(state.Connections, statusFpsConnection)
        end
        if type(tags) == "table" then
            for index, tag in ipairs(tags) do addStatusItem(tag, index + 2) end
        end
        statusBar.Visible = #statusItems > 0
    end
    setStatus(config.Status or (config.ShowStatus and {Executor = config.ShowExecutor ~= false, FPS = config.ShowFPS ~= false, Tags = config.StatusTags}) or (config.StatusTags and {Tags = config.StatusTags}) or {})
    local dragSurface = make("TextButton", {
        Name = "DragSurface",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -112, 1, 0),
        Text = "",
        AutoButtonColor = false,
        Active = true,
        ZIndex = 4
    }, header)
    local searchStatus = make("TextLabel", {
        BackgroundColor3 = theme.Panel,
        BackgroundTransparency = 0.04,
        Position = UDim2.fromOffset(174, 58),
        Size = UDim2.fromOffset(220, 28),
        Text = "No matches found",
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = theme.Muted,
        TextXAlignment = Enum.TextXAlignment.Center,
        Visible = false,
        ZIndex = 100
    }, root)
    corner(searchStatus, 8)
    stroke(searchStatus, theme.Accent, 0.82, 1)

    local function objectMatches(object, query)
        local needle = string.lower(query or "")
        if needle == "" then return true end
        if string.find(string.lower(object.Name or ""), needle, 1, true) then return true end
        for _, child in ipairs(object:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                local text = tostring(child.Text or child.PlaceholderText or "")
                if string.find(string.lower(text), needle, 1, true) then return true end
            end
        end
        return false
    end

    local function filterSearch(query)
        query = tostring(query or "")
        local firstMatch
        local totalMatches = 0
        for _, tabItem in ipairs(state.Tabs) do
            local groupMatch = tabItem.Group and objectMatches(tabItem.Group.Instance, query) or false
            local tabMatch = groupMatch or objectMatches(tabItem.Page, query)
            for _, child in ipairs(tabItem.Page:GetChildren()) do
                if child:IsA("GuiObject") and not child:IsA("UIListLayout") then
                    child.Visible = query == "" or objectMatches(child, query)
                end
            end
            tabItem.Button.Visible = query == "" or tabMatch
            if tabMatch then
                totalMatches = totalMatches + 1
                if not firstMatch then firstMatch = tabItem end
            end
        end
        for _, group in ipairs(state.Groups) do
            local groupVisible = query == "" or objectMatches(group.Instance, query)
            for _, tabItem in ipairs(group.Tabs) do
                if tabItem.Button.Visible then groupVisible = true end
            end
            group.Instance.Visible = groupVisible
        end
        searchStatus.Visible = query ~= "" and totalMatches == 0
        if query ~= "" and firstMatch and firstMatch.Select then firstMatch.Select() end
    end

    local searchOpen = false
    searchButton.MouseButton1Click:Connect(function()
        searchOpen = not searchOpen
        searchBox.Visible = searchOpen
        searchClear.Visible = searchOpen
        if searchOpen then
            searchBox:CaptureFocus()
        else
            searchBox.Text = ""
            filterSearch("")
        end
    end)
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        filterSearch(searchBox.Text)
    end)
    searchClear.MouseButton1Click:Connect(function()
        searchBox.Text = ""
        searchBox:CaptureFocus()
    end)
    local searchKeyConn = UserInputService.InputBegan:Connect(function(input, processed)
        if processed or not searchOpen then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Escape then
            searchOpen = false
            searchBox.Visible = false
            searchClear.Visible = false
            searchBox.Text = ""
            filterSearch("")
        end
    end)
    table.insert(state.Connections, searchKeyConn)

    close.MouseEnter:Connect(function()
        tween(close, 0.15, {BackgroundColor3 = Color3.fromRGB(255, 80, 90), BackgroundTransparency = 0.15})
    end)
    close.MouseLeave:Connect(function()
        tween(close, 0.15, {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.92})
    end)
    minimize.MouseEnter:Connect(function()
        tween(minimize, 0.15, {BackgroundTransparency = 0.85})
    end)
    minimize.MouseLeave:Connect(function()
        tween(minimize, 0.15, {BackgroundTransparency = 0.92})
    end)

    local divider = make("Frame", {
        Name = "HeaderLine",
        Position = UDim2.new(0, 14, 0, 53),
        Size = UDim2.new(1, -28, 0, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        ZIndex = 3
    }, root)

    local nav = make("ScrollingFrame", {
        Name = "Tabs",
        Position = UDim2.fromOffset(12, 64),
        Size = UDim2.new(0, 142, 1, -78),
        BackgroundColor3 = theme.Panel,
        BackgroundTransparency = glass,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.Accent,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 3
    }, root)
    corner(nav, 12)
    stroke(nav, Color3.new(1, 1, 1), 0.88, 1)
    pad(nav, 8, 8, 10, 10)
    make("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, nav)

    local content = make("Frame", {
        Name = "Content",
        Position = UDim2.new(0, 162, 0, 64),
        Size = UDim2.new(1, -176, 1, -78),
        BackgroundColor3 = theme.Panel,
        BackgroundTransparency = glass,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 3
    }, root)
    corner(content, 12)
    stroke(content, Color3.new(1, 1, 1), 0.88, 1)

    local contentPages = make("Folder", {Name = "Pages"}, content)

    local openButton = make("TextButton", {
        Name = "OpenButton",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 16),
        Size = UDim2.fromOffset(158, 46),
        BackgroundColor3 = theme.Panel,
        BackgroundTransparency = 0.08,
        Text = "",
        AutoButtonColor = false,
        Active = true,
        Visible = config.OpenButton ~= false,
        ZIndex = 20
    }, gui)
    corner(openButton, 13)
    stroke(openButton, theme.Accent, 0.35, 1.2)

    local openIcon = make("ImageButton", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(10, 9),
        Size = UDim2.fromOffset(28, 28),
        Image = assetId(config.OpenButtonIcon or config.Icon or "6031097225"),
        ImageColor3 = theme.Accent,
        AutoButtonColor = false,
        Active = true,
        ZIndex = 22
    }, openButton)

    local openTitle = make("TextLabel", {
        Name = "OpenTitle",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(48, 0),
        Size = UDim2.new(1, -58, 1, 0),
        Text = "Open Window",
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21
    }, openButton)

    local minimized = false
    local function setOpen(value)
        state.Open = value
        if value then
            if minimized then
                minimized = false
                content.Visible = true
                nav.Visible = true
                divider.Visible = true
                minimizeIcon.Image = assetId("minus")
            end
            root.Visible = true
            root.Size = UDim2.fromOffset(winW * 0.94, winH * 0.94)
            tween(root, 0.3, {Size = UDim2.fromOffset(winW, winH)}, Enum.EasingStyle.Back)
            tween(openButton, 0.2, {BackgroundTransparency = 0.15})
        else
            tween(root, 0.18, {Size = UDim2.fromOffset(winW * 0.9, winH * 0.9)}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            task.delay(0.19, function()
                if not state.Open and root.Parent then root.Visible = false end
            end)
            tween(openButton, 0.2, {BackgroundTransparency = 0.05})
        end
    end

    local suppressOpenClick = false
    openButton.MouseButton1Click:Connect(function()
        if suppressOpenClick then
            suppressOpenClick = false
            return
        end
        setOpen(not state.Open)
    end)
    close.MouseButton1Click:Connect(function() setOpen(false) end)

    minimize.MouseButton1Click:Connect(function()
        minimized = not minimized
        content.Visible = not minimized
        nav.Visible = not minimized
        divider.Visible = not minimized
        tween(root, 0.22, {
            Size = minimized and UDim2.fromOffset(winW, 54) or UDim2.fromOffset(winW, winH)
        })
        minimizeIcon.Image = assetId(minimized and "plus" or "minus")
    end)

    local openDragging = false
    local openDragMoved = false
    local openDragStart
    local openDragOffset
    openIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            openDragging = true
            openDragMoved = false
            openDragStart = input.Position
            openDragOffset = input.Position - openButton.AbsolutePosition
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then openDragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if openDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - openDragStart
            if delta.Magnitude > 4 then openDragMoved = true end
            local size = openButton.AbsoluteSize
            local topLeft = input.Position - openDragOffset
            local x = topLeft.X + size.X / 2
            local y = topLeft.Y
            openButton.Position = UDim2.fromOffset(x, y)
            if openDragMoved then suppressOpenClick = true end
        end
    end)

    local dragging, dragStart, dragOffset, dragInput
    dragSurface.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            dragOffset = input.Position - root.AbsolutePosition
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragSurface.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local size = root.AbsoluteSize
            local topLeft = input.Position - dragOffset
            local x = topLeft.X + size.X / 2
            local y = topLeft.Y + size.Y / 2
            root.Position = UDim2.fromOffset(x, y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            dragInput = nil
        end
    end)

    local resizeHandles = {}
    local resizeVisuals = {}
    local _drag = nil

    local function addResizeVisual(name, position, anchor, size, rotation)
        local grip = make("Frame", {
            Name = name,
            AnchorPoint = anchor,
            Position = position,
            Size = size,
            Rotation = rotation or 0,
            BackgroundColor3 = theme.Text,
            BackgroundTransparency = 0.35,
            BorderSizePixel = 0,
            ZIndex = 39,
            Visible = resizable,
        }, root)
        corner(grip, 99)
        table.insert(resizeVisuals, grip)
        return grip
    end

    addResizeVisual("ResizeGuideBL_Outer", UDim2.new(0, 13, 1, -10), Vector2.new(.5, .5), UDim2.fromOffset(16, 3), -45)
    addResizeVisual("ResizeGuideBL_Inner", UDim2.new(0, 20, 1, -10), Vector2.new(.5, .5), UDim2.fromOffset(10, 3), -45)
    addResizeVisual("ResizeGuideBR_Outer", UDim2.new(1, -13, 1, -10), Vector2.new(.5, .5), UDim2.fromOffset(16, 3), 45)
    addResizeVisual("ResizeGuideBR_Inner", UDim2.new(1, -20, 1, -10), Vector2.new(.5, .5), UDim2.fromOffset(10, 3), 45)
    addResizeVisual("ResizeGuideLeft",  UDim2.new(0,    6, .5, 0), Vector2.new(.5, .5), UDim2.fromOffset(3, 36), 0)
    addResizeVisual("ResizeGuideRight", UDim2.new(1,   -6, .5, 0), Vector2.new(.5, .5), UDim2.fromOffset(3, 36), 0)

    local function addResizeHandle(name, position, anchor, size, xFactor, yFactor)
        local hit = make("TextButton", {
            Name = name,
            AnchorPoint = anchor,
            Position = position,
            Size = size,
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 40,
            Visible = resizable
        }, root)
        table.insert(resizeHandles, {Hit = hit, X = xFactor, Y = yFactor})
        return hit
    end

    addResizeHandle("ResizeTL", UDim2.fromScale(0, 0), Vector2.new(0, 0), UDim2.fromOffset(28, 28), -1, -1)
    addResizeHandle("ResizeTR", UDim2.fromScale(1, 0), Vector2.new(1, 0), UDim2.fromOffset(28, 28),  1, -1)
    addResizeHandle("ResizeBL", UDim2.fromScale(0, 1), Vector2.new(0, 1), UDim2.fromOffset(28, 28), -1,  1)
    addResizeHandle("ResizeBR", UDim2.fromScale(1, 1), Vector2.new(1, 1), UDim2.fromOffset(28, 28),  1,  1)
    addResizeHandle("ResizeTop",    UDim2.fromScale(.5, 0), Vector2.new(.5, 0), UDim2.new(.34, 0, 0, 12),  0, -1)
    addResizeHandle("ResizeBottom", UDim2.fromScale(.5, 1), Vector2.new(.5, 1), UDim2.new(.34, 0, 0, 14),  0,  1)
    addResizeHandle("ResizeLeft",   UDim2.fromScale(0, .5), Vector2.new(0, .5), UDim2.new(0, 12, .34, 0), -1,  0)
    addResizeHandle("ResizeRight",  UDim2.fromScale(1, .5), Vector2.new(1, .5), UDim2.new(0, 12, .34, 0),  1,  0)

    local function beginResize(info, input)
        if not state.Resizable then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local start = input.Position
        local startW = root.AbsoluteSize.X
        local startH = root.AbsoluteSize.Y
        local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
        _drag = {
            Input = input,
            Update = function(pos)
                local delta = pos - start
                local maxW = math.max(260, vp.X)
                local maxH = math.max(220, vp.Y)
                local newW = math.clamp(startW + info.X * delta.X, MIN_W, math.min(MAX_W, maxW))
                local newH = math.clamp(startH + info.Y * delta.Y, MIN_H, math.min(MAX_H, maxH))
                winW, winH = newW, newH
                root.Size = UDim2.fromOffset(newW, newH)
            end
        }
    end

    for _, info in ipairs(resizeHandles) do
        info.Hit.InputBegan:Connect(function(input) beginResize(info, input) end)
    end

    UserInputService.InputChanged:Connect(function(input)
        if not _drag then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        _drag.Update(input.Position)
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            _drag = nil
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
        darkOverlay.BackgroundColor3 = theme.Background
        darkOverlay.BackgroundTransparency = state.Acrylic
        rootStroke.Color = theme.Stroke or Color3.new(1, 1, 1)
        title.TextColor3 = theme.Text
        subtitle.TextColor3 = theme.Muted
        close.TextColor3 = theme.Text
        minimize.TextColor3 = theme.Text
        closeIcon.ImageColor3 = theme.Text
        minimizeIcon.ImageColor3 = theme.Text
        openTitle.TextColor3 = theme.Text
        openIcon.ImageColor3 = theme.Accent
        searchButton.BackgroundColor3 = theme.Panel
        searchGlyph.ImageColor3 = theme.Text
        searchBox.BackgroundColor3 = theme.Surface
        searchBox.TextColor3 = theme.Text
        searchBox.PlaceholderColor3 = theme.Muted
        searchClear.ImageColor3 = theme.Muted
        searchStatus.BackgroundColor3 = theme.Panel
        searchStatus.TextColor3 = theme.Muted
        nav.ScrollBarImageColor3 = theme.Accent
        content.BackgroundColor3 = theme.Panel
        content.BackgroundTransparency = state.Glass
        nav.BackgroundColor3 = theme.Panel
        nav.BackgroundTransparency = state.Glass
        openButton.BackgroundColor3 = theme.Panel
        openIcon.ImageColor3 = theme.Accent
        logo.ImageColor3 = theme.Accent
        for _, item in ipairs(statusItems) do
            local color = normalizeColor(item.Data.Color, theme.Accent)
            local textColor = normalizeColor(item.Data.TextColor, theme.Text)
            item.Frame.BackgroundColor3 = color
            item.Label.TextColor3 = textColor
            local icon = item.Frame:FindFirstChild("Icon")
            if icon then icon.ImageColor3 = textColor end
        end
        for _, grip in ipairs(resizeVisuals) do
            grip.BackgroundColor3 = theme.Text
        end
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
        name = tostring(name or "Custom")
        local custom = deepCopy(theme)
        for k, v in pairs(values or {}) do
            if custom[k] ~= nil then custom[k] = v end
        end
        OpenHubUI.Themes[name] = custom
        applyTheme(custom, name)
        return custom
    end

    function state:GetThemes()
        return deepCopy(OpenHubUI.Themes)
    end

    function state:DeleteCustomTheme(name)
        if OpenHubUI.Themes[name] and not OpenHubUI.DefaultThemes[name] then
            OpenHubUI.Themes[name] = nil
            if state.ThemeName == name then applyTheme(OpenHubUI.Themes.Midnight, "Midnight") end
            return true
        end
        return false
    end

    function state:SetTransparency(value)
        state.Transparency = math.clamp(tonumber(value) or state.Transparency, 0, 0.85)
        root.BackgroundTransparency = state.Transparency
    end

    function state:SetAcrylic(value)
        state.Acrylic = math.clamp(tonumber(value) or state.Acrylic, 0, 0.9)
        darkOverlay.BackgroundTransparency = state.Acrylic
    end

    function state:SetGlass(value)
        state.Glass = math.clamp(tonumber(value) or state.Glass, 0, 0.9)
        content.BackgroundTransparency = state.Glass
        nav.BackgroundTransparency = state.Glass
    end

    function state:SetBackground(source, options)
        options = options or {}
        local image
        image = loadLocalImage(source, options.Data)
        bg.Image = image or ""
        bg.ImageTransparency = math.clamp(tonumber(options.Transparency) or 0.7, 0, 1)
        bg.ScaleType = options.ScaleType == "Fit" and Enum.ScaleType.Fit or Enum.ScaleType.Crop
        return bg.Image ~= ""
    end

    function state:SetResizable(value)
        state.Resizable = value == true
        for _, info in ipairs(resizeHandles) do
            info.Hit.Visible = state.Resizable
        end
        for _, grip in ipairs(resizeVisuals) do
            grip.Visible = state.Resizable
        end
    end

    function state:Notify(notice)
        notice = type(notice) == "table" and notice or {Text = tostring(notice)}
        local duration = tonumber(notice.Duration) or 4

        local holder = gui:FindFirstChild("Notifications")
        if not holder then
            holder = make("Frame", {
                Name = "Notifications",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -18, 0, 18),
                Size = UDim2.fromOffset(300, 500),
                ZIndex = 400
            }, gui)
            make("UIListLayout", {
                Padding = UDim.new(0, 10),
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Top
            }, holder)
        end

        local card = make("Frame", {
            BackgroundColor3 = theme.Panel,
            BackgroundTransparency = 0.08,
            Size = UDim2.fromOffset(280, 0),
            ClipsDescendants = true,
            ZIndex = 401
        }, holder)
        corner(card, 12)
        make("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new(theme.Surface, theme.Panel),
            Transparency = NumberSequence.new(0.08)
        }, card)

        local noticeIcon = make("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(14, 13),
            Size = UDim2.fromOffset(22, 22),
            Image = assetId(notice.Icon or "bell"),
            ImageColor3 = theme.Accent,
            ZIndex = 402
        }, card)

        local dismiss = make("ImageButton", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -12, 0, 12),
            Size = UDim2.fromOffset(20, 20),
            Image = assetId("x"),
            ImageColor3 = theme.Muted,
            AutoButtonColor = false,
            ZIndex = 403
        }, card)
        dismiss.MouseButton1Click:Connect(function()
            if card.Parent then
                tween(card, 0.2, {BackgroundTransparency = 1, Size = UDim2.fromOffset(280, 0)})
                task.delay(0.22, function()
                    if card.Parent then card:Destroy() end
                end)
            end
        end)

        local titleLbl = make("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(46, 10),
            Size = UDim2.new(1, -82, 0, 22),
            Text = notice.Title or "OpenHub",
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextColor3 = theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 402
        }, card)

        local bodyLbl = make("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(46, 34),
            Size = UDim2.new(1, -62, 0, 0),
            Text = notice.Content or notice.Text or "",
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextWrapped = true,
            TextColor3 = theme.Muted,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 402
        }, card)

        task.defer(function()
            local textH = math.max(bodyLbl.TextBounds.Y, 16)
            local totalH = 48 + textH
            card.Size = UDim2.fromOffset(280, 0)
            card.BackgroundTransparency = 1
            tween(card, 0.3, {Size = UDim2.fromOffset(280, totalH), BackgroundTransparency = 0.08}, Enum.EasingStyle.Quint)
        end)

        task.delay(duration, function()
            if card.Parent then
                tween(card, 0.3, {BackgroundTransparency = 1, Size = UDim2.fromOffset(280, 0)}, Enum.EasingStyle.Quint)
                task.wait(0.32)
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
    local layoutOrder = 0
    local currentGroup

    function Window:CreateTabGroup(cfg)
        cfg = type(cfg) == "table" and cfg or {Name = tostring(cfg or "Group")}
        layoutOrder = layoutOrder + 1

        local frame = make("Frame", {
            Name = "Group_" .. (cfg.Name or "Group"),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 28),
            LayoutOrder = layoutOrder,
            ZIndex = 4
        }, nav)

        local button = make("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            AutoButtonColor = false,
            Active = true,
            ZIndex = 5
        }, frame)

        local groupIcon = make("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(4, 6),
            Size = UDim2.fromOffset(16, 16),
            Image = assetId(cfg.Icon or "folder-open"),
            ImageColor3 = theme.Muted,
            ZIndex = 6
        }, button)

        local lbl = make("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(26, 6),
            Size = UDim2.new(1, -52, 0, 16),
            Text = string.upper(cfg.Name or "GROUP"),
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextColor3 = theme.Muted,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 0.15,
            ZIndex = 5
        }, button)

        local arrow = make("ImageLabel", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -5, 0, 6),
            Size = UDim2.fromOffset(16, 16),
            Image = assetId("chevron-up"),
            ImageColor3 = theme.Muted,
            ZIndex = 6
        }, button)

        local item = {Instance = frame, Button = button, Label = lbl, Icon = groupIcon, Arrow = arrow, Tabs = {}, Expanded = true}
        function item:SetExpanded(value)
            item.Expanded = value == true
            tween(arrow, 0.28, {Rotation = item.Expanded and 0 or 180})
            for _, tab in ipairs(item.Tabs) do
                if item.Expanded then
                    tab.Button.Visible = true
                    tab.Button.Size = UDim2.new(1, 0, 0, 0)
                    tween(tab.Button, 0.28, {Size = UDim2.new(1, 0, 0, 34)})
                else
                    tween(tab.Button, 0.28, {Size = UDim2.new(1, 0, 0, 0)})
                    task.delay(0.3, function()
                        if not item.Expanded and tab.Button.Parent then tab.Button.Visible = false end
                    end)
                end
            end
        end
        button.MouseButton1Click:Connect(function()
            item:SetExpanded(not item.Expanded)
        end)
        function item:UpdateTheme(t)
            lbl.TextColor3 = t.Muted
            groupIcon.ImageColor3 = t.Muted
            arrow.ImageColor3 = t.Muted
        end
        table.insert(state.Groups, item)
        table.insert(state.Elements, item)
        currentGroup = item
        return item
    end

    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or ("Tab " .. (#state.Tabs + 1))
        layoutOrder = layoutOrder + 1

        local button = make("TextButton", {
            Name = tabName .. "Button",
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = theme.Accent,
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = layoutOrder,
            ZIndex = 4
        }, nav)
        corner(button, 8)

        local icon = make("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(8, 8),
            Size = UDim2.fromOffset(16, 16),
            Image = assetId(tabConfig.Icon or ""),
            ImageColor3 = theme.Muted,
            ZIndex = 5
        }, button)

        local hasIcon = tabConfig.Icon and tabConfig.Icon ~= ""
        local label = make("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(hasIcon and 30 or 10, 0),
            Size = UDim2.new(1, hasIcon and -38 or -16, 1, 0),
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
        pad(page, 12, 12, 12, 12)
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

        tab.Group = currentGroup
        if currentGroup then
            table.insert(currentGroup.Tabs, tab)
            button.Visible = currentGroup.Expanded
        end

        local function selectTab()
            state.SelectedTab = tabName
            for _, other in ipairs(state.Tabs) do
                other.Page.Visible = false
                tween(other.Button, 0.18, {BackgroundTransparency = 1})
                other.Label.TextColor3 = theme.Muted
                other.Icon.ImageColor3 = theme.Muted
            end
            page.Visible = true
            tween(button, 0.2, {BackgroundTransparency = 0.82})
            label.TextColor3 = theme.Text
            icon.ImageColor3 = theme.Accent
            page.CanvasPosition = Vector2.new(0, 0)
        end

        tab.Select = selectTab

        button.MouseButton1Click:Connect(selectTab)
        button.MouseEnter:Connect(function()
            if not page.Visible then
                tween(button, 0.12, {BackgroundTransparency = 0.92})
            end
        end)
        button.MouseLeave:Connect(function()
            if not page.Visible then
                tween(button, 0.12, {BackgroundTransparency = 1})
            end
        end)

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

        local function elementFrame(name, height)
            local frame = make("Frame", {
                Name = name or "Element",
                Size = UDim2.new(1, 0, 0, height or 48),
                BackgroundColor3 = theme.Surface,
                BackgroundTransparency = 0.25,
                BorderSizePixel = 0,
                ZIndex = 5
            }, page)
            corner(frame, 10)
            stroke(frame, Color3.new(1, 1, 1), 0.9, 1)
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
                Size = UDim2.new(1, 0, 0, 24),
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
            local item = {Instance = frame}
            function item:UpdateTheme(t) lbl.TextColor3 = t.Accent end
            return addElement(item)
        end

        function tab:CreateBanner(cfg)
            cfg = type(cfg) == "table" and cfg or {Image = cfg}
            local height = math.clamp(tonumber(cfg.Height) or 148, 86, 280)
            local frame = make("Frame", {
                Name = cfg.Name or "Banner",
                Size = UDim2.new(1, 0, 0, height),
                BackgroundColor3 = theme.Surface,
                BackgroundTransparency = 0.08,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                ZIndex = 5
            }, page)
            corner(frame, 12)
            stroke(frame, Color3.new(1, 1, 1), 0.82, 1)
            local image = make("ImageLabel", {
                Name = "Image",
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Image = loadLocalImage(cfg.Image or cfg.ImageUrl or "", cfg.Data) or "",
                ImageTransparency = math.clamp(tonumber(cfg.ImageTransparency) or 0.08, 0, 1),
                ScaleType = cfg.ScaleType == "Fit" and Enum.ScaleType.Fit or Enum.ScaleType.Crop,
                ZIndex = 5
            }, frame)
            corner(image, 12)
            local shade = make("Frame", {
                Name = "Shade",
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = theme.Background,
                BackgroundTransparency = 0.18,
                BorderSizePixel = 0,
                ZIndex = 6
            }, frame)
            corner(shade, 12)
            make("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.48, 0.9),
                    NumberSequenceKeypoint.new(1, 0.05)
                })
            }, shade)
            local titleLabel = make("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 1, -48),
                Size = UDim2.new(1, -28, 0, 22),
                Text = tostring(cfg.Title or ""),
                Font = Enum.Font.GothamBold,
                TextSize = tonumber(cfg.TitleSize) or 16,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 7
            }, frame)
            local descriptionLabel = make("TextLabel", {
                Name = "Description",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 1, -26),
                Size = UDim2.new(1, -28, 0, 16),
                Text = tostring(cfg.Description or ""),
                Font = Enum.Font.Gotham,
                TextSize = tonumber(cfg.DescriptionSize) or 11,
                TextColor3 = theme.Muted,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Visible = cfg.Description ~= nil and tostring(cfg.Description) ~= "",
                ZIndex = 7
            }, frame)
            local item = {Instance = frame, Image = image, Title = titleLabel, Description = descriptionLabel}
            function item:UpdateTheme(t)
                shade.BackgroundColor3 = t.Background
                titleLabel.TextColor3 = t.Text
                descriptionLabel.TextColor3 = t.Muted
            end
            return addElement(item)
        end

        function tab:CreateLabel(cfg)
            cfg = type(cfg) == "table" and cfg or {Text = tostring(cfg or "Label")}
            local frame = elementFrame(cfg.Name or "Label", cfg.Height or 38)
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
            local frame = elementFrame(cfg.Name or "Paragraph", cfg.Height or 72)
            local head = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 8),
                Size = UDim2.new(1, -24, 0, 16),
                Text = cfg.Title or "Information",
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local body = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 28),
                Size = UDim2.new(1, -24, 1, -36),
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
            local hasDescription = cfg.Description ~= nil and tostring(cfg.Description) ~= ""
            local frame = elementFrame(cfg.Name or "Button", hasDescription and 60 or 42)
            local btn = make("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 6
            }, frame)
            local txt = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, hasDescription and 5 or 0),
                Size = UDim2.new(1, -40, 0, hasDescription and 18 or 42),
                Text = cfg.Name or "Button",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 7
            }, btn)
            local desc
            if hasDescription then
                desc = make("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(14, 27),
                    Size = UDim2.new(1, -42, 0, 18),
                    Text = tostring(cfg.Description),
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    TextColor3 = theme.Muted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 7
                }, btn)
            end
            local arrow = make("ImageLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(16, 18),
                Image = assetId("arrow-right"),
                ImageColor3 = theme.Muted,
                ZIndex = 7
            }, btn)
            btn.MouseEnter:Connect(function()
                tween(frame, 0.14, {BackgroundTransparency = 0.1})
            end)
            btn.MouseLeave:Connect(function()
                tween(frame, 0.14, {BackgroundTransparency = 0.25})
            end)
            btn.MouseButton1Click:Connect(function()
                if cfg.Callback then task.spawn(cfg.Callback) end
            end)
            local item = {Instance = frame}
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
                txt.TextColor3 = t.Text
                arrow.ImageColor3 = t.Muted
                if desc then desc.TextColor3 = t.Muted end
            end
            return addElement(item)
        end

        function tab:CreateToggle(cfg)
            cfg = cfg or {}
            local value = cfg.CurrentValue == true
            local frame = elementFrame(cfg.Name or "Toggle", cfg.Description and 58 or 44)
            local name = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, cfg.Description and 6 or 0),
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
                    Position = UDim2.fromOffset(12, 26),
                    Size = UDim2.new(1, -72, 0, 20),
                    Text = cfg.Description,
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    TextColor3 = theme.Muted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6
                }, frame)
            end
            local switch = make("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(40, 22),
                BackgroundColor3 = value and theme.Accent or Color3.fromRGB(60, 60, 70),
                BackgroundTransparency = value and 0.1 or 0.3,
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
            corner(knob, 8)
            local function set(v, fire)
                value = v == true
                tween(switch, 0.18, {
                    BackgroundColor3 = value and theme.Accent or Color3.fromRGB(60, 60, 70),
                    BackgroundTransparency = value and 0.1 or 0.3
                })
                tween(knob, 0.18, {
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
                if value then switch.BackgroundColor3 = t.Accent end
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
            local hasDescription = cfg.Description ~= nil and tostring(cfg.Description) ~= ""
            local sliderOffset = hasDescription and 18 or 0
            local frame = elementFrame(cfg.Name or "Slider", hasDescription and 76 or 58)
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 6),
                Size = UDim2.new(1, -70, 0, 16),
                Text = cfg.Name or "Slider",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local desc
            if hasDescription then
                desc = make("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(12, 23),
                    Size = UDim2.new(1, -24, 0, 14),
                    Text = tostring(cfg.Description),
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    TextColor3 = theme.Muted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 6
                }, frame)
            end
            local valLabel = make("TextLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -12, 0, 6),
                Size = UDim2.fromOffset(55, 16),
                Text = tostring(value),
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextColor3 = theme.Accent,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 6
            }, frame)
            local track = make("Frame", {
                Position = UDim2.new(0, 12, 0, 34 + sliderOffset),
                Size = UDim2.new(1, -24, 0, 5),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 0.88,
                BorderSizePixel = 0,
                ZIndex = 6
            }, frame)
            corner(track, 3)
            local fill = make("Frame", {
                Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0),
                BackgroundColor3 = theme.Accent,
                BorderSizePixel = 0,
                ZIndex = 7
            }, track)
            corner(fill, 3)
            local knob = make("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new((value - min) / math.max(max - min, 1), 0, 0.5, 0),
                Size = UDim2.fromOffset(12, 12),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 8
            }, track)
            corner(knob, 6)
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
                    local p = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                    set(min + (max - min) * p, true)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local p = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
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
                fill.BackgroundColor3 = t.Accent
                if desc then desc.TextColor3 = t.Muted end
            end
            return addElement(item)
        end

        function tab:CreateInput(cfg)
            cfg = cfg or {}
            local hasDescription = cfg.Description ~= nil and tostring(cfg.Description) ~= ""
            local frame = elementFrame(cfg.Name or "Input", hasDescription and 72 or 52)
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 5),
                Size = UDim2.new(1, -24, 0, 14),
                Text = cfg.Name or "Input",
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextColor3 = theme.Muted,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local desc
            if hasDescription then
                desc = make("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(12, 20),
                    Size = UDim2.new(1, -24, 0, 14),
                    Text = tostring(cfg.Description),
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    TextColor3 = theme.Muted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 6
                }, frame)
            end
            local box = make("TextBox", {
                Position = UDim2.fromOffset(12, hasDescription and 40 or 22),
                Size = UDim2.new(1, -24, 0, 22),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.6,
                Text = tostring(cfg.Default or ""),
                PlaceholderText = cfg.Placeholder or "Enter value...",
                ClearTextOnFocus = false,
                TextColor3 = theme.Text,
                PlaceholderColor3 = theme.Muted,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 6
            }, frame)
            corner(box, 6)
            pad(box, 8, 8, 0, 0)
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
                label.TextColor3 = t.Muted
                box.TextColor3 = t.Text
                box.PlaceholderColor3 = t.Muted
                if desc then desc.TextColor3 = t.Muted end
            end
            return addElement(item)
        end

        function tab:CreateDropdown(cfg)
            cfg = cfg or {}
            local options = cfg.Options or {"Option 1", "Option 2"}
            local selected = cfg.CurrentOption or options[1]
            if type(selected) == "table" then selected = selected[1] end
            local expanded = false

            local hasDescription = cfg.Description ~= nil and tostring(cfg.Description) ~= ""
            local baseHeight = hasDescription and 66 or 44
            local frame = elementFrame(cfg.Name or "Dropdown", baseHeight)
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, hasDescription and 5 or 0),
                Size = UDim2.new(0.4, 0, 1, 0),
                Text = cfg.Name or "Dropdown",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local desc
            if hasDescription then
                desc = make("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(12, 25),
                    Size = UDim2.new(0.42, -12, 0, 14),
                    Text = tostring(cfg.Description),
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    TextColor3 = theme.Muted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 6
                }, frame)
            end

            local chosen = make("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.new(0.55, 0, 0, 28),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.55,
                Text = tostring(selected),
                Font = Enum.Font.Gotham,
                TextSize = 11,
                TextColor3 = theme.Text,
                AutoButtonColor = false,
                ZIndex = 6
            }, frame)
            corner(chosen, 7)
            local chosenArrow = make("ImageLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -16, 0.5, 0),
                Size = UDim2.fromOffset(14, 14),
                Image = assetId("chevron-down"),
                ImageColor3 = theme.Muted,
                ZIndex = 7
            }, frame)

            local list = make("Frame", {
                Name = "DropdownPopup",
                BackgroundColor3 = theme.Panel,
                BackgroundTransparency = 0.08,
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 500,
                Position = UDim2.new(0, 4, 0, baseHeight + 6),
                Size = UDim2.new(1, -8, 0, 0)
            }, frame)
            corner(list, 10)
            stroke(list, Color3.new(1, 1, 1), 0.8, 1)

            local scroll = make("ScrollingFrame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 1),
                CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = theme.Accent,
                ZIndex = 501
            }, list)
            pad(scroll, 6, 6, 6, 6)
            make("UIListLayout", {
                Padding = UDim.new(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder
            }, scroll)

            local function closeList()
                expanded = false
                tween(frame, 0.18, {Size = UDim2.new(1, 0, 0, baseHeight)})
                tween(list, 0.18, {Size = UDim2.new(1, -8, 0, 0)})
                task.delay(0.19, function()
                    if not expanded then list.Visible = false end
                end)
            end

            local function rebuild()
                for _, c in ipairs(scroll:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                for i, opt in ipairs(options) do
                    local b = make("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = theme.Accent,
                        BackgroundTransparency = 0.92,
                        Text = "  " .. tostring(opt),
                        Font = Enum.Font.Gotham,
                        TextSize = 12,
                        TextColor3 = theme.Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutoButtonColor = false,
                        LayoutOrder = i,
                        ZIndex = 502
                    }, scroll)
                    corner(b, 6)
                    b.MouseEnter:Connect(function()
                        tween(b, 0.1, {BackgroundTransparency = 0.75})
                    end)
                    b.MouseLeave:Connect(function()
                        tween(b, 0.1, {BackgroundTransparency = 0.92})
                    end)
                    b.MouseButton1Click:Connect(function()
                        selected = opt
                        chosen.Text = tostring(opt)
                        closeList()
                        if cfg.Callback then task.spawn(cfg.Callback, opt) end
                    end)
                end
            end
            rebuild()

            local function openList()
                expanded = true
                local popupH = math.min(#options, 6) * 31 + 14
                list.Position = UDim2.new(0, 4, 0, baseHeight + 6)
                list.Size = UDim2.new(1, -8, 0, 0)
                list.Visible = true
                tween(frame, 0.22, {Size = UDim2.new(1, 0, 0, baseHeight + popupH + 6)})
                tween(list, 0.22, {Size = UDim2.new(1, -8, 0, popupH)})
            end

            chosen.MouseButton1Click:Connect(function()
                if expanded then closeList() else openList() end
            end)


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
                chosen.TextColor3 = t.Text
                chosenArrow.ImageColor3 = t.Muted
                list.BackgroundColor3 = t.Panel
                if desc then desc.TextColor3 = t.Muted end
            end
            return addElement(item)
        end

        function tab:CreateKeybind(cfg)
            cfg = cfg or {}
            local key = cfg.CurrentBind or "RightShift"
            local listening = false
            local hasDescription = cfg.Description ~= nil and tostring(cfg.Description) ~= ""
            local frame = elementFrame(cfg.Name or "Keybind", hasDescription and 64 or 44)
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, hasDescription and 5 or 0),
                Size = UDim2.new(1, -100, 0, hasDescription and 18 or 44),
                Text = cfg.Name or "Keybind",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local desc
            if hasDescription then
                desc = make("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(12, 26),
                    Size = UDim2.new(1, -100, 0, 14),
                    Text = tostring(cfg.Description),
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    TextColor3 = theme.Muted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 6
                }, frame)
            end
            local btn = make("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(78, 26),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.55,
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
                btn.TextColor3 = t.Accent
                if desc then desc.TextColor3 = t.Muted end
            end
            return addElement(item)
        end

        function tab:CreateColorPicker(cfg)
            cfg = type(cfg) == "table" and cfg or {Name = tostring(cfg or "Color")}
            local color = normalizeColor(cfg.Color or cfg.Default or cfg.Value, theme.Accent)
            local h, sat, val = color:ToHSV()
            local alpha = 1
            local hasDescription = cfg.Description ~= nil and tostring(cfg.Description) ~= ""
            local baseHeight = hasDescription and 64 or 44
            local frame = elementFrame(cfg.Name or "Color", baseHeight)
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, hasDescription and 5 or 0),
                Size = UDim2.new(1, -68, 0, hasDescription and 18 or 44),
                Text = cfg.Name or "Color",
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 6
            }, frame)
            local desc
            if hasDescription then
                desc = make("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(12, 26),
                    Size = UDim2.new(1, -68, 0, 14),
                    Text = tostring(cfg.Description),
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    TextColor3 = theme.Muted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 6
                }, frame)
            end
            local swatch = make("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -12, 0.5, 0),
                Size = UDim2.fromOffset(46, 24),
                BackgroundColor3 = color,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 6
            }, frame)
            corner(swatch, 8)
            stroke(swatch, Color3.new(1, 1, 1), 0.7, 1)

            local PW, PH = 244, 286
            local popup = make("Frame", {
                Name = "ColorPickerPopup",
                Size = UDim2.fromOffset(PW, PH),
                BackgroundColor3 = theme.Panel,
                BackgroundTransparency = 0.02,
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 1000,
                ClipsDescendants = false,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.new(0.5, 0, 0, baseHeight + 6)
            }, frame)
            corner(popup, 14)
            stroke(popup, theme.Accent, 0.5, 1)

            local header = make("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 10),
                Size = UDim2.new(1, -28, 0, 22),
                ZIndex = 1001
            }, popup)
            local headerTitle = make("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -28, 1, 0),
                Text = tostring(cfg.Name or "Color") .. "  •  Color Studio",
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1002
            }, header)
            local closeButton = make("ImageButton", {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.fromOffset(18, 18),
                BackgroundTransparency = 1,
                Image = assetId("x"),
                ImageColor3 = theme.Muted,
                AutoButtonColor = false,
                ZIndex = 1002
            }, header)

            local PAD = 14
            local SVW, SVH = PW - PAD * 2, 118
            local svBox = make("Frame", {
                Position = UDim2.fromOffset(PAD, 40),
                Size = UDim2.fromOffset(SVW, SVH),
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 1001
            }, popup)
            corner(svBox, 9)
            local whiteLayer = make("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 1002
            }, svBox)
            corner(whiteLayer, 9)
            make("UIGradient", {
                Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
            }, whiteLayer)
            local blackLayer = make("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                ZIndex = 1003
            }, svBox)
            corner(blackLayer, 9)
            make("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
            }, blackLayer)
            local svKnob = make("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(sat, 0, 1 - val, 0),
                Size = UDim2.fromOffset(16, 16),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 1004
            }, svBox)
            corner(svKnob, 8)
            stroke(svKnob, Color3.new(0, 0, 0), 0.2, 1.5)
            local svHit = make("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Active = true,
                ZIndex = 1005
            }, svBox)

            make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(PAD, 157),
                Size = UDim2.fromOffset(SVW, 10),
                Text = "HUE",
                Font = Enum.Font.GothamBold,
                TextSize = 8,
                TextColor3 = theme.Muted,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1002
            }, popup)
            local hueY = 168
            local hueTrack = make("Frame", {
                Position = UDim2.fromOffset(PAD, hueY),
                Size = UDim2.fromOffset(SVW, 12),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 1001
            }, popup)
            corner(hueTrack, 6)
            make("UIGradient", {
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
                Position = UDim2.new(h, 0, 0.5, 0),
                Size = UDim2.fromOffset(10, 18),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 1002
            }, hueTrack)
            corner(hueKnob, 5)
            stroke(hueKnob, Color3.new(0, 0, 0), 0.2, 1)
            local hueHit = make("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Active = true,
                ZIndex = 1003
            }, hueTrack)

            make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(PAD, 179),
                Size = UDim2.fromOffset(SVW, 10),
                Text = "OPACITY",
                Font = Enum.Font.GothamBold,
                TextSize = 8,
                TextColor3 = theme.Muted,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1002
            }, popup)
            local alphaY = 190
            local alphaTrack = make("Frame", {
                Position = UDim2.fromOffset(PAD, alphaY),
                Size = UDim2.fromOffset(SVW, 12),
                BackgroundColor3 = Color3.fromRGB(155, 155, 155),
                BorderSizePixel = 0,
                ZIndex = 1001
            }, popup)
            corner(alphaTrack, 6)
            local alphaFill = make("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = color,
                BorderSizePixel = 0,
                ZIndex = 1002
            }, alphaTrack)
            corner(alphaFill, 6)
            make("UIGradient", {
                Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
            }, alphaFill)
            local alphaKnob = make("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(alpha, 0, 0.5, 0),
                Size = UDim2.fromOffset(10, 18),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 1003
            }, alphaTrack)
            corner(alphaKnob, 5)
            stroke(alphaKnob, Color3.new(0, 0, 0), 0.2, 1)
            local alphaHit = make("TextButton", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Active = true,
                ZIndex = 1004
            }, alphaTrack)

            local preview = make("Frame", {
                Position = UDim2.fromOffset(PAD, 216),
                Size = UDim2.fromOffset(42, 26),
                BackgroundColor3 = color,
                BorderSizePixel = 0,
                ZIndex = 1002
            }, popup)
            corner(preview, 7)
            stroke(preview, Color3.new(1, 1, 1), 0.7, 1)
            local hexBox = make("TextBox", {
                Position = UDim2.fromOffset(PAD + 52, 216),
                Size = UDim2.fromOffset(SVW - 52, 26),
                BackgroundColor3 = theme.Surface,
                BackgroundTransparency = 0.1,
                Text = string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255)),
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextColor3 = theme.Text,
                TextXAlignment = Enum.TextXAlignment.Center,
                ClearTextOnFocus = false,
                BorderSizePixel = 0,
                ZIndex = 1002
            }, popup)
            corner(hexBox, 7)

            local applyColor
            local presetColors = {
                Color3.fromRGB(235, 87, 87), Color3.fromRGB(255, 168, 76),
                Color3.fromRGB(255, 219, 92), Color3.fromRGB(76, 201, 120),
                Color3.fromRGB(76, 170, 255), Color3.fromRGB(130, 105, 255),
                Color3.fromRGB(210, 93, 255), Color3.fromRGB(245, 247, 255)
            }
            make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(PAD, 246),
                Size = UDim2.fromOffset(SVW, 10),
                Text = "PRESETS",
                Font = Enum.Font.GothamBold,
                TextSize = 8,
                TextColor3 = theme.Muted,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1002
            }, popup)
            local presetY = 256
            for index, preset in ipairs(presetColors) do
                local presetButton = make("TextButton", {
                    Position = UDim2.fromOffset(PAD + (index - 1) * 26, presetY),
                    Size = UDim2.fromOffset(20, 20),
                    BackgroundColor3 = preset,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 1002
                }, popup)
                corner(presetButton, 10)
                stroke(presetButton, Color3.new(1, 1, 1), 0.7, 1)
                presetButton.MouseButton1Click:Connect(function()
                    color = preset
                    h, sat, val = color:ToHSV()
                    applyColor(true)
                end)
            end


            applyColor = function(fire)
                color = Color3.fromHSV(h, sat, val)
                swatch.BackgroundColor3 = color
                preview.BackgroundColor3 = color
                svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svKnob.Position = UDim2.new(sat, 0, 1 - val, 0)
                hueKnob.Position = UDim2.new(h, 0, 0.5, 0)
                alphaKnob.Position = UDim2.new(alpha, 0, 0.5, 0)
                alphaFill.BackgroundColor3 = color
                hexBox.Text = string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
                if fire and cfg.Callback then task.spawn(cfg.Callback, color, alpha) end
            end

            local function updateFromColor(value, fire)
                color = value
                h, sat, val = color:ToHSV()
                applyColor(fire ~= false)
            end
            local function pointer(input)
                return Vector2.new(input.Position.X, input.Position.Y)
            end
            local svDrag, hueDrag, alphaDrag = false, false, false
            svHit.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    svDrag = true
                    local rel = pointer(input) - svBox.AbsolutePosition
                    sat = math.clamp(rel.X / math.max(svBox.AbsoluteSize.X, 1), 0, 1)
                    val = 1 - math.clamp(rel.Y / math.max(svBox.AbsoluteSize.Y, 1), 0, 1)
                    applyColor(true)
                end
            end)
            hueHit.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    hueDrag = true
                    local rel = pointer(input) - hueTrack.AbsolutePosition
                    h = math.clamp(rel.X / math.max(hueTrack.AbsoluteSize.X, 1), 0, 1)
                    applyColor(true)
                end
            end)
            alphaHit.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    alphaDrag = true
                    local rel = pointer(input) - alphaTrack.AbsolutePosition
                    alpha = math.clamp(rel.X / math.max(alphaTrack.AbsoluteSize.X, 1), 0, 1)
                    applyColor(true)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
                if svDrag then
                    local rel = pointer(input) - svBox.AbsolutePosition
                    sat = math.clamp(rel.X / math.max(svBox.AbsoluteSize.X, 1), 0, 1)
                    val = 1 - math.clamp(rel.Y / math.max(svBox.AbsoluteSize.Y, 1), 0, 1)
                    applyColor(true)
                elseif hueDrag then
                    local rel = pointer(input) - hueTrack.AbsolutePosition
                    h = math.clamp(rel.X / math.max(hueTrack.AbsoluteSize.X, 1), 0, 1)
                    applyColor(true)
                elseif alphaDrag then
                    local rel = pointer(input) - alphaTrack.AbsolutePosition
                    alpha = math.clamp(rel.X / math.max(alphaTrack.AbsoluteSize.X, 1), 0, 1)
                    applyColor(true)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    svDrag, hueDrag, alphaDrag = false, false, false
                end
            end)
            hexBox.FocusLost:Connect(function()
                local parsed = normalizeColor(hexBox.Text, nil)
                if parsed then updateFromColor(parsed) else applyColor(false) end
            end)

            local open = false
            local function positionPopup()
                popup.Position = UDim2.new(0.5, 0, 0, baseHeight + 6)
            end
            closeButton.MouseButton1Click:Connect(function()
                open = false
                tween(frame, 0.22, {Size = UDim2.new(1, 0, 0, baseHeight)})
                tween(popup, 0.22, {Size = UDim2.new(0, PW, 0, 0)})
                task.delay(0.23, function()
                    if not open then popup.Visible = false end
                end)
            end)
            swatch.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    positionPopup()
                    popup.Size = UDim2.fromOffset(PW, 0)
                    popup.Visible = true
                    tween(frame, 0.24, {Size = UDim2.new(1, 0, 0, baseHeight + PH + 6)})
                    tween(popup, 0.24, {Size = UDim2.fromOffset(PW, PH)})
                else
                    tween(frame, 0.22, {Size = UDim2.new(1, 0, 0, baseHeight)})
                    tween(popup, 0.22, {Size = UDim2.fromOffset(PW, 0)})
                    task.delay(0.23, function()
                        if not open then popup.Visible = false end
                    end)
                end
            end)
            local item = {Instance = frame}
            function item:Set(value)
                if typeof(value) == "Color3" then updateFromColor(value, false) end
            end
            function item:Get() return color end
            function item:GetAlpha() return alpha end
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
                label.TextColor3 = t.Text
                if desc then desc.TextColor3 = t.Muted end
                popup.BackgroundColor3 = t.Panel
                headerTitle.TextColor3 = t.Text
                closeButton.ImageColor3 = t.Muted
                hexBox.BackgroundColor3 = t.Surface
                hexBox.TextColor3 = t.Text
            end
            return addElement(item)
        end

        function tab:CreateDivider()
            local frame = make("Frame", {
                Name = "Divider",
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 0.9,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 1),
                ZIndex = 5
            }, page)
            local item = {Instance = frame}
            function item:UpdateTheme(t) end
            return addElement(item)
        end

        function tab:CreateProgressBar(cfg)
            cfg = cfg or {}
            local value = math.clamp(tonumber(cfg.Value) or 0, 0, 100)
            local frame = elementFrame(cfg.Name or "Progress", 48)
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 5),
                Size = UDim2.new(1, -70, 0, 16),
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
                Size = UDim2.fromOffset(48, 16),
                Text = tostring(value) .. "%",
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextColor3 = theme.Accent,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 6
            }, frame)
            local track = make("Frame", {
                Position = UDim2.new(0, 12, 0, 28),
                Size = UDim2.new(1, -24, 0, 6),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BackgroundTransparency = 0.88,
                BorderSizePixel = 0,
                ZIndex = 6
            }, frame)
            corner(track, 3)
            local fill = make("Frame", {
                Size = UDim2.new(value / 100, 0, 1, 0),
                BackgroundColor3 = theme.Accent,
                BorderSizePixel = 0,
                ZIndex = 7
            }, track)
            corner(fill, 3)
            local item = {Instance = frame}
            function item:Set(v)
                value = math.clamp(tonumber(v) or value, 0, 100)
                tween(fill, 0.2, {Size = UDim2.new(value / 100, 0, 1, 0)})
                amount.Text = tostring(math.floor(value)) .. "%"
            end
            function item:Get() return value end
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
                label.TextColor3 = t.Text
                amount.TextColor3 = t.Accent
                fill.BackgroundColor3 = t.Accent
            end
            return addElement(item)
        end

        function tab:CreateImage(cfg)
            cfg = type(cfg) == "table" and cfg or {Image = cfg}
            local imgSrc = cfg.Image or ""
            local resolved = loadLocalImage(imgSrc, cfg.Data)
            local frame = elementFrame(cfg.Name or "Image", cfg.Height or 130)
            local image = make("ImageLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(6, 6),
                Size = UDim2.new(1, -12, 1, -12),
                Image = resolved,
                ScaleType = cfg.ScaleType == "Fit" and Enum.ScaleType.Fit or Enum.ScaleType.Crop,
                ZIndex = 6
            }, frame)
            corner(image, 8)
            local item = {Instance = frame}
            function item:Set(v, local_)
                image.Image = loadLocalImage(v)
            end
            function item:UpdateTheme(t) frame.BackgroundColor3 = t.Surface end
            return addElement(item)
        end

        function tab:CreateSearchBox(cfg)
            cfg = cfg or {}
            local frame = elementFrame(cfg.Name or "Search", 50)
            local box = make("TextBox", {
                Position = UDim2.fromOffset(10, 10),
                Size = UDim2.new(1, -20, 0, 28),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.55,
                Text = "",
                PlaceholderText = cfg.Placeholder or "Search...",
                ClearTextOnFocus = false,
                TextColor3 = theme.Text,
                PlaceholderColor3 = theme.Muted,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 6
            }, frame)
            corner(box, 7)
            pad(box, 10, 10, 0, 0)
            box:GetPropertyChangedSignal("Text"):Connect(function()
                if cfg.Callback then task.spawn(cfg.Callback, box.Text) end
            end)
            local item = {Instance = frame}
            function item:Set(v) box.Text = tostring(v) end
            function item:Get() return box.Text end
            function item:UpdateTheme(t)
                frame.BackgroundColor3 = t.Surface
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
            local baseHeight = 44
            local frame = elementFrame(cfg.Name or "Multi", baseHeight)
            local label = make("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 0),
                Size = UDim2.new(0.4, 0, 1, 0),
                Text = cfg.Name or "Multi",
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
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.55,
                Text = "Select",
                Font = Enum.Font.Gotham,
                TextSize = 10,
                TextColor3 = theme.Text,
                AutoButtonColor = false,
                ZIndex = 6
            }, frame)
            corner(chosen, 7)
            local chosenArrow = make("ImageLabel", {
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -16, 0.5, 0),
                Size = UDim2.fromOffset(14, 14),
                Image = assetId("chevron-down"),
                ImageColor3 = theme.Muted,
                ZIndex = 7
            }, frame)

            local popup = make("Frame", {
                BackgroundColor3 = theme.Panel,
                BackgroundTransparency = 0.08,
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 500,
                Position = UDim2.new(0, 4, 0, baseHeight + 6),
                Size = UDim2.new(1, -8, 0, 0)
            }, frame)
            corner(popup, 10)
            stroke(popup, Color3.new(1, 1, 1), 0.8, 1)

            local scroll = make("ScrollingFrame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 1),
                CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 2,
                ZIndex = 501
            }, popup)
            pad(scroll, 6, 6, 6, 6)
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

            local expanded = false
            local function closePopup()
                expanded = false
                tween(frame, 0.18, {Size = UDim2.new(1, 0, 0, baseHeight)})
                tween(popup, 0.18, {Size = UDim2.new(1, -8, 0, 0)})
                task.delay(0.19, function()
                    if not expanded then popup.Visible = false end
                end)
            end

            local function refresh()
                local vals = values()
                chosen.Text = #vals == 0 and "Select" or table.concat(vals, ", ")
                for _, b in ipairs(scroll:GetChildren()) do
                    if b:IsA("TextButton") then b:Destroy() end
                end
                for i, opt in ipairs(options) do
                    local isOn = selected[tostring(opt)]
                    local b = make("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = isOn and theme.Accent or theme.Surface,
                        BackgroundTransparency = isOn and 0.25 or 0.4,
                        Text = tostring(opt),
                        Font = Enum.Font.Gotham,
                        TextSize = 11,
                        TextColor3 = theme.Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutoButtonColor = false,
                        LayoutOrder = i,
                        ZIndex = 502
                    }, scroll)
                    corner(b, 6)
                    pad(b, 28, 8, 0, 0)
                    make("ImageLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2.fromOffset(8, 7),
                        Size = UDim2.fromOffset(14, 14),
                        Image = assetId(isOn and "check" or "circle"),
                        ImageColor3 = isOn and theme.Accent or theme.Muted,
                        ZIndex = 503
                    }, b)
                    b.MouseButton1Click:Connect(function()
                        selected[tostring(opt)] = not selected[tostring(opt)]
                        refresh()
                        if cfg.Callback then task.spawn(cfg.Callback, values()) end
                    end)
                end
            end

            chosen.MouseButton1Click:Connect(function()
                if expanded then
                    closePopup()
                else
                    expanded = true
                    local popupH = math.min(#options, 6) * 31 + 14
                    popup.Position = UDim2.new(0, 4, 0, baseHeight + 6)
                    popup.Size = UDim2.new(1, -8, 0, 0)
                    popup.Visible = true
                    tween(frame, 0.22, {Size = UDim2.new(1, 0, 0, baseHeight + popupH + 6)})
                    tween(popup, 0.22, {Size = UDim2.new(1, -8, 0, popupH)})
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
                chosen.TextColor3 = t.Text
                chosenArrow.ImageColor3 = t.Muted
                popup.BackgroundColor3 = t.Panel
                refresh()
            end
            return addElement(item)
        end

        function tab:CreateTextBox(cfg)
            return self:CreateInput(cfg)
        end

        table.insert(state.Tabs, tab)
        if #state.Tabs == 1 then selectTab() end
        return tab
    end

    function Window:SetTheme(name) state:SetTheme(name) end
    function Window:CreateCustomTheme(name, values) return state:CreateCustomTheme(name, values) end
    function Window:GetThemes() return state:GetThemes() end
    function Window:DeleteCustomTheme(name) return state:DeleteCustomTheme(name) end
    function Window:SetBackground(source, options) return state:SetBackground(source, options) end
    function Window:SetTransparency(value) state:SetTransparency(value) end
    function Window:SetAcrylic(value) state:SetAcrylic(value) end
    function Window:SetGlass(value) state:SetGlass(value) end
    function Window:SetResizable(value) state:SetResizable(value) end
    function Window:SetStatus(options) setStatus(options) end
    function Window:SetStatusTags(tags) setStatus({Tags = tags}) end
    function Window:Notify(notice) return state:Notify(notice) end
    function Window:Destroy() state:Destroy() end
    function Window:Toggle() setOpen(not state.Open) end

    state.Window = Window

    if config.BackgroundImage then
        state:SetBackground(config.BackgroundImage, {
            Local = config.BackgroundLocal,
            Transparency = config.BackgroundImageTransparency or 0.7
        })
    end

    if config.Intro ~= false then
        root.Size = UDim2.fromOffset(winW * 0.92, winH * 0.92)
        root.BackgroundTransparency = 1
        tween(root, 0.35, {
            Size = UDim2.fromOffset(winW, winH),
            BackgroundTransparency = transparency
        }, Enum.EasingStyle.Back)
    end

    return Window
end

return OpenHubUI
