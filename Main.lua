local dir = "https://raw.githubusercontent.com/rhuda21/ConfigManager/refs/heads/main/"
local Config = loadstring(game:HttpGet(dir .. _G.Script))()

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
            setclipboard(response.Body)
            return response.Body
        else
            return nil
        end
    elseif action == "Download" then
        -- Ensure .txt is appended for raw content
        local rawUrl = file
        if not rawUrl:match("%.txt$") then
            rawUrl = rawUrl .. ".txt"
        end
        local response = request({
            Url = rawUrl,
            Method = "GET"
        })
        if response.StatusCode == 200 and response.Body then
            return response.Body
        else
            return nil
        end
    end
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
downloadBtn.Size = UDim2.new(0, 200, 0, 40)
downloadBtn.Position = UDim2.new(0, 80, 0, 150)
downloadBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 120)
downloadBtn.TextColor3 = Color3.fromRGB(255,255,255)
downloadBtn.Font = Enum.Font.SourceSans
downloadBtn.TextSize = 20
downloadBtn.Parent = windowFrame

local downloadCorner = Instance.new("UICorner")
downloadCorner.CornerRadius = UDim.new(0, 8)
downloadCorner.Parent = downloadBtn

local function notify(msg, duration)
    duration = duration or 2
    local notif = Instance.new("TextLabel")
    notif.Text = msg
    notif.Size = UDim2.new(1, 0, 0, 30)
    notif.Position = UDim2.new(0, 0, 0, -35)
    notif.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
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

exportBtn.MouseButton1Click:Connect(function()
    local gameId = game.PlaceId
    local path = Config.Games[gameId]
    if path then
        if isfile(path) then
            local pasteUrl = PasteAPI("Export", path)
            if pasteUrl then
                notify("Config exported! URL:  On Clipboard " .. pasteUrl)
            end
        else
            notify("Config file not found at path: " .. path)
        end
    else
        notify("This game is unsupported: " .. gameId)
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
            notify("Config downloaded and saved!")
        end
    else
        notify("Failed to download config.")
    end
end)