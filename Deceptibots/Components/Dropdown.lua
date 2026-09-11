return function(Theme, Utility)
	local Dropdown = {}
	Dropdown.__index = Dropdown

	function Dropdown.new(Parent, Config)
		Config = Config or {}
		local Self = setmetatable({}, Dropdown)

		Self.Options = Config.Options or {}
		Self.Multi = Config.Multi or false
		Self.Value = Self.Multi and (Config.Default or {}) or (Config.Default or Self.Options[1])
		Self.Callback = Config.Callback or function() end
		Self.Open = false
		Self.OptionButtons = {}

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
				Utility.AddPressScale(Self.Head, 0.985)
				Self.Head.MouseEnter:Connect(function()
					Utility.Tween(Self.Head, Theme.TweenFast, {BackgroundColor3 = Theme.ElevatedHover})
				end)
				Self.Head.MouseLeave:Connect(function()
					Utility.Tween(Self.Head, Theme.TweenFast, {BackgroundColor3 = Theme.Elevated})
				end)

				Self.SelectedLabel = Utility.Create("TextLabel", {
					Text = (not Self.Multi and Self.Value) and tostring(Self.Value) or "Select...",
					Font = Theme.Font,
					TextSize = 13,
					TextColor3 = (not Self.Multi and Self.Value) and Theme.Text or Theme.TextMuted,
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
				Self.List = Utility.Create("CanvasGroup", {
					Name = "List",
					BackgroundColor3 = Theme.Elevated,
					Size = UDim2.new(1, 0, 0, 0),
					GroupTransparency = 1,
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

	local function Contains(List, Value, Index)
		Index = Index or 1
		local Item = List[Index]
		if Item == nil then
			return false
		end
		if Item == Value then
			return true
		end
		return Contains(List, Value, Index + 1)
	end

	local function RemoveValue(List, Value, Index, Result)
		Index = Index or 1
		Result = Result or {}
		local Item = List[Index]
		if Item == nil then
			return Result
		end
		if Item ~= Value then
			table.insert(Result, Item)
		end
		return RemoveValue(List, Value, Index + 1, Result)
	end

	function Dropdown.Refresh(Self)
		DestroyOld(Self.List:GetChildren(), 1)
		Self.OptionButtons = {}

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

			Self.OptionButtons[Index] = OptionButton

			OptionButton.MouseEnter:Connect(function()
				if not (Self.Multi and Contains(Self.Value, Option)) then
					Utility.Tween(OptionButton, Theme.TweenFast, {BackgroundColor3 = Theme.ElevatedHover})
				end
			end)
			OptionButton.MouseLeave:Connect(function()
				if not (Self.Multi and Contains(Self.Value, Option)) then
					Utility.Tween(OptionButton, Theme.TweenFast, {BackgroundColor3 = Theme.Elevated})
				end
			end)
			OptionButton.MouseButton1Click:Connect(function()
				Self:Set(Option)
				if not Self.Multi then
					Self:Toggle()
				end
			end)

			BuildOption(Index + 1)
		end
		BuildOption(1)

		Self:Paint()
	end

	function Dropdown.Paint(Self)
		local function PaintOption(Index)
			local OptionButton = Self.OptionButtons[Index]
			if OptionButton == nil then
				return
			end
			local IsSelected = Self.Multi and Contains(Self.Value, Self.Options[Index])
			Utility.Tween(OptionButton, Theme.TweenFast, {
				BackgroundColor3 = IsSelected and Theme.AccentMuted or Theme.Elevated,
			})
			PaintOption(Index + 1)
		end
		PaintOption(1)

		if not Self.Multi then
			return
		end

		local function CountSelected(Index, Count)
			Count = Count or 0
			if Self.Value[Index] == nil then
				return Count
			end
			return CountSelected(Index + 1, Count + 1)
		end
		local Count = CountSelected(1)

		if Count == 0 then
			Self.SelectedLabel.Text = "Select..."
			Self.SelectedLabel.TextColor3 = Theme.TextMuted
		elseif Count == 1 then
			Self.SelectedLabel.Text = tostring(Self.Value[1])
			Self.SelectedLabel.TextColor3 = Theme.Text
		else
			Self.SelectedLabel.Text = Count .. " Selected"
			Self.SelectedLabel.TextColor3 = Theme.Text
		end
	end

	function Dropdown.Toggle(Self)
		Self.Open = not Self.Open
		local TargetHeight = Self.Open and (#Self.Options * 30) or 0
		Utility.Tween(Self.List, Theme.TweenMedium, {
			Size = UDim2.new(1, 0, 0, TargetHeight),
			GroupTransparency = Self.Open and 0 or 1,
		})
		Utility.Tween(Self.Chevron, Theme.TweenFast, {Rotation = Self.Open and 180 or 0})
	end

	function Dropdown.Set(Self, Option)
		if Self.Multi then
			if Contains(Self.Value, Option) then
				Self.Value = RemoveValue(Self.Value, Option)
			else
				table.insert(Self.Value, Option)
			end
			Self:Paint()
			Self.Callback(Self.Value)
		else
			Self.Value = Option
			Self.SelectedLabel.Text = tostring(Option)
			Utility.Tween(Self.SelectedLabel, Theme.TweenFast, {TextColor3 = Theme.Text})
			Self.Callback(Option)
		end
	end

	return Dropdown
end
