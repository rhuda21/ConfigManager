local Config = {}
Config.path = "SpeedHubX"
Config.SystemPath = "SHXConfigs"

Config.Theme = {
    Background = Color3.fromRGB(20, 20, 20),
    Glow = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(151, 17, 17),
    LightContrast = Color3.fromRGB(30, 30, 30),
    DarkContrast = Color3.fromRGB(15, 15, 15),

    TextColor = Color3.fromRGB(255, 255, 255),
    TextStrokeColor = Color3.fromRGB(0, 0, 0),

    ElementBackground = Color3.fromRGB(25, 25, 25),
    ElementTextColor = Color3.fromRGB(255, 255, 255),
    ElementTextStrokeColor = Color3.fromRGB(0, 0, 0),
    ElementAccent = Color3.fromRGB(50, 50, 50),
}

Config.Games = {
    [126884695634066] = Config.path .. "\\Grow a Garden.json",
    [91867617264223] = Config.path .. "\\Grow a Garden.json",
    [124977557560410] = Config.path .. "\\Grow a Garden.json",
    [127742093697776] = Config.path .. "\\Plant Vs Brainrot.json",
    [16732694052] = Config.path .. "\\Fisch.lua",
    [131716211654599] = Config.path .. "\\Fisch.lua"
}

Config.exec = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end

return Config