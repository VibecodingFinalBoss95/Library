return function(Theme, Utility)
	local UserInputService = game:GetService("UserInputService")

	local ColorPicker = {}
	ColorPicker.__index = ColorPicker

	local function BuildHueKeypoints(Index, Keypoints)
		Keypoints = Keypoints or {}
		if Index > 10 then
			return Keypoints
		end
		local Hue = Index / 10
		table.insert(Keypoints, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)))
		return BuildHueKeypoints(Index + 1, Keypoints)
	end

	function ColorPicker.new(Parent, Config)
		Config = Config or {}
		local Self = setmetatable({}, ColorPicker)

		local Default = Config.Default or Color3.fromRGB(31, 122, 84)
		local Hue, Sat, Val = Default:ToHSV()
		Self.Hue, Self.Sat, Self.Val = Hue, Sat, Val
		Self.Callback = Config.Callback or function() end
		Self.Open = false

		Utility.Build({
			function()
				Self.Frame = Utility.Create("Frame", {
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					Parent = Parent.Container,
				})
				Utility.Create("UIListLayout", {
					Padding = UDim.new(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Self.Frame,
				})
			end,
			function()
				Self.Head = Utility.Create("TextButton", {
					Text = "",
					AutoButtonColor = false,
					BackgroundColor3 = Theme.Elevated,
					Size = UDim2.new(1, 0, 0, 32),
					LayoutOrder = 1,
					Parent = Self.Frame,
				})
				Utility.AddCorner(Self.Head, Theme.CornerRadiusSmall)
				Utility.AddStroke(Self.Head, Theme.Border, 1)
				Self.Head.MouseEnter:Connect(function()
					Utility.Tween(Self.Head, Theme.TweenFast, {BackgroundColor3 = Theme.ElevatedHover})
				end)
				Self.Head.MouseLeave:Connect(function()
					Utility.Tween(Self.Head, Theme.TweenFast, {BackgroundColor3 = Theme.Elevated})
				end)

				Utility.Create("TextLabel", {
					Text = Config.Text or "Color",
					Font = Theme.Font,
					TextSize = 13,
					TextColor3 = Theme.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -50, 1, 0),
					Position = UDim2.new(0, 12, 0, 0),
					Parent = Self.Head,
				})

				Self.Swatch = Utility.Create("Frame", {
					BackgroundColor3 = Default,
					Size = UDim2.fromOffset(24, 24),
					Position = UDim2.new(1, -36, 0.5, -12),
					Parent = Self.Head,
				})
				Utility.AddCorner(Self.Swatch, Theme.CornerRadiusSmall)
				Utility.AddStroke(Self.Swatch, Theme.Border, 1)
			end,
			function()
				Self.Panel = Utility.Create("Frame", {
					BackgroundColor3 = Theme.Elevated,
					Size = UDim2.new(1, 0, 0, 0),
					ClipsDescendants = true,
					LayoutOrder = 2,
					Parent = Self.Frame,
				})
				Utility.AddCorner(Self.Panel, Theme.CornerRadiusSmall)
				Utility.AddStroke(Self.Panel, Theme.Border, 1)

				Self.Inner = Utility.Create("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -24, 0, 150),
					Position = UDim2.new(0, 12, 0, 12),
					Parent = Self.Panel,
				})
			end,
			function()
				Self.SVBox = Utility.Create("Frame", {
					BackgroundColor3 = Color3.fromHSV(Self.Hue, 1, 1),
					Size = UDim2.new(1, 0, 0, 100),
					Parent = Self.Inner,
				})
				Utility.AddCorner(Self.SVBox, Theme.CornerRadiusSmall)

				local WhiteOverlay = Utility.Create("Frame", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					Size = UDim2.new(1, 0, 1, 0),
					Parent = Self.SVBox,
				})
				Utility.AddCorner(WhiteOverlay, Theme.CornerRadiusSmall)
				Utility.Create("UIGradient", {
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1),
					}),
					Parent = WhiteOverlay,
				})

				local BlackOverlay = Utility.Create("Frame", {
					BackgroundColor3 = Color3.new(0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					Parent = Self.SVBox,
				})
				Utility.AddCorner(BlackOverlay, Theme.CornerRadiusSmall)
				Utility.Create("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0),
					}),
					Parent = BlackOverlay,
				})

				Self.SVCursor = Utility.Create("Frame", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					Size = UDim2.fromOffset(10, 10),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(Self.Sat, 0, 1 - Self.Val, 0),
					ZIndex = 3,
					Parent = Self.SVBox,
				})
				Utility.AddCorner(Self.SVCursor, UDim.new(1, 0))
				Utility.AddStroke(Self.SVCursor, Theme.Background, 2)
			end,
			function()
				Self.HueBar = Utility.Create("Frame", {
					Size = UDim2.new(1, 0, 0, 14),
					Position = UDim2.new(0, 0, 0, 116),
					Parent = Self.Inner,
				})
				Utility.AddCorner(Self.HueBar, UDim.new(1, 0))
				Utility.Create("UIGradient", {
					Color = ColorSequence.new(BuildHueKeypoints(0)),
					Parent = Self.HueBar,
				})

				Self.HueCursor = Utility.Create("Frame", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					Size = UDim2.fromOffset(6, 18),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(Self.Hue, 0, 0.5, 0),
					ZIndex = 3,
					Parent = Self.HueBar,
				})
				Utility.AddCorner(Self.HueCursor, Theme.CornerRadiusSmall)
				Utility.AddStroke(Self.HueCursor, Theme.Background, 2)
			end,
			function()
				local DraggingSV, DraggingHue = false, false

				local function UpdateSV(Pos)
					local BoxPos, BoxSize = Self.SVBox.AbsolutePosition, Self.SVBox.AbsoluteSize
					local RelX = math.clamp((Pos.X - BoxPos.X) / BoxSize.X, 0, 1)
					local RelY = math.clamp((Pos.Y - BoxPos.Y) / BoxSize.Y, 0, 1)
					Self.Sat = RelX
					Self.Val = 1 - RelY
					Self.SVCursor.Position = UDim2.new(RelX, 0, RelY, 0)
					Self:Apply()
				end

				local function UpdateHue(Pos)
					local BarPos, BarSize = Self.HueBar.AbsolutePosition, Self.HueBar.AbsoluteSize
					local RelX = math.clamp((Pos.X - BarPos.X) / BarSize.X, 0, 1)
					Self.Hue = RelX
					Self.HueCursor.Position = UDim2.new(RelX, 0, 0.5, 0)
					Self.SVBox.BackgroundColor3 = Color3.fromHSV(Self.Hue, 1, 1)
					Self:Apply()
				end

				Self.SVBox.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1
						or Input.UserInputType == Enum.UserInputType.Touch then
						DraggingSV = true
						UpdateSV(Input.Position)
					end
				end)

				Self.HueBar.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1
						or Input.UserInputType == Enum.UserInputType.Touch then
						DraggingHue = true
						UpdateHue(Input.Position)
					end
				end)

				UserInputService.InputChanged:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseMovement
						or Input.UserInputType == Enum.UserInputType.Touch then
						if DraggingSV then
							UpdateSV(Input.Position)
						elseif DraggingHue then
							UpdateHue(Input.Position)
						end
					end
				end)

				UserInputService.InputEnded:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1
						or Input.UserInputType == Enum.UserInputType.Touch then
						DraggingSV = false
						DraggingHue = false
					end
				end)

				Self.Head.MouseButton1Click:Connect(function()
					Self:Toggle()
				end)
			end,
		})

		return Self
	end

	function ColorPicker.Apply(Self)
		local NewColor = Color3.fromHSV(Self.Hue, Self.Sat, Self.Val)
		Self.Swatch.BackgroundColor3 = NewColor
		Self.Callback(NewColor)
	end

	function ColorPicker.Toggle(Self)
		Self.Open = not Self.Open
		Utility.Tween(Self.Panel, Theme.TweenMedium, {
			Size = UDim2.new(1, 0, 0, Self.Open and 174 or 0),
		})
	end

	return ColorPicker
end
