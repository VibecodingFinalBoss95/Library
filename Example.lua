local Deceptibots = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/VibecodingFinalBoss95/Library/main/Loader.lua"
))()

local Window = Deceptibots:CreateWindow({
	Title = "Deceptibots Test",
	Size = UDim2.fromOffset(560, 380),
})

local MainTab = Window:CreateTab("Main")
local InfoSection = MainTab:CreateSection("Info")

InfoSection:CreateParagraph({
	Title = "Deceptibots",
	Body = "This exercises every component so you can confirm everything renders and responds correctly.",
})

InfoSection:CreateTextLabel({
	Text = "Muted helper label",
	Muted = true,
})

local MainSection = MainTab:CreateSection("Components")

MainSection:CreateToggle({
	Text = "Toggle Test",
	Default = false,
	Callback = function(Value)
		print("[Toggle]", Value)
	end,
})

MainSection:CreateButton({
	Text = "Button Test",
	Callback = function()
		print("[Button] Clicked")
	end,
})

MainSection:CreateDropdown({
	Text = "Dropdown Test",
	Options = {"Option A", "Option B", "Option C"},
	Default = "Option A",
	Callback = function(Value)
		print("[Dropdown]", Value)
	end,
})

MainSection:CreateDropdown({
	Text = "Multi Dropdown Test",
	Options = {"Sword", "Bow", "Staff", "Shield"},
	Multi = true,
	Default = {"Sword"},
	Callback = function(Values)
		print("[Dropdown/Multi]", table.concat(Values, ", "))
	end,
})

MainSection:CreateSlider({
	Text = "Slider Test",
	Min = 0,
	Max = 100,
	Default = 25,
	Callback = function(Value)
		print("[Slider]", Value)
	end,
})

MainSection:CreateDualSlider({
	Text = "Dual Slider Test",
	Min = 0,
	Max = 100,
	DefaultLow = 20,
	DefaultHigh = 80,
	Callback = function(Low, High)
		print("[DualSlider]", Low, High)
	end,
})

local ExtrasTab = Window:CreateTab("Extras")
local ExtrasSection = ExtrasTab:CreateSection("More Components")

ExtrasSection:CreateAdaptiveInput({
	Text = "Text Input Test",
	Mode = "Text",
	Callback = function(Value)
		print("[AdaptiveInput/Text]", Value)
	end,
})

ExtrasSection:CreateAdaptiveInput({
	Text = "Number Input Test",
	Mode = "Number",
	Default = 10,
	Callback = function(Value)
		print("[AdaptiveInput/Number]", Value)
	end,
})

ExtrasSection:CreateColorPicker({
	Text = "Color Picker Test",
	Default = Color3.fromRGB(31, 122, 84),
	Callback = function(Value)
		print("[ColorPicker]", Value)
	end,
})

print("[Deceptibots] Test script finished — window should be visible now.")
