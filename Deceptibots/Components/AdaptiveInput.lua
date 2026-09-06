return function(Theme, Utility)
	local AdaptiveInput = {}
	AdaptiveInput.__index = AdaptiveInput

	function AdaptiveInput.new(Parent, Config)
		Config = Config or {}
		local Self = setmetatable({}, AdaptiveInput)

		Self.Mode = Config.Mode or "Text"
		Self.Callback = Config.Callback or function() end
		Self.Value = Config.Default ~= nil and tostring(Config.Default) or ""

		local Filled = Self.Value ~= ""

		Utility.Build({
			function()
				Self.Frame = Utility.Create("Frame", {
					Size = UDim2.new(1, 0, 0, 44),
					BackgroundColor3 = Theme.Elevated,
					Parent = Parent.Container,
				})
				Utility.AddCorner(Self.Frame, Theme.CornerRadiusSmall)
				Self.Stroke = Utility.AddStroke(Self.Frame, Theme.Border, 1)
			end,
			function()
				Self.Label = Utility.Create("TextLabel", {
					Text = Config.Text or "Input",
					Font = Theme.Font,
					TextSize = Filled and 10 or 13,
					TextColor3 = Theme.TextMuted,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -24, 0, 14),
					Position = Filled and UDim2.new(0, 12, 0, 6) or UDim2.new(0, 12, 0.5, -8),
					Parent = Self.Frame,
				})
				Self.Box = Utility.Create("TextBox", {
					Text = Self.Value,
					Font = Theme.FontMedium,
					TextSize = 13,
					TextColor3 = Theme.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					Size = UDim2.new(1, -24, 0, 16),
					Position = UDim2.new(0, 12, 1, -22),
					Parent = Self.Frame,
				})
			end,
			function()
				local function FloatLabel(Up)
					Utility.Tween(Self.Label, Theme.TweenFast, {
						Position = Up and UDim2.new(0, 12, 0, 6) or UDim2.new(0, 12, 0.5, -8),
						TextSize = Up and 10 or 13,
					})
				end

				Self.Box.Focused:Connect(function()
					FloatLabel(true)
					Utility.Tween(Self.Stroke, Theme.TweenFast, {Color = Theme.Gold})
				end)

				Self.Box.FocusLost:Connect(function(EnterPressed)
					if Self.Box.Text == "" then
						FloatLabel(false)
					end
					Utility.Tween(Self.Stroke, Theme.TweenFast, {Color = Theme.Border})
					Self.Value = Self.Box.Text
					Self.Callback(Self.Value, EnterPressed)
				end)

				Self.Box:GetPropertyChangedSignal("Text"):Connect(function()
					if Self.Mode ~= "Number" then
						return
					end

					local Text = Self.Box.Text
					local Filtered = Text:gsub("[^%d%.%-]", "")

					local Negative = Filtered:sub(1, 1) == "-"
					Filtered = Filtered:gsub("%-", "")
					if Negative then
						Filtered = "-" .. Filtered
					end

					local FirstDot = Filtered:find("%.")
					if FirstDot then
						local IntegerPart = Filtered:sub(1, FirstDot)
						local DecimalPart = Filtered:sub(FirstDot + 1):gsub("%.", "")
						Filtered = IntegerPart .. DecimalPart
					end

					if Filtered ~= Text then
						Self.Box.Text = Filtered
					end
				end)
			end,
		})

		return Self
	end

	function AdaptiveInput.Get(Self)
		return Self.Box.Text
	end

	function AdaptiveInput.Set(Self, Value)
		Self.Box.Text = tostring(Value)
		Self.Value = Self.Box.Text
	end

	return AdaptiveInput
end
