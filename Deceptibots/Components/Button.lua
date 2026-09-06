return function(Theme, Utility)
	local Button = {}
	Button.__index = Button

	function Button.new(Parent, Config)
		Config = Config or {}
		local Self = setmetatable({}, Button)
		Self.Callback = Config.Callback or function() end

		Utility.Build({
			function()
				Self.Instance = Utility.Create("TextButton", {
					Text = Config.Text or "Button",
					Font = Theme.FontMedium,
					TextSize = 13,
					TextColor3 = Theme.Text,
					AutoButtonColor = false,
					BackgroundColor3 = Theme.Elevated,
					Size = UDim2.new(1, 0, 0, 32),
					Parent = Parent.Container,
				})
				Utility.AddCorner(Self.Instance, Theme.CornerRadiusSmall)
				Utility.AddStroke(Self.Instance, Theme.Border, 1)
			end,
			function()
				Self.Instance.MouseEnter:Connect(function()
					Utility.Tween(Self.Instance, Theme.TweenFast, {BackgroundColor3 = Theme.ElevatedHover})
				end)
				Self.Instance.MouseLeave:Connect(function()
					Utility.Tween(Self.Instance, Theme.TweenFast, {BackgroundColor3 = Theme.Elevated})
				end)
				Self.Instance.MouseButton1Down:Connect(function()
					Utility.Tween(Self.Instance, Theme.TweenFast, {BackgroundColor3 = Theme.AccentMuted})
				end)
				Self.Instance.MouseButton1Up:Connect(function()
					Utility.Tween(Self.Instance, Theme.TweenFast, {BackgroundColor3 = Theme.ElevatedHover})
				end)
				Self.Instance.MouseButton1Click:Connect(function()
					Self.Callback()
				end)
			end,
		})

		return Self
	end

	return Button
end
