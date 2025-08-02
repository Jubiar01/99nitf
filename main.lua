local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

wait(2)

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
if not PlayerGui then
    warn("PlayerGui not found!")
    return
end

local TreeAura, KillAura, BringItems

local function loadModules()
    print("Loading modules...")
    
    TreeAura = {
        toggle = function() return false end,
        stop = function() end,
        setDistance = function() end,
        getDistance = function() return 86 end,
        setDelay = function() end,
        getDelay = function() return 0.1 end,
        isEnabled = function() return false end,
        setMaxTreesPerCycle = function() end,
        getMaxTreesPerCycle = function() return 3 end,
        setAutoCollectLogs = function() end,
        getAutoCollectLogs = function() return true end
    }
    
    KillAura = {
        toggle = function() return false end,
        stop = function() end,
        setDistance = function() end,
        getDistance = function() return 80 end,
        isEnabled = function() return false end
    }
    
    BringItems = {
        bringSelected = function() return false end,
        bringAll = function() return false end,
        setSelectedItem = function() end,
        getSelectedItem = function() return "Log" end,
        refreshItems = function() return {"Log", "Stone", "Stick"} end,
        getAvailableItems = function() return {"Log", "Stone", "Stick"} end,
        setAutoStore = function() end,
        getAutoStore = function() return false end,
        storeAllNearbyItems = function() return false end,
        isEnabled = function() return false end,
        toggle = function() return false end,
        stop = function() end
    }
    
    local success1, treeModule = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Jubiar01/99nitf/refs/heads/main/tree.lua"))()
    end)
    
    local success2, killModule = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Jubiar01/99nitf/refs/heads/main/kill.lua"))()
    end)
    
    local success3, bringModule = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Jubiar01/99nitf/refs/heads/main/bring.lua"))()
    end)
    
    if success1 and treeModule then
        TreeAura = treeModule
        print("✅ Tree Aura module loaded!")
    else
        print("❌ Failed to load Tree Aura module - using fallback")
    end
    
    if success2 and killModule then
        KillAura = killModule
        print("✅ Kill Aura module loaded!")
    else
        print("❌ Failed to load Kill Aura module - using fallback")
    end
    
    if success3 and bringModule then
        BringItems = bringModule
        print("✅ Bring Items module loaded!")
    else
        print("❌ Failed to load Bring Items module - using fallback")
    end
    
    print("Modules loading complete!")
    return true
end

