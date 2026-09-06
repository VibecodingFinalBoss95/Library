return function(Theme, Utility)
	local Dropdown = {}
	Dropdown.__index = Dropdown

	function Dropdown.new(Parent, Config)
		Config = Config or {}
		local Self = setmetatable({}, Dropdown)

		Self.Options = Config.Options or {}
		Self.Value = Config.Default or Self.Options[1]
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
					Padding = UDim.new(0, 6),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Self.Frame,
				})
				Utility.Create("TextLabel", {
					Text = Config.Text or "Dropdown",
					Font = Theme.Font,
					TextSize = 13,
					TextColor3 = Theme.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 16),
					LayoutOrder = 1,
					Parent = Self.Frame,
				})
			end,
			function()
				Self.Head = Utility.Create("TextButton", {
					Text = "",
					AutoButtonColor = false,
					BackgroundColor3 = Theme.Elevated,
					Size = UDim2.new(1, 0, 0, 32),
					LayoutOrder = 2,
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

				Self.SelectedLabel = Utility.Create("TextLabel", {
					Text = Self.Value and tostring(Self.Value) or "Select...",
					Font = Theme.Font,
					TextSize = 13,
					TextColor3 = Self.Value and Theme.Text or Theme.TextMuted,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -34, 1, 0),
					Position = UDim2.new(0, 12, 0, 0),
					Parent = Self.Head,
				})

				Self.Chevron = Utility.Create("TextLabel", {
					Text = "v",
					Font = Theme.FontBold,
					TextSize = 13,
					TextColor3 = Theme.Gold,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(24, 24),
					Position = UDim2.new(1, -30, 0.5, -12),
					Parent = Self.Head,
				})
			end,
			function()
				Self.List = Utility.Create("Frame", {
					Name = "List",
					BackgroundColor3 = Theme.Elevated,
					Size = UDim2.new(1, 0, 0, 0),
					ClipsDescendants = true,
					LayoutOrder = 3,
					Parent = Self.Frame,
				})
				Utility.AddCorner(Self.List, Theme.CornerRadiusSmall)
				Utility.Create("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Self.List,
				})

				Self:Refresh()

				Self.Head.MouseButton1Click:Connect(function()
					Self:Toggle()
				end)
			end,
		})

		return Self
	end

	local function DestroyOld(Children, Index)
		local Child = Children[Index]
		if Child == nil then
			return
		end
		if Child:IsA("TextButton") then
			Child:Destroy()
		end
		DestroyOld(Children, Index + 1)
	end

	function Dropdown.Refresh(Self)
		DestroyOld(Self.List:GetChildren(), 1)

		local function BuildOption(Index)
			local Option = Self.Options[Index]
			if Option == nil then
				return
			end

			local OptionButton = Utility.Create("TextButton", {
				Text = "",
				AutoButtonColor = false,
				BackgroundColor3 = Theme.Elevated,
				Size = UDim2.new(1, 0, 0, 30),
				LayoutOrder = Index,
				Parent = Self.List,
			})
			Utility.Create("TextLabel", {
				Text = tostring(Option),
				Font = Theme.Font,
				TextSize = 13,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -12, 1, 0),
				Position = UDim2.new(0, 12, 0, 0),
				Parent = OptionButton,
			})

			OptionButton.MouseEnter:Connect(function()
				Utility.Tween(OptionButton, Theme.TweenFast, {BackgroundColor3 = Theme.ElevatedHover})
			end)
			OptionButton.MouseLeave:Connect(function()
				Utility.Tween(OptionButton, Theme.TweenFast, {BackgroundColor3 = Theme.Elevated})
			end)
			OptionButton.MouseButton1Click:Connect(function()
				Self:Set(Option)
				Self:Toggle()
			end)

			BuildOption(Index + 1)
		end
		BuildOption(1)
	end

	function Dropdown.Toggle(Self)
		Self.Open = not Self.Open
		local TargetHeight = Self.Open and (#Self.Options * 30) or 0
		Utility.Tween(Self.List, Theme.TweenMedium, {Size = UDim2.new(1, 0, 0, TargetHeight)})
		Utility.Tween(Self.Chevron, Theme.TweenFast, {Rotation = Self.Open and 180 or 0})
	end

	function Dropdown.Set(Self, Value)
		Self.Value = Value
		Self.SelectedLabel.Text = tostring(Value)
		Self.SelectedLabel.TextColor3 = Theme.Text
		Self.Callback(Value)
	end

	return Dropdown
end
