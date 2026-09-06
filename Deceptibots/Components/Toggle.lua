return function(Theme, Utility)
	local Toggle = {}
	Toggle.__index = Toggle

	function Toggle.new(Parent, Config)
		Config = Config or {}
		local Self = setmetatable({}, Toggle)

		Self.Value = Config.Default or false
		Self.Callback = Config.Callback or function() end

		Utility.Build({
			function()
				Self.Frame = Utility.Create("Frame", {
					Size = UDim2.new(1, 0, 0, 28),
					BackgroundTransparency = 1,
					Parent = Parent.Container,
				})
				Utility.Create("TextLabel", {
					Text = Config.Text or "Toggle",
					Font = Theme.Font,
					TextSize = 13,
					TextColor3 = Theme.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -50, 1, 0),
					Parent = Self.Frame,
				})
			end,
			function()
				Self.Track = Utility.Create("TextButton", {
					Text = "",
					AutoButtonColor = false,
					BackgroundColor3 = Self.Value and Theme.Accent or Theme.Elevated,
					Size = UDim2.fromOffset(38, 20),
					Position = UDim2.new(1, -38, 0.5, -10),
					Parent = Self.Frame,
				})
				Utility.AddCorner(Self.Track, UDim.new(1, 0))
				Utility.AddStroke(Self.Track, Theme.Border, 1)

				Self.Knob = Utility.Create("Frame", {
					BackgroundColor3 = Theme.Text,
					Size = UDim2.fromOffset(14, 14),
					Position = Self.Value and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
					Parent = Self.Track,
				})
				Utility.AddCorner(Self.Knob, UDim.new(1, 0))

				Self.Track.MouseButton1Click:Connect(function()
					Self:Set(not Self.Value)
				end)
			end,
		})

		return Self
	end

	function Toggle.Set(Self, Value)
		Self.Value = Value
		Self.Callback(Value)

		Utility.Tween(Self.Track, Theme.TweenFast, {
			BackgroundColor3 = Value and Theme.Accent or Theme.Elevated,
		})
		Utility.Tween(Self.Knob, Theme.TweenFast, {
			Position = Value and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
		})
	end

	return Toggle
end
