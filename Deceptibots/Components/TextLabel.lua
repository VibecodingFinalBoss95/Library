return function(Theme, Utility)
	local TextLabel = {}
	TextLabel.__index = TextLabel

	function TextLabel.new(Parent, Config)
		Config = Config or {}
		local Self = setmetatable({}, TextLabel)

		Utility.Build({
			function()
				Self.Instance = Utility.Create("TextLabel", {
					Text = Config.Text or "Label",
					Font = Config.Bold and Theme.FontBold or Theme.Font,
					TextSize = Config.TextSize or 13,
					TextColor3 = Config.Color or (Config.Muted and Theme.TextMuted) or Theme.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 18),
					Parent = Parent.Container,
				})
			end,
		})

		return Self
	end

	function TextLabel.Set(Self, Text)
		Self.Instance.Text = Text
	end

	return TextLabel
end
