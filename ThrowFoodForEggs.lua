-- Rayfield UI Script: Professional Automation Hub (Exact CrossLine Teleport & Loop)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "MikunnHub | Throw food for animals",
   LoadingTitle = "loading Hub...",
   LoadingSubtitle = "by mikunn_is_dumb",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "AutomationHub"
   },
   KeySystem = false,
   KeySettings = {
      Title = "Key System",
      Subtitle = "Authentication",
      Note = "No key required",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"1234"}
   }
})

-- Services & References
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

-- Remote References
local TrainingStop = Remotes:WaitForChild("Training_Stop")
local TrainingStart = Remotes:WaitForChild("Training_Start")
local TrainingTapBonus = Remotes:WaitForChild("Training_TapBonus")
local ThrowStart = Remotes:WaitForChild("Throw_Start")
local ThrowResolve = Remotes:WaitForChild("Throw_Resolve")
local ThrowComplete = Remotes:WaitForChild("Throw_Complete")
local PlotEquipBest = Remotes:WaitForChild("Plot_EquipBest")
local StandUpgrade = Remotes:WaitForChild("Stand_Upgrade")
local ShopBuy = Remotes:WaitForChild("Shop_Buy")
local PlotUpgradeFence = Remotes:WaitForChild("Plot_UpgradeFence")
local PlotSellAll = Remotes:WaitForChild("Plot_SellAll")

-- High-performance cached lookup for Training
local cachedTrainingPart = nil
local function GetTrainingPart()
   if cachedTrainingPart and cachedTrainingPart.Parent then return cachedTrainingPart end
   for _, obj in ipairs(workspace:GetDescendants()) do
      if obj:IsA("BasePart") then
         local name = obj.Name:lower()
         if name:find("training") or name:find("train") or name:find("gym") or name:find("bench") then
            cachedTrainingPart = obj
            return obj
         end
      end
   end
   return nil
end

-- Exact Throwing Line Lookup based on your Explorer window (`CrossLine`)
local function GetThrowPart()
   local starterArea = workspace:FindFirstChild("StarterArea")
   if starterArea then
      local crossLine = starterArea:FindFirstChild("CrossLine")
      if crossLine and crossLine:IsA("BasePart") then
         return crossLine
      end
   end
   -- Fallback scan if StarterArea or CrossLine changes name structure
   for _, obj in ipairs(workspace:GetDescendants()) do
      if obj:IsA("BasePart") and obj.Name == "CrossLine" then
         return obj
      end
   end
   return nil
end

-- UI Click Emulation Helper
local function ClickTapBonusButton()
   for _, gui in ipairs(PlayerGui:GetChildren()) do
      if gui:IsA("ScreenGui") and gui.Enabled then
         for _, obj in ipairs(gui:GetDescendants()) do
            if (obj:IsA("TextButton") or obj:IsA("ImageButton")) and obj.Visible then
               local name = obj.Name:lower()
               if name:find("tap") or name:find("bonus") or name:find("click") or name:find("boost") then
                  for _, signal in ipairs({"MouseButton1Click", "MouseButton1Down", "Activated"}) do
                     pcall(function() firesignal(obj[signal]) end)
                  end
               end
            end
         end
      end
   end
end

------------------------------------------------------------------------
-- TABS SETUP
------------------------------------------------------------------------
local TrainingTab = Window:CreateTab("Training", 4483362458)
local ThrowingTab = Window:CreateTab("Throwing", 6023426915)
local ManagementTab = Window:CreateTab("Pets & Upgrades", 6023426810)

------------------------------------------------------------------------
-- TRAINING TAB
------------------------------------------------------------------------
TrainingTab:CreateSection("Training Automation")

TrainingTab:CreateToggle({
   Name = "Auto Start Training",
   CurrentValue = false,
   Flag = "AutoTrainingToggle",
   Callback = function(Value)
      _G.AutoTraining = Value
      if _G.AutoTrainingThread then task.cancel(_G.AutoTrainingThread) end
      
      if Value then
         _G.AutoTrainingThread = task.spawn(function()
            while _G.AutoTraining do
               pcall(function()
                  local char = LocalPlayer.Character
                  local root = char and char:FindFirstChild("HumanoidRootPart")
                  local part = GetTrainingPart()
                  
                  if root and part then
                     if (root.Position - part.Position).Magnitude > 12 then
                        root.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.2)
                     end
                  end
                  TrainingStart:InvokeServer()
               end)
               task.wait(1.0)
            end
         end)
      else
         pcall(function()
            TrainingStop:InvokeServer()
         end)
      end
   end,
})

TrainingTab:CreateToggle({
   Name = "Auto Tap Bonus",
   CurrentValue = false,
   Flag = "AutoTapBonusToggle",
   Callback = function(Value)
      _G.AutoTapBonus = Value
      if _G.AutoTapBonusThread then task.cancel(_G.AutoTapBonusThread) end
      
      if Value then
         _G.AutoTapBonusThread = task.spawn(function()
            while _G.AutoTapBonus do
               pcall(function()
                  ClickTapBonusButton()
                  TrainingTapBonus:InvokeServer(1)
                  TrainingTapBonus:InvokeServer(2)
               end)
               task.wait(0.1)
            end
         end)
      end
   end,
})

