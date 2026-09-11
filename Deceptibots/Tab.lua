return function(Theme, Utility, SectionModule)
	local Tab = {}
	Tab.__index = Tab

	function Tab.new(Window, Name)
		local Self = setmetatable({}, Tab)
		Self.Window = Window
		Self.Name = Name
		Self.Sections = {}
		Self.Active = false

		Utility.Build({
			function()
				Self.Button = Utility.Create("TextButton", {
					Name = Name .. "TabButton",
					Text = "",
					AutoButtonColor = false,
					BackgroundColor3 = Theme.Elevated,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 32),
					Parent = Window.TabBar,
				})
				Utility.AddCorner(Self.Button, Theme.CornerRadiusSmall)
				Utility.AddPressScale(Self.Button, 0.985)

				Self.Indicator = Utility.Create("Frame", {
					Name = "Indicator",
					BackgroundColor3 = Theme.Gold,
					BorderSizePixel = 0,
					AnchorPoint = Vector2.new(0, 0.5),
					Size = UDim2.new(0, 3, 0, 0),
					Position = UDim2.new(0, 0, 0.5, 0),
					Parent = Self.Button,
				})
				Utility.AddCorner(Self.Indicator, UDim.new(1, 0))

				Utility.Create("TextLabel", {
					Name = "Label",
					Text = Name,
					Font = Theme.FontMedium,
					TextSize = 13,
					TextColor3 = Theme.TextMuted,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -16, 1, 0),
					Position = UDim2.new(0, 14, 0, 0),
					Parent = Self.Button,
				})
			end,
			function()
				Self.Page = Utility.Create("ScrollingFrame", {
					Name = Name .. "Page",
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					CanvasSize = UDim2.new(0, 0, 0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarThickness = 3,
					ScrollBarImageColor3 = Theme.Gold,
					ScrollBarImageTransparency = 0.4,
					Visible = false,
					Parent = Window.ContentArea,
				})
				Utility.Create("UIListLayout", {
					Padding = UDim.new(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Self.Page,
				})
				Utility.Create("UIPadding", {
					PaddingTop = UDim.new(0, 14),
					PaddingBottom = UDim.new(0, 14),
					PaddingLeft = UDim.new(0, 14),
					PaddingRight = UDim.new(0, 14),
					Parent = Self.Page,
				})
			end,
			function()
				Self.Button.MouseButton1Click:Connect(function()
					Self:Select()
				end)
				Self.Button.MouseEnter:Connect(function()
					if not Self.Active then
						Utility.Tween(Self.Button, Theme.TweenFast, {BackgroundTransparency = 0.7})
					end
				end)
				Self.Button.MouseLeave:Connect(function()
					if not Self.Active then
						Utility.Tween(Self.Button, Theme.TweenFast, {BackgroundTransparency = 1})
					end
				end)
			end,
		})

		return Self
	end

	local function DeselectAll(Tabs, Index)
		local OtherTab = Tabs[Index]
		if OtherTab == nil then
			return
		end
		OtherTab.Active = false
		OtherTab.Page.Visible = false
		Utility.Tween(OtherTab.Button, Theme.TweenFast, {BackgroundTransparency = 1})
		Utility.Tween(OtherTab.Indicator, Theme.TweenFast, {Size = UDim2.new(0, 3, 0, 0)})
		Utility.Tween(OtherTab.Button.Label, Theme.TweenFast, {TextColor3 = Theme.TextMuted})
		DeselectAll(Tabs, Index + 1)
	end

	function Tab.Select(Self)
		DeselectAll(Self.Window.Tabs, 1)

		Self.Active = true
		Self.Page.Visible = true
		Utility.Tween(Self.Button, Theme.TweenFast, {BackgroundTransparency = 0.85})
		Utility.Tween(Self.Indicator, Theme.TweenFast, {Size = UDim2.new(0, 3, 0, 18)})
		Utility.Tween(Self.Button.Label, Theme.TweenFast, {TextColor3 = Theme.Text})
	end

	function Tab.CreateSection(Self, Title)
		local NewSection = SectionModule.new(Self, Title)
		table.insert(Self.Sections, NewSection)
		return NewSection
	end

	return Tab
end