local function createRayfieldGUI()
    print("Creating Rayfield UI...")
    
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    
    local Window = Rayfield:CreateWindow({
        Name = "🎯 Aura Farm Pro v7.0",
        LoadingTitle = "Aura Farm Pro",
        LoadingSubtitle = "Complete Automation Suite",
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "AuraFarmPro",
            FileName = "config"
        },
        Discord = {
            Enabled = false,
            Invite = "noinvitelink",
            RememberJoins = true
        },
        KeySystem = false
    })
    
    local TreeTab = Window:CreateTab("🌳 Tree Farm", 4483345998)
    local KillTab = Window:CreateTab("⚔️ Kill Aura", 4483345998)
    local BringTab = Window:CreateTab("📦 Bring Items", 4483345998)
    local SettingsTab = Window:CreateTab("⚙️ Settings", 4483345998)
    
    local AutoStoreToggle
    
    TreeTab:CreateSection("Tree Farm Controls")
    
    local TreeToggle = TreeTab:CreateToggle({
        Name = "Auto Farm Trees",
        CurrentValue = false,
        Flag = "AutoFarmTreeToggle",
        Callback = function(Value)
            if TreeAura then
                if Value then
                    TreeAura.toggle()
                    Rayfield:Notify({
                        Title = "Tree Farm",
                        Content = "🟢 Auto Tree Farming Enabled!",
                        Duration = 3,
                        Image = 4483345998
                    })
                else
                    TreeAura.stop()
                    Rayfield:Notify({
                        Title = "Tree Farm",
                        Content = "🔴 Auto Tree Farming Disabled!",
                        Duration = 3,
                        Image = 4483345998
                    })
                end
            end
        end,
    })
    
    local TreeDistanceSlider = TreeTab:CreateSlider({
        Name = "Farm Distance",
        Range = {10, 200},
        Increment = 1,
        Suffix = "studs",
        CurrentValue = 86,
        Flag = "TreeDistance",
        Callback = function(Value)
            if TreeAura and TreeAura.setDistance then
                TreeAura.setDistance(Value)
            end
        end,
    })
    
    local TreeDelaySlider = TreeTab:CreateSlider({
        Name = "Chopping Delay",
        Range = {0.1, 2},
        Increment = 0.1,
        Suffix = "seconds",
        CurrentValue = 0.1,
        Flag = "TreeDelay",
        Callback = function(Value)
            if TreeAura and TreeAura.setDelay then
                TreeAura.setDelay(Value)
            end
        end,
    })
    
    local MaxTreesSlider = TreeTab:CreateSlider({
        Name = "Trees Per Cycle",
        Range = {1, 10},
        Increment = 1,
        Suffix = "trees",
        CurrentValue = 3,
        Flag = "MaxTrees",
        Callback = function(Value)
            if TreeAura and TreeAura.setMaxTreesPerCycle then
                TreeAura.setMaxTreesPerCycle(Value)
            end
        end,
    })
    
    local AutoCollectToggle = TreeTab:CreateToggle({
        Name = "Auto Collect Logs",
        CurrentValue = true,
        Flag = "AutoCollectLogs",
        Callback = function(Value)
            if TreeAura and TreeAura.setAutoCollectLogs then
                TreeAura.setAutoCollectLogs(Value)
            end
        end,
    })
    
    TreeTab:CreateParagraph({
        Title = "Enhanced Tree Farming",
        Content = "Automatically farms trees from both Foliage and Landmarks folders. Supports Small Trees and auto log collection."
    })
    
    KillTab:CreateSection("Kill Aura Controls")
    
    local KillToggle = KillTab:CreateToggle({
        Name = "Enable Kill Aura",
        CurrentValue = false,
        Flag = "KillAuraToggle",
        Callback = function(Value)
            if KillAura then
                if Value then
                    KillAura.toggle()
                    Rayfield:Notify({
                        Title = "Kill Aura",
                        Content = "🟢 Kill Aura Enabled!",
                        Duration = 3,
                        Image = 4483345998
                    })
                else
                    KillAura.stop()
                    Rayfield:Notify({
                        Title = "Kill Aura",
                        Content = "🔴 Kill Aura Disabled!",
                        Duration = 3,
                        Image = 4483345998
                    })
                end
            end
        end,
    })
    
    local KillSlider = KillTab:CreateSlider({
        Name = "Attack Distance",
        Range = {10, 200},
        Increment = 1,
        Suffix = "studs",
        CurrentValue = 80,
        Flag = "KillDistance",
        Callback = function(Value)
            if KillAura and KillAura.setDistance then
                KillAura.setDistance(Value)
            end
        end,
    })
    
    KillTab:CreateParagraph({
        Title = "Combat System",
        Content = "Automatically attacks the closest target within range. Uses best available tool for maximum damage."
    })
    
    BringTab:CreateSection("Bring Items Controls")
    
    local selectedItemDropdown
    
    local function refreshItemDropdown()
        if BringItems and BringItems.refreshItems then
            local items = BringItems.refreshItems()
            if selectedItemDropdown and #items > 0 then
                selectedItemDropdown:Refresh(items, BringItems.getSelectedItem())
            end
        end
    end
    
    selectedItemDropdown = BringTab:CreateDropdown({
        Name = "Select Item Type",
        Options = {"Log", "Stone", "Stick"},
        CurrentOption = "Log",
        Flag = "SelectedItem",
        Callback = function(Value)
            if BringItems and BringItems.setSelectedItem then
                BringItems.setSelectedItem(Value)
            end
        end,
    })
    
    local RefreshButton = BringTab:CreateButton({
        Name = "🔄 Refresh Item List",
        Callback = function()
            refreshItemDropdown()
            Rayfield:Notify({
                Title = "Items Refreshed",
                Content = "📦 Item list updated!",
                Duration = 2,
                Image = 4483345998
            })
        end,
    })
    
    BringTab:CreateSection("Bring Actions")
    
    local BringSelectedButton = BringTab:CreateButton({
        Name = "📦 Bring Selected Items",
        Callback = function()
            if BringItems and BringItems.bringSelected then
                local selectedItem = BringItems.getSelectedItem and BringItems.getSelectedItem() or "items"
                local success = BringItems.bringSelected()
                
                if success then
                    Rayfield:Notify({
                        Title = "Items Brought",
                        Content = "✅ Brought all " .. selectedItem .. " items!",
                        Duration = 3,
                        Image = 4483345998
                    })
                else
                    Rayfield:Notify({
                        Title = "No Items Found",
                        Content = "❌ No " .. selectedItem .. " items found!",
                        Duration = 3,
                        Image = 4483345998
                    })
                end
            end
        end,
    })
    
    local BringAllButton = BringTab:CreateButton({
        Name = "🌟 Bring ALL Items",
        Callback = function()
            if BringItems and BringItems.bringAll then
                local success = BringItems.bringAll()
                if success then
                    Rayfield:Notify({
                        Title = "All Items Brought",
                        Content = "✅ Brought ALL items to you!",
                        Duration = 3,
                        Image = 4483345998
                    })
                else
                    Rayfield:Notify({
                        Title = "No Items Found",
                        Content = "❌ No items found in world!",
                        Duration = 3,
                        Image = 4483345998
                    })
                end
            end
        end,
    })
    
    BringTab:CreateSection("Auto Storage")
    
    AutoStoreToggle = BringTab:CreateToggle({
        Name = "Auto Store in Bag",
        CurrentValue = false,
        Flag = "AutoStore",
        Callback = function(Value)
            if BringItems and BringItems.setAutoStore then
                BringItems.setAutoStore(Value)
                if Value then
                    Rayfield:Notify({
                        Title = "Auto Store",
                        Content = "🎒 Auto-store enabled!",
                        Duration = 3,
                        Image = 4483345998
                    })
                else
                    Rayfield:Notify({
                        Title = "Auto Store",
                        Content = "🎒 Auto-store disabled!",
                        Duration = 3,
                        Image = 4483345998
                    })
                end
            end
        end,
    })
    
    local StoreNearbyButton = BringTab:CreateButton({
        Name = "🎒 Store Nearby Items",
        Callback = function()
            if BringItems and BringItems.storeAllNearbyItems then
                local success = BringItems.storeAllNearbyItems()
                if success then
                    Rayfield:Notify({
                        Title = "Items Stored",
                        Content = "🎒 Stored nearby items in bag!",
                        Duration = 3,
                        Image = 4483345998
                    })
                else
                    Rayfield:Notify({
                        Title = "Storage Failed",
                        Content = "❌ No items to store or no bag found!",
                        Duration = 3,
                        Image = 4483345998
                    })
                end
            end
        end,
    })
    
    BringTab:CreateParagraph({
        Title = "Enhanced Item System",
        Content = "Button-based item collection with auto-storage. Bring items to you and automatically store them in your bag (Old Sack/Sack/Bag)."
    })
    
    BringTab:CreateParagraph({
        Title = "How to Use",
        Content = "1. Refresh item list to scan available items\n2. Select item type and click 'Bring Selected'\n3. Enable 'Auto Store' for automatic bag storage\n4. Use 'Store Nearby' to manually store items"
    })
    
    SettingsTab:CreateSection("General Controls")
    
    local ResetButton = SettingsTab:CreateButton({
        Name = "🔄 Reset All Settings",
        Callback = function()
            TreeDistanceSlider:Set(86)
            TreeDelaySlider:Set(0.1)
            MaxTreesSlider:Set(3)
            AutoCollectToggle:Set(true)
            KillSlider:Set(80)
            
            if TreeAura then
                if TreeAura.setDistance then TreeAura.setDistance(86) end
                if TreeAura.setDelay then TreeAura.setDelay(0.1) end
                if TreeAura.setMaxTreesPerCycle then TreeAura.setMaxTreesPerCycle(3) end
                if TreeAura.setAutoCollectLogs then TreeAura.setAutoCollectLogs(true) end
            end
            if KillAura and KillAura.setDistance then
                KillAura.setDistance(80)
            end
            
            Rayfield:Notify({
                Title = "Settings Reset",
                Content = "🔄 All settings reset to defaults!",
                Duration = 3,
                Image = 4483345998
            })
        end,
    })
    
    local StopAllButton = SettingsTab:CreateButton({
        Name = "🛑 Stop All Auras",
        Callback = function()
            if TreeAura and TreeAura.stop then
                TreeAura.stop()
                TreeToggle:Set(false)
            end
            if KillAura and KillAura.stop then
                KillAura.stop()
                KillToggle:Set(false)
            end
            if BringItems and BringItems.stop then
                BringItems.stop()
                if AutoStoreToggle then
                    AutoStoreToggle:Set(false)
                end
            end
            Rayfield:Notify({
                Title = "Emergency Stop",
                Content = "🛑 All systems stopped!",
                Duration = 3,
                Image = 4483345998
            })
        end,
    })
    
    local DestroyButton = SettingsTab:CreateButton({
        Name = "🗑️ Destroy GUI",
        Callback = function()
            if TreeAura and TreeAura.stop then TreeAura.stop() end
            if KillAura and KillAura.stop then KillAura.stop() end
            if BringItems and BringItems.stop then BringItems.stop() end
            Rayfield:Destroy()
            print("🗑️ GUI destroyed!")
        end,
    })
    
    SettingsTab:CreateSection("Script Information")
    
    SettingsTab:CreateParagraph({
        Title = "Aura Farm Pro v7.0",
        Content = "Complete automation suite with enhanced tree farming, smart item collection with auto-storage, and combat features. Items are brought to you and automatically stored in your bag."
    })
    
    SettingsTab:CreateParagraph({
        Title = "Features",
        Content = "• Auto Tree Farming (Foliage + Landmarks)\n• Kill Aura with Tool Priority\n• Smart Item Collection System\n• Auto Bag Storage\n• Auto Log Collection\n• Chainsaw Support\n• Enhanced Performance"
    })
    
    wait(1)
    refreshItemDropdown()
    
    Rayfield:Notify({
        Title = "Aura Farm Pro v7.0",
        Content = "✨ All modules loaded successfully!",
        Duration = 5,
        Image = 4483345998
    })
    
    print("✨ Rayfield UI created successfully!")
    
    return {
        Rayfield = Rayfield,
        Window = Window,
        TreeToggle = TreeToggle,
        KillToggle = KillToggle
    }
end

local function main()
    print("🚀 Starting Aura Farm Pro v7.0...")
    
    loadModules()
    
    local success, result = pcall(function()
        local gui = createRayfieldGUI()
        
        print("✨ Aura Farm Pro v7.0 loaded successfully!")
        print("🌳 Tree Farm: " .. (TreeAura and "✅ LOADED" or "❌ FALLBACK"))
        print("⚔️ Kill Aura: " .. (KillAura and "✅ LOADED" or "❌ FALLBACK"))
        print("📦 Bring Items + Auto Storage: " .. (BringItems and "✅ LOADED" or "❌ FALLBACK"))
        
        return gui
    end)
    
    if not success then
        warn("Failed to create GUI: " .. tostring(result))
    end
end

main()
