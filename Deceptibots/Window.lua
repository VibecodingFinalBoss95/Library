return function(Theme, Utility, TabModule)
	local Players = game:GetService("Players")

	local Window = {}
	Window.__index = Window

	local function ComputeScale(ViewportSize)
		local WidthScale = ViewportSize.X / Theme.ReferenceWidth
		local HeightScale = ViewportSize.Y / Theme.ReferenceHeight
		return math.clamp(math.min(WidthScale, HeightScale), Theme.MinScale, Theme.MaxScale)
	end

	function Window.new(Config)
		Config = Config or {}
		local Self = setmetatable({}, Window)

		Self.Title = Config.Title or "Window"
		Self.Size = Config.Size or UDim2.fromOffset(560, 380)
		Self.Tabs = {}

		local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

		Utility.Build({
			function()
				Self.ScreenGui = Utility.Create("ScreenGui", {
					Name = "Deceptibots_" .. Self.Title:gsub("%s+", ""),
					ResetOnSpawn = false,
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					Parent = PlayerGui,
				})
			end,
			function()
				Self.Root = Utility.Create("Frame", {
					Name = "Root",
					Size = Self.Size,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					BackgroundColor3 = Theme.Background,
					BorderSizePixel = 0,
					Parent = Self.ScreenGui,
				})
				Utility.AddCorner(Self.Root, Theme.CornerRadiusLarge)
				Utility.AddStroke(Self.Root, Theme.Border, 1)
				Utility.AddShadow(Self.Root, Theme.CornerRadiusLarge)

				Self.Scale = Utility.Create("UIScale", {
					Scale = 1,
					Parent = Self.Root,
				})
			end,
			function()
				Self.TitleBar = Utility.Create("Frame", {
					Name = "TitleBar",
					Size = UDim2.new(1, 0, 0, 40),
					BackgroundColor3 = Theme.Surface,
					BorderSizePixel = 0,
					Parent = Self.Root,
				})
				Utility.AddCorner(Self.TitleBar, Theme.CornerRadiusLarge)

				Utility.Create("Frame", {
					Size = UDim2.new(1, 0, 0, 10),
					Position = UDim2.new(0, 0, 1, -10),
					BackgroundColor3 = Theme.Surface,
					BorderSizePixel = 0,
					Parent = Self.TitleBar,
				})

				Utility.Create("Frame", {
					Name = "AccentLine",
					Size = UDim2.new(1, 0, 0, 2),
					Position = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = Theme.Gold,
					BorderSizePixel = 0,
					Parent = Self.TitleBar,
				})

				Utility.Create("TextLabel", {
					Text = Self.Title,
					Font = Theme.FontBold,
					TextSize = 15,
					TextColor3 = Theme.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -80, 1, 0),
					Position = UDim2.new(0, 16, 0, 0),
					Parent = Self.TitleBar,
				})
			end,
			function()
				local CloseButton = Utility.Create("TextButton", {
					Name = "Close",
					Text = "X",
					Font = Theme.FontBold,
					TextSize = 18,
					TextColor3 = Theme.TextMuted,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(32, 32),
					Position = UDim2.new(1, -36, 0.5, -16),
					Parent = Self.TitleBar,
				})
				CloseButton.MouseButton1Click:Connect(function()
					Self.ScreenGui.Enabled = false
				end)
				CloseButton.MouseEnter:Connect(function()
					Utility.Tween(CloseButton, Theme.TweenFast, {TextColor3 = Theme.Danger})
				end)
				CloseButton.MouseLeave:Connect(function()
					Utility.Tween(CloseButton, Theme.TweenFast, {TextColor3 = Theme.TextMuted})
				end)
				Utility.MakeDraggable(Self.Root, Self.TitleBar)
			end,
			function()
				Self.TabBar = Utility.Create("Frame", {
					Name = "TabBar",
					Size = UDim2.new(0, 130, 1, -40),
					Position = UDim2.new(0, 0, 0, 40),
					BackgroundColor3 = Theme.Surface,
					BorderSizePixel = 0,
					Parent = Self.Root,
				})
				Utility.Create("UIListLayout", {
					Padding = UDim.new(0, 2),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Self.TabBar,
				})
				Utility.Create("UIPadding", {
					PaddingTop = UDim.new(0, 10),
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
					Parent = Self.TabBar,
				})
			end,
			function()
				Self.ContentArea = Utility.Create("Frame", {
					Name = "ContentArea",
					Size = UDim2.new(1, -130, 1, -40),
					Position = UDim2.new(0, 130, 0, 40),
					BackgroundTransparency = 1,
					Parent = Self.Root,
				})
			end,
			function()
				local TargetScale = ComputeScale(Self.ScreenGui.AbsoluteSize)
				Self.Scale.Scale = TargetScale * 0.92
				Utility.Tween(Self.Scale, Theme.TweenMedium, {Scale = TargetScale})

				Self.ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					Utility.Tween(Self.Scale, Theme.TweenMedium, {Scale = ComputeScale(Self.ScreenGui.AbsoluteSize)})
				end)
			end,
		})

		return Self
	end

	function Window.CreateTab(Self, Name, Icon)
		local NewTab = TabModule.new(Self, Name, Icon)
		table.insert(Self.Tabs, NewTab)

		if #Self.Tabs == 1 then
			NewTab:Select()
		end

		return NewTab
	end

	function Window.Toggle(Self)
		Self.ScreenGui.Enabled = not Self.ScreenGui.Enabled
	end

	function Window.Destroy(Self)
		Self.ScreenGui:Destroy()
	end

	return Window
end
