return function(Theme, Utility)
	local UserInputService = game:GetService("UserInputService")

	local Slider = {}
	Slider.__index = Slider

	function Slider.new(Parent, Config)
		Config = Config or {}
		local Self = setmetatable({}, Slider)

		Self.Min = Config.Min or 0
		Self.Max = Config.Max or 100
		Self.Decimals = Config.Decimals or 0
		Self.Value = Config.Default or Self.Min
		Self.Callback = Config.Callback or function() end

		Utility.Build({
			function()
				Self.Frame = Utility.Create("Frame", {
					Size = UDim2.new(1, 0, 0, 40),
					BackgroundTransparency = 1,
					Parent = Parent.Container,
				})
				Utility.Create("TextLabel", {
					Text = Config.Text or "Slider",
					Font = Theme.Font,
					TextSize = 13,
					TextColor3 = Theme.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -60, 0, 16),
					Parent = Self.Frame,
				})
				Self.ValueLabel = Utility.Create("TextLabel", {
					Text = tostring(Utility.Round(Self.Value, Self.Decimals)),
					Font = Theme.FontMedium,
					TextSize = 13,
					TextColor3 = Theme.Gold,
					TextXAlignment = Enum.TextXAlignment.Right,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 60, 0, 16),
					Position = UDim2.new(1, -60, 0, 0),
					Parent = Self.Frame,
				})
			end,
			function()
				Self.Track = Utility.Create("Frame", {
					BackgroundColor3 = Theme.Elevated,
					Size = UDim2.new(1, 0, 0, 6),
					Position = UDim2.new(0, 0, 0, 26),
					Parent = Self.Frame,
				})
				Utility.AddCorner(Self.Track, UDim.new(1, 0))

				local Ratio = (Self.Value - Self.Min) / (Self.Max - Self.Min)
				Self.Fill = Utility.Create("Frame", {
					BackgroundColor3 = Theme.Accent,
					Size = UDim2.new(Ratio, 0, 1, 0),
					Parent = Self.Track,
				})
				Utility.AddCorner(Self.Fill, UDim.new(1, 0))

				Self.Handle = Utility.Create("Frame", {
					BackgroundColor3 = Theme.Gold,
					Size = UDim2.fromOffset(14, 14),
					Position = UDim2.new(Ratio, -7, 0.5, -7),
					ZIndex = 2,
					Parent = Self.Track,
				})
				Utility.AddCorner(Self.Handle, UDim.new(1, 0))
				Utility.AddStroke(Self.Handle, Theme.Background, 2)
			end,
			function()
				local Dragging = false

				local function UpdateFromInput(PosX)
					local TrackPos = Self.Track.AbsolutePosition.X
					local TrackSize = Self.Track.AbsoluteSize.X
					local Relative = math.clamp((PosX - TrackPos) / TrackSize, 0, 1)
					local NewValue = Self.Min + (Self.Max - Self.Min) * Relative
					Self:Set(Utility.Round(NewValue, Self.Decimals))
				end

				Self.Track.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1
						or Input.UserInputType == Enum.UserInputType.Touch then
						Dragging = true
						UpdateFromInput(Input.Position.X)
					end
				end)

				UserInputService.InputChanged:Connect(function(Input)
					if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement
						or Input.UserInputType == Enum.UserInputType.Touch) then
						UpdateFromInput(Input.Position.X)
					end
				end)

				UserInputService.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1
						or Input.UserInputType == Enum.UserInputType.Touch then
						Dragging = false
					end
				end)
			end,
		})

		return Self
	end

	function Slider.Set(Self, Value)
		Value = math.clamp(Value, Self.Min, Self.Max)
		Self.Value = Value

		local Ratio = (Value - Self.Min) / (Self.Max - Self.Min)
		Self.Fill.Size = UDim2.new(Ratio, 0, 1, 0)
		Self.Handle.Position = UDim2.new(Ratio, -7, 0.5, -7)
		Self.ValueLabel.Text = tostring(Utility.Round(Value, Self.Decimals))

		Self.Callback(Value)
	end

	return Slider
end