------------------------------------------------------------------------
-- THROWING TAB (EXACT CROSSLINE TELEPORT & LOOP)
------------------------------------------------------------------------
ThrowingTab:CreateSection("Throwing Automation")

ThrowingTab:CreateToggle({
   Name = "Auto Throw (Teleport to CrossLine)",
   CurrentValue = false,
   Flag = "AutoThrowToggle",
   Callback = function(Value)
      _G.AutoThrow = Value
      if _G.AutoThrowThread then task.cancel(_G.AutoThrowThread) end
      
      if Value then
         _G.AutoThrowThread = task.spawn(function()
            -- Instant Teleport directly to CrossLine on activation
            local throwPart = GetThrowPart()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if root and throwPart then
               root.CFrame = throwPart.CFrame + Vector3.new(0, 3, 0)
               task.wait(0.4) -- Physics settle delay
            end
            
            while _G.AutoThrow do
               pcall(function()
                  local currentChar = LocalPlayer.Character
                  local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                  local humanoid = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
                  local currentThrowPart = GetThrowPart()
                  
                  if currentRoot and humanoid and humanoid.Health > 0 then
                     -- Keep locked to the throwing line area if forced away
                     if currentThrowPart and (currentRoot.Position - currentThrowPart.Position).Magnitude > 12 then
                        currentRoot.CFrame = currentThrowPart.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.2)
                     end
                     
                     -- Execute sequence
                     ThrowStart:InvokeServer()
                     task.wait(0.25)
                     
                     ThrowResolve:InvokeServer(0.925)
                     task.wait(0.25)
                     
                     ThrowComplete:InvokeServer()
                  end
               end)
               task.wait(1.5)
            end
         end)
      end
   end,
})

------------------------------------------------------------------------
-- PETS & UPGRADES TAB
------------------------------------------------------------------------
ManagementTab:CreateSection("Shop Automation")

ManagementTab:CreateToggle({
   Name = "Auto Buy Best Food (Multi-Tier)",
   CurrentValue = false,
   Flag = "AutoBuyFoodToggle",
   Callback = function(Value)
      _G.AutoBuyFood = Value
      if _G.AutoBuyFoodThread then task.cancel(_G.AutoBuyFoodThread) end
      
      if Value then
         _G.AutoBuyFoodThread = task.spawn(function()
            while _G.AutoBuyFood do
               pcall(function()
                  for tierId = 38, 1, -1 do
                     local success = pcall(function()
                        ShopBuy:InvokeServer(tierId)
                     end)
                     if success then
                        task.wait(0.2)
                        break
                     end
                  end
               end)
               task.wait(1.5)
            end
         end)
      end
   end,
})

ManagementTab:CreateSection("Pets & Equipment")

ManagementTab:CreateToggle({
   Name = "Auto Equip Best Animals",
   CurrentValue = false,
   Flag = "AutoEquipBestToggle",
   Callback = function(Value)
      _G.AutoEquipBest = Value
      if _G.AutoEquipThread then task.cancel(_G.AutoEquipThread) end
      
      if Value then
         _G.AutoEquipThread = task.spawn(function()
            while _G.AutoEquipBest do
               pcall(function() PlotEquipBest:InvokeServer() end)
               task.wait(3.0)
            end
         end)
      end
   end,
})

ManagementTab:CreateButton({
   Name = "Sell All Unwanted Pets",
   Callback = function()
      pcall(function()
         PlotSellAll:InvokeServer()
      end)
      Rayfield:Notify({
         Title = "Success",
         Content = "Triggered Sell All Pets remote.",
         Duration = 2,
         Image = 4483362458,
      })
   end,
})

ManagementTab:CreateSection("Stand & Plot Upgrades")

ManagementTab:CreateToggle({
   Name = "Auto Stand Upgrade",
   CurrentValue = false,
   Flag = "AutoStandUpgradeToggle",
   Callback = function(Value)
      _G.AutoStandUpgrade = Value
      if _G.AutoStandUpgradeThread then task.cancel(_G.AutoStandUpgradeThread) end
      
      if Value then
         _G.AutoStandUpgradeThread = task.spawn(function()
            while _G.AutoStandUpgrade do
               pcall(function() StandUpgrade:InvokeServer() end)
               task.wait(3.0)
            end
         end)
      end
   end,
})

ManagementTab:CreateToggle({
   Name = "Auto Upgrade Fence",
   CurrentValue = false,
   Flag = "AutoUpgradeFenceToggle",
   Callback = function(Value)
      _G.AutoUpgradeFence = Value
      if _G.AutoUpgradeFenceThread then task.cancel(_G.AutoUpgradeFenceThread) end
      
      if Value then
         _G.AutoUpgradeFenceThread = task.spawn(function()
            while _G.AutoUpgradeFence do
               pcall(function() PlotUpgradeFence:InvokeServer() end)
               task.wait(3.0)
            end
         end)
      end
   end,
})

Rayfield:Notify({
   Title = "Hub Loaded Successfully",
   Content = "Auto Throw linked directly to CrossLine teleportation.",
   Duration = 5,
   Image = 4483362458,
})
