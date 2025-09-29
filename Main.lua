local UIFuncs = {}

local dir = "https://raw.githubusercontent.com/rhuda21/ConfigManager/refs/heads/main/"
local Config = loadstring(game:HttpGet(dir .. _G.Script))()

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function PasteAPI(action, file)
    if action == "Export" then
        local content = readfile(file)
        local response = request({
            Url = "https://dpaste.com/api/",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/x-www-form-urlencoded"
            },
            Body = "content=" .. content .. "&syntax=text&expiry_days=7"
        })
        if response.StatusCode == 201 and response.Body then
            local cleanUrl = string.match(response.Body, "^%s*(.-)%s*$")
            local finalUrl = cleanUrl .. ".txt"
            setclipboard(finalUrl)
            return finalUrl
        else
            return nil
        end
    elseif action == "Download" then
        local response = request({
            Url = file,
            Method = "GET"
        })
        if response.StatusCode == 200 and response.Body then
            return response.Body
        else
            return nil
        end
    end
end

UIFuncs.MakeDraggable = function(topbarobject, object)
	local function CustomPos(topbarobject, object)
		object.Size = UDim2.new(0, object.Size.X.Offset, 0, object.Size.Y.Offset)
		local Dragging = nil
		local DragInput = nil
		local DragStart = nil
		local StartPosition = nil
		local LastPosition = nil
		local Tween = nil
		local function UpdatePos(input)
			local Delta = input.Position - DragStart
			local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
			if Tween then Tween:Cancel() end
			Tween = TweenService:Create(object,TweenInfo.new(0.03, Enum.EasingStyle.Linear),{Position = pos})Tween:Play()
        end
		topbarobject.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = input.Position
				StartPosition = object.Position
				if Tween then Tween:Cancel() end
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)
		topbarobject.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				DragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == DragInput and Dragging then
				UpdatePos(input)
			end
		end)
	end
	CustomPos(topbarobject, object)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ConfigUI"
screenGui.Parent = cloneref(gethui()) or game:GetService("CoreGui")

local windowFrame = Instance.new("Frame")
windowFrame.Name = "WindowFrame"
windowFrame.Size = UDim2.new(0, 360, 0, 220)
windowFrame.Position = UDim2.new(0, 40, 0, 40)
windowFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
windowFrame.BorderSizePixel = 0
windowFrame.Parent = screenGui
windowFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = windowFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Text = "Config Manager"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 24
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Parent = windowFrame

-- Export Button
local exportBtn = Instance.new("TextButton")
exportBtn.Name = "ExportButton"
exportBtn.Text = "EXPORT config"
exportBtn.Size = UDim2.new(0, 200, 0, 40)
exportBtn.Position = UDim2.new(0, 80, 0, 50)
exportBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
exportBtn.TextColor3 = Color3.fromRGB(255,255,255)
exportBtn.Font = Enum.Font.SourceSans
exportBtn.TextSize = 20
exportBtn.Parent = windowFrame

local exportCorner = Instance.new("UICorner")
exportCorner.CornerRadius = UDim.new(0, 8)
exportCorner.Parent = exportBtn

-- URL Input
local urlBox = Instance.new("TextBox")
urlBox.Name = "URLInput"
urlBox.PlaceholderText = "Enter config URL..."
urlBox.Size = UDim2.new(0, 320, 0, 32)
urlBox.Position = UDim2.new(0, 20, 0, 100)
urlBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
urlBox.TextColor3 = Color3.fromRGB(255,255,255)
urlBox.Font = Enum.Font.SourceSans
urlBox.TextSize = 18
urlBox.Parent = windowFrame

local urlCorner = Instance.new("UICorner")
urlCorner.CornerRadius = UDim.new(0, 6)
urlCorner.Parent = urlBox

-- Download Button
local downloadBtn = Instance.new("TextButton")
downloadBtn.Name = "DownloadButton"
downloadBtn.Text = "Download"
downloadBtn.Size = UDim2.new(0, 140, 0, 40)
downloadBtn.Position = UDim2.new(0, 80, 0, 150)
downloadBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 120)
downloadBtn.TextColor3 = Color3.fromRGB(255,255,255)
downloadBtn.Font = Enum.Font.SourceSans
downloadBtn.TextSize = 20
downloadBtn.Parent = windowFrame
downloadBtn.BackgroundTransparency = 0.1

