-- KaelixHub UI Library
-- Modern UI Library for Roblox Script Hubs

local KaelixLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Configurações padrão
local Config = {
	MainColor = Color3.fromRGB(138, 43, 226), -- Roxo/Purple
	BackgroundColor = Color3.fromRGB(25, 25, 25),
	SecondaryColor = Color3.fromRGB(35, 35, 35),
	TextColor = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.Gotham,
	TweenSpeed = 0.3,
}

-- Função auxiliar para criar tweens
local function Tween(object, properties, duration)
	local tweenInfo = TweenInfo.new(duration or Config.TweenSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(object, tweenInfo, properties)
	tween:Play()
	return tween
end

-- Função para criar cantos arredondados
local function AddCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = parent
	return corner
end

-- Função principal para criar a janela
function KaelixLib:CreateWindow(title)
	title = title or "KaelixHub"

	print("🔧 Criando ScreenGui...")

	-- Colocar no PlayerGui (melhor para testes no Studio)
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer

	-- Aguardar PlayerGui carregar
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

	if not PlayerGui then
		warn("❌ PlayerGui não encontrado!")
		return
	end

	print("🔧 PlayerGui encontrado:", PlayerGui:GetFullName())

	-- REMOVER UIs ANTIGAS (evitar acúmulo)
	-- Verificar no PlayerGui
	local oldUI = PlayerGui:FindFirstChild("KaelixHub")
	if oldUI then
		print("🗑️ Removendo UI antiga do PlayerGui...")
		oldUI:Destroy()
	end

	-- Verificar no CoreGui (para executores)
	local success, CoreGui = pcall(function()
		return game:GetService("CoreGui")
	end)

	if success and CoreGui then
		local oldCoreUI = CoreGui:FindFirstChild("KaelixHub")
		if oldCoreUI then
			print("🗑️ Removendo UI antiga do CoreGui...")
			oldCoreUI:Destroy()
		end
	end

	-- Pequeno delay para garantir que a UI antiga foi destruída
	wait(0.1)

	-- Criar ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "KaelixHub"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Enabled = true -- Garantir que está habilitado

	-- Proteção contra detecção (para executores)
	if syn and syn.protect_gui then
		syn.protect_gui(ScreenGui)
		ScreenGui.Parent = game:GetService("CoreGui")
		print("🎨 UI criada no CoreGui (protegida)")
	elseif gethui then
		ScreenGui.Parent = gethui()
		print("🎨 UI criada no gethui()")
	else
		-- Usar PlayerGui para Studio/testes normais
		ScreenGui.Parent = PlayerGui
		print("🎨 UI criada em:", ScreenGui.Parent:GetFullName())
	end

	wait(0.1) -- Pequeno delay para garantir que o ScreenGui foi adicionado

	-- Frame principal
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 550, 0, 400)
	MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
	MainFrame.BackgroundColor3 = Config.BackgroundColor
	MainFrame.BorderSizePixel = 0
	MainFrame.Active = true
	MainFrame.Draggable = true
	MainFrame.Parent = ScreenGui
	AddCorner(MainFrame, 10)

	-- Sombra
	local Shadow = Instance.new("ImageLabel")
	Shadow.Name = "Shadow"
	Shadow.Size = UDim2.new(1, 30, 1, 30)
	Shadow.Position = UDim2.new(0, -15, 0, -15)
	Shadow.BackgroundTransparency = 1
	Shadow.Image = "rbxassetid://1316045217"
	Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	Shadow.ImageTransparency = 0.7
	Shadow.ScaleType = Enum.ScaleType.Slice
	Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
	Shadow.ZIndex = 0
	Shadow.Parent = MainFrame

	-- Header (cabeçalho)
	local Header = Instance.new("Frame")
	Header.Name = "Header"
	Header.Size = UDim2.new(1, 0, 0, 45)
	Header.BackgroundColor3 = Config.SecondaryColor
	Header.BorderSizePixel = 0
	Header.Parent = MainFrame
	AddCorner(Header, 10)

	-- Corrigir cantos do header
	local HeaderFix = Instance.new("Frame")
	HeaderFix.Size = UDim2.new(1, 0, 0, 10)
	HeaderFix.Position = UDim2.new(0, 0, 1, -10)
	HeaderFix.BackgroundColor3 = Config.SecondaryColor
	HeaderFix.BorderSizePixel = 0
	HeaderFix.Parent = Header

	-- Título
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "Title"
	TitleLabel.Size = UDim2.new(0, 200, 1, 0)
	TitleLabel.Position = UDim2.new(0, 15, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Text = title
	TitleLabel.TextColor3 = Config.TextColor
	TitleLabel.TextSize = 18
	TitleLabel.Font = Config.Font
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = Header

	-- Colorir parte do título
	local function ColorizeTitle()
		local fullText = title
		local colorPart = "Kaelix"
		if fullText:find(colorPart) then
			TitleLabel.RichText = true
			TitleLabel.Text = fullText:gsub(colorPart, '<font color="rgb(138, 43, 226)">' .. colorPart .. "</font>")
		end
	end
	ColorizeTitle()

	-- FPS Counter
	local FPSLabel = Instance.new("TextLabel")
	FPSLabel.Name = "FPS"
	FPSLabel.Size = UDim2.new(0, 120, 1, 0)
	FPSLabel.Position = UDim2.new(1, -135, 0, 0)
	FPSLabel.BackgroundTransparency = 1
	FPSLabel.Text = "FPS COUNTER"
	FPSLabel.TextColor3 = Config.TextColor
	FPSLabel.TextSize = 12
	FPSLabel.Font = Config.Font
	FPSLabel.TextXAlignment = Enum.TextXAlignment.Right
	FPSLabel.Parent = Header

	-- Atualizar FPS
	local lastUpdate = tick()
	local fps = 60
	RunService.RenderStepped:Connect(function()
		if tick() - lastUpdate >= 1 then
			fps = math.floor(1 / RunService.RenderStepped:Wait())
			lastUpdate = tick()
		end
	end)

	spawn(function()
		while ScreenGui.Parent do
			FPSLabel.Text = "FPS COUNTER\n" .. tostring(fps) .. "+"
			wait(1)
		end
	end)

	-- Container para tabs (com scroll)
	local TabContainer = Instance.new("ScrollingFrame")
	TabContainer.Name = "TabContainer"
	TabContainer.Size = UDim2.new(0, 145, 1, -55)
	TabContainer.Position = UDim2.new(0, 10, 0, 50)
	TabContainer.BackgroundTransparency = 1
	TabContainer.BorderSizePixel = 0
	TabContainer.ScrollBarThickness = 3
	TabContainer.ScrollBarImageColor3 = Config.MainColor
	TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabContainer.Parent = MainFrame

	-- Adicionar padding interno para não cortar os botões
	local TabPadding = Instance.new("UIPadding")
	TabPadding.PaddingRight = UDim.new(0, 8)
	TabPadding.Parent = TabContainer

	local TabList = Instance.new("UIListLayout")
	TabList.SortOrder = Enum.SortOrder.LayoutOrder
	TabList.Padding = UDim.new(0, 5)
	TabList.Parent = TabContainer

	-- Auto-resize do canvas das tabs
	TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabList.AbsoluteContentSize.Y + 10)
	end)

	-- Container para conteúdo
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Size = UDim2.new(1, -170, 1, -60)
	ContentContainer.Position = UDim2.new(0, 160, 0, 50)
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Parent = MainFrame

	local WindowLib = {
		Tabs = {},
		CurrentTab = nil,
	}

	-- Função para criar uma nova tab
	function WindowLib:CreateTab(name)
		local TabButton = Instance.new("TextButton")
		TabButton.Name = name
		TabButton.Size = UDim2.new(1, 0, 0, 35)
		TabButton.BackgroundColor3 = Config.SecondaryColor
		TabButton.BorderSizePixel = 0
		TabButton.Text = name
		TabButton.TextColor3 = Config.TextColor
		TabButton.TextSize = 14
		TabButton.Font = Config.Font
		TabButton.AutoButtonColor = false
		TabButton.Parent = TabContainer
		AddCorner(TabButton, 6)

		-- Highlight da tab
		local Highlight = Instance.new("Frame")
		Highlight.Name = "Highlight"
		Highlight.Size = UDim2.new(0, 3, 1, 0)
		Highlight.BackgroundColor3 = Config.MainColor
		Highlight.BorderSizePixel = 0
		Highlight.Visible = false
		Highlight.Parent = TabButton

		-- Conteúdo da tab
		local TabContent = Instance.new("ScrollingFrame")
		TabContent.Name = name .. "Content"
		TabContent.Size = UDim2.new(1, 0, 1, 0)
		TabContent.BackgroundTransparency = 1
		TabContent.BorderSizePixel = 0
		TabContent.ScrollBarThickness = 4
		TabContent.ScrollBarImageColor3 = Config.MainColor
		TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabContent.Visible = false
		TabContent.Parent = ContentContainer

		local ContentList = Instance.new("UIListLayout")
		ContentList.SortOrder = Enum.SortOrder.LayoutOrder
		ContentList.Padding = UDim.new(0, 8)
		ContentList.Parent = TabContent

		-- Auto-resize do canvas
		ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
		end)

		-- Evento de clique na tab
		TabButton.MouseButton1Click:Connect(function()
			for _, tab in pairs(WindowLib.Tabs) do
				tab.Button.BackgroundColor3 = Config.SecondaryColor
				tab.Highlight.Visible = false
				tab.Content.Visible = false
			end

			TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Highlight.Visible = true
			TabContent.Visible = true
			WindowLib.CurrentTab = TabLib
		end)

		-- Hover effect
		TabButton.MouseEnter:Connect(function()
			if WindowLib.CurrentTab ~= TabLib then
				Tween(TabButton, { BackgroundColor3 = Color3.fromRGB(40, 40, 40) }, 0.2)
			end
		end)

		TabButton.MouseLeave:Connect(function()
			if WindowLib.CurrentTab ~= TabLib then
				Tween(TabButton, { BackgroundColor3 = Config.SecondaryColor }, 0.2)
			end
		end)

		local TabLib = {
			Button = TabButton,
			Content = TabContent,
			Highlight = Highlight,
			Elements = {},
		}

		table.insert(WindowLib.Tabs, TabLib)

		-- Ativar primeira tab automaticamente
		if #WindowLib.Tabs == 1 then
			TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Highlight.Visible = true
			TabContent.Visible = true
			WindowLib.CurrentTab = TabLib
		end

		-- Função para criar um botão
		function TabLib:CreateButton(text, callback)
			local ButtonFrame = Instance.new("Frame")
			ButtonFrame.Name = "ButtonFrame"
			ButtonFrame.Size = UDim2.new(1, -10, 0, 35)
			ButtonFrame.BackgroundColor3 = Config.SecondaryColor
			ButtonFrame.BorderSizePixel = 0
			ButtonFrame.Parent = TabContent
			AddCorner(ButtonFrame, 6)

			local Button = Instance.new("TextButton")
			Button.Name = "Button"
			Button.Size = UDim2.new(1, -10, 1, 0)
			Button.Position = UDim2.new(0, 5, 0, 0)
			Button.BackgroundTransparency = 1
			Button.Text = text
			Button.TextColor3 = Config.TextColor
			Button.TextSize = 13
			Button.Font = Config.Font
			Button.AutoButtonColor = false
			Button.Parent = ButtonFrame

			Button.MouseButton1Click:Connect(function()
				Tween(ButtonFrame, { BackgroundColor3 = Config.MainColor }, 0.1)
				wait(0.1)
				Tween(ButtonFrame, { BackgroundColor3 = Config.SecondaryColor }, 0.1)

				pcall(callback)
			end)

			Button.MouseEnter:Connect(function()
				Tween(ButtonFrame, { BackgroundColor3 = Color3.fromRGB(45, 45, 45) }, 0.2)
			end)

			Button.MouseLeave:Connect(function()
				Tween(ButtonFrame, { BackgroundColor3 = Config.SecondaryColor }, 0.2)
			end)

			return Button
		end

		-- Função para criar um toggle/switch
		function TabLib:CreateToggle(text, default, callback)
			default = default or false

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Name = "ToggleFrame"
			ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
			ToggleFrame.BackgroundColor3 = Config.SecondaryColor
			ToggleFrame.BorderSizePixel = 0
			ToggleFrame.Parent = TabContent
			AddCorner(ToggleFrame, 6)

			local ToggleLabel = Instance.new("TextLabel")
			ToggleLabel.Name = "Label"
			ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
			ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
			ToggleLabel.BackgroundTransparency = 1
			ToggleLabel.Text = text
			ToggleLabel.TextColor3 = Config.TextColor
			ToggleLabel.TextSize = 13
			ToggleLabel.Font = Config.Font
			ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
			ToggleLabel.Parent = ToggleFrame

			local ToggleButton = Instance.new("TextButton")
			ToggleButton.Name = "Toggle"
			ToggleButton.Size = UDim2.new(0, 50, 0, 20)
			ToggleButton.Position = UDim2.new(1, -60, 0.5, -10)
			ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			ToggleButton.BorderSizePixel = 0
			ToggleButton.Text = ""
			ToggleButton.AutoButtonColor = false
			ToggleButton.Parent = ToggleFrame
			AddCorner(ToggleButton, 10)

			local ToggleCircle = Instance.new("Frame")
			ToggleCircle.Name = "Circle"
			ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
			ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
			ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			ToggleCircle.BorderSizePixel = 0
			ToggleCircle.Parent = ToggleButton
			AddCorner(ToggleCircle, 8)

			local toggled = default

			local function UpdateToggle()
				if toggled then
					Tween(ToggleButton, { BackgroundColor3 = Config.MainColor }, 0.2)
					Tween(ToggleCircle, { Position = UDim2.new(1, -18, 0.5, -8) }, 0.2)
				else
					Tween(ToggleButton, { BackgroundColor3 = Color3.fromRGB(50, 50, 50) }, 0.2)
					Tween(ToggleCircle, { Position = UDim2.new(0, 2, 0.5, -8) }, 0.2)
				end
			end

			UpdateToggle()

			ToggleButton.MouseButton1Click:Connect(function()
				toggled = not toggled
				UpdateToggle()
				pcall(callback, toggled)
			end)

			return {
				SetValue = function(value)
					toggled = value
					UpdateToggle()
				end,
			}
		end

		-- Função para criar um slider
		function TabLib:CreateSlider(text, min, max, default, callback)
			min = min or 0
			max = max or 100
			default = default or min

			local SliderFrame = Instance.new("Frame")
			SliderFrame.Name = "SliderFrame"
			SliderFrame.Size = UDim2.new(1, -10, 0, 50)
			SliderFrame.BackgroundColor3 = Config.SecondaryColor
			SliderFrame.BorderSizePixel = 0
			SliderFrame.Parent = TabContent
			AddCorner(SliderFrame, 6)

			local SliderLabel = Instance.new("TextLabel")
			SliderLabel.Name = "Label"
			SliderLabel.Size = UDim2.new(1, -20, 0, 20)
			SliderLabel.Position = UDim2.new(0, 10, 0, 5)
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.Text = text
			SliderLabel.TextColor3 = Config.TextColor
			SliderLabel.TextSize = 13
			SliderLabel.Font = Config.Font
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
			SliderLabel.Parent = SliderFrame

			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Name = "Value"
			ValueLabel.Size = UDim2.new(0, 50, 0, 20)
			ValueLabel.Position = UDim2.new(1, -60, 0, 5)
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Text = tostring(default)
			ValueLabel.TextColor3 = Config.MainColor
			ValueLabel.TextSize = 13
			ValueLabel.Font = Config.Font
			ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
			ValueLabel.Parent = SliderFrame

			local SliderBack = Instance.new("Frame")
			SliderBack.Name = "SliderBack"
			SliderBack.Size = UDim2.new(1, -20, 0, 4)
			SliderBack.Position = UDim2.new(0, 10, 1, -15)
			SliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			SliderBack.BorderSizePixel = 0
			SliderBack.Parent = SliderFrame
			AddCorner(SliderBack, 2)

			local SliderFill = Instance.new("Frame")
			SliderFill.Name = "Fill"
			SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
			SliderFill.BackgroundColor3 = Config.MainColor
			SliderFill.BorderSizePixel = 0
			SliderFill.Parent = SliderBack
			AddCorner(SliderFill, 2)

			local SliderButton = Instance.new("TextButton")
			SliderButton.Name = "Button"
			SliderButton.Size = UDim2.new(1, 0, 1, 0)
			SliderButton.BackgroundTransparency = 1
			SliderButton.Text = ""
			SliderButton.Parent = SliderBack

			local dragging = false

			local function UpdateSlider(input)
				local pos =
					math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
				local value = math.floor(min + (max - min) * pos)

				SliderFill.Size = UDim2.new(pos, 0, 1, 0)
				ValueLabel.Text = tostring(value)

				pcall(callback, value)
			end

			SliderButton.MouseButton1Down:Connect(function()
				dragging = true
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					UpdateSlider(input)
				end
			end)

			SliderButton.MouseButton1Click:Connect(function(input)
				UpdateSlider(UserInputService:GetMouseLocation())
			end)

			return {
				SetValue = function(value)
					value = math.clamp(value, min, max)
					local pos = (value - min) / (max - min)
					SliderFill.Size = UDim2.new(pos, 0, 1, 0)
					ValueLabel.Text = tostring(value)
				end,
			}
		end

		-- Função para criar um checkbox
		function TabLib:CreateCheckbox(text, default, callback)
			default = default or false

			local CheckboxFrame = Instance.new("Frame")
			CheckboxFrame.Name = "CheckboxFrame"
			CheckboxFrame.Size = UDim2.new(1, -10, 0, 35)
			CheckboxFrame.BackgroundColor3 = Config.SecondaryColor
			CheckboxFrame.BorderSizePixel = 0
			CheckboxFrame.Parent = TabContent
			AddCorner(CheckboxFrame, 6)

			local CheckboxLabel = Instance.new("TextLabel")
			CheckboxLabel.Name = "Label"
			CheckboxLabel.Size = UDim2.new(1, -50, 1, 0)
			CheckboxLabel.Position = UDim2.new(0, 10, 0, 0)
			CheckboxLabel.BackgroundTransparency = 1
			CheckboxLabel.Text = text
			CheckboxLabel.TextColor3 = Config.TextColor
			CheckboxLabel.TextSize = 13
			CheckboxLabel.Font = Config.Font
			CheckboxLabel.TextXAlignment = Enum.TextXAlignment.Left
			CheckboxLabel.Parent = CheckboxFrame

			local CheckboxButton = Instance.new("TextButton")
			CheckboxButton.Name = "Checkbox"
			CheckboxButton.Size = UDim2.new(0, 20, 0, 20)
			CheckboxButton.Position = UDim2.new(1, -35, 0.5, -10)
			CheckboxButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			CheckboxButton.BorderSizePixel = 0
			CheckboxButton.Text = ""
			CheckboxButton.AutoButtonColor = false
			CheckboxButton.Parent = CheckboxFrame
			AddCorner(CheckboxButton, 4)

			local CheckboxCheck = Instance.new("ImageLabel")
			CheckboxCheck.Name = "Check"
			CheckboxCheck.Size = UDim2.new(0.7, 0, 0.7, 0)
			CheckboxCheck.Position = UDim2.new(0.15, 0, 0.15, 0)
			CheckboxCheck.BackgroundTransparency = 1
			CheckboxCheck.Image = "rbxassetid://3926305904"
			CheckboxCheck.ImageRectOffset = Vector2.new(312, 4)
			CheckboxCheck.ImageRectSize = Vector2.new(24, 24)
			CheckboxCheck.ImageColor3 = Config.MainColor
			CheckboxCheck.Visible = default
			CheckboxCheck.Parent = CheckboxButton

			local checked = default

			CheckboxButton.MouseButton1Click:Connect(function()
				checked = not checked
				CheckboxCheck.Visible = checked

				if checked then
					CheckboxButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				else
					CheckboxButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				end

				pcall(callback, checked)
			end)

			return {
				SetValue = function(value)
					checked = value
					CheckboxCheck.Visible = checked
					CheckboxButton.BackgroundColor3 = checked and Color3.fromRGB(60, 60, 60)
						or Color3.fromRGB(50, 50, 50)
				end,
			}
		end

		-- Função para criar um keybind button
		function TabLib:CreateKeybind(text, defaultKey, callback)
			local KeybindFrame = Instance.new("Frame")
			KeybindFrame.Name = "KeybindFrame"
			KeybindFrame.Size = UDim2.new(1, -10, 0, 35)
			KeybindFrame.BackgroundColor3 = Config.SecondaryColor
			KeybindFrame.BorderSizePixel = 0
			KeybindFrame.Parent = TabContent
			AddCorner(KeybindFrame, 6)

			local KeybindLabel = Instance.new("TextLabel")
			KeybindLabel.Name = "Label"
			KeybindLabel.Size = UDim2.new(1, -80, 1, 0)
			KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
			KeybindLabel.BackgroundTransparency = 1
			KeybindLabel.Text = text
			KeybindLabel.TextColor3 = Config.TextColor
			KeybindLabel.TextSize = 13
			KeybindLabel.Font = Config.Font
			KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
			KeybindLabel.Parent = KeybindFrame

			local KeybindButton = Instance.new("TextButton")
			KeybindButton.Name = "Keybind"
			KeybindButton.Size = UDim2.new(0, 60, 0, 25)
			KeybindButton.Position = UDim2.new(1, -70, 0.5, -12.5)
			KeybindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			KeybindButton.BorderSizePixel = 0
			KeybindButton.Text = defaultKey or "X"
			KeybindButton.TextColor3 = Config.TextColor
			KeybindButton.TextSize = 12
			KeybindButton.Font = Config.Font
			KeybindButton.AutoButtonColor = false
			KeybindButton.Parent = KeybindFrame
			AddCorner(KeybindButton, 4)

			local currentKey = defaultKey or "X"
			local binding = false

			KeybindButton.MouseButton1Click:Connect(function()
				KeybindButton.Text = "..."
				binding = true
			end)

			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if binding then
					if input.UserInputType == Enum.UserInputType.Keyboard then
						currentKey = input.KeyCode.Name
						KeybindButton.Text = currentKey
						binding = false
					end
				elseif not gameProcessed then
					if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == currentKey then
						pcall(callback)
					end
				end
			end)

			return {
				SetKey = function(key)
					currentKey = key
					KeybindButton.Text = key
				end,
			}
		end

		-- Função para criar texto/label
		function TabLib:CreateLabel(text)
			local LabelFrame = Instance.new("Frame")
			LabelFrame.Name = "LabelFrame"
			LabelFrame.Size = UDim2.new(1, -10, 0, 30)
			LabelFrame.BackgroundColor3 = Config.SecondaryColor
			LabelFrame.BorderSizePixel = 0
			LabelFrame.Parent = TabContent
			AddCorner(LabelFrame, 6)

			local Label = Instance.new("TextLabel")
			Label.Name = "Label"
			Label.Size = UDim2.new(1, -20, 1, 0)
			Label.Position = UDim2.new(0, 10, 0, 0)
			Label.BackgroundTransparency = 1
			Label.Text = text
			Label.TextColor3 = Config.TextColor
			Label.TextSize = 12
			Label.Font = Config.Font
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.TextWrapped = true
			Label.Parent = LabelFrame

			return {
				SetText = function(newText)
					Label.Text = newText
				end,
			}
		end

		-- Função para criar um textbox
		function TabLib:CreateTextbox(placeholder, callback)
			local TextboxFrame = Instance.new("Frame")
			TextboxFrame.Name = "TextboxFrame"
			TextboxFrame.Size = UDim2.new(1, -10, 0, 35)
			TextboxFrame.BackgroundColor3 = Config.SecondaryColor
			TextboxFrame.BorderSizePixel = 0
			TextboxFrame.Parent = TabContent
			AddCorner(TextboxFrame, 6)

			local Textbox = Instance.new("TextBox")
			Textbox.Name = "Textbox"
			Textbox.Size = UDim2.new(1, -20, 1, 0)
			Textbox.Position = UDim2.new(0, 10, 0, 0)
			Textbox.BackgroundTransparency = 1
			Textbox.PlaceholderText = placeholder or "Enter text..."
			Textbox.Text = ""
			Textbox.TextColor3 = Config.TextColor
			Textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
			Textbox.TextSize = 13
			Textbox.Font = Config.Font
			Textbox.TextXAlignment = Enum.TextXAlignment.Left
			Textbox.ClearTextOnFocus = false
			Textbox.Parent = TextboxFrame

			Textbox.FocusLost:Connect(function(enterPressed)
				if enterPressed then
					pcall(callback, Textbox.Text)
				end
			end)

			return {
				SetText = function(text)
					Textbox.Text = text
				end,
				GetText = function()
					return Textbox.Text
				end,
			}
		end

		-- Função para criar um dropdown
		function TabLib:CreateDropdown(text, options, default, callback)
			options = options or {}
			default = default or (options[1] or "None")

			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Name = "DropdownFrame"
			DropdownFrame.Size = UDim2.new(1, -10, 0, 35)
			DropdownFrame.BackgroundColor3 = Config.SecondaryColor
			DropdownFrame.BorderSizePixel = 0
			DropdownFrame.Parent = TabContent
			DropdownFrame.ClipsDescendants = true
			AddCorner(DropdownFrame, 6)

			local DropdownLabel = Instance.new("TextLabel")
			DropdownLabel.Name = "Label"
			DropdownLabel.Size = UDim2.new(1, -90, 0, 35)
			DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
			DropdownLabel.BackgroundTransparency = 1
			DropdownLabel.Text = text
			DropdownLabel.TextColor3 = Config.TextColor
			DropdownLabel.TextSize = 13
			DropdownLabel.Font = Config.Font
			DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
			DropdownLabel.Parent = DropdownFrame

			local DropdownButton = Instance.new("TextButton")
			DropdownButton.Name = "Button"
			DropdownButton.Size = UDim2.new(0, 150, 0, 25)
			DropdownButton.Position = UDim2.new(1, -160, 0, 5)
			DropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			DropdownButton.BorderSizePixel = 0
			DropdownButton.Text = default .. " ▼"
			DropdownButton.TextColor3 = Config.TextColor
			DropdownButton.TextSize = 12
			DropdownButton.Font = Config.Font
			DropdownButton.AutoButtonColor = false
			DropdownButton.Parent = DropdownFrame
			AddCorner(DropdownButton, 4)

			local DropdownList = Instance.new("Frame")
			DropdownList.Name = "List"
			DropdownList.Size = UDim2.new(0, 150, 0, 0)
			DropdownList.Position = UDim2.new(1, -160, 0, 35)
			DropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			DropdownList.BorderSizePixel = 0
			DropdownList.Visible = false
			DropdownList.Parent = DropdownFrame
			AddCorner(DropdownList, 4)

			local ListLayout = Instance.new("UIListLayout")
			ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ListLayout.Padding = UDim.new(0, 2)
			ListLayout.Parent = DropdownList

			local selectedValue = default
			local isOpen = false

			-- Criar opções
			for _, option in ipairs(options) do
				local OptionButton = Instance.new("TextButton")
				OptionButton.Name = option
				OptionButton.Size = UDim2.new(1, 0, 0, 25)
				OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				OptionButton.BorderSizePixel = 0
				OptionButton.Text = option
				OptionButton.TextColor3 = Config.TextColor
				OptionButton.TextSize = 11
				OptionButton.Font = Config.Font
				OptionButton.AutoButtonColor = false
				OptionButton.Parent = DropdownList

				-- Highlight se for a opção selecionada
				if option == selectedValue then
					OptionButton.BackgroundColor3 = Config.MainColor
				end

				OptionButton.MouseEnter:Connect(function()
					if option ~= selectedValue then
						Tween(OptionButton, { BackgroundColor3 = Color3.fromRGB(55, 55, 55) }, 0.2)
					end
				end)

				OptionButton.MouseLeave:Connect(function()
					if option ~= selectedValue then
						Tween(OptionButton, { BackgroundColor3 = Color3.fromRGB(45, 45, 45) }, 0.2)
					end
				end)

				OptionButton.MouseButton1Click:Connect(function()
					selectedValue = option
					DropdownButton.Text = option .. " ▼"

					-- Atualizar highlight
					for _, child in pairs(DropdownList:GetChildren()) do
						if child:IsA("TextButton") then
							if child.Text == option then
								Tween(child, { BackgroundColor3 = Config.MainColor }, 0.2)
							else
								Tween(child, { BackgroundColor3 = Color3.fromRGB(45, 45, 45) }, 0.2)
							end
						end
					end

					-- Fechar dropdown
					isOpen = false
					DropdownButton.Text = option .. " ▼"
					Tween(DropdownFrame, { Size = UDim2.new(1, -10, 0, 35) }, 0.3)
					wait(0.3)
					DropdownList.Visible = false

					pcall(callback, option)
				end)
			end

			-- Abrir/Fechar dropdown
			DropdownButton.MouseButton1Click:Connect(function()
				isOpen = not isOpen

				if isOpen then
					DropdownButton.Text = selectedValue .. " ▲"
					DropdownList.Visible = true
					local listHeight = #options * 27
					Tween(DropdownFrame, { Size = UDim2.new(1, -10, 0, 35 + listHeight + 5) }, 0.3)
					DropdownList.Size = UDim2.new(0, 150, 0, listHeight)
				else
					DropdownButton.Text = selectedValue .. " ▼"
					Tween(DropdownFrame, { Size = UDim2.new(1, -10, 0, 35) }, 0.3)
					wait(0.3)
					DropdownList.Visible = false
				end
			end)

			return {
				SetValue = function(value)
					selectedValue = value
					DropdownButton.Text = value .. " ▼"

					-- Atualizar highlight
					for _, child in pairs(DropdownList:GetChildren()) do
						if child:IsA("TextButton") then
							if child.Text == value then
								child.BackgroundColor3 = Config.MainColor
							else
								child.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
							end
						end
					end
				end,
				GetValue = function()
					return selectedValue
				end,
				Refresh = function(newOptions)
					-- Limpar opções antigas
					for _, child in pairs(DropdownList:GetChildren()) do
						if child:IsA("TextButton") then
							child:Destroy()
						end
					end

					-- Adicionar novas opções
					for _, option in ipairs(newOptions) do
						local OptionButton = Instance.new("TextButton")
						OptionButton.Name = option
						OptionButton.Size = UDim2.new(1, 0, 0, 25)
						OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
						OptionButton.BorderSizePixel = 0
						OptionButton.Text = option
						OptionButton.TextColor3 = Config.TextColor
						OptionButton.TextSize = 11
						OptionButton.Font = Config.Font
						OptionButton.AutoButtonColor = false
						OptionButton.Parent = DropdownList

						OptionButton.MouseButton1Click:Connect(function()
							selectedValue = option
							DropdownButton.Text = option .. " ▼"
							isOpen = false
							Tween(DropdownFrame, { Size = UDim2.new(1, -10, 0, 35) }, 0.3)
							wait(0.3)
							DropdownList.Visible = false
							pcall(callback, option)
						end)
					end
				end,
			}
		end

		return TabLib
	end

	-- Sistema de Notificações (estilo Windows)
	local NotificationQueue = {}
	local ActiveNotifications = {}
	local MaxNotifications = 5

	function WindowLib:CreateNotification(title, content, duration)
		title = title or "Notification"
		content = content or "No content"
		duration = duration or 5

		-- Se já tem muitas notificações, adicionar na fila
		if #ActiveNotifications >= MaxNotifications then
			table.insert(NotificationQueue, { title = title, content = content, duration = duration })
			return
		end

		-- Criar notificação
		local NotifFrame = Instance.new("Frame")
		NotifFrame.Name = "Notification"
		NotifFrame.Size = UDim2.new(0, 300, 0, 0)
		NotifFrame.Position = UDim2.new(1, -320, 1, -20)
		NotifFrame.BackgroundColor3 = Config.BackgroundColor
		NotifFrame.BorderSizePixel = 0
		NotifFrame.ClipsDescendants = true
		NotifFrame.Parent = ScreenGui
		AddCorner(NotifFrame, 8)

		-- Sombra
		local NotifShadow = Instance.new("ImageLabel")
		NotifShadow.Name = "Shadow"
		NotifShadow.Size = UDim2.new(1, 20, 1, 20)
		NotifShadow.Position = UDim2.new(0, -10, 0, -10)
		NotifShadow.BackgroundTransparency = 1
		NotifShadow.Image = "rbxassetid://1316045217"
		NotifShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
		NotifShadow.ImageTransparency = 0.5
		NotifShadow.ScaleType = Enum.ScaleType.Slice
		NotifShadow.SliceCenter = Rect.new(10, 10, 118, 118)
		NotifShadow.ZIndex = 0
		NotifShadow.Parent = NotifFrame

		-- Header da notificação
		local NotifHeader = Instance.new("Frame")
		NotifHeader.Name = "Header"
		NotifHeader.Size = UDim2.new(1, 0, 0, 35)
		NotifHeader.BackgroundColor3 = Config.MainColor
		NotifHeader.BorderSizePixel = 0
		NotifHeader.Parent = NotifFrame
		AddCorner(NotifHeader, 8)

		local NotifHeaderFix = Instance.new("Frame")
		NotifHeaderFix.Size = UDim2.new(1, 0, 0, 8)
		NotifHeaderFix.Position = UDim2.new(0, 0, 1, -8)
		NotifHeaderFix.BackgroundColor3 = Config.MainColor
		NotifHeaderFix.BorderSizePixel = 0
		NotifHeaderFix.Parent = NotifHeader

		-- Título
		local NotifTitle = Instance.new("TextLabel")
		NotifTitle.Name = "Title"
		NotifTitle.Size = UDim2.new(1, -40, 1, 0)
		NotifTitle.Position = UDim2.new(0, 10, 0, 0)
		NotifTitle.BackgroundTransparency = 1
		NotifTitle.Text = title
		NotifTitle.TextColor3 = Config.TextColor
		NotifTitle.TextSize = 14
		NotifTitle.Font = Enum.Font.GothamBold
		NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
		NotifTitle.Parent = NotifHeader

		-- Botão fechar
		local CloseButton = Instance.new("TextButton")
		CloseButton.Name = "Close"
		CloseButton.Size = UDim2.new(0, 25, 0, 25)
		CloseButton.Position = UDim2.new(1, -30, 0, 5)
		CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
		CloseButton.BorderSizePixel = 0
		CloseButton.Text = "×"
		CloseButton.TextColor3 = Config.TextColor
		CloseButton.TextSize = 18
		CloseButton.Font = Enum.Font.GothamBold
		CloseButton.AutoButtonColor = false
		CloseButton.Parent = NotifHeader
		AddCorner(CloseButton, 4)

		-- Conteúdo
		local NotifContent = Instance.new("TextLabel")
		NotifContent.Name = "Content"
		NotifContent.Size = UDim2.new(1, -20, 1, -45)
		NotifContent.Position = UDim2.new(0, 10, 0, 40)
		NotifContent.BackgroundTransparency = 1
		NotifContent.Text = content
		NotifContent.TextColor3 = Color3.fromRGB(200, 200, 200)
		NotifContent.TextSize = 12
		NotifContent.Font = Config.Font
		NotifContent.TextXAlignment = Enum.TextXAlignment.Left
		NotifContent.TextYAlignment = Enum.TextYAlignment.Top
		NotifContent.TextWrapped = true
		NotifContent.Parent = NotifFrame

		-- Calcular altura baseado no conteúdo
		local textSize = game:GetService("TextService")
			:GetTextSize(content, 12, Config.Font, Vector2.new(270, math.huge))
		local contentHeight = math.max(60, math.min(textSize.Y + 50, 200))

		-- Adicionar à lista de notificações ativas
		table.insert(ActiveNotifications, NotifFrame)

		-- Reposicionar todas as notificações
		local function RepositionNotifications()
			local yOffset = 20
			for i = #ActiveNotifications, 1, -1 do
				local notif = ActiveNotifications[i]
				if notif and notif.Parent then
					Tween(notif, { Position = UDim2.new(1, -320, 1, -(yOffset + notif.Size.Y.Offset)) }, 0.3)
					yOffset = yOffset + notif.Size.Y.Offset + 10
				end
			end
		end

		-- Animação de entrada (expandir)
		Tween(NotifFrame, { Size = UDim2.new(0, 300, 0, contentHeight) }, 0.3)
		wait(0.3)
		RepositionNotifications()

		-- Função para remover notificação
		local function RemoveNotification()
			-- Animação de saída
			Tween(
				NotifFrame,
				{ Position = UDim2.new(1, 0, NotifFrame.Position.Y.Scale, NotifFrame.Position.Y.Offset) },
				0.3
			)
			wait(0.3)

			-- Remover da lista
			for i, notif in ipairs(ActiveNotifications) do
				if notif == NotifFrame then
					table.remove(ActiveNotifications, i)
					break
				end
			end

			NotifFrame:Destroy()
			RepositionNotifications()

			-- Processar fila
			if #NotificationQueue > 0 then
				local next = table.remove(NotificationQueue, 1)
				WindowLib:CreateNotification(next.title, next.content, next.duration)
			end
		end

		-- Botão fechar
		CloseButton.MouseButton1Click:Connect(RemoveNotification)

		CloseButton.MouseEnter:Connect(function()
			Tween(CloseButton, { BackgroundColor3 = Color3.fromRGB(220, 40, 40) }, 0.2)
		end)

		CloseButton.MouseLeave:Connect(function()
			Tween(CloseButton, { BackgroundColor3 = Color3.fromRGB(255, 60, 60) }, 0.2)
		end)

		-- Auto-remover depois de X segundos
		spawn(function()
			wait(duration)
			if NotifFrame.Parent then
				RemoveNotification()
			end
		end)
	end

	return WindowLib
end

return KaelixLib
