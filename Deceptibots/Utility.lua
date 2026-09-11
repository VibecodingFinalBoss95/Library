return function(Theme)
	local TweenService = game:GetService("TweenService")

	local Utility = {}

	local function AssignProps(Object, Props, Key)
		local NextKey, NextValue = next(Props, Key)
		if NextKey == nil then
			return
		end
		Object[NextKey] = NextValue
		AssignProps(Object, Props, NextKey)
	end

	function Utility.Create(ClassName, Props)
		local Object = Instance.new(ClassName)
		AssignProps(Object, Props or {}, nil)
		return Object
	end

	function Utility.AddCorner(Target, Radius)
		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = Radius or Theme.CornerRadius
		Corner.Parent = Target
		return Corner
	end

	function Utility.AddStroke(Target, Color, Thickness, Transparency)
		local Stroke = Instance.new("UIStroke")
		Stroke.Color = Color or Theme.Border
		Stroke.Thickness = Thickness or 1
		Stroke.Transparency = Transparency or 0
		Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		Stroke.Parent = Target
		return Stroke
	end

	local function AddShadowLayer(Holder, Radius, Index)
		if Index > 4 then
			return
		end
		local Pad = Index * 3
		local Layer = Instance.new("Frame")
		Layer.BackgroundColor3 = Color3.new(0, 0, 0)
		Layer.BackgroundTransparency = 0.88 + (Index * 0.02)
		Layer.BorderSizePixel = 0
		Layer.Size = UDim2.new(1, -Pad * 2, 1, -Pad * 2)
		Layer.Position = UDim2.new(0, Pad, 0, Pad + 2)
		Layer.ZIndex = Holder.ZIndex
		Utility.AddCorner(Layer, Radius)
		Layer.Parent = Holder
		AddShadowLayer(Holder, Radius, Index + 1)
	end

	function Utility.AddShadow(Target, Radius)
		local Holder = Instance.new("Frame")
		Holder.Name = "Shadow"
		Holder.BackgroundTransparency = 1
		Holder.Size = UDim2.new(1, 24, 1, 24)
		Holder.Position = UDim2.new(0, -12, 0, -12)
		Holder.ZIndex = math.max(Target.ZIndex - 1, 0)
		Holder.Parent = Target
		AddShadowLayer(Holder, Radius or Theme.CornerRadius, 1)
		return Holder
	end

	function Utility.Tween(Target, Info, Props)
		local Tween = TweenService:Create(Target, Info, Props)
		Tween:Play()
		return Tween
	end

	function Utility.AddPressScale(Target, PressedScale, RestScale)
		RestScale = RestScale or 1
		local Scale = Utility.Create("UIScale", {
			Scale = RestScale,
			Parent = Target,
		})

		Target.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch then
				Utility.Tween(Scale, Theme.TweenFast, {Scale = PressedScale})
			end
		end)

		Target.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch then
				Utility.Tween(Scale, Theme.TweenFast, {Scale = RestScale})
			end
		end)

		return Scale
	end

	function Utility.MakeDraggable(Frame, Handle)
		Handle = Handle or Frame
		local Dragging = false
		local DragStart, StartPos

		Handle.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				DragStart = Input.Position
				StartPos = Frame.Position

				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)

		Handle.InputChanged:Connect(function(Input)
			if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement
				or Input.UserInputType == Enum.UserInputType.Touch) then
				local Delta = Input.Position - DragStart
				Frame.Position = UDim2.new(
					StartPos.X.Scale, StartPos.X.Offset + Delta.X,
					StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
				)
			end
		end)
	end

	function Utility.Round(Number, Decimals)
		local Mult = 10 ^ (Decimals or 0)
		return math.floor(Number * Mult + 0.5) / Mult
	end

	function Utility.Build(Steps, Index)
		Index = Index or 1
		local Step = Steps[Index]
		if Step == nil then
			return
		end
		Step()
		task.wait()
		Utility.Build(Steps, Index + 1)
	end

	return Utility
end