local downloadCorner = Instance.new("UICorner")
downloadCorner.CornerRadius = UDim.new(0, 8)
downloadCorner.Parent = downloadBtn

-- Play Button
local playBtn = Instance.new("TextButton")
playBtn.Name = "PlayButton"
playBtn.Text = "▶️"
playBtn.Size = UDim2.new(0, 50, 0, 40)
playBtn.Position = UDim2.new(0, 230, 0, 150)
playBtn.BackgroundColor3 = Color3.fromRGB(120, 200, 60)
playBtn.TextColor3 = Color3.fromRGB(255,255,255)
playBtn.Font = Enum.Font.SourceSansBold
playBtn.TextSize = 20
playBtn.Parent = windowFrame
playBtn.BackgroundTransparency = 0.1

local playCorner = Instance.new("UICorner")
playCorner.CornerRadius = UDim.new(0, 8)
playCorner.Parent = playBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -36, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 22
closeBtn.Parent = windowFrame
closeBtn.BackgroundTransparency = 0.1

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

local binBtn = Instance.new("TextButton")
binBtn.Name = "Bin"
binBtn.Text = "🗑️"
binBtn.Size = UDim2.new(0, 50, 0, 40)
binBtn.Position = UDim2.new(0, 290, 0, 150)
binBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
binBtn.TextColor3 = Color3.fromRGB(255,255,255)
binBtn.Font = Enum.Font.SourceSansBold
binBtn.TextSize = 20
binBtn.Parent = windowFrame
binBtn.BackgroundTransparency = 0.1

local binCorner = Instance.new("UICorner")
binCorner.CornerRadius = UDim.new(0, 8)
binCorner.Parent = binBtn

-- Tabs container
local tabsFrame = Instance.new("Frame")
tabsFrame.Name = "TabsFrame"
tabsFrame.Size = UDim2.new(1, 0, 0, 36)
tabsFrame.Position = UDim2.new(0, 0, 0, 0)
tabsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabsFrame.BorderSizePixel = 0
tabsFrame.Parent = windowFrame
tabsFrame.ZIndex = 2

local tabsCorner = Instance.new("UICorner")
tabsCorner.CornerRadius = UDim.new(0, 12)
tabsCorner.Parent = tabsFrame

-- Tab buttons
local tabNames = {"Config", "Settings"}
local tabButtons = {}

for i, name in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "Tab"
    tabBtn.Text = name
    tabBtn.Size = UDim2.new(0, 100, 1, 0)
    tabBtn.Position = UDim2.new(0, (i-1)*110, 0, 0)
    tabBtn.BackgroundColor3 = i == 1 and Color3.fromRGB(60,120,200) or Color3.fromRGB(50,50,50)
    tabBtn.TextColor3 = Color3.fromRGB(255,255,255)
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.TextSize = 18
    tabBtn.Parent = tabsFrame
    tabBtn.ZIndex = 3

    local tabBtnCorner = Instance.new("UICorner")
    tabBtnCorner.CornerRadius = UDim.new(0, 8)
    tabBtnCorner.Parent = tabBtn

    tabButtons[i] = tabBtn
end

-- Hide/show content based on tab
local function showTab(idx)
    for i, btn in ipairs(tabButtons) do
        btn.BackgroundColor3 = i == idx and Color3.fromRGB(60,120,200) or Color3.fromRGB(50,50,50)
    end
    -- Example: Hide all except config tab (add more tab content as needed)
    local showConfig = idx == 1
    exportBtn.Visible = showConfig
    downloadBtn.Visible = showConfig
    playBtn.Visible = showConfig
    binBtn.Visible = showConfig
    urlBox.Visible = showConfig
    -- Add more tab content visibility logic here
end

for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        showTab(i)
    end)
end

showTab(1)

-- Move titleLabel below tabs
titleLabel.Position = UDim2.new(0, 0, 0, 36)
titleLabel.Size = UDim2.new(1, 0, 0, 40)

-- Functions UI

