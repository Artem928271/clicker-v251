--[[ 
    ░█████╗░██████╗░███████╗███╗░░██╗░█████╗░██╗░░░██╗
    V420000 | INSTANT 10K | ZERO-DELAY EDITION [FIXED]
    СТАТУС: ⚡ МОМЕНТАЛЬНО | 🎯 ТОЧНОЕ КОЛИЧЕСТВО | 📊 ОТЧЁТ
    🔍 ПОИСК | 🪟 СВОРАЧИВАНИЕ | 🚀 ПОЛНЫЙ СПИСОК
--]]

if not game:IsLoaded() then game.Loaded:Wait() end

local LP = game:GetService("Players").LocalPlayer
local UI_NAME = "V420000_INSTANT_FINAL"
local Target = LP:WaitForChild("PlayerGui")
if Target:FindFirstChild(UI_NAME) then Target[UI_NAME]:Destroy() end

-- [ ГЛОБАЛЬНЫЙ ЛОГГЕР ОТЧЁТОВ ]
local ReportLog = {}
local function AddReport(msg)
    table.insert(ReportLog, msg)
    if #ReportLog > 50 then table.remove(ReportLog, 1) end
    print("📊 [ОТЧЁТ]: " .. msg)
end

-- [ ХРАНИЛИЩЕ КАРТОЧЕК ДЛЯ ПОИСКА ]
local AllCards = {}

-- [ ФИЛЬТР: УБИРАЕМ ТОЛЬКО СИСТЕМНЫЕ ROBLOX-РЕМОУТЫ ]
local function IsSystemRobloxRemote(obj)
    local name = obj.Name:lower()
    local fullPath = obj:GetFullName():lower()
    
    -- Только явные системные/роблоксовские
    local systemWords = {
        "integritycheck", "dynamictranslation", "localizationservice",
        "rbx", "core", "base", "protocol", "internal", "protected",
        "security", "auth", "token", "service", "system",
        "chat", "notification", "teleport", "join", "leave"
    }
    
    for _, word in ipairs(systemWords) do
        if fullPath:find(word) or name:find(word) then
            return true
        end
    end
    return false
end

-- [ ГИПЕР-ЛОГИКА: МОМЕНТАЛЬНЫЙ ВЫСТРЕЛ С ОТЧЁТОМ ]
local function InstantBurst(obj, val, mode)
    local count = tonumber(val)
    if not count or count < 1 then 
        AddReport("❌ Ошибка: введи число больше 0!")
        return 
    end
    
    if count > 25000 then 
        AddReport("⚠️ Лимит 25k! Уменьшено до 25000")
        count = 25000
    end
    
    local method = (obj:IsA("RemoteEvent") and "FireServer" or "InvokeServer")
    local startTime = tick()
    local successCount = 0
    local errorCount = 0
    
    AddReport(string.format("🚀 ЗАПУСК: %s | %d пакетов | Режим: %s", obj.Name, count, mode or "STANDARD"))
    
    for i = 1, count do
        local success, err = pcall(function()
            obj[method](obj, count)
        end)
        
        if success then 
            successCount = successCount + 1
        else 
            errorCount = errorCount + 1
        end
        
        if i % 1000 == 0 then
            AddReport(string.format("📈 Прогресс: %d/%d | Успешно: %d | Ошибок: %d", i, count, successCount, errorCount))
        end
    end
    
    local elapsed = tick() - startTime
    AddReport(string.format("✅ ГОТОВО! Отправлено: %d | Ошибок: %d | Время: %.3fс", successCount, errorCount, elapsed))
    
    pcall(function()
        if _G.ReportLabel then
            _G.ReportLabel.Text = string.format("✅ Отправлено: %d | Ошибок: %d | %.2fс", successCount, errorCount, elapsed)
        end
    end)
end

-- [ ИНТЕРФЕЙС ]
local Screen = Instance.new("ScreenGui", Target)
Screen.Name = UI_NAME
Screen.ResetOnSpawn = false

-- ОСНОВНОЕ ОКНО
local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 300, 0, 340)
Main.Position = UDim2.new(0.5, -55, 0.5, -205)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
Main.Active, Main.Draggable = true, true
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 255)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

-- КНОПКА СВОРАЧИВАНИЯ (КРУЖОЧЕК)
local MinimizeBtn = Instance.new("TextButton", Main)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -40, 0, 5)
MinimizeBtn.Text = "−"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
MinimizeBtn.Font = "Code"
MinimizeBtn.TextSize = 18
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(1, 1)

