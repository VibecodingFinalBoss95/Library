return function(Theme, Utility)
	local UserInputService = game:GetService("UserInputService")

	local DualSlider = {}
	DualSlider.__index = DualSlider

	local function Ratio(Value, Min, Max)
		return (Value - Min) / (Max - Min)
	end

	function DualSlider.new(Parent, Config)
		Config = Config or {}
		local Self = setmetatable({}, DualSlider)

		Self.Min = Config.Min or 0
		Self.Max = Config.Max or 100
		Self.Decimals = Config.Decimals or 0
		Self.Low = Config.DefaultLow or Self.Min
		Self.High = Config.DefaultHigh or Self.Max
		Self.Callback = Config.Callback or function() end

		Utility.Build({
			function()
				Self.Frame = Utility.Create("Frame", {
					Size = UDim2.new(1, 0, 0, 40),
					BackgroundTransparency = 1,
					Parent = Parent.Container,
				})
				Utility.Create("TextLabel", {
					Text = Config.Text or "Range",
					Font = Theme.Font,
					TextSize = 13,
					TextColor3 = Theme.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -110, 0, 16),
					Parent = Self.Frame,
				})
				Self.ValueLabel = Utility.Create("TextLabel", {
					Text = tostring(Utility.Round(Self.Low, Self.Decimals)) .. " - " .. tostring(Utility.Round(Self.High, Self.Decimals)),
					Font = Theme.FontMedium,
					TextSize = 13,
					TextColor3 = Theme.Gold,
					TextXAlignment = Enum.TextXAlignment.Right,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 110, 0, 16),
					Position = UDim2.new(1, -110, 0, 0),
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

				local LowRatio = Ratio(Self.Low, Self.Min, Self.Max)
				local HighRatio = Ratio(Self.High, Self.Min, Self.Max)

				Self.Fill = Utility.Create("Frame", {
					BackgroundColor3 = Theme.Accent,
					Position = UDim2.new(LowRatio, 0, 0, 0),
					Size = UDim2.new(HighRatio - LowRatio, 0, 1, 0),
					Parent = Self.Track,
				})
				Utility.AddCorner(Self.Fill, UDim.new(1, 0))

				Self.LowHandle = Utility.Create("Frame", {
					BackgroundColor3 = Theme.Gold,
					Size = UDim2.fromOffset(14, 14),
					Position = UDim2.new(LowRatio, -7, 0.5, -7),
					ZIndex = 2,
					Parent = Self.Track,
				})
				Utility.AddCorner(Self.LowHandle, UDim.new(1, 0))
				Self.LowHandleStroke = Utility.AddStroke(Self.LowHandle, Theme.Background, 2)
				Self.LowHandleScale = Utility.Create("UIScale", {Scale = 1, Parent = Self.LowHandle})

				Self.HighHandle = Utility.Create("Frame", {
					BackgroundColor3 = Theme.Gold,
					Size = UDim2.fromOffset(14, 14),
					Position = UDim2.new(HighRatio, -7, 0.5, -7),
					ZIndex = 2,
					Parent = Self.Track,
				})
				Utility.AddCorner(Self.HighHandle, UDim.new(1, 0))
				Self.HighHandleStroke = Utility.AddStroke(Self.HighHandle, Theme.Background, 2)
				Self.HighHandleScale = Utility.Create("UIScale", {Scale = 1, Parent = Self.HighHandle})
			end,
			function()
				local DraggingLow, DraggingHigh = false, false

				local function Render()
					local LowRatio = Ratio(Self.Low, Self.Min, Self.Max)
					local HighRatio = Ratio(Self.High, Self.Min, Self.Max)
					Self.Fill.Position = UDim2.new(LowRatio, 0, 0, 0)
					Self.Fill.Size = UDim2.new(HighRatio - LowRatio, 0, 1, 0)
					Self.LowHandle.Position = UDim2.new(LowRatio, -7, 0.5, -7)
					Self.HighHandle.Position = UDim2.new(HighRatio, -7, 0.5, -7)
					Self.ValueLabel.Text = tostring(Utility.Round(Self.Low, Self.Decimals)) .. " - " .. tostring(Utility.Round(Self.High, Self.Decimals))
				end

				local function UpdateFromInput(PosX)
					local TrackPos = Self.Track.AbsolutePosition.X
					local TrackSize = Self.Track.AbsoluteSize.X
					local NewRatio = math.clamp((PosX - TrackPos) / TrackSize, 0, 1)
					local NewValue = Utility.Round(Self.Min + (Self.Max - Self.Min) * NewRatio, Self.Decimals)

					if DraggingLow then
						Self.Low = math.min(NewValue, Self.High)
					elseif DraggingHigh then
						Self.High = math.max(NewValue, Self.Low)
					end

					Render()
					Self.Callback(Self.Low, Self.High)
				end

				Self.LowHandle.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1
						or Input.UserInputType == Enum.UserInputType.Touch then
						DraggingLow = true
						Utility.Tween(Self.LowHandleStroke, Theme.TweenFast, {Thickness = 3})
						Utility.Tween(Self.LowHandleScale, Theme.TweenFast, {Scale = 1.12})
					end
				end)

				Self.HighHandle.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1
						or Input.UserInputType == Enum.UserInputType.Touch then
						DraggingHigh = true
						Utility.Tween(Self.HighHandleStroke, Theme.TweenFast, {Thickness = 3})
						Utility.Tween(Self.HighHandleScale, Theme.TweenFast, {Scale = 1.12})
					end
				end)

				UserInputService.InputChanged:Connect(function(Input)
					if (DraggingLow or DraggingHigh) and (Input.UserInputType == Enum.UserInputType.MouseMovement
						or Input.UserInputType == Enum.UserInputType.Touch) then
						UpdateFromInput(Input.Position.X)
					end
				end)

				UserInputService.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1
						or Input.UserInputType == Enum.UserInputType.Touch then
						if DraggingLow then
							Utility.Tween(Self.LowHandleStroke, Theme.TweenFast, {Thickness = 2})
							Utility.Tween(Self.LowHandleScale, Theme.TweenFast, {Scale = 1})
						end
						if DraggingHigh then
							Utility.Tween(Self.HighHandleStroke, Theme.TweenFast, {Thickness = 2})
							Utility.Tween(Self.HighHandleScale, Theme.TweenFast, {Scale = 1})
						end
						DraggingLow = false
						DraggingHigh = false
					end
				end)
			end,
		})

		return Self
	end

	function DualSlider.Set(Self, Low, High)
		Self.Low = math.clamp(Low, Self.Min, Self.Max)
		Self.High = math.clamp(High, Self.Low, Self.Max)

		local LowRatio = Ratio(Self.Low, Self.Min, Self.Max)
		local HighRatio = Ratio(Self.High, Self.Min, Self.Max)

		Utility.Tween(Self.Fill, Theme.TweenFast, {
			Position = UDim2.new(LowRatio, 0, 0, 0),
			Size = UDim2.new(HighRatio - LowRatio, 0, 1, 0),
		})
		Utility.Tween(Self.LowHandle, Theme.TweenFast, {Position = UDim2.new(LowRatio, -7, 0.5, -7)})
		Utility.Tween(Self.HighHandle, Theme.TweenFast, {Position = UDim2.new(HighRatio, -7, 0.5, -7)})
		Self.ValueLabel.Text = tostring(Utility.Round(Self.Low, Self.Decimals)) .. " - " .. tostring(Utility.Round(Self.High, Self.Decimals))

		Self.Callback(Self.Low, Self.High)
	end

	return DualSlider
end
