# KaelixHub UI Library

Uma biblioteca moderna e completa para criar interfaces de usuário (UI) em scripts do Roblox.

## 🎨 Características

- ✅ Design moderno e responsivo
- ✅ Sistema de abas (tabs) lateral
- ✅ Contador de FPS em tempo real
- ✅ Janela arrastável
- ✅ Animações suaves
- ✅ Fácil de usar

## 📦 Componentes Disponíveis

### 1. **Button** (Botão)
Botão simples clicável

### 2. **Toggle/Switch** (Interruptor)
Botão de alternância on/off com animação

### 3. **Slider** (Barra deslizante)
Controle deslizante para valores numéricos

### 4. **Checkbox** (Caixa de seleção)
Caixa de marcação simples

### 5. **Keybind** (Atalho de teclado)
Botão com tecla de atalho personalizável

### 6. **Label** (Texto)
Texto informativo

### 7. **Textbox** (Caixa de texto)
Campo de entrada de texto

## 🚀 Como Usar

### Instalação

1. Copie o conteúdo de `lib.lua` para seu script
2. OU hospede o script e carregue via `loadstring`

### Exemplo Básico

```lua
-- Carregar a biblioteca
local KaelixLib = loadstring(game:HttpGet("SUA_URL_AQUI"))()

-- Criar janela
local Window = KaelixLib:CreateWindow("KaelixHub")

-- Criar tab
local Tab = Window:CreateTab("Main")

-- Adicionar botão
Tab:CreateButton("Clique aqui", function()
    print("Botão clicado!")
end)

-- Adicionar toggle
Tab:CreateToggle("Ativar Feature", false, function(value)
    print("Toggle:", value)
end)

-- Adicionar slider
Tab:CreateSlider("Velocidade", 0, 100, 50, function(value)
    print("Valor:", value)
end)
```

## 📝 Documentação dos Componentes

### CreateWindow
```lua
local Window = KaelixLib:CreateWindow(título)
```
Cria a janela principal da UI.

### CreateTab
```lua
local Tab = Window:CreateTab(nome)
```
Cria uma nova aba na interface.

### CreateButton
```lua
Tab:CreateButton(texto, callback)
```
- `texto`: Texto do botão
- `callback`: Função executada ao clicar

### CreateToggle
```lua
local toggle = Tab:CreateToggle(texto, padrão, callback)
```
- `texto`: Texto do toggle
- `padrão`: Estado inicial (true/false)
- `callback`: Função executada ao alternar

**Métodos:**
- `toggle:SetValue(value)`: Define o valor do toggle

### CreateSlider
```lua
local slider = Tab:CreateSlider(texto, min, max, padrão, callback)
```
- `texto`: Texto do slider
- `min`: Valor mínimo
- `max`: Valor máximo
- `padrão`: Valor inicial
- `callback`: Função executada ao mudar valor

**Métodos:**
- `slider:SetValue(value)`: Define o valor do slider

### CreateCheckbox
```lua
local checkbox = Tab:CreateCheckbox(texto, padrão, callback)
```
- `texto`: Texto da checkbox
- `padrão`: Estado inicial (true/false)
- `callback`: Função executada ao marcar/desmarcar

**Métodos:**
- `checkbox:SetValue(value)`: Define o estado da checkbox

### CreateKeybind
```lua
local keybind = Tab:CreateKeybind(texto, tecla, callback)
```
- `texto`: Texto do keybind
- `tecla`: Tecla padrão (ex: "X", "E", "Q")
- `callback`: Função executada ao pressionar a tecla

**Métodos:**
- `keybind:SetKey(tecla)`: Altera a tecla

### CreateLabel
```lua
local label = Tab:CreateLabel(texto)
```
- `texto`: Texto a ser exibido

**Métodos:**
- `label:SetText(texto)`: Altera o texto

### CreateTextbox
```lua
local textbox = Tab:CreateTextbox(placeholder, callback)
```
- `placeholder`: Texto de exemplo
- `callback`: Função executada ao pressionar Enter

**Métodos:**
- `textbox:SetText(texto)`: Define o texto
- `textbox:GetText()`: Retorna o texto atual

## 🎨 Personalização

Você pode personalizar as cores editando a tabela `Config` em `lib.lua`:

```lua
local Config = {
    MainColor = Color3.fromRGB(138, 43, 226),      -- Cor principal (roxo)
    BackgroundColor = Color3.fromRGB(25, 25, 25),   -- Cor de fundo
    SecondaryColor = Color3.fromRGB(35, 35, 35),    -- Cor secundária
    TextColor = Color3.fromRGB(255, 255, 255),      -- Cor do texto
    Font = Enum.Font.Gotham,                        -- Fonte
    TweenSpeed = 0.3                                -- Velocidade das animações
}
```

## 📱 Recursos Adicionais

### Contador de FPS
O contador de FPS é atualizado automaticamente no cabeçalho.

### Janela Arrastável
A janela pode ser arrastada clicando e segurando o cabeçalho.

### Sistema de Abas
Navegue entre diferentes seções usando as abas laterais.

### Animações Suaves
Todos os componentes possuem animações suaves e responsivas.

## 🔧 Compatibilidade

- ✅ Roblox Studio
- ✅ Exploits populares (Synapse, Script-Ware, KRNL, etc.)
- ✅ Executores mobile

## 📄 Exemplo Completo

Veja o arquivo `example.lua` para um exemplo completo de uso da biblioteca.

## 🤝 Contribuindo

Sinta-se livre para contribuir com melhorias, correções de bugs ou novos recursos!

## 📜 Licença

Este projeto é de código aberto e livre para uso pessoal e comercial.

---

**Desenvolvido por Kaelix**
