local Repository = "https://raw.githubusercontent.com/VibecodingFinalBoss95/Library/main/UILibrary/"

local function FetchAsync(Url)
	if game.HttpGet then
		return game:HttpGet(Url)
	elseif syn and syn.request then
		return syn.request({Url = Url, Method = "GET"}).Body
	elseif http_request then
		return http_request({Url = Url, Method = "GET"}).Body
	elseif request then
		return request({Url = Url, Method = "GET"}).Body
	end
	error("UILibrary: no HTTP function available on this executor")
end

local function LoadModule(Path)
	local Source = FetchAsync(Repository .. Path)
	return loadstring(Source)()
end

local Theme = LoadModule("Theme.lua")()
local Utility = LoadModule("Utility.lua")(Theme)

local Toggle = LoadModule("Components/Toggle.lua")(Theme, Utility)
local Button = LoadModule("Components/Button.lua")(Theme, Utility)
local Dropdown = LoadModule("Components/Dropdown.lua")(Theme, Utility)
local Slider = LoadModule("Components/Slider.lua")(Theme, Utility)
local AdaptiveInput = LoadModule("Components/AdaptiveInput.lua")(Theme, Utility)
local ColorPicker = LoadModule("Components/ColorPicker.lua")(Theme, Utility)

local Section = LoadModule("Section.lua")(Theme, Utility, Toggle, Button, Dropdown, Slider, AdaptiveInput, ColorPicker)
local Tab = LoadModule("Tab.lua")(Theme, Utility, Section)
local Window = LoadModule("Window.lua")(Theme, Utility, Tab)

local UILibrary = {}

function UILibrary.CreateWindow(Self, Config)
	return Window.new(Config)
end

return UILibrary
