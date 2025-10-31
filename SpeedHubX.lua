local Config = {}
Config.path = "SpeedHubX"
Config.SystemPath = "SHXConfigs"

Config.Theme = {
    Accent = Color3.fromRGB(255, 0, 0),
		AcrylicMain = Color3.fromRGB(20, 20, 20),
		AcrylicBorder = Color3.fromRGB(40, 40, 40), 
	
		TitleBarLine = Color3.fromRGB(90, 90, 90),
		Tab = Color3.fromRGB(180, 0, 0),
	
		Element = Color3.fromRGB(180, 0, 0),
		ElementBorder = Color3.fromRGB(50, 50, 50),
		InElementBorder = Color3.fromRGB(80, 80, 80),
		ElementTransparency = 0.75,
	
		ToggleSlider = Color3.fromRGB(200, 0, 0),
		ToggleToggled = Color3.fromRGB(255, 255, 255),
	
		SliderRail = Color3.fromRGB(160, 160, 160),
	
		DropdownHolder = Color3.fromRGB(50, 50, 50),
		DropdownBorder = Color3.fromRGB(180, 0, 0),
		DropdownOption = Color3.fromRGB(220, 0, 0),
	
		Keybind = Color3.fromRGB(160, 0, 0),
	
		Input = Color3.fromRGB(180, 180, 180),
		InputFocused = Color3.fromRGB(0, 0, 0),
		InputIndicator = Color3.fromRGB(255, 50, 50),
	
		Dialog = Color3.fromRGB(30, 30, 30),
		DialogHolder = Color3.fromRGB(45, 45, 45),
		DialogHolderLine = Color3.fromRGB(180, 0, 0),
		DialogButton = Color3.fromRGB(30, 30, 30),
		DialogButtonBorder = Color3.fromRGB(255, 0, 0),
		DialogBorder = Color3.fromRGB(70, 70, 70),
		DialogInput = Color3.fromRGB(40, 40, 40),
		DialogInputLine = Color3.fromRGB(220, 0, 0),
	
		Text = Color3.fromRGB(255, 255, 255),
		SubText = Color3.fromRGB(170, 170, 170),
		Hover = Color3.fromRGB(220, 0, 0),
		HoverChange = 0.08,
}

Config.Games = {
    [126884695634066] = Config.path .. "/Grow a Garden.json",
    [91867617264223] = Config.path .. "/Grow a Garden.json",
    [124977557560410] = Config.path .. "/Grow a Garden.json",
    [127742093697776] = Config.path .. "/Plant Vs Brainrot.json",
    [16732694052] = Config.path .. "/Fisch.lua",
    [131716211654599] = Config.path .. "/Fisch.lua",
	[121864768012064] = Config.path .. "/Fish it.json"
}

Config.exec = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end

return Config