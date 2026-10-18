local OpenHubUI = {}
OpenHubUI.Version = "1.0.0"
OpenHubUI.Themes = {
    Midnight = {Background = Color3.fromRGB(8, 9, 13), Panel = Color3.fromRGB(15, 17, 23), Surface = Color3.fromRGB(21, 24, 32), Accent = Color3.fromRGB(133, 104, 255), Accent2 = Color3.fromRGB(83, 184, 255), Text = Color3.fromRGB(244, 246, 255), Muted = Color3.fromRGB(147, 153, 171), Stroke = Color3.fromRGB(92, 99, 126), Transparency = 0.18, Acrylic = 0.30},
    Obsidian = {Background = Color3.fromRGB(5, 6, 8), Panel = Color3.fromRGB(12, 13, 16), Surface = Color3.fromRGB(20, 21, 25), Accent = Color3.fromRGB(238, 238, 245), Accent2 = Color3.fromRGB(140, 146, 160), Text = Color3.fromRGB(248, 248, 250), Muted = Color3.fromRGB(145, 147, 155), Stroke = Color3.fromRGB(88, 91, 101), Transparency = 0.20, Acrylic = 0.34},
    Aurora = {Background = Color3.fromRGB(5, 12, 16), Panel = Color3.fromRGB(9, 20, 25), Surface = Color3.fromRGB(15, 31, 37), Accent = Color3.fromRGB(75, 235, 190), Accent2 = Color3.fromRGB(82, 172, 255), Text = Color3.fromRGB(235, 255, 250), Muted = Color3.fromRGB(135, 174, 170), Stroke = Color3.fromRGB(59, 126, 118), Transparency = 0.18, Acrylic = 0.30},
    Crimson = {Background = Color3.fromRGB(13, 6, 8), Panel = Color3.fromRGB(23, 10, 13), Surface = Color3.fromRGB(34, 15, 19), Accent = Color3.fromRGB(255, 74, 104), Accent2 = Color3.fromRGB(255, 146, 103), Text = Color3.fromRGB(255, 242, 245), Muted = Color3.fromRGB(179, 139, 148), Stroke = Color3.fromRGB(126, 62, 77), Transparency = 0.18, Acrylic = 0.30},
    Sapphire = {Background = Color3.fromRGB(5, 8, 15), Panel = Color3.fromRGB(9, 15, 27), Surface = Color3.fromRGB(15, 23, 39), Accent = Color3.fromRGB(75, 145, 255), Accent2 = Color3.fromRGB(99, 220, 255), Text = Color3.fromRGB(239, 247, 255), Muted = Color3.fromRGB(136, 157, 190), Stroke = Color3.fromRGB(54, 91, 148), Transparency = 0.18, Acrylic = 0.30},
    Sakura = {Background = Color3.fromRGB(15, 8, 14), Panel = Color3.fromRGB(24, 13, 23), Surface = Color3.fromRGB(37, 20, 34), Accent = Color3.fromRGB(255, 133, 202), Accent2 = Color3.fromRGB(190, 143, 255), Text = Color3.fromRGB(255, 242, 251), Muted = Color3.fromRGB(187, 147, 177), Stroke = Color3.fromRGB(128, 76, 117), Transparency = 0.18, Acrylic = 0.30},
    Ember = {Background = Color3.fromRGB(14, 9, 5), Panel = Color3.fromRGB(25, 16, 9), Surface = Color3.fromRGB(39, 25, 14), Accent = Color3.fromRGB(255, 159, 66), Accent2 = Color3.fromRGB(255, 218, 119), Text = Color3.fromRGB(255, 248, 236), Muted = Color3.fromRGB(187, 158, 127), Stroke = Color3.fromRGB(132, 91, 49), Transparency = 0.18, Acrylic = 0.30}
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        pcall(function() obj[k] = v end)
    end
    obj.Parent = parent
    return obj
end
local function corner(parent, radius)
    return make("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, parent)
end
local function stroke(parent, color, transparency, thickness)
    return make("UIStroke", {Color = color or Color3.new(1,1,1), Transparency = transparency or 0.75, Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, parent)
end
local function pad(parent, x, y)
    return make("UIPadding", {PaddingLeft = UDim.new(0, x or 10), PaddingRight = UDim.new(0, x or 10), PaddingTop = UDim.new(0, y or 8), PaddingBottom = UDim.new(0, y or 8)}, parent)
end
local function tween(obj, time, props, style, direction)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.22, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out), props)
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

function OpenHubUI:CreateWindow(config)
    config = config or {}
    local themeName = config.Theme or "Midnight"
    local theme = deepCopy(self.Themes[themeName] or self.Themes.Midnight)
    local transparency = math.clamp(tonumber(config.Transparency) or theme.Transparency or 0.18, 0, 0.9)
    local acrylic = math.clamp(tonumber(config.Acrylic) or theme.Acrylic or 0.3, 0, 0.85)
    local guiParent = CoreGui
    pcall(function() if gethui then guiParent = gethui() end end)
    local gui = make("ScreenGui", {Name = "OpenHubUI_" .. HttpService:GenerateGUID(false):gsub("-", ""), IgnoreGuiInset = true, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, guiParent)
    local state = {Theme = theme, ThemeName = themeName, Transparency = transparency, Acrylic = acrylic, BackgroundImage = nil, Tabs = {}, Elements = {}, Connections = {}, Open = true, Destroyed = false}
    local scale = make("UIScale", {Scale = 1}, nil)
    local camera = workspace.CurrentCamera
    local function updateScale()
        if camera then
            local width = camera.ViewportSize.X
            scale.Scale = width < 520 and 0.76 or (width < 760 and 0.88 or 1)
        end
    end
    local root = make("Frame", {Name = "Root", AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(config.Width or 720, config.Height or 470), BackgroundColor3 = theme.Background, BackgroundTransparency = transparency, BorderSizePixel = 0}, gui)
    scale.Parent = root
    corner(root, 16)
    local rootStroke = stroke(root, theme.Stroke, 0.25, 1)
    local rootGradient = make("UIGradient", {Rotation = 25, Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme.Panel), ColorSequenceKeypoint.new(1, theme.Background)})}, root)
    local bg = make("ImageLabel", {Name = "BackgroundImage", BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), ImageTransparency = 0.58, ScaleType = Enum.ScaleType.Crop, Image = "", ZIndex = 0}, root)
    corner(bg, 16)
    local darkOverlay = make("Frame", {Name = "AcrylicOverlay", Size = UDim2.fromScale(1,1), BackgroundColor3 = theme.Background, BackgroundTransparency = acrylic, BorderSizePixel = 0, ZIndex = 1}, root)
    corner(darkOverlay, 16)
    local shine = make("Frame", {Name = "TopShine", BackgroundColor3 = Color3.new(1,1,1), BackgroundTransparency = 0.95, BorderSizePixel = 0, Position = UDim2.new(0,1,0,1), Size = UDim2.new(1,-2,0,1), ZIndex = 8}, root)
    local header = make("Frame", {Name = "Header", BackgroundTransparency = 1, Size = UDim2.new(1,0,0,58), ZIndex = 3}, root)
    local logo = make("ImageLabel", {Name = "Logo", BackgroundTransparency = 1, Position = UDim2.fromOffset(17,13), Size = UDim2.fromOffset(31,31), Image = assetId(config.Icon or "")}, header)
    local title = make("TextLabel", {Name = "Title", BackgroundTransparency = 1, Position = UDim2.fromOffset(config.Icon and 58 or 20, 9), Size = UDim2.new(1,-150,0,25), Font = Enum.Font.GothamBold, Text = config.Title or "OpenHub", TextSize = 18, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4}, header)
    local subtitle = make("TextLabel", {Name = "Subtitle", BackgroundTransparency = 1, Position = UDim2.fromOffset(config.Icon and 59 or 21, 32), Size = UDim2.new(1,-160,0,16), Font = Enum.Font.Gotham, Text = config.Subtitle or "Interface Suite", TextSize = 10, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4}, header)
    local close = make("TextButton", {Name = "Close", AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-14,0,13), Size = UDim2.fromOffset(30,30), BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.12, Text = "×", TextSize = 23, Font = Enum.Font.Gotham, TextColor3 = theme.Text, AutoButtonColor = false, ZIndex = 5}, header)
    corner(close, 9)
    local minimize = make("TextButton", {Name = "Minimize", AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-50,0,13), Size = UDim2.fromOffset(30,30), BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.12, Text = "−", TextSize = 22, Font = Enum.Font.Gotham, TextColor3 = theme.Text, AutoButtonColor = false, ZIndex = 5}, header)
    corner(minimize, 9)
    local divider = make("Frame", {Name = "HeaderLine", Position = UDim2.new(0,14,0,57), Size = UDim2.new(1,-28,0,1), BackgroundColor3 = theme.Stroke, BackgroundTransparency = 0.55, BorderSizePixel = 0, ZIndex = 3}, root)
    local nav = make("ScrollingFrame", {Name = "Tabs", Position = UDim2.fromOffset(12,70), Size = UDim2.new(0,150,1,-84), BackgroundColor3 = theme.Panel, BackgroundTransparency = 0.28, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = theme.Accent, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 3}, root)
    corner(nav, 12)
    stroke(nav, theme.Stroke, 0.78, 1)
    pad(nav, 8, 8)
    local navLayout = make("UIListLayout", {Padding = UDim.new(0,6), SortOrder = Enum.SortOrder.LayoutOrder}, nav)
    local content = make("Frame", {Name = "Content", Position = UDim2.new(0,174,0,70), Size = UDim2.new(1,-186,1,-84), BackgroundColor3 = theme.Panel, BackgroundTransparency = 0.28, BorderSizePixel = 0, ZIndex = 3}, root)
    corner(content, 12)
    stroke(content, theme.Stroke, 0.78, 1)
    local contentPages = make("Folder", {Name = "Pages"}, content)
    local openButton = make("TextButton", {Name = "OpenButton", AnchorPoint = Vector2.new(0,0.5), Position = UDim2.new(0,18,0.5,0), Size = UDim2.fromOffset(46,46), BackgroundColor3 = theme.Panel, BackgroundTransparency = 0.08, Text = "", AutoButtonColor = false, Visible = config.OpenButton ~= false, ZIndex = 20}, gui)
    corner(openButton, 15)
    stroke(openButton, theme.Accent, 0.18, 1.3)
    local openIcon = make("ImageLabel", {Name = "Icon", BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.fromScale(0.5,0.5), Size = UDim2.fromOffset(24,24), Image = assetId(config.OpenButtonIcon or config.Icon or "6031097225"), ImageColor3 = theme.Text, ZIndex = 21}, openButton)
    local openText = make("TextLabel", {Name = "OpenText", BackgroundColor3 = theme.Panel, BackgroundTransparency = 0.08, Position = UDim2.new(1,8,0,7), Size = UDim2.fromOffset(90,32), Text = "OpenHub", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = theme.Text, Visible = false, ZIndex = 20}, openButton)
    corner(openText, 9)
    local function setOpen(value)
        state.Open = value
        if value then
            root.Visible = true
            root.Size = UDim2.fromOffset((config.Width or 720)*0.94, (config.Height or 470)*0.94)
            tween(root, 0.32, {Size = UDim2.fromOffset(config.Width or 720, config.Height or 470)}, Enum.EasingStyle.Back)
            tween(openButton, 0.2, {BackgroundTransparency = 0.08})
        else
            tween(root, 0.18, {Size = UDim2.fromOffset((config.Width or 720)*0.85, (config.Height or 470)*0.85)}, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            task.delay(0.19, function() if not state.Open and root.Parent then root.Visible = false end end)
            tween(openButton, 0.2, {BackgroundTransparency = 0})
        end
    end
    openButton.MouseButton1Click:Connect(function() setOpen(not state.Open) end)
    close.MouseButton1Click:Connect(function() setOpen(false) end)
    minimize.MouseButton1Click:Connect(function()
        local hidden = content.Visible
        content.Visible = not hidden
        nav.Visible = not hidden
        divider.Visible = not hidden
        tween(root, 0.22, {Size = hidden and UDim2.fromOffset(config.Width or 720, 58) or UDim2.fromOffset(config.Width or 720, config.Height or 470)})
        minimize.Text = hidden and "+" or "−"
    end)
    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = root.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    if camera then camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale) end
    updateScale()

    local function applyTheme(newTheme, newName)
        theme = deepCopy(newTheme)
        state.Theme = theme
        state.ThemeName = newName or "Custom"
        root.BackgroundColor3 = theme.Background
        root.BackgroundTransparency = state.Transparency
        rootGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, theme.Panel), ColorSequenceKeypoint.new(1, theme.Background)})
        darkOverlay.BackgroundColor3 = theme.Background
        darkOverlay.BackgroundTransparency = state.Acrylic
        rootStroke.Color = theme.Stroke
        title.TextColor3 = theme.Text
        subtitle.TextColor3 = theme.Muted
        close.TextColor3 = theme.Text
        minimize.TextColor3 = theme.Text
        nav.ScrollBarImageColor3 = theme.Accent
        content.BackgroundColor3 = theme.Panel
        nav.BackgroundColor3 = theme.Panel
        openButton.BackgroundColor3 = theme.Panel
        openIcon.ImageColor3 = theme.Text
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
        for k, v in pairs(values or {}) do if custom[k] ~= nil then custom[k] = v end end
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
        if options.Local then image = resolveAsset(source) or "" else image = assetId(source) end
        bg.Image = image or ""
        bg.ImageTransparency = math.clamp(tonumber(options.Transparency) or 0.58, 0, 1)
        bg.ScaleType = options.ScaleType == "Fit" and Enum.ScaleType.Fit or Enum.ScaleType.Crop
        state.BackgroundImage = source
        darkOverlay.BackgroundTransparency = state.Acrylic
        return bg.Image ~= ""
    end
    function state:SetBackgroundFile(fileName, url, options)
        if not (writefile and getcustomasset and request) then return false, "Executor file functions are unavailable" end
        local ok, response = pcall(function() return request({Url = url, Method = "GET"}) end)
        if not ok or not response or not response.Body then return false, "Unable to download image" end
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
                task.wait(1/rate)
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
            holder = make("Frame", {Name = "Notifications", BackgroundTransparency = 1, AnchorPoint = Vector2.new(1,0), Position = UDim2.new(1,-18,0,18), Size = UDim2.fromOffset(290,400), ZIndex = 50}, gui)
            make("UIListLayout", {Padding = UDim.new(0,8), HorizontalAlignment = Enum.HorizontalAlignment.Right, SortOrder = Enum.SortOrder.LayoutOrder}, holder)
        end
        local card = make("Frame", {BackgroundColor3 = theme.Panel, BackgroundTransparency = 0.08, Size = UDim2.new(1,0,0,74), ClipsDescendants = true, ZIndex = 51}, holder)
        corner(card, 12)
        stroke(card, theme.Accent, 0.35, 1)
        local accent = make("Frame", {BackgroundColor3 = theme.Accent, Size = UDim2.new(0,3,1,-18), Position = UDim2.fromOffset(0,9), BorderSizePixel = 0, ZIndex = 52}, card)
        corner(accent, 2)
        make("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14,9), Size = UDim2.new(1,-24,0,20), Text = notice.Title or "OpenHub", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 52}, card)
        make("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(14,31), Size = UDim2.new(1,-24,0,32), Text = notice.Content or notice.Text or "", Font = Enum.Font.Gotham, TextSize = 11, TextWrapped = true, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 52}, card)
        card.BackgroundTransparency = 1
        tween(card, 0.22, {BackgroundTransparency = 0.08})
        task.delay(tonumber(notice.Duration) or 3, function()
            if card.Parent then tween(card, 0.2, {BackgroundTransparency = 1, Size = UDim2.new(1,0,0,0)}); task.wait(0.22); card:Destroy() end
        end)
        return card
    end
    function state:Destroy()
        state.Destroyed = true
        gui:Destroy()
    end

    local Window = {Instance = root, GUI = gui, State = state}
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or ("Tab " .. (#state.Tabs + 1))
        local button = make("TextButton", {Name = tabName .. "Button", Size = UDim2.new(1,0,0,38), BackgroundColor3 = theme.Accent, BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = #state.Tabs + 1, ZIndex = 4}, nav)
        corner(button, 9)
        local icon = make("ImageLabel", {Name = "Icon", BackgroundTransparency = 1, Position = UDim2.fromOffset(10,9), Size = UDim2.fromOffset(20,20), Image = assetId(tabConfig.Icon or ""), ImageColor3 = theme.Muted, ZIndex = 5}, button)
        local label = make("TextLabel", {Name = "Label", BackgroundTransparency = 1, Position = UDim2.fromOffset(tabConfig.Icon and 39 or 12,0), Size = UDim2.new(1,tabConfig.Icon and -45 or -18,1,0), Text = tabName, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = theme.Muted, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5}, button)
        local page = make("ScrollingFrame", {Name = tabName, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1,1), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = theme.Accent, Visible = false, ZIndex = 4}, contentPages)
        pad(page, 12, 12)
        local layout = make("UIListLayout", {Padding = UDim.new(0,9), SortOrder = Enum.SortOrder.LayoutOrder}, page)
        local tab = {Name = tabName, Button = button, Page = page, Icon = icon, Label = label, Elements = {}}
        local function selectTab()
            for _, other in ipairs(state.Tabs) do
                other.Page.Visible = false
                tween(other.Button, 0.18, {BackgroundTransparency = 1})
                other.Label.TextColor3 = theme.Muted
                other.Icon.ImageColor3 = theme.Muted
            end
            page.Visible = true
            tween(button, 0.22, {BackgroundTransparency = 0.78})
            label.TextColor3 = theme.Text
            icon.ImageColor3 = theme.Accent
            page.CanvasPosition = Vector2.new(0,0)
        end
        button.MouseButton1Click:Connect(selectTab)
        function tab:UpdateTheme(newTheme)
            button.BackgroundColor3 = newTheme.Accent
            page.ScrollBarImageColor3 = newTheme.Accent
            if page.Visible then label.TextColor3 = newTheme.Text; icon.ImageColor3 = newTheme.Accent else label.TextColor3 = newTheme.Muted; icon.ImageColor3 = newTheme.Muted end
            for _, element in ipairs(tab.Elements) do pcall(function() if element.UpdateTheme then element:UpdateTheme(newTheme) end end) end
        end
        function tab:SetIcon(value) icon.Image = assetId(value); icon.Visible = value ~= nil and value ~= ""; label.Position = UDim2.fromOffset(icon.Visible and 39 or 12,0) end
        local function elementFrame(name, height)
            local frame = make("Frame", {Name = name or "Element", Size = UDim2.new(1,0,0,height or 54), BackgroundColor3 = theme.Surface, BackgroundTransparency = 0.12, BorderSizePixel = 0, ZIndex = 5}, page)
            corner(frame, 10)
            stroke(frame, theme.Stroke, 0.78, 1)
            return frame
        end
        local function addElement(item) table.insert(tab.Elements, item); table.insert(state.Elements, item); return item end
        function tab:CreateSection(text)
            local frame = make("Frame", {Name = "Section", BackgroundTransparency = 1, Size = UDim2.new(1,0,0,25), ZIndex = 5}, page)
            make("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Text = text or "Section", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = theme.Accent, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6}, frame)
            local line = make("Frame", {BackgroundColor3 = theme.Stroke, BackgroundTransparency = 0.45, Position = UDim2.new(0,0,1,-1), Size = UDim2.new(1,0,0,1), BorderSizePixel = 0, ZIndex = 6}, frame)
            local item = {Instance = frame}; function item:UpdateTheme(t) line.BackgroundColor3 = t.Stroke; frame:FindFirstChildOfClass("TextLabel").TextColor3 = t.Accent end
            return addElement(item)
        end
        function tab:CreateLabel(cfg)
            cfg = type(cfg) == "table" and cfg or {Text = tostring(cfg or "Label")}
            local frame = elementFrame(cfg.Name or "Label", cfg.Height or 42)
            local textLabel = make("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(12,0), Size = UDim2.new(1,-24,1,0), Text = cfg.Text or "Label", Font = Enum.Font.Gotham, TextSize = cfg.TextSize or 12, TextColor3 = theme.Text, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6}, frame)
            local item = {Instance = frame}; function item:Set(text) textLabel.Text = tostring(text) end; function item:UpdateTheme(t) frame.BackgroundColor3 = t.Surface; textLabel.TextColor3 = t.Text end
            return addElement(item)
        end
        function tab:CreateParagraph(cfg)
            cfg = cfg or {}
            local frame = elementFrame(cfg.Name or "Paragraph", cfg.Height or 74)
            local head = make("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(12,8), Size = UDim2.new(1,-24,0,19), Text = cfg.Title or "Information", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6}, frame)
            local body = make("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(12,28), Size = UDim2.new(1,-24,1,-34), Text = cfg.Content or cfg.Text or "", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = theme.Muted, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 6}, frame)
            local item = {Instance = frame}; function item:Set(text) body.Text = tostring(text) end; function item:UpdateTheme(t) frame.BackgroundColor3=t.Surface; head.TextColor3=t.Text; body.TextColor3=t.Muted end
            return addElement(item)
        end
        function tab:CreateButton(cfg)
            cfg = type(cfg) == "table" and cfg or {Name = tostring(cfg or "Button")}
            local frame = elementFrame(cfg.Name or "Button", cfg.Height or 46)
            local btn = make("TextButton", {BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), Text = "", AutoButtonColor = false, ZIndex = 6}, frame)
            local ico = make("ImageLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(12,13), Size = UDim2.fromOffset(19,19), Image = assetId(cfg.Icon or ""), ImageColor3 = theme.Accent, Visible = cfg.Icon ~= nil, ZIndex = 7}, btn)
            local txt = make("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(cfg.Icon and 41 or 13,0), Size = UDim2.new(1,cfg.Icon and -50 or -25,1,0), Text = cfg.Name or "Button", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 7}, btn)
            local arrow = make("TextLabel", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-13,0.5,0), Size = UDim2.fromOffset(18,22), Text = "›", Font = Enum.Font.Gotham, TextSize = 22, TextColor3 = theme.Muted, ZIndex = 7}, btn)
            btn.MouseEnter:Connect(function() tween(frame,0.15,{BackgroundColor3=theme.Accent}); tween(frame,0.15,{BackgroundTransparency=0.83}) end)
            btn.MouseLeave:Connect(function() tween(frame,0.15,{BackgroundColor3=theme.Surface}); tween(frame,0.15,{BackgroundTransparency=0.12}) end)
            btn.MouseButton1Click:Connect(function() tween(frame,0.08,{Size=UDim2.new(1,-3,0,frame.Size.Y.Offset)}); task.delay(0.09,function() if frame.Parent then tween(frame,0.15,{Size=UDim2.new(1,0,0,frame.Size.Y.Offset)}) end end); if cfg.Callback then task.spawn(cfg.Callback) end end)
            local item = {Instance = frame}; function item:UpdateTheme(t) frame.BackgroundColor3=t.Surface; txt.TextColor3=t.Text; ico.ImageColor3=t.Accent; arrow.TextColor3=t.Muted end
            return addElement(item)
        end
        function tab:CreateToggle(cfg)
            cfg = cfg or {}
            local value = cfg.CurrentValue == true
            local frame = elementFrame(cfg.Name or "Toggle", cfg.Description and 65 or 52)
            local name = make("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(12, cfg.Description and 8 or 0), Size = UDim2.new(1,-78,cfg.Description and 0 or 1,cfg.Description and 20 or 0), Text = cfg.Name or "Toggle", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6}, frame)
            local desc
            if cfg.Description then desc = make("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(12,30), Size = UDim2.new(1,-80,0,23), Text = cfg.Description, Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = theme.Muted, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6}, frame) end
            local switch = make("TextButton", {AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-12,0.5,0), Size = UDim2.fromOffset(42,23), BackgroundColor3 = value and theme.Accent or theme.Stroke, BackgroundTransparency = value and 0 or 0.35, Text = "", AutoButtonColor = false, ZIndex = 6}, frame)
            corner(switch, 12)
            local knob = make("Frame", {Position = value and UDim2.new(1,-20,0,3) or UDim2.fromOffset(3,3), Size = UDim2.fromOffset(17,17), BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, ZIndex = 7}, switch); corner(knob, 10)
            local function set(v, fire) value = v == true; tween(switch,0.18,{BackgroundColor3=value and theme.Accent or theme.Stroke,BackgroundTransparency=value and 0 or 0.35}); tween(knob,0.18,{Position=value and UDim2.new(1,-20,0,3) or UDim2.fromOffset(3,3)}); if fire and cfg.Callback then task.spawn(cfg.Callback,value) end end
            switch.MouseButton1Click:Connect(function() set(not value,true) end)
            local item = {Instance = frame}; function item:Set(v) set(v,true) end; function item:Get() return value end; function item:UpdateTheme(t) frame.BackgroundColor3=t.Surface; name.TextColor3=t.Text; if desc then desc.TextColor3=t.Muted end; switch.BackgroundColor3=value and t.Accent or t.Stroke end
            addElement(item); if cfg.Callback and cfg.CurrentValue then task.spawn(cfg.Callback,value) end; return item
        end
        function tab:CreateSlider(cfg)
            cfg = cfg or {}; local min = tonumber(cfg.Min) or 0; local max = tonumber(cfg.Max) or 100; local value = math.clamp(tonumber(cfg.CurrentValue) or min,min,max)
            local frame = elementFrame(cfg.Name or "Slider", 66)
            local label = make("TextLabel", {BackgroundTransparency=1,Position=UDim2.fromOffset(12,7),Size=UDim2.new(1,-75,0,20),Text=cfg.Name or "Slider",Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=theme.Text,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6},frame)
            local valLabel = make("TextLabel", {BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-12,0,7),Size=UDim2.fromOffset(65,20),Text=tostring(value),Font=Enum.Font.GothamBold,TextSize=11,TextColor3=theme.Accent,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=6},frame)
            local track = make("Frame", {Position=UDim2.new(0,12,0,39),Size=UDim2.new(1,-24,0,5),BackgroundColor3=theme.Stroke,BackgroundTransparency=0.3,BorderSizePixel=0,ZIndex=6},frame); corner(track,4)
            local fill = make("Frame", {Size=UDim2.new((value-min)/math.max(max-min,1),0,1,0),BackgroundColor3=theme.Accent,BorderSizePixel=0,ZIndex=7},track); corner(fill,4)
            local knob = make("Frame", {AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new((value-min)/math.max(max-min,1),0,0.5,0),Size=UDim2.fromOffset(13,13),BackgroundColor3=theme.Text,BorderSizePixel=0,ZIndex=8},track); corner(knob,8); stroke(knob,theme.Accent,0.15,1)
            local hit = make("TextButton", {BackgroundTransparency=1,Position=UDim2.new(0,0,0,-9),Size=UDim2.new(1,0,1,18),Text="",ZIndex=9},track)
            local function set(v,fire) value=math.clamp(v,min,max); local p=(value-min)/math.max(max-min,1); fill.Size=UDim2.new(p,0,1,0); knob.Position=UDim2.new(p,0,0.5,0); valLabel.Text=tostring(math.floor(value*100)/100); if fire and cfg.Callback then task.spawn(cfg.Callback,value) end end
            local sliding=false
            hit.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then sliding=true; local p=math.clamp((input.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1); set(min+(max-min)*p,true) end end)
            UserInputService.InputChanged:Connect(function(input) if sliding and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then local p=math.clamp((input.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1); set(min+(max-min)*p,true) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then sliding=false end end)
            local item={Instance=frame}; function item:Set(v) set(tonumber(v) or value,true) end; function item:Get() return value end; function item:UpdateTheme(t) frame.BackgroundColor3=t.Surface; label.TextColor3=t.Text; valLabel.TextColor3=t.Accent; track.BackgroundColor3=t.Stroke; fill.BackgroundColor3=t.Accent end
            return addElement(item)
        end
        function tab:CreateInput(cfg)
            cfg=cfg or {}; local frame=elementFrame(cfg.Name or "Input",cfg.Description and 72 or 58)
            local label=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,6),Size=UDim2.new(1,-24,0,18),Text=cfg.Name or "Input",Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=theme.Text,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6},frame)
            local box=make("TextBox",{Position=UDim2.fromOffset(12,29),Size=UDim2.new(1,-24,0,26),BackgroundColor3=theme.Background,BackgroundTransparency=0.18,Text=tostring(cfg.Default or ""),PlaceholderText=cfg.Placeholder or "Enter value...",ClearTextOnFocus=false,TextColor3=theme.Text,PlaceholderColor3=theme.Muted,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0,ZIndex=6},frame); corner(box,7); pad(box,8,0)
            box.FocusLost:Connect(function(enter) if (not cfg.Enter or enter) and cfg.Callback then task.spawn(cfg.Callback,box.Text) end end)
            local item={Instance=frame}; function item:Set(v) box.Text=tostring(v) end; function item:Get() return box.Text end; function item:UpdateTheme(t) frame.BackgroundColor3=t.Surface; label.TextColor3=t.Text; box.BackgroundColor3=t.Background; box.TextColor3=t.Text; box.PlaceholderColor3=t.Muted end
            return addElement(item)
        end
        function tab:CreateDropdown(cfg)
            cfg=cfg or {}; local options=cfg.Options or {"Option 1","Option 2"}; local selected=cfg.CurrentOption or options[1]; if type(selected)=="table" then selected=selected[1] end
            local expanded=false; local frame=elementFrame(cfg.Name or "Dropdown",48)
            local label=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,0),Size=UDim2.new(0.45,0,1,0),Text=cfg.Name or "Dropdown",Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=theme.Text,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6},frame)
            local chosen=make("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0.5,0),Size=UDim2.new(0.52,0,0,29),BackgroundColor3=theme.Background,BackgroundTransparency=0.18,Text=tostring(selected),Font=Enum.Font.Gotham,TextSize=11,TextColor3=theme.Text,AutoButtonColor=false,ZIndex=6},frame); corner(chosen,7)
            local list=make("Frame",{Position=UDim2.new(0,0,1,5),Size=UDim2.new(1,0,0,0),BackgroundColor3=theme.Panel,BackgroundTransparency=0.04,ClipsDescendants=true,Visible=false,ZIndex=15},frame); corner(list,9); stroke(list,theme.Stroke,0.35,1)
            local scroll=make("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.fromScale(1,1),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=2,ZIndex=16},list); pad(scroll,5,5); make("UIListLayout",{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder},scroll)
            local function rebuild()
                for _,c in ipairs(scroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                for i,opt in ipairs(options) do local b=make("TextButton",{Size=UDim2.new(1,0,0,29),BackgroundColor3=theme.Accent,BackgroundTransparency=0.88,Text=tostring(opt),Font=Enum.Font.Gotham,TextSize=11,TextColor3=theme.Text,AutoButtonColor=false,LayoutOrder=i,ZIndex=17},scroll); corner(b,6); b.MouseButton1Click:Connect(function() selected=opt; chosen.Text=tostring(opt); expanded=false; tween(list,0.16,{Size=UDim2.new(1,0,0,0)}); task.delay(0.16,function() list.Visible=false end); if cfg.Callback then task.spawn(cfg.Callback,opt) end end) end
            end
            rebuild()
            chosen.MouseButton1Click:Connect(function() expanded=not expanded; list.Visible=true; local h=math.min(#options,5)*32+10; tween(list,0.2,{Size=UDim2.new(1,0,0,expanded and h or 0)}); if not expanded then task.delay(0.2,function() if not expanded then list.Visible=false end end) end end)
            local item={Instance=frame}; function item:Set(v) selected=v; chosen.Text=tostring(v); if cfg.Callback then task.spawn(cfg.Callback,v) end end; function item:Get() return selected end; function item:UpdateOptions(v) options=v or {}; rebuild() end; function item:UpdateTheme(t) frame.BackgroundColor3=t.Surface; label.TextColor3=t.Text; chosen.BackgroundColor3=t.Background; chosen.TextColor3=t.Text; list.BackgroundColor3=t.Panel; for _,b in ipairs(scroll:GetChildren()) do if b:IsA("TextButton") then b.TextColor3=t.Text end end end
            return addElement(item)
        end
        function tab:CreateKeybind(cfg)
            cfg=cfg or {}; local key=cfg.CurrentBind or "RightShift"; local listening=false
            local frame=elementFrame(cfg.Name or "Keybind",48)
            local label=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-100,1,0),Text=cfg.Name or "Keybind",Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=theme.Text,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6},frame)
            local btn=make("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0.5,0),Size=UDim2.fromOffset(78,28),BackgroundColor3=theme.Background,BackgroundTransparency=0.12,Text=key,Font=Enum.Font.GothamBold,TextSize=10,TextColor3=theme.Accent,AutoButtonColor=false,ZIndex=6},frame); corner(btn,7)
            btn.MouseButton1Click:Connect(function() listening=true; btn.Text="..." end)
            local conn=UserInputService.InputBegan:Connect(function(input,processed) if processed then return end; if listening and input.UserInputType==Enum.UserInputType.Keyboard then key=input.KeyCode.Name; btn.Text=key; listening=false elseif not listening and input.KeyCode.Name==key and cfg.Callback then task.spawn(cfg.Callback,key) end end)
            local item={Instance=frame}; function item:Set(v) key=tostring(v); btn.Text=key end; function item:Get() return key end; function item:UpdateTheme(t) frame.BackgroundColor3=t.Surface; label.TextColor3=t.Text; btn.BackgroundColor3=t.Background; btn.TextColor3=t.Accent end
            return addElement(item)
        end
        function tab:CreateColorPicker(cfg)
            cfg=cfg or {}; local color=cfg.Color or theme.Accent
            local frame=elementFrame(cfg.Name or "Color",48)
            local label=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,0),Size=UDim2.new(1,-70,1,0),Text=cfg.Name or "Accent Color",Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=theme.Text,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6},frame)
            local swatch=make("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-12,0.5,0),Size=UDim2.fromOffset(42,25),BackgroundColor3=color,Text="",AutoButtonColor=false,ZIndex=6},frame); corner(swatch,7)
            local popup=make("Frame",{Name="ColorPickerPopup",Position=UDim2.new(1,-218,1,5),Size=UDim2.fromOffset(210,92),BackgroundColor3=theme.Panel,BorderSizePixel=0,Visible=false,ZIndex=30},frame)
            corner(popup,10); stroke(popup,theme.Stroke,0.25,1); pad(popup,10,8)
            local preview=make("Frame",{Size=UDim2.new(1,0,0,22),BackgroundColor3=color,BorderSizePixel=0,ZIndex=31},popup); corner(preview,6)
            local hueTrack=make("Frame",{Position=UDim2.new(0,0,0,34),Size=UDim2.new(1,0,0,12),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=31},popup); corner(hueTrack,5)
            make("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),ColorSequenceKeypoint.new(0.17,Color3.fromRGB(255,255,0)),ColorSequenceKeypoint.new(0.33,Color3.fromRGB(0,255,0)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),ColorSequenceKeypoint.new(0.67,Color3.fromRGB(0,0,255)),ColorSequenceKeypoint.new(0.83,Color3.fromRGB(255,0,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0))})},hueTrack)
            local hueHit=make("TextButton",{BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Text="",ZIndex=33},hueTrack)
            local hueKnob=make("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.fromOffset(8,18),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=34},hueTrack); corner(hueKnob,4); stroke(hueKnob,theme.Background,0,1)
            local hex=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,0,0,54),Size=UDim2.new(1,0,0,20),Text="Click the bar to change hue",Font=Enum.Font.Gotham,TextSize=10,TextColor3=theme.Muted,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=31},popup)
            local hue=0
            local function setHue(h,fire)
                hue=math.clamp(h,0,1); color=Color3.fromHSV(hue,0.82,1); swatch.BackgroundColor3=color; preview.BackgroundColor3=color; hueKnob.Position=UDim2.new(hue,0,0.5,0); hex.Text=string.format("#%02X%02X%02X",math.floor(color.R*255),math.floor(color.G*255),math.floor(color.B*255)); if fire and cfg.Callback then task.spawn(cfg.Callback,color) end
            end
            swatch.MouseButton1Click:Connect(function() popup.Visible=not popup.Visible; if popup.Visible then popup.ZIndex=30 end end)
            hueHit.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then setHue(math.clamp((input.Position.X-hueTrack.AbsolutePosition.X)/math.max(hueTrack.AbsoluteSize.X,1),0,1),true) end end)
            local hueDrag=false
            hueHit.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then hueDrag=true end end)
            UserInputService.InputChanged:Connect(function(input) if hueDrag and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then setHue(math.clamp((input.Position.X-hueTrack.AbsolutePosition.X)/math.max(hueTrack.AbsoluteSize.X,1),0,1),true) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then hueDrag=false end end)
            local item={Instance=frame}
            function item:Set(v) if typeof(v)=="Color3" then color=v; swatch.BackgroundColor3=v; preview.BackgroundColor3=v; local h=select(1,v:ToHSV()); setHue(h,false); if cfg.Callback then task.spawn(cfg.Callback,v) end end end
            function item:Get() return color end
            function item:UpdateTheme(t) frame.BackgroundColor3=t.Surface; label.TextColor3=t.Text; popup.BackgroundColor3=t.Panel; hex.TextColor3=t.Muted; stroke(popup,t.Stroke,0.25,1) end
            return addElement(item)
        end
        function tab:CreateDivider()
            local frame=make("Frame",{Name="Divider",BackgroundColor3=theme.Stroke,BackgroundTransparency=0.5,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),ZIndex=5},page)
            local item={Instance=frame}; function item:UpdateTheme(t) frame.BackgroundColor3=t.Stroke end
            return addElement(item)
        end
        function tab:CreateProgressBar(cfg)
            cfg=cfg or {}; local value=math.clamp(tonumber(cfg.Value) or 0,0,100)
            local frame=elementFrame(cfg.Name or "Progress",cfg.Description and 65 or 52)
            local label=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,5),Size=UDim2.new(1,-70,0,20),Text=cfg.Name or "Progress",Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=theme.Text,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6},frame)
            local amount=make("TextLabel",{BackgroundTransparency=1,AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-12,0,5),Size=UDim2.fromOffset(55,20),Text=tostring(value).."%",Font=Enum.Font.GothamBold,TextSize=11,TextColor3=theme.Accent,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=6},frame)
            local track=make("Frame",{Position=UDim2.new(0,12,0,31),Size=UDim2.new(1,-24,0,7),BackgroundColor3=theme.Stroke,BorderSizePixel=0,ZIndex=6},frame); corner(track,5)
            local fill=make("Frame",{Size=UDim2.new(value/100,0,1,0),BackgroundColor3=theme.Accent,BorderSizePixel=0,ZIndex=7},track); corner(fill,5)
            local item={Instance=frame}
            function item:Set(v) value=math.clamp(tonumber(v) or value,0,100); tween(fill,0.2,{Size=UDim2.new(value/100,0,1,0)}); amount.Text=tostring(math.floor(value)).."%" end
            function item:Get() return value end
            function item:UpdateTheme(t) frame.BackgroundColor3=t.Surface; label.TextColor3=t.Text; amount.TextColor3=t.Accent; track.BackgroundColor3=t.Stroke; fill.BackgroundColor3=t.Accent end
            return addElement(item)
        end
        function tab:CreateImage(cfg)
            cfg=type(cfg)=="table" and cfg or {Image=cfg}
            local frame=elementFrame(cfg.Name or "Image",cfg.Height or 150)
            local image=make("ImageLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(6,6),Size=UDim2.new(1,-12,1,-12),Image=assetId(cfg.Image or ""),ScaleType=cfg.ScaleType=="Fit" and Enum.ScaleType.Fit or Enum.ScaleType.Crop,ZIndex=6},frame); corner(image,8)
            local item={Instance=frame}
            function item:Set(v) image.Image=assetId(v) end
            function item:UpdateTheme(t) frame.BackgroundColor3=t.Surface end
            return addElement(item)
        end
        function tab:CreateSearchBox(cfg)
            cfg=cfg or {}; local frame=elementFrame(cfg.Name or "Search",58)
            local label=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,4),Size=UDim2.new(1,-24,0,17),Text=cfg.Name or "Search",Font=Enum.Font.GothamMedium,TextSize=11,TextColor3=theme.Muted,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6},frame)
            local box=make("TextBox",{Position=UDim2.fromOffset(10,24),Size=UDim2.new(1,-20,0,27),BackgroundColor3=theme.Background,BackgroundTransparency=0.15,Text="",PlaceholderText=cfg.Placeholder or "Search...",ClearTextOnFocus=false,TextColor3=theme.Text,PlaceholderColor3=theme.Muted,Font=Enum.Font.Gotham,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,BorderSizePixel=0,ZIndex=6},frame); corner(box,7); pad(box,8,0)
            box:GetPropertyChangedSignal("Text"):Connect(function() if cfg.Callback then task.spawn(cfg.Callback,box.Text) end end)
            local item={Instance=frame}; function item:Set(v) box.Text=tostring(v) end; function item:Get() return box.Text end; function item:UpdateTheme(t) frame.BackgroundColor3=t.Surface; label.TextColor3=t.Muted; box.BackgroundColor3=t.Background; box.TextColor3=t.Text; box.PlaceholderColor3=t.Muted end
            return addElement(item)
        end
        function tab:CreateMultiDropdown(cfg)
            cfg=cfg or {}; local options=cfg.Options or {}; local selected={}
            for _,v in ipairs(cfg.CurrentOptions or {}) do selected[tostring(v)]=true end
            local frame=elementFrame(cfg.Name or "Multi dropdown",48)
            local label=make("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(12,0),Size=UDim2.new(0.45,0,1,0),Text=cfg.Name or "Multi dropdown",Font=Enum.Font.GothamMedium,TextSize=12,TextColor3=theme.Text,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6},frame)
            local chosen=make("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0.5,0),Size=UDim2.new(0.52,0,0,29),BackgroundColor3=theme.Background,Text="Select options",Font=Enum.Font.Gotham,TextSize=10,TextColor3=theme.Text,AutoButtonColor=false,ZIndex=6},frame); corner(chosen,7)
            local popup=make("Frame",{Position=UDim2.new(0,0,1,4),Size=UDim2.new(1,0,0,0),BackgroundColor3=theme.Panel,ClipsDescendants=true,Visible=false,ZIndex=15},frame); corner(popup,8); stroke(popup,theme.Stroke,0.3,1)
            local scroll=make("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.fromScale(1,1),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=2,ZIndex=16},popup); pad(scroll,5,5); make("UIListLayout",{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder},scroll)
            local function values() local out={} for _,v in ipairs(options) do if selected[tostring(v)] then table.insert(out,v) end end return out end
            local function refresh() local vals=values(); chosen.Text=#vals==0 and "Select options" or table.concat(vals,", "); for _,b in ipairs(scroll:GetChildren()) do if b:IsA("TextButton") then b:Destroy() end end; for i,opt in ipairs(options) do local b=make("TextButton",{Size=UDim2.new(1,0,0,28),BackgroundColor3=selected[tostring(opt)] and theme.Accent or theme.Surface,BackgroundTransparency=selected[tostring(opt)] and 0.15 or 0.25,Text=(selected[tostring(opt)] and "✓  " or "＋  ")..tostring(opt),Font=Enum.Font.Gotham,TextSize=11,TextColor3=theme.Text,AutoButtonColor=false,LayoutOrder=i,ZIndex=17},scroll); corner(b,6); b.MouseButton1Click:Connect(function() selected[tostring(opt)]=not selected[tostring(opt)]; refresh(); if cfg.Callback then task.spawn(cfg.Callback,values()) end end) end end
            chosen.MouseButton1Click:Connect(function() popup.Visible=not popup.Visible; tween(popup,0.18,{Size=UDim2.new(1,0,0,popup.Visible and math.min(#options,5)*31+10 or 0)}) end); refresh()
            local item={Instance=frame}; function item:Set(v) selected={}; for _,x in ipairs(v or {}) do selected[tostring(x)]=true end; refresh() end; function item:Get() return values() end; function item:UpdateOptions(v) options=v or {}; refresh() end; function item:UpdateTheme(t) frame.BackgroundColor3=t.Surface; label.TextColor3=t.Text; chosen.BackgroundColor3=t.Background; chosen.TextColor3=t.Text; popup.BackgroundColor3=t.Panel; refresh() end
            return addElement(item)
        end
        function tab:CreateTextBox(cfg) return self:CreateInput(cfg) end
        local item={Instance=page}; function item:Select() selectTab() end
        table.insert(state.Tabs,tab)
        if #state.Tabs==1 then selectTab() end
        return tab
    end
    function Window:SetTheme(name) state:SetTheme(name) end
    function Window:CreateCustomTheme(name, values) return state:CreateCustomTheme(name,values) end
    function Window:SetBackground(source,options) return state:SetBackground(source,options) end
    function Window:SetBackgroundFile(fileName,url,options) return state:SetBackgroundFile(fileName,url,options) end
    function Window:SetGifFrames(frames,fps) return state:SetGifFrames(frames,fps) end
    function Window:SetTransparency(value) state:SetTransparency(value) end
    function Window:SetAcrylic(value) state:SetAcrylic(value) end
    function Window:Notify(notice) return state:Notify(notice) end
    function Window:Destroy() state:Destroy() end
    function Window:Toggle() setOpen(not state.Open) end
    state.Window = Window
    if config.BackgroundImage then state:SetBackground(config.BackgroundImage,{Local=config.BackgroundLocal,Transparency=config.BackgroundImageTransparency or 0.58}) end
    if config.Intro ~= false then
        root.Size=UDim2.fromOffset((config.Width or 720)*0.88,(config.Height or 470)*0.88)
        root.BackgroundTransparency=1
        tween(root,0.35,{Size=UDim2.fromOffset(config.Width or 720,config.Height or 470),BackgroundTransparency=transparency},Enum.EasingStyle.Back)
    end
    return Window
end

return OpenHubUI
