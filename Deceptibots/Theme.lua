return function()
	local Theme = {}

	Theme.Background    = Color3.fromRGB(11, 13, 12)
	Theme.Surface       = Color3.fromRGB(19, 22, 20)
	Theme.Elevated      = Color3.fromRGB(27, 31, 28)
	Theme.ElevatedHover = Color3.fromRGB(35, 40, 36)

	Theme.Accent      = Color3.fromRGB(31, 122, 84)
	Theme.AccentHover = Color3.fromRGB(41, 143, 100)
	Theme.AccentMuted = Color3.fromRGB(20, 58, 44)

	Theme.Gold      = Color3.fromRGB(201, 162, 57)
	Theme.GoldHover = Color3.fromRGB(219, 181, 79)

	Theme.Text         = Color3.fromRGB(235, 233, 226)
	Theme.TextMuted    = Color3.fromRGB(142, 148, 140)
	Theme.TextDisabled = Color3.fromRGB(84, 89, 85)

	Theme.Border      = Color3.fromRGB(40, 45, 41)
	Theme.BorderLight = Color3.fromRGB(58, 64, 58)

	Theme.Danger  = Color3.fromRGB(178, 64, 64)
	Theme.Success = Theme.Accent

	Theme.CornerRadius      = UDim.new(0, 6)
	Theme.CornerRadiusSmall = UDim.new(0, 4)
	Theme.CornerRadiusLarge = UDim.new(0, 10)

	Theme.Font       = Enum.Font.Gotham
	Theme.FontMedium = Enum.Font.GothamMedium
	Theme.FontBold   = Enum.Font.GothamBold

	Theme.TweenFast   = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	Theme.TweenMedium = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	Theme.ReferenceWidth  = 1280
	Theme.ReferenceHeight = 800
	Theme.MinScale        = 0.55
	Theme.MaxScale        = 1

	return Theme
end
