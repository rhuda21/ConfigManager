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

local theme = Config.Theme

local windowFrame = Instance.new("Frame")
windowFrame.Name = "WindowFrame"
windowFrame.Size = UDim2.new(0, 360, 0, 220)
windowFrame.Position = UDim2.new(0, 40, 0, 40)
windowFrame.BackgroundColor3 = theme.AcrylicMain or Color3.fromRGB(40, 40, 40)
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
titleLabel.TextColor3 = theme.Text or Color3.fromRGB(255, 255, 255)
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
exportBtn.BackgroundColor3 = theme.Accent or Color3.fromRGB(60, 120, 200)
exportBtn.TextColor3 = theme.Text or Color3.fromRGB(255,255,255)
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
urlBox.BackgroundColor3 = theme.Input or Color3.fromRGB(50, 50, 50)
urlBox.TextColor3 = theme.Text or Color3.fromRGB(255,255,255)
urlBox.Font = Enum.Font.SourceSans
urlBox.TextSize = 18
urlBox.Parent = windowFrame

local urlCorner = Instance.new("UICorner")
urlCorner.CornerRadius = UDim.new(0, 6)
urlCorner.Parent = urlBox

-- Download Button (Replace)
local downloadBtn = Instance.new("TextButton")
downloadBtn.Name = "DownloadButton"
downloadBtn.Text = "Download"
downloadBtn.Size = UDim2.new(0, 110, 0, 40)
downloadBtn.Position = UDim2.new(0, 80, 0, 150)
downloadBtn.BackgroundColor3 = theme.Element or Color3.fromRGB(60, 200, 120)
downloadBtn.TextColor3 = theme.Text or Color3.fromRGB(255,255,255)
downloadBtn.Font = Enum.Font.SourceSans
downloadBtn.TextSize = 20
downloadBtn.Parent = windowFrame
downloadBtn.BackgroundTransparency = theme.ElementTransparency or 0.1

local downloadCorner = Instance.new("UICorner")
downloadCorner.CornerRadius = UDim.new(0, 8)
downloadCorner.Parent = downloadBtn

-- New Download Button (Create New)
local downloadNewBtn = Instance.new("TextButton")
downloadNewBtn.Name = "DownloadNewButton"
downloadNewBtn.Text = "⬇️"
downloadNewBtn.Size = UDim2.new(0, 32, 0, 40)
downloadNewBtn.Position = UDim2.new(0, 196, 0, 150)
downloadNewBtn.BackgroundColor3 = theme.DropdownOption or Color3.fromRGB(60, 180, 220)
downloadNewBtn.TextColor3 = theme.Text or Color3.fromRGB(255,255,255)
downloadNewBtn.Font = Enum.Font.SourceSansBold
downloadNewBtn.TextSize = 22
downloadNewBtn.Parent = windowFrame
downloadNewBtn.BackgroundTransparency = theme.ElementTransparency or 0.1

local downloadNewCorner = Instance.new("UICorner")
downloadNewCorner.CornerRadius = UDim.new(0, 8)
downloadNewCorner.Parent = downloadNewBtn

downloadNewBtn.MouseButton1Click:Connect(function()
    local url = urlBox.Text
    local c = PasteAPI("Download", url)
    if c then
        local folder = Config.SystemPath or "configs"
        if not isfolder(folder) then makefolder(folder) end
        local gameid = game.PlaceId
        local files = listfiles(folder)
        local count = 0
        for _, file in ipairs(files) do
            local fname = file:match("[^\\/]+$")
            if fname:find(tostring(gameid)) then
                count = count + 1
            end
        end
        local newPath = folder .. "/" .. tostring(gameid) .. "_" .. tostring(count + 1)
        writefile(newPath, c)
        UIFuncs.Notify("Config downloaded as new file: " .. newPath)
    else
        UIFuncs.Notify("Failed to download config.")
    end
end)

