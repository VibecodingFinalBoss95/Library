return function(Theme, Utility)
	local Paragraph = {}
	Paragraph.__index = Paragraph

	function Paragraph.new(Parent, Config)
		Config = Config or {}
		local Self = setmetatable({}, Paragraph)

		Utility.Build({
			function()
				Self.Frame = Utility.Create("Frame", {
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					BackgroundTransparency = 1,
					Parent = Parent.Container,
				})
				Utility.Create("UIListLayout", {
					Padding = UDim.new(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Self.Frame,
				})
			end,
			function()
				Self.TitleLabel = Utility.Create("TextLabel", {
					Text = Config.Title or "Title",
					Font = Theme.FontBold,
					TextSize = 13,
					TextColor3 = Theme.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					LayoutOrder = 1,
					Parent = Self.Frame,
				})
				Self.BodyLabel = Utility.Create("TextLabel", {
					Text = Config.Body or "",
					Font = Theme.Font,
					TextSize = 12,
					TextColor3 = Theme.TextMuted,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextWrapped = true,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0),
					LayoutOrder = 2,
					Parent = Self.Frame,
				})
			end,
		})

		return Self
	end

	function Paragraph.Set(Self, Title, Body)
		Self.TitleLabel.Text = Title
		Self.BodyLabel.Text = Body
	end

	return Paragraph
end