-- МАЛЕНЬКАЯ ИКОНКА ДЛЯ РАЗВОРАЧИВАНИЯ
local SmallIcon = Instance.new("TextButton", Screen)
SmallIcon.Size = UDim2.new(0, 50, 0, 50)
SmallIcon.Position = UDim2.new(0.8, 0, 0.9, 0)
SmallIcon.Text = "⚡"
SmallIcon.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
SmallIcon.TextColor3 = Color3.new(1, 1, 1)
SmallIcon.Font = "Code"
SmallIcon.TextSize = 24
Instance.new("UICorner", SmallIcon).CornerRadius = UDim.new(1, 1)
SmallIcon.Visible = false

-- ФУНКЦИЯ СВОРАЧИВАНИЯ/РАЗВОРАЧИВАНИЯ
local function ToggleMinimize()
    local isMinimized = SmallIcon.Visible
    Main.Visible = isMinimized
    SmallIcon.Visible = not isMinimized
end

MinimizeBtn.MouseButton1Click:Connect(ToggleMinimize)
SmallIcon.MouseButton1Click:Connect(ToggleMinimize)

-- ЗАГОЛОВОК
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ V420000 INSTANT | ПОИСК 🔍"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = "Code"
Title.TextSize = 18

-- СТРОКА ПОИСКА
local SearchBox = Instance.new("TextBox", Main)
SearchBox.Size = UDim2.new(0, 380, 0, 35)
SearchBox.Position = UDim2.new(0.5, -190, 0, 45)
SearchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
SearchBox.Text = ""
SearchBox.PlaceholderText = "🔍 Введи название ремоута..."
SearchBox.TextColor3 = Color3.new(0, 1, 0.5)
SearchBox.Font = "Code"
SearchBox.TextSize = 16
Instance.new("UICorner", SearchBox)
Instance.new("UIStroke", SearchBox).Color = Color3.new(0, 1, 0.5)

-- КНОПКА ОЧИСТКИ ПОИСКА
local ClearBtn = Instance.new("TextButton", Main)
ClearBtn.Size = UDim2.new(0, 50, 0, 30)
ClearBtn.Position = UDim2.new(1, -60, 0, 48)
ClearBtn.Text = "✕"
ClearBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ClearBtn.TextColor3 = Color3.new(1, 1, 1)
ClearBtn.Font = "Code"
ClearBtn.TextSize = 16
Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 5)
ClearBtn.MouseButton1Click:Connect(function()
    SearchBox.Text = ""
    FilterRemotes("")
end)

-- ПОЛЕ ВВОДА КОЛИЧЕСТВА
local GlobalAmt = Instance.new("TextBox", Main)
GlobalAmt.Size = UDim2.new(0, 380, 0, 40)
GlobalAmt.Position = UDim2.new(0.5, -190, 0, 85)
GlobalAmt.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
GlobalAmt.Text = "1000"
GlobalAmt.TextColor3 = Color3.new(0, 1, 0.5)
GlobalAmt.Font = "Code"
GlobalAmt.TextSize = 25
Instance.new("UICorner", GlobalAmt)
Instance.new("UIStroke", GlobalAmt).Color = Color3.new(0, 1, 0.5)

-- ОТЧЁТНАЯ СТРОКА
local ReportLabel = Instance.new("TextLabel", Main)
ReportLabel.Size = UDim2.new(1, -20, 0, 30)
ReportLabel.Position = UDim2.new(0, 10, 0, 130)
ReportLabel.BackgroundTransparency = 1
ReportLabel.Text = "📊 Ожидание команды..."
ReportLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
ReportLabel.Font = "Code"
ReportLabel.TextSize = 14
_G.ReportLabel = ReportLabel

-- СКРОЛЛ ДЛЯ РЕМОУТОВ
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -180)
Scroll.Position = UDim2.new(0, 10, 0, 170)
Scroll.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)

-- ФУНКЦИЯ ФИЛЬТРАЦИИ (ПОИСК)
local function FilterRemotes(query)
    query = query:lower()
    for _, card in ipairs(AllCards) do
        local cardName = card.Name:lower()
        if query == "" or cardName:find(query) then
            card.Visible = true
        else
            card.Visible = false
        end
    end
    pcall(function()
        Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
    end)
    AddReport("🔍 Поиск: '" .. query .. "' | Найдено: " .. #Scroll:GetChildren())
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    FilterRemotes(SearchBox.Text)
end)

