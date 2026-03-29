local Kavo = {}

local tween = game:GetService("TweenService")
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local coregui = game:GetService("CoreGui")
local players = game:GetService("Players")

local Utility = {}
local Objects = {}

function Kavo:DraggingEnabled(frame, parent)
    parent = parent or frame
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    input.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function Utility:TweenObject(obj, properties, duration, style, dir)
    style = style or Enum.EasingStyle.Quart
    dir = dir or Enum.EasingDirection.Out
    local info = TweenInfo.new(duration, style, dir)
    local t = tween:Create(obj, info, properties)
    t:Play()
    return t
end

-- [ Theme Management ]
local themeList = {
    SchemeColor = Color3.fromRGB(0, 122, 255), -- iOS Blue
    Background = Color3.fromRGB(20, 20, 25),
    Header = Color3.fromRGB(28, 28, 35),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(35, 35, 45),
    SidebarColor = Color3.fromRGB(25, 25, 30),
}

local themeStyles = {
    DarkTheme = {
        SchemeColor = Color3.fromRGB(64, 64, 64),
        Background = Color3.fromRGB(15, 15, 15),
        Header = Color3.fromRGB(20, 20, 20),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(25, 25, 25)
    },
    LightTheme = {
        SchemeColor = Color3.fromRGB(150, 150, 150),
        Background = Color3.fromRGB(245, 245, 250),
        Header = Color3.fromRGB(255, 255, 255),
        TextColor = Color3.fromRGB(30, 30, 30),
        ElementColor = Color3.fromRGB(235, 235, 240)
    },
    PremiumGlass = { 
        SchemeColor = Color3.fromRGB(0, 122, 255), 
        Background = Color3.fromRGB(20, 20, 25),
        Header = Color3.fromRGB(25, 25, 32),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(32, 32, 40)
    }
}

local ThemeSignals = {}
function ThemeSignals:Subscribe(callback)
    table.insert(self, callback)
    callback(themeList)
end

function ThemeSignals:Update(newTheme)
    for k, v in pairs(newTheme) do
        themeList[k] = v
    end
    for _, cb in pairs(self) do
        if type(cb) == "function" then
            cb(themeList)
        end
    end
end

local SettingsT = {}
local Name = "KavoConfig.JSON"

pcall(function()
    if not pcall(function() readfile(Name) end) then
        writefile(Name, game:service'HttpService':JSONEncode(SettingsT))
    end
    Settings = game:service'HttpService':JSONEncode(readfile(Name))
end)

local LibName = "Kavo_" .. tostring(math.random(1000, 9999))

function Kavo:ToggleUI()
    if coregui:FindFirstChild(LibName) then
        coregui[LibName].Enabled = not coregui[LibName].Enabled
    end
end