-- Play Button
local playBtn = Instance.new("TextButton")
playBtn.Name = "PlayButton"
playBtn.Text = "▶️"
playBtn.Size = UDim2.new(0, 50, 0, 40)
playBtn.Position = UDim2.new(0, 230, 0, 150)
playBtn.BackgroundColor3 = theme.ToggleSlider or Color3.fromRGB(120, 200, 60)
playBtn.TextColor3 = theme.Text or Color3.fromRGB(255,255,255)
playBtn.Font = Enum.Font.SourceSansBold
playBtn.TextSize = 20
playBtn.Parent = windowFrame
playBtn.BackgroundTransparency = theme.ElementTransparency or 0.1

local playCorner = Instance.new("UICorner")
playCorner.CornerRadius = UDim.new(0, 8)
playCorner.Parent = playBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -36, 0, 4)
closeBtn.BackgroundColor3 = theme.DialogButtonBorder or Color3.fromRGB(200, 60, 60)
closeBtn.TextColor3 = theme.Text or Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 22
closeBtn.Parent = windowFrame
closeBtn.BackgroundTransparency = theme.ElementTransparency or 0.1

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

local binBtn = Instance.new("TextButton")
binBtn.Name = "Bin"
binBtn.Text = "🗑️"
binBtn.Size = UDim2.new(0, 50, 0, 40)
binBtn.Position = UDim2.new(0, 290, 0, 150)
binBtn.BackgroundColor3 = theme.DialogButtonBorder or Color3.fromRGB(200, 80, 80)
binBtn.TextColor3 = theme.Text or Color3.fromRGB(255,255,255)
binBtn.Font = Enum.Font.SourceSansBold
binBtn.TextSize = 20
binBtn.Parent = windowFrame
binBtn.BackgroundTransparency = theme.ElementTransparency or 0.1

local binCorner = Instance.new("UICorner")
binCorner.CornerRadius = UDim.new(0, 8)
binCorner.Parent = binBtn

local fileManagerBtn = Instance.new("TextButton")
fileManagerBtn.Name = "FileManagerButton"
fileManagerBtn.Text = "Files"
fileManagerBtn.Size = UDim2.new(0, 60, 0, 32)
fileManagerBtn.Position = UDim2.new(1, -100, 0, 4)
fileManagerBtn.BackgroundColor3 = theme.Tab or Color3.fromRGB(80, 120, 200)
fileManagerBtn.TextColor3 = theme.Text or Color3.fromRGB(255,255,255)
fileManagerBtn.Font = Enum.Font.SourceSansBold
fileManagerBtn.TextSize = 18
fileManagerBtn.Parent = windowFrame
fileManagerBtn.BackgroundTransparency = theme.ElementTransparency or 0.1

local fileManagerCorner = Instance.new("UICorner")
fileManagerCorner.CornerRadius = UDim.new(0, 8)
fileManagerCorner.Parent = fileManagerBtn