UIFuncs.confirm = function(msg, yesText, noText, onYes, onNo)
    yesText = yesText or "Yes"
    noText = noText or "No"
    local confirmBox = Instance.new("Frame")
    confirmBox.Size = UDim2.new(0, 240, 0, 100)
    confirmBox.Position = UDim2.new(0.5, -120, 0.5, -50)
    confirmBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    confirmBox.Parent = windowFrame
    confirmBox.ZIndex = 10

    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = UDim.new(0, 10)
    confirmCorner.Parent = confirmBox

    local confirmLabel = Instance.new("TextLabel")
    confirmLabel.Text = msg
    confirmLabel.Size = UDim2.new(1, 0, 0, 50)
    confirmLabel.Position = UDim2.new(0, 0, 0, 0)
    confirmLabel.BackgroundTransparency = 1
    confirmLabel.TextColor3 = Color3.fromRGB(255,255,255)
    confirmLabel.Font = Enum.Font.SourceSansBold
    confirmLabel.TextSize = 18
    confirmLabel.Parent = confirmBox
    confirmLabel.ZIndex = 11

    local yesBtn = Instance.new("TextButton")
    yesBtn.Text = yesText
    yesBtn.Size = UDim2.new(0, 90, 0, 32)
    yesBtn.Position = UDim2.new(0, 20, 0, 60)
    yesBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    yesBtn.TextColor3 = Color3.fromRGB(255,255,255)
    yesBtn.Font = Enum.Font.SourceSansBold
    yesBtn.TextSize = 18
    yesBtn.Parent = confirmBox
    yesBtn.ZIndex = 11

    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 8)
    yesCorner.Parent = yesBtn

    local noBtn = Instance.new("TextButton")
    noBtn.Text = noText
    noBtn.Size = UDim2.new(0, 90, 0, 32)
    noBtn.Position = UDim2.new(0, 130, 0, 60)
    noBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
    noBtn.TextColor3 = Color3.fromRGB(255,255,255)
    noBtn.Font = Enum.Font.SourceSansBold
    noBtn.TextSize = 18
    noBtn.Parent = confirmBox
    noBtn.ZIndex = 11

    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 8)
    noCorner.Parent = noBtn

    yesBtn.MouseButton1Click:Connect(function()
        confirmBox:Destroy()
        if onYes then onYes() end
    end)
    noBtn.MouseButton1Click:Connect(function()
        confirmBox:Destroy()
        if onNo then onNo() end
    end)
end

UIFuncs.Notify = function(msg, duration, color)
    duration = duration or 2
    local notif = Instance.new("TextLabel")
    notif.Text = msg
    notif.Size = UDim2.new(1, 0, 0, 30)
    notif.Position = UDim2.new(0, 0, 0, -35)
    notif.BackgroundColor3 = color or Config.Theme.Accent
    notif.TextColor3 = Color3.fromRGB(255,255,255)
    notif.Font = Enum.Font.SourceSansBold
    notif.TextSize = 18
    notif.Parent = windowFrame
    notif.BackgroundTransparency = 0.1
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif
    notif:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.25, true)
    task.delay(duration, function()
        notif:TweenPosition(UDim2.new(0, 0, 0, -35), "In", "Quad", 0.25, true)
        task.wait(0.3)
        notif:Destroy()
    end)
end

binBtn.MouseButton1Click:Connect(function()
    local gameid = game.PlaceId
    local path = Config.Games[gameid]
    if path and isfile(path) then
        UIFuncs.confirm("Delete config?\nThis cannot be undone.\nPATH: " .. path,"Yes", "No",function()delfile(path)UIFuncs.Notify("Config deleted!", 2, Config.Theme.Accent)end,function() end)
    else
        UIFuncs.Notify("No config to delete.", 2, Config.Theme.Accent)
    end
end)

exportBtn.MouseButton1Click:Connect(function()
    local gameId = game.PlaceId
    local path = Config.Games[gameId]
    if path then
        if isfile(path) then
            local pasteUrl = PasteAPI("Export", path)
            if pasteUrl then
                UIFuncs.Notify("Config exported! On Clipboard " .. pasteUrl)
            end
        else
            UIFuncs.Notify("Config file not found at path: " .. path)
        end
    else
        UIFuncs.Notify("This game is unsupported: " .. gameId)
    end
end)

downloadBtn.MouseButton1Click:Connect(function()
    local url = urlBox.Text
    local c = PasteAPI("Download", url)
    if c then
        local gameid = game.PlaceId
        local path = Config.Games[gameid]
        if path then
            writefile(path,c)
            UIFuncs.Notify("Config downloaded and saved!")
        end
    else
        UIFuncs.Notify("Failed to download config.")
    end
end)

playBtn.MouseButton1Click:Connect(function()
    Config.exec()
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
UIFuncs.MakeDraggable(titleLabel, windowFrame)