function Kavo.CreateLib(kavName, themeList)
    if not themeList then
        themeList = themes
    end
    if themeList == "DarkTheme" then
        themeList = themeStyles.DarkTheme
    elseif themeList == "LightTheme" then
        themeList = themeStyles.LightTheme
    elseif themeList == "BloodTheme" then
        themeList = themeStyles.BloodTheme
    elseif themeList == "GrapeTheme" then
        themeList = themeStyles.GrapeTheme
    elseif themeList == "Ocean" then
        themeList = themeStyles.Ocean
    elseif themeList == "Midnight" then
        themeList = themeStyles.Midnight
    elseif themeList == "Sentinel" then
        themeList = themeStyles.Sentinel
    elseif themeList == "Synapse" then
        themeList = themeStyles.Synapse
    elseif themeList == "Serpent" then
        themeList = themeStyles.Serpent
    else
        if themeList.SchemeColor == nil then
            themeList.SchemeColor = Color3.fromRGB(74, 99, 135)
    if not themeList then
        themeList = themeStyles.PremiumGlass
    elseif type(themeList) == "string" then
        themeList = themeStyles[themeList] or themeStyles.PremiumGlass
    end

    kavName = kavName or "Library"
    local selectedTab 
    
    for i,v in pairs(coregui:GetChildren()) do
        if (v:IsA("ScreenGui") or v:IsA("CanvasGroup")) and v.Name == kavName then
            v:Destroy()
        end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = LibName
    ScreenGui.Parent = coregui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("CanvasGroup")
    local MainCorner = Instance.new("UICorner")
    local MainStroke = Instance.new("UIStroke")
    
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = themeList.Background
    Main.Position = UDim2.new(0.5, -262, 0.5, -159)
    Main.Size = UDim2.new(0, 525, 0, 318)
    Main.ClipsDescendants = true
    Main.GroupTransparency = 1 -- For fade-in

    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = Main

    MainStroke.Color = Color3.fromRGB(255, 255, 255)
    MainStroke.Transparency = 0.9
    MainStroke.Thickness = 1
    MainStroke.Parent = Main

    local MainHeader = Instance.new("Frame")
    MainHeader.Name = "MainHeader"
    MainHeader.Parent = Main
    MainHeader.BackgroundTransparency = 1
    MainHeader.Size = UDim2.new(1, 0, 0, 40)
    
    local title = Instance.new("TextLabel")
    title.Name = "title"
    title.Parent = MainHeader
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Font = Enum.Font.BuilderSansExtraBold -- Modern font
    title.Text = kavName
    title.TextColor3 = themeList.TextColor
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left

    local close = Instance.new("TextButton")
    close.Name = "close"
    close.Parent = MainHeader
    close.BackgroundColor3 = Color3.fromRGB(255, 59, 48) -- iOS Red
    close.Position = UDim2.new(1, -30, 0, 12)
    close.Size = UDim2.new(0, 16, 0, 16)
    close.Text = ""
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = close

    close.MouseButton1Click:Connect(function()
        Utility:TweenObject(Main, {GroupTransparency = 1}, 0.25)
        task.wait(0.25)
        ScreenGui:Destroy()
    end)

    local MainSide = Instance.new("Frame")
    MainSide.Name = "MainSide"
    MainSide.Parent = Main
    MainSide.BackgroundColor3 = themeList.SidebarColor or themeList.Background
    MainSide.Position = UDim2.new(0, 0, 0, 40)
    MainSide.Size = UDim2.new(0, 150, 1, -40)
    MainSide.BorderSizePixel = 0

    local tabFrames = Instance.new("ScrollingFrame")
    tabFrames.Name = "tabFrames"
    tabFrames.Parent = MainSide
    tabFrames.BackgroundTransparency = 1
    tabFrames.Position = UDim2.new(0, 5, 0, 5)
    tabFrames.Size = UDim2.new(1, -10, 1, -10)
    tabFrames.ScrollBarThickness = 0
    tabFrames.CanvasSize = UDim2.new(0, 0, 0, 0)

    local tabListing = Instance.new("UIListLayout")
    tabListing.Parent = tabFrames
    tabListing.SortOrder = Enum.SortOrder.LayoutOrder
    tabListing.Padding = UDim.new(0, 4)

    local pages = Instance.new("Frame")
    pages.Name = "pages"
    pages.Parent = Main
    pages.BackgroundTransparency = 1
    pages.Position = UDim2.new(0, 155, 0, 45)
    pages.Size = UDim2.new(1, -165, 1, -55)

    local Pages = Instance.new("Folder")
    Pages.Name = "Pages"
    Pages.Parent = pages

    local infoContainer = Instance.new("Frame")
    infoContainer.Name = "infoContainer"
    infoContainer.Parent = Main
    infoContainer.BackgroundTransparency = 1
    infoContainer.Position = UDim2.new(0, 155, 1, -35)
    infoContainer.Size = UDim2.new(1, -165, 0, 30)
    infoContainer.ClipsDescendants = true

    Kavo:DraggingEnabled(MainHeader, Main)

    -- [ Theme Subscription ]
    ThemeSignals:Subscribe(function(theme)
        Main.BackgroundColor3 = theme.Background
        title.TextColor3 = theme.TextColor
        MainSide.BackgroundColor3 = theme.SidebarColor or theme.Background
        MainStroke.Color = theme.TextColor
    end)

    -- [ Open Animation ]
    Utility:TweenObject(Main, {GroupTransparency = 0}, 0.4)

    function Kavo:ChangeColor(prope, color)
        local t = {}
        t[prope] = color
        ThemeSignals:Update(t)
    end

    local Tabs = {}
    local first = true


    function Tabs:NewTab(tabName)
        tabName = tabName or "Tab"
        local tabButton = Instance.new("TextButton")
        local UICorner = Instance.new("UICorner")
        local page = Instance.new("ScrollingFrame")
        local pageListing = Instance.new("UIListLayout")

        local function UpdateSize()
            local cS = pageListing.AbsoluteContentSize

            game.TweenService:Create(page, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                CanvasSize = UDim2.new(0,cS.X,0,cS.Y)
            }):Play()
        end

        page.Name = "Page"
        page.Parent = Pages
        page.Active = true
        page.BackgroundColor3 = themeList.Background
        page.BorderSizePixel = 0
        page.Position = UDim2.new(0, 0, -0.00371747208, 0)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 5
        page.Visible = false
        page.ScrollBarImageColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 16, themeList.SchemeColor.g * 255 - 15, themeList.SchemeColor.b * 255 - 28)

        pageListing.Name = "pageListing"
        pageListing.Parent = page
        pageListing.SortOrder = Enum.SortOrder.LayoutOrder
        pageListing.Padding = UDim.new(0, 5)

        tabButton.Name = tabName.."TabButton"
        tabButton.Parent = tabFrames
        tabButton.BackgroundColor3 = themeList.SchemeColor
        Objects[tabButton] = "SchemeColor"
        tabButton.Size = UDim2.new(0, 135, 0, 28)
        tabButton.AutoButtonColor = false
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = tabName
        tabButton.TextColor3 = themeList.TextColor
        Objects[tabButton] = "TextColor3"
        tabButton.TextSize = 14.000
        tabButton.BackgroundTransparency = 1

        if first then
            first = false
            page.Visible = true
            tabButton.BackgroundTransparency = 0
            UpdateSize()
        else
            page.Visible = false
            tabButton.BackgroundTransparency = 1
        end

        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = tabButton
        table.insert(Tabs, tabName)

        UpdateSize()
        page.ChildAdded:Connect(UpdateSize)
        page.ChildRemoved:Connect(UpdateSize)

        tabButton.MouseButton1Click:Connect(function()
            for i,v in next, Pages:GetChildren() do
                v.Visible = false
            end
            page.Visible = true
            for i,v in next, tabFrames:GetChildren() do
                if v:IsA("TextButton") then
                    Utility:TweenObject(v, {BackgroundTransparency = 1, TextTransparency = 0.3}, 0.2)
                end
            end
            Utility:TweenObject(tabButton, {BackgroundTransparency = 0, TextTransparency = 0}, 0.2)
            UpdateSize()
        end)

        local Sections = {}
        local focusing = false
        local viewDe = false

        ThemeSignals:Subscribe(function(theme)
            page.BackgroundColor3 = theme.Background
            page.ScrollBarImageColor3 = theme.SchemeColor
            tabButton.TextColor3 = theme.TextColor
            tabButton.BackgroundColor3 = theme.SchemeColor
        end)
    
        function Sections:NewSection(secName, hidden)
            secName = secName or "Section"
            local sectionFunctions = {}
            local modules = {}
            
            local sectionFrame = Instance.new("Frame")
            local sectionlistoknvm = Instance.new("UIListLayout")
            local sectionHead = Instance.new("Frame")
            local sectionName = Instance.new("TextLabel")
            local sectionInners = Instance.new("Frame")
            local sectionElListing = Instance.new("UIListLayout")
            
            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = page
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.Size = UDim2.new(1, 0, 0, 40)
            
            sectionlistoknvm.Name = "sectionlistoknvm"
            sectionlistoknvm.Parent = sectionFrame
            sectionlistoknvm.SortOrder = Enum.SortOrder.LayoutOrder
            sectionlistoknvm.Padding = UDim.new(0, 5)

            sectionHead.Name = "sectionHead"
            sectionHead.Parent = sectionFrame
            sectionHead.BackgroundTransparency = 1
            sectionHead.Size = UDim2.new(1, 0, 0, 30)
            sectionHead.Visible = not hidden

            sectionName.Name = "sectionName"
            sectionName.Parent = sectionHead
            sectionName.BackgroundTransparency = 1
            sectionName.Position = UDim2.new(0, 5, 0, 0)
            sectionName.Size = UDim2.new(1, -10, 1, 0)
            sectionName.Font = Enum.Font.BuilderSansBold
            sectionName.Text = secName:upper()
            sectionName.TextColor3 = themeList.TextColor
            sectionName.TextSize = 13
            sectionName.TextXAlignment = Enum.TextXAlignment.Left
            sectionName.TextTransparency = 0.4
               
            sectionInners.Name = "sectionInners"
            sectionInners.Parent = sectionFrame
            sectionInners.BackgroundTransparency = 1
            sectionInners.Size = UDim2.new(1, 0, 0, 0)

            sectionElListing.Name = "sectionElListing"
            sectionElListing.Parent = sectionInners
            sectionElListing.SortOrder = Enum.SortOrder.LayoutOrder
            sectionElListing.Padding = UDim.new(0, 6)

            local function updateSectionFrame()
                local innerSc = sectionElListing.AbsoluteContentSize
                sectionInners.Size = UDim2.new(1, 0, 0, innerSc.Y)
                local frameSc = sectionlistoknvm.AbsoluteContentSize
                sectionFrame.Size = UDim2.new(1, 0, 0, frameSc.Y)
                UpdateSize()
            end

            sectionElListing:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionFrame)
            sectionlistoknvm:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateSectionFrame)

            ThemeSignals:Subscribe(function(theme)
                sectionName.TextColor3 = theme.TextColor
            end)

            local Elements = {}

            function Elements:NewButton(bname, tipINf, callback)
                local ButtonFunction = {}
                tipINf = tipINf or "Tip: Clicking this will trigger an action."
                bname = bname or "Button"
                callback = callback or function() end

                local buttonElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local UIStroke = Instance.new("UIStroke")
                local btnInfo = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")

                buttonElement.Name = bname
                buttonElement.Parent = sectionInners
                buttonElement.BackgroundColor3 = themeList.ElementColor
                buttonElement.Size = UDim2.new(1, 0, 0, 38)
                buttonElement.AutoButtonColor = false
                buttonElement.Text = ""

                UICorner.CornerRadius = UDim.new(0, 8)
                UICorner.Parent = buttonElement

                UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                UIStroke.Color = Color3.fromRGB(255, 255, 255)
                UIStroke.Transparency = 0.95
                UIStroke.Parent = buttonElement

                btnInfo.Name = "btnInfo"
                btnInfo.Parent = buttonElement
                btnInfo.BackgroundTransparency = 1
                btnInfo.Position = UDim2.new(0, 12, 0, 0)
                btnInfo.Size = UDim2.new(1, -40, 1, 0)
                btnInfo.Font = Enum.Font.BuilderSansSemibold
                btnInfo.Text = bname
                btnInfo.TextColor3 = themeList.TextColor
                btnInfo.TextSize = 14
                btnInfo.TextXAlignment = Enum.TextXAlignment.Left

                viewInfo.Name = "viewInfo"
                viewInfo.Parent = buttonElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(1, -30, 0.5, -9)
                viewInfo.Size = UDim2.new(0, 18, 0, 18)
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                viewInfo.ImageTransparency = 0.6

                local moreInfo = Instance.new("TextLabel")
                local infoCorner = Instance.new("UICorner")
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = themeList.SchemeColor
                moreInfo.Position = UDim2.new(0, 0, 1, 0)
                moreInfo.Size = UDim2.new(1, 0, 1, 0)
                moreInfo.Font = Enum.Font.BuilderSansMedium
                moreInfo.Text = "  " .. tipINf
                moreInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
                moreInfo.TextSize = 13
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                infoCorner.CornerRadius = UDim.new(0, 6)
                infoCorner.Parent = moreInfo

                buttonElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        callback()
                        Utility:TweenObject(buttonElement, {BackgroundColor3 = themeList.SchemeColor}, 0.1, Enum.EasingStyle.Linear)
                        task.wait(0.1)
                        Utility:TweenObject(buttonElement, {BackgroundColor3 = themeList.ElementColor}, 0.2, Enum.EasingStyle.Linear)
                    else
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 1, 0)}, 0.2)
                        focusing = false
                    end
                end)

                buttonElement.MouseEnter:Connect(function()
                    if not focusing then
                        Utility:TweenObject(buttonElement, {BackgroundTransparency = 0.2}, 0.2)
                    end
                end)
                buttonElement.MouseLeave:Connect(function()
                    if not focusing then
                        Utility:TweenObject(buttonElement, {BackgroundTransparency = 0}, 0.2)
                    end
                end)

                viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                        task.wait(2)
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 1, 0)}, 0.2)
                        focusing = false
                        viewDe = false
                    end
                end)

                ThemeSignals:Subscribe(function(theme)
                    buttonElement.BackgroundColor3 = theme.ElementColor
                    btnInfo.TextColor3 = theme.TextColor
                    viewInfo.ImageColor3 = theme.SchemeColor
                    moreInfo.BackgroundColor3 = theme.SchemeColor
                end)
                
                function ButtonFunction:UpdateButton(newTitle)
                    btnInfo.Text = newTitle
                end
                return ButtonFunction
            end

            function Elements:NewTextBox(tname, tTip, callback)
                tname = tname or "Textbox"
                tTip = tTip or "Input text here"
                callback = callback or function() end

                local textboxElement = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local UIStroke = Instance.new("UIStroke")
                local togName = Instance.new("TextLabel")
                local TextBox = Instance.new("TextBox")
                local boxCorner = Instance.new("UICorner")
                local boxStroke = Instance.new("UIStroke")

                textboxElement.Name = tname
                textboxElement.Parent = sectionInners
                textboxElement.BackgroundColor3 = themeList.ElementColor
                textboxElement.Size = UDim2.new(1, 0, 0, 42)

                UICorner.CornerRadius = UDim.new(0, 8)
                UICorner.Parent = textboxElement

                UIStroke.Transparency = 0.95
                UIStroke.Parent = textboxElement

                togName.Name = "togName"
                togName.Parent = textboxElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0, 12, 0, 0)
                togName.Size = UDim2.new(0.4, 0, 1, 0)
                togName.Font = Enum.Font.BuilderSansSemibold
                togName.Text = tname
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left

                TextBox.Parent = textboxElement
                TextBox.BackgroundColor3 = themeList.Background
                TextBox.Position = UDim2.new(1, -140, 0.5, -12)
                TextBox.Size = UDim2.new(0, 130, 0, 24)
                TextBox.Font = Enum.Font.BuilderSans
                TextBox.PlaceholderText = "..."
                TextBox.Text = ""
                TextBox.TextColor3 = themeList.TextColor
                TextBox.TextSize = 12
                TextBox.ClipsDescendants = true

                boxCorner.CornerRadius = UDim.new(0, 6)
                boxCorner.Parent = TextBox
                boxStroke.Transparency = 0.8
                boxStroke.Color = themeList.SchemeColor
                boxStroke.Parent = TextBox

                TextBox.FocusLost:Connect(function(EnterPressed)
                    if EnterPressed then
                        callback(TextBox.Text)
                        TextBox.Text = ""
                    end
                end)

                ThemeSignals:Subscribe(function(theme)
                    textboxElement.BackgroundColor3 = theme.ElementColor
                    togName.TextColor3 = theme.TextColor
                    TextBox.BackgroundColor3 = theme.Background
                    TextBox.TextColor3 = theme.TextColor
                    boxStroke.Color = theme.SchemeColor
                end)
            end

            function Elements:NewToggle(tname, nTip, callback)
                local TogFunction = {}
                tname = tname or "Toggle"
                nTip = nTip or "Toggles an option"
                callback = callback or function() end
                local toggled = false

                local toggleElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local UIStroke = Instance.new("UIStroke")
                local togName = Instance.new("TextLabel")
                local switch = Instance.new("Frame")
                local switchCorner = Instance.new("UICorner")
                local knob = Instance.new("Frame")
                local knobCorner = Instance.new("UICorner")

                toggleElement.Name = tname
                toggleElement.Parent = sectionInners
                toggleElement.BackgroundColor3 = themeList.ElementColor
                toggleElement.Size = UDim2.new(1, 0, 0, 38)
                toggleElement.AutoButtonColor = false
                toggleElement.Text = ""

                UICorner.CornerRadius = UDim.new(0, 8)
                UICorner.Parent = toggleElement
                UIStroke.Transparency = 0.95
                UIStroke.Parent = toggleElement

                togName.Name = "togName"
                togName.Parent = toggleElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0, 12, 0, 0)
                togName.Size = UDim2.new(1, -60, 1, 0)
                togName.Font = Enum.Font.BuilderSansSemibold
                togName.Text = tname
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left

                switch.Name = "switch"
                switch.Parent = toggleElement
                switch.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                switch.Position = UDim2.new(1, -45, 0.5, -10)
                switch.Size = UDim2.new(0, 34, 0, 20)
                switchCorner.CornerRadius = UDim.new(1, 0)
                switchCorner.Parent = switch

                knob.Name = "knob"
                knob.Parent = switch
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                knob.Position = UDim2.new(0, 2, 0.5, -8)
                knob.Size = UDim2.new(0, 16, 0, 16)
                knobCorner.CornerRadius = UDim.new(1, 0)
                knobCorner.Parent = knob

                local function toggle(state)
                    toggled = state
                    if toggled then
                        Utility:TweenObject(switch, {BackgroundColor3 = themeList.SchemeColor}, 0.2)
                        Utility:TweenObject(knob, {Position = UDim2.new(0, 16, 0.5, -8)}, 0.2)
                    else
                        Utility:TweenObject(switch, {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}, 0.2)
                        Utility:TweenObject(knob, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
                    end
                    pcall(callback, toggled)
                end

                toggleElement.MouseButton1Click:Connect(function()
                    toggle(not toggled)
                end)

                ThemeSignals:Subscribe(function(theme)
                    toggleElement.BackgroundColor3 = theme.ElementColor
                    togName.TextColor3 = theme.TextColor
                    if toggled then switch.BackgroundColor3 = theme.SchemeColor end
                end)

                function TogFunction:UpdateToggle(text, state)
                    if text then togName.Text = text end
                    if state ~= nil then toggle(state) end
                end
                return TogFunction
            end

            function Elements:NewSlider(slidInf, slidTip, maxvalue, minvalue, callback)
                slidInf = slidInf or "Slider"
                maxvalue = maxvalue or 100
                minvalue = minvalue or 0
                callback = callback or function() end

                local sliderElement = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local UIStroke = Instance.new("UIStroke")
                local togName = Instance.new("TextLabel")
                local sliderBtn = Instance.new("TextButton")
                local sliderDrag = Instance.new("Frame")
                local dragCorner = Instance.new("UICorner")
                local knob = Instance.new("Frame")
                local knobCorner = Instance.new("UICorner")
                local valLabel = Instance.new("TextLabel")

                sliderElement.Name = slidInf
                sliderElement.Parent = sectionInners
                sliderElement.BackgroundColor3 = themeList.ElementColor
                sliderElement.Size = UDim2.new(1, 0, 0, 48)

                UICorner.CornerRadius = UDim.new(0, 8)
                UICorner.Parent = sliderElement
                UIStroke.Transparency = 0.95
                UIStroke.Parent = sliderElement

                togName.Name = "togName"
                togName.Parent = sliderElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0, 12, 0, 8)
                togName.Size = UDim2.new(0.5, 0, 0, 14)
                togName.Font = Enum.Font.BuilderSansSemibold
                togName.Text = slidInf
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 13
                togName.TextXAlignment = Enum.TextXAlignment.Left

                valLabel.Name = "valLabel"
                valLabel.Parent = sliderElement
                valLabel.BackgroundTransparency = 1
                valLabel.Position = UDim2.new(1, -50, 0, 8)
                valLabel.Size = UDim2.new(0, 40, 0, 14)
                valLabel.Font = Enum.Font.BuilderSansMedium
                valLabel.Text = tostring(minvalue)
                valLabel.TextColor3 = themeList.TextColor
                valLabel.TextSize = 12
                valLabel.TextXAlignment = Enum.TextXAlignment.Right

                sliderBtn.Name = "sliderBtn"
                sliderBtn.Parent = sliderElement
                sliderBtn.BackgroundTransparency = 1
                sliderBtn.Position = UDim2.new(0, 12, 0, 32)
                sliderBtn.Size = UDim2.new(1, -24, 0, 4)
                sliderBtn.Text = ""

                local sliderBack = Instance.new("Frame")
                sliderBack.Parent = sliderBtn
                sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                sliderBack.Size = UDim2.new(1, 0, 1, 0)
                Instance.new("UICorner", sliderBack).CornerRadius = UDim.new(1, 0)

                sliderDrag.Name = "sliderDrag"
                sliderDrag.Parent = sliderBack
                sliderDrag.BackgroundColor3 = themeList.SchemeColor
                sliderDrag.Size = UDim2.new(0, 0, 1, 0)
                dragCorner.CornerRadius = UDim.new(1, 0)
                dragCorner.Parent = sliderDrag

                knob.Name = "knob"
                knob.Parent = sliderDrag
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                knob.Position = UDim2.new(1, -6, 0.5, -6)
                knob.Size = UDim2.new(0, 12, 0, 12)
                knobCorner.CornerRadius = UDim.new(1, 0)
                knobCorner.Parent = knob

                local dragging = false
                local function update(input)
                    local pos = math.clamp((input.Position.X - sliderBtn.AbsolutePosition.X) / sliderBtn.AbsoluteSize.X, 0, 1)
                    local val = math.floor(minvalue + (maxvalue - minvalue) * pos)
                    valLabel.Text = tostring(val)
                    sliderDrag.Size = UDim2.new(pos, 0, 1, 0)
                    pcall(callback, val)
                end

                sliderBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        update(input)
                    end
                end)

                input.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        update(input)
                    end
                end)

                input.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                ThemeSignals:Subscribe(function(theme)
                    sliderElement.BackgroundColor3 = theme.ElementColor
                    togName.TextColor3 = theme.TextColor
                    valLabel.TextColor3 = theme.TextColor
                    sliderDrag.BackgroundColor3 = theme.SchemeColor
                end)
            end

            function Elements:NewDropdown(dropname, dropinf, list, callback)
                local DropFunction = {}
                list = list or {}
                callback = callback or function() end
                local opened = false

                local dropFrame = Instance.new("Frame")
                local dropOpen = Instance.new("TextButton")
                local togName = Instance.new("TextLabel")
                local chevron = Instance.new("ImageLabel")
                local container = Instance.new("Frame")
                local containerList = Instance.new("UIListLayout")

                dropFrame.Name = dropname
                dropFrame.Parent = sectionInners
                dropFrame.BackgroundColor3 = themeList.ElementColor
                dropFrame.ClipsDescendants = true
                dropFrame.Size = UDim2.new(1, 0, 0, 38)
                Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 8)
                Instance.new("UIStroke", dropFrame).Transparency = 0.95

                dropOpen.Name = "dropOpen"
                dropOpen.Parent = dropFrame
                dropOpen.BackgroundTransparency = 1
                dropOpen.Size = UDim2.new(1, 0, 0, 38)
                dropOpen.Text = ""

                togName.Name = "togName"
                togName.Parent = dropOpen
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0, 12, 0, 0)
                togName.Size = UDim2.new(1, -40, 1, 0)
                togName.Font = Enum.Font.BuilderSansSemibold
                togName.Text = dropname
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left

                chevron.Name = "chevron"
                chevron.Parent = dropOpen
                chevron.BackgroundTransparency = 1
                chevron.Position = UDim2.new(1, -30, 0.5, -9)
                chevron.Size = UDim2.new(0, 18, 0, 18)
                chevron.Image = "rbxassetid://3926305904"
                chevron.ImageRectOffset = Vector2.new(524, 764)
                chevron.ImageRectSize = Vector2.new(36, 36)
                chevron.ImageTransparency = 0.6

                container.Name = "container"
                container.Parent = dropFrame
                container.BackgroundTransparency = 1
                container.Position = UDim2.new(0, 10, 0, 38)
                container.Size = UDim2.new(1, -20, 0, 0)

                containerList.Parent = container
                containerList.Padding = UDim.new(0, 4)

                local function refresh()
                    for _, v in pairs(container:GetChildren()) do
                        if v:IsA("TextButton") then v:Destroy() end
                    end
                    for _, val in pairs(list) do
                        local item = Instance.new("TextButton")
                        item.Name = val
                        item.Parent = container
                        item.BackgroundColor3 = themeList.Background
                        item.Size = UDim2.new(1, 0, 0, 30)
                        item.Font = Enum.Font.BuilderSans
                        item.Text = "  " .. val
                        item.TextColor3 = themeList.TextColor
                        item.TextSize = 13
                        item.TextXAlignment = Enum.TextXAlignment.Left
                        Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)
                        
                        item.MouseButton1Click:Connect(function()
                            togName.Text = dropname .. ": " .. val
                            callback(val)
                            opened = false
                            Utility:TweenObject(dropFrame, {Size = UDim2.new(1, 0, 0, 38)}, 0.2)
                            Utility:TweenObject(chevron, {Rotation = 0}, 0.2)
                        end)
                    end
                end

                dropOpen.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        Utility:TweenObject(dropFrame, {Size = UDim2.new(1, 0, 0, 38 + containerList.AbsoluteContentSize.Y + 10)}, 0.2)
                        Utility:TweenObject(chevron, {Rotation = 180}, 0.2)
                    else
                        Utility:TweenObject(dropFrame, {Size = UDim2.new(1, 0, 0, 38)}, 0.2)
                        Utility:TweenObject(chevron, {Rotation = 0}, 0.2)
                    end
                end)

                refresh()

                ThemeSignals:Subscribe(function(theme)
                    dropFrame.BackgroundColor3 = theme.ElementColor
                    togName.TextColor3 = theme.TextColor
                    chevron.ImageColor3 = theme.SchemeColor
                end)
            end 
            function Elements:NewKeybind(keytext, keyinf, first, callback)
                keytext = keytext or "KeybindText"
                keyinf = keyinf or "KebindInfo"
                callback = callback or function() end
                local oldKey = first.Name
                local keybindElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local togName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local touch = Instance.new("ImageLabel")
                local Sample = Instance.new("ImageLabel")
                local togName_2 = Instance.new("TextLabel")

                local ms = game.Players.LocalPlayer:GetMouse()
                local uis = game:GetService("UserInputService")
                local infBtn = viewInfo

                local moreInfo = Instance.new("TextLabel")
                local UICorner1 = Instance.new("UICorner")

                local sample = Sample

                keybindElement.Name = "keybindElement"
                keybindElement.Parent = sectionInners
                keybindElement.BackgroundColor3 = themeList.ElementColor
                keybindElement.ClipsDescendants = true
                keybindElement.Size = UDim2.new(0, 352, 0, 33)
                keybindElement.AutoButtonColor = false
                keybindElement.Font = Enum.Font.SourceSans
                keybindElement.Text = ""
                keybindElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                keybindElement.TextSize = 14.000
                keybindElement.MouseButton1Click:connect(function(e) 
                    if not focusing then
                        togName_2.Text = ". . ."
                        local a, b = game:GetService('UserInputService').InputBegan:wait();
                        if a.KeyCode.Name ~= "Unknown" then
                            togName_2.Text = a.KeyCode.Name
                            oldKey = a.KeyCode.Name;
                        end
                        local c = sample:Clone()
                        c.Parent = keybindElement
                        local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                        c.Position = UDim2.new(0, x, 0, y)
                        local len, size = 0.35, nil
                        if keybindElement.AbsoluteSize.X >= keybindElement.AbsoluteSize.Y then
                            size = (keybindElement.AbsoluteSize.X * 1.5)
                        else
                            size = (keybindElement.AbsoluteSize.Y * 1.5)
                        end
                        c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
                        for i = 1, 10 do
                        c.ImageTransparency = c.ImageTransparency + 0.05
                            wait(len / 12)
                        end
                    else
                        for i,v in next, infoContainer:GetChildren() do
                            Utility:TweenObject(v, {Position = UDim2.new(0,0,2,0)}, 0.2)
                            focusing = false
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                    end
                end)
        
                game:GetService("UserInputService").InputBegan:connect(function(current, ok) 
                    if not ok then 
                        if current.KeyCode.Name == oldKey then 
                            callback()
                        end
                    end
                end)

                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.r * 255 - 14, themeList.SchemeColor.g * 255 - 17, themeList.SchemeColor.b * 255 - 13)
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.RichText = true
                moreInfo.Font = Enum.Font.GothamSemibold
                moreInfo.Text = "  "..keyinf
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14.000
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left

                Sample.Name = "Sample"
                Sample.Parent = keybindElement
                Sample.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Sample.BackgroundTransparency = 1.000
                Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
                Sample.ImageColor3 = themeList.SchemeColor
                Sample.ImageTransparency = 0.600

                
                togName.Name = "togName"
                togName.Parent = keybindElement
                togName.BackgroundColor3 = themeList.TextColor
                togName.BackgroundTransparency = 1.000
                togName.Position = UDim2.new(0.096704483, 0, 0.272727281, 0)
                togName.Size = UDim2.new(0, 222, 0, 14)
                togName.Font = Enum.Font.GothamSemibold
                togName.Text = keytext
                togName.RichText = true
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14.000
                togName.TextXAlignment = Enum.TextXAlignment.Left

                viewInfo.Name = "viewInfo"
            function Elements:NewKeybind(keytext, keyinf, first, callback)
                keytext = keytext or "Keybind"
                keyinf = keyinf or "Press a key"
                callback = callback or function() end
                local oldKey = first.Name

                local keybindElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local UIStroke = Instance.new("UIStroke")
                local togName = Instance.new("TextLabel")
                local viewBind = Instance.new("TextLabel")

                keybindElement.Name = keytext
                keybindElement.Parent = sectionInners
                keybindElement.BackgroundColor3 = themeList.ElementColor
                keybindElement.Size = UDim2.new(1, 0, 0, 38)
                keybindElement.AutoButtonColor = false
                keybindElement.Text = ""

                UICorner.CornerRadius = UDim.new(0, 8)
                UICorner.Parent = keybindElement
                UIStroke.Transparency = 0.95
                UIStroke.Parent = keybindElement

                togName.Name = "togName"
                togName.Parent = keybindElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0, 12, 0, 0)
                togName.Size = UDim2.new(1, -100, 1, 0)
                togName.Font = Enum.Font.BuilderSansSemibold
                togName.Text = keytext
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left

                viewBind.Name = "viewBind"
                viewBind.Parent = keybindElement
                viewBind.BackgroundTransparency = 1
                viewBind.Position = UDim2.new(1, -95, 0, 0)
                viewBind.Size = UDim2.new(0, 80, 1, 0)
                viewBind.Font = Enum.Font.BuilderSansMedium
                viewBind.Text = oldKey
                viewBind.TextColor3 = themeList.SchemeColor
                viewBind.TextSize = 14
                viewBind.TextXAlignment = Enum.TextXAlignment.Right

                keybindElement.MouseButton1Click:Connect(function()
                    viewBind.Text = "..."
                    local inputwait = game:GetService("UserInputService").InputBegan:wait()
                    if inputwait.UserInputType == Enum.UserInputType.Keyboard then
                        viewBind.Text = inputwait.KeyCode.Name
                        oldKey = inputwait.KeyCode.Name
                        callback(inputwait.KeyCode)
                    end
                end)

                game:GetService("UserInputService").InputBegan:Connect(function(current, ok)
                    if not ok and current.KeyCode.Name == oldKey then
                        callback(current.KeyCode)
                    end
                end)

                ThemeSignals:Subscribe(function(theme)
                    keybindElement.BackgroundColor3 = theme.ElementColor
                    togName.TextColor3 = theme.TextColor
                    viewBind.TextColor3 = theme.SchemeColor
                end)
            end

            function Elements:NewColorPicker(colText, colInf, defcolor, callback)
                local ColorFunction = {}
                colText = colText or "Color Picker"
                defcolor = defcolor or Color3.fromRGB(255, 255, 255)
                callback = callback or function() end
                
                local h, s, v = Color3.toHSV(defcolor)
                local colorOpened = false

                local colorElement = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local UIStroke = Instance.new("UIStroke")
                local colorHeader = Instance.new("TextButton")
                local togName = Instance.new("TextLabel")
                local colorPreview = Instance.new("Frame")
                local previewCorner = Instance.new("UICorner")
                local colorInners = Instance.new("Frame")
                local rgbMap = Instance.new("ImageButton")
                local darknessMap = Instance.new("ImageButton")
                local cursor = Instance.new("Frame")
                local cursor2 = Instance.new("Frame")

                colorElement.Name = colText
                colorElement.Parent = sectionInners
                colorElement.BackgroundColor3 = themeList.ElementColor
                colorElement.ClipsDescendants = true
                colorElement.Size = UDim2.new(1, 0, 0, 38)
                UICorner.CornerRadius = UDim.new(0, 8)
                UICorner.Parent = colorElement
                UIStroke.Transparency = 0.95
                UIStroke.Parent = colorElement

                colorHeader.Name = "colorHeader"
                colorHeader.Parent = colorElement
                colorHeader.BackgroundTransparency = 1
                colorHeader.Size = UDim2.new(1, 0, 0, 38)
                colorHeader.Text = ""

                togName.Name = "togName"
                togName.Parent = colorHeader
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0, 12, 0, 0)
                togName.Size = UDim2.new(1, -60, 1, 0)
                togName.Font = Enum.Font.BuilderSansSemibold
                togName.Text = colText
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left

                colorPreview.Name = "colorPreview"
                colorPreview.Parent = colorHeader
                colorPreview.BackgroundColor3 = defcolor
                colorPreview.Position = UDim2.new(1, -45, 0.5, -9)
                colorPreview.Size = UDim2.new(0, 30, 0, 18)
                previewCorner.CornerRadius = UDim.new(0, 4)
                previewCorner.Parent = colorPreview

                colorInners.Name = "colorInners"
                colorInners.Parent = colorElement
                colorInners.BackgroundTransparency = 1
                colorInners.Position = UDim2.new(0, 10, 0, 38)
                colorInners.Size = UDim2.new(1, -20, 0, 100)

                rgbMap.Name = "rgbMap"
                rgbMap.Parent = colorInners
                rgbMap.Image = "rbxassetid://4155801252"
                rgbMap.Size = UDim2.new(1, -25, 1, 0)
                Instance.new("UICorner", rgbMap).CornerRadius = UDim.new(0, 6)

                darknessMap.Name = "darknessMap"
                darknessMap.Parent = colorInners
                darknessMap.Image = "rbxassetid://4155801252"
                darknessMap.ImageColor3 = Color3.new(0, 0, 0)
                darknessMap.Position = UDim2.new(1, -18, 0, 0)
                darknessMap.Size = UDim2.new(0, 18, 1, 0)
                Instance.new("UICorner", darknessMap).CornerRadius = UDim.new(0, 6)

                cursor.Size = UDim2.new(0, 8, 0, 8)
                cursor.BackgroundColor3 = Color3.new(1, 1, 1)
                cursor.Parent = rgbMap
                Instance.new("UICorner", cursor).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", cursor).Thickness = 1

                cursor2.Size = UDim2.new(1, 0, 0, 4)
                cursor2.BackgroundColor3 = Color3.new(1, 1, 1)
                cursor2.Parent = darknessMap
                Instance.new("UIStroke", cursor2).Thickness = 1

                local function updateColor()
                    local realColor = Color3.fromHSV(h, s, v)
                    colorPreview.BackgroundColor3 = realColor
                    rgbMap.ImageColor3 = Color3.fromHSV(h, 1, 1)
                    callback(realColor)
                end

                colorHeader.MouseButton1Click:Connect(function()
                    colorOpened = not colorOpened
                    Utility:TweenObject(colorElement, {Size = UDim2.new(1, 0, 0, colorOpened and 150 or 38)}, 0.2)
                end)

                -- Basic picking logic (simplified for implementation)
                rgbMap.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local function move(input)
                            local x = math.clamp((input.Position.X - rgbMap.AbsolutePosition.X) / rgbMap.AbsoluteSize.X, 0, 1)
                            local y = math.clamp((input.Position.Y - rgbMap.AbsolutePosition.Y) / rgbMap.AbsoluteSize.Y, 0, 1)
                            h, s = x, 1 - y
                            cursor.Position = UDim2.new(x, -4, y, -4)
                            updateColor()
                        end
                        local conn; conn = input.InputChanged:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseMovement then move(input) end
                        end)
                        input.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then conn:Disconnect() end
                        end)
                        move(input)
                    end
                end)

                ThemeSignals:Subscribe(function(theme)
                    colorElement.BackgroundColor3 = theme.ElementColor
                    togName.TextColor3 = theme.TextColor
                end)
            end

            function Elements:NewLabel(title)
                local labelFunctions = {}
                local label = Instance.new("Frame")
                local text = Instance.new("TextLabel")

                label.Name = title
                label.Parent = sectionInners
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, 0, 0, 30)

                text.Name = "text"
                text.Parent = label
                text.BackgroundTransparency = 1
                text.Size = UDim2.new(1, 0, 1, 0)
                text.Font = Enum.Font.BuilderSansMedium
                text.Text = title
                text.TextColor3 = themeList.TextColor
                text.TextSize = 14
                text.TextXAlignment = Enum.TextXAlignment.Left

                ThemeSignals:Subscribe(function(theme)
                    text.TextColor3 = theme.TextColor
                end)

                function labelFunctions:UpdateLabel(newText)
                    text.Text = newText
                end
                return labelFunctions
            end

            return Elements
        end
        return Sections
    end
    return Tabs
end
return Kavo