-- Functions UI
UIFuncs.ShowFileManager = function()
    if windowFrame:FindFirstChild("Frame") then return end
    local fmFrame = Instance.new("Frame")
    fmFrame.Size = UDim2.new(0, 320, 0, 180)
    fmFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
    fmFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    fmFrame.Parent = windowFrame
    fmFrame.ZIndex = 20
    local fmCorner = Instance.new("UICorner")
    fmCorner.CornerRadius = UDim.new(0, 10)
    fmCorner.Parent = fmFrame
    local fmTitle = Instance.new("TextLabel")
    fmTitle.Text = "Config Files"
    fmTitle.Size = UDim2.new(1, 0, 0, 32)
    fmTitle.Position = UDim2.new(0, 0, 0, 0)
    fmTitle.BackgroundTransparency = 1
    fmTitle.TextColor3 = Color3.fromRGB(255,255,255)
    fmTitle.Font = Enum.Font.SourceSansBold
    fmTitle.TextSize = 20
    fmTitle.Parent = fmFrame
    fmTitle.ZIndex = 21
    local closeFMBtn = Instance.new("TextButton")
    closeFMBtn.Text = "X"
    closeFMBtn.Size = UDim2.new(0, 32, 0, 32)
    closeFMBtn.Position = UDim2.new(1, -36, 0, 4)
    closeFMBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeFMBtn.TextColor3 = Color3.fromRGB(255,255,255)
    closeFMBtn.Font = Enum.Font.SourceSansBold
    closeFMBtn.TextSize = 18
    closeFMBtn.Parent = fmFrame
    closeFMBtn.ZIndex = 21
    local closeFMCorner = Instance.new("UICorner")
    closeFMCorner.CornerRadius = UDim.new(0, 8)
    closeFMCorner.Parent = closeFMBtn
    closeFMBtn.MouseButton1Click:Connect(function()
        fmFrame:Destroy()
    end)
    local filesList = Instance.new("ScrollingFrame")
    filesList.Size = UDim2.new(1, -20, 1, -42)
    filesList.Position = UDim2.new(0, 10, 0, 38)
    filesList.BackgroundTransparency = 1
    filesList.CanvasSize = UDim2.new(0, 0, 0, 0)
    filesList.ScrollBarThickness = 6
    filesList.Parent = fmFrame
    filesList.ZIndex = 21
    local configFolder = Config.SystemPath or "configs"
    local files = listfiles(configFolder)
    local y = 0
    for _, file in ipairs(files) do
        local fname = file:match("[^\\/]+$")
        local fileBtn = Instance.new("TextButton")
        fileBtn.Text = fname
        fileBtn.Size = UDim2.new(0.7, -10, 0, 28)
        fileBtn.Position = UDim2.new(0, 0, 0, y)
        fileBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        fileBtn.TextColor3 = Color3.fromRGB(255,255,255)
        fileBtn.Font = Enum.Font.SourceSans
        fileBtn.TextSize = 16
        fileBtn.Parent = filesList
        fileBtn.ZIndex = 22
        local fileBtnCorner = Instance.new("UICorner")
        fileBtnCorner.CornerRadius = UDim.new(0, 6)
        fileBtnCorner.Parent = fileBtn

        local loadBtn = Instance.new("TextButton")
        loadBtn.Text = "Load"
        loadBtn.Size = UDim2.new(0.3, -6, 0, 28)
        loadBtn.Position = UDim2.new(0.7, 4, 0, y)
        loadBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
        loadBtn.TextColor3 = Color3.fromRGB(255,255,255)
        loadBtn.Font = Enum.Font.SourceSansBold
        loadBtn.TextSize = 16
        loadBtn.Parent = filesList
        loadBtn.ZIndex = 22
        local loadBtnCorner = Instance.new("UICorner")
        loadBtnCorner.CornerRadius = UDim.new(0, 6)
        loadBtnCorner.Parent = loadBtn

        fileBtn.MouseButton1Click:Connect(function()
            setclipboard(file)
            UIFuncs.Notify("Path copied to clipboard:\n" .. file)
        end)
        loadBtn.MouseButton1Click:Connect(function()
            local gameid = game.PlaceId
            local defaultPath = Config.Games[gameid]
            if defaultPath then
                local content = readfile(file)
                writefile(defaultPath, content)
                UIFuncs.Notify("Loaded config:\n" .. fname .. "\nNow Load Script with the ▶️ button.")
            else
                UIFuncs.Notify("No default path for this game.")
            end
        end)
        y = y + 32
    end
    filesList.CanvasSize = UDim2.new(0, 0, 0, y)
end
fileManagerBtn.MouseButton1Click:Connect(UIFuncs.ShowFileManager)

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
    notif.Position = UDim2.new(0, 0, 1, -35)
    notif.BackgroundColor3 = color or theme.Accent
    notif.TextColor3 = theme.Text or Color3.fromRGB(255,255,255)
    notif.Font = Enum.Font.SourceSansBold
    notif.TextSize = 18
    notif.Parent = windowFrame
    notif.BackgroundTransparency = theme.ElementTransparency or 0.1
    notif.ZIndex = 100
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif
    notif:TweenPosition(UDim2.new(0, 0, 1, -35), "Out", "Quad", 0.25, true)
    task.delay(duration, function()
        notif:TweenPosition(UDim2.new(0, 0, 1, 10), "In", "Quad", 0.25, true)
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
        UIFuncs.confirm("Replace existing config?", "Yes", "No",
            function()
                local gameid = game.PlaceId
                local path = Config.Games[gameid]
                if path then
                    writefile(path, c)
                    UIFuncs.Notify("Config downloaded and replaced!")
                end
            end,
            function()
                UIFuncs.Notify("Config download cancelled.")
            end
        )
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