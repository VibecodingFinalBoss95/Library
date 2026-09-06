return function(Theme, Utility, Toggle, Button, Dropdown, Slider, AdaptiveInput, ColorPicker)
	local Section = {}
	Section.__index = Section

	function Section.new(Tab, Title)
		local Self = setmetatable({}, Section)
		Self.Tab = Tab

		Utility.Build({
			function()
				Self.Frame = Utility.Create("Frame", {
					Name = "Section",
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundColor3 = Theme.Surface,
					BorderSizePixel = 0,
					Parent = Tab.Page,
				})
				Utility.AddCorner(Self.Frame, Theme.CornerRadius)
				Utility.AddStroke(Self.Frame, Theme.Border, 1)

				if Title then
					Utility.Create("TextLabel", {
						Text = Title:upper(),
						Font = Theme.FontBold,
						TextSize = 11,
						TextColor3 = Theme.Gold,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -28, 0, 16),
						Position = UDim2.new(0, 14, 0, 12),
						Parent = Self.Frame,
					})
				end
			end,
			function()
				Self.Container = Utility.Create("Frame", {
					Name = "Items",
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, -28, 0, 0),
					Position = UDim2.new(0, 14, 0, Title and 34 or 12),
					BackgroundTransparency = 1,
					Parent = Self.Frame,
				})
				Utility.Create("UIListLayout", {
					Padding = UDim.new(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Self.Container,
				})
				Utility.Create("UIPadding", {
					PaddingBottom = UDim.new(0, 14),
					Parent = Self.Container,
				})
			end,
		})

		return Self
	end

	function Section.CreateToggle(Self, Config)
		return Toggle.new(Self, Config)
	end

	function Section.CreateButton(Self, Config)
		return Button.new(Self, Config)
	end

	function Section.CreateDropdown(Self, Config)
		return Dropdown.new(Self, Config)
	end

	function Section.CreateSlider(Self, Config)
		return Slider.new(Self, Config)
	end

	function Section.CreateAdaptiveInput(Self, Config)
		return AdaptiveInput.new(Self, Config)
	end

	function Section.CreateColorPicker(Self, Config)
		return ColorPicker.new(Self, Config)
	end

	return Section
end