-- ФУНКЦИЯ ДОБАВЛЕНИЯ КАРТОЧКИ
local function AddCard(obj)
    -- Убираем только системные Roblox-ремоуты
    if IsSystemRobloxRemote(obj) then return end

    local isSafe = obj.Name:lower():find("check") or obj.Name:lower():find("ban")
    local Card = Instance.new("Frame", Scroll)
    Card.Size = UDim2.new(1, -10, 0, 120)
    Card.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    Card.Name = obj.Name:lower()
    Instance.new("UICorner", Card)
    
    table.insert(AllCards, Card)
    
    -- ПОКАЗЫВАЕМ ПОЛНЫЙ ПУТЬ (ЧТОБЫ ВИДЕТЬ, ГДЕ ИМЕННО РЕМОУТ)
    local PathLabel = Instance.new("TextLabel", Card)
    PathLabel.Size = UDim2.new(1, -10, 0, 20)
    PathLabel.Position = UDim2.new(0, 5, 0, 35)
    PathLabel.Text = "📍 " .. obj:GetFullName()
    PathLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    PathLabel.Font = "Code"
    PathLabel.TextSize = 10
    PathLabel.TextXAlignment = "Left"
    PathLabel.BackgroundTransparency = 1
    
    local Name = Instance.new("TextLabel", Card)
    Name.Size = UDim2.new(0.7, 0, 0, 30)
    Name.Position = UDim2.new(0, 15, 0, 5)
    Name.Text = (isSafe and "✅" or "❌") .. " " .. obj.Name:upper()
    Name.TextColor3 = isSafe and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    Name.Font = "Code"
    Name.TextSize = 16
    Name.BackgroundTransparency = 1
    Name.TextXAlignment = "Left"

    local bData = {"SEND", "AUTO", "LOOP", "STOP"}
    for i, n in ipairs(bData) do
        local B = Instance.new("TextButton", Card)
        B.Size = UDim2.new(0.2, 0, 0, 45)
        B.Position = UDim2.new(0.03 + (i-1)*0.24, 0, 0.60, 0)
        B.Text = n
        B.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
        B.TextColor3 = Color3.new(1, 1, 1)
        B.Font = "Code"
        B.TextSize = 14
        local s = Instance.new("UIStroke", B)
        s.Color = Color3.fromRGB(0, 170, 255)
        Instance.new("UICorner", B)

        B.MouseButton1Click:Connect(function()
            local val = GlobalAmt.Text
            
            if n == "SEND" then
                AddReport(string.format("🎯 КЛИК: %s | КОЛИЧЕСТВО: %s", obj.Name, val))
                InstantBurst(obj, val, "SEND")
                
            elseif n == "AUTO" then
                _G[obj.Name.."_X"] = not _G[obj.Name.."_X"]
                B.Text = _G[obj.Name.."_X"] and "⏹️" or "AUTO"
                AddReport(string.format("🔄 АВТО: %s = %s", obj.Name, _G[obj.Name.."_X"] and "ON" or "OFF"))
                
                task.spawn(function() 
                    while _G[obj.Name.."_X"] do 
                        InstantBurst(obj, val, "AUTO") 
                        task.wait(0.3) 
                    end 
                end)
                
            elseif n == "LOOP" then
                AddReport(string.format("🔁 ЦИКЛ: %s | %s раз", obj.Name, val))
                for i = 1, math.min(tonumber(val) or 10, 50) do
                    InstantBurst(obj, "1", "LOOP")
                    task.wait(0.05)
                    if i % 10 == 0 then
                        AddReport(string.format("🔄 Цикл %d/%d", i, math.min(tonumber(val) or 10, 50)))
                    end
                end
                AddReport("✅ ЦИКЛ ЗАВЕРШЁН")
                
            elseif n == "STOP" then
                _G[obj.Name.."_X"] = false
                B.Text = "AUTO"
                AddReport("⛔ ОСТАНОВЛЕНО: " .. obj.Name)
            end
        end)
    end
end

-- ПОИСК ВСЕХ РЕМОУТОВ (ВО ВСЕХ МЕСТАХ)
for _, v in pairs(game:GetDescendants()) do
    pcall(function() 
        if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and not IsSystemRobloxRemote(v) then 
            AddCard(v) 
        end 
    end)
end

-- ОБНОВЛЕНИЕ РАЗМЕРА СКРОЛЛА
game:GetService("RunService").Heartbeat:Connect(function() 
    pcall(function()
        Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
    end)
end)

-- ФИНАЛЬНЫЙ ОТЧЁТ
AddReport("🏁 СКРИПТ ЗАГРУЖЕН! Найдено ремоутов: " .. #AllCards)
print("✅ V420000 INSTANT FIXED | ПОЛНЫЙ СПИСОК | СВОРАЧИВАНИЕ ДОБАВЛЕНО")
print("📊 Теперь видны ВСЕ игровые ремоуты с полным путём!")
