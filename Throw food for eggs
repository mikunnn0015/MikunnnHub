local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Muscle Legends Hub",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "by MikunnnHub",
   ConfigurationSaving = { Enabled = false }
})

-- Services & References
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Global Toggle States
local autoStrength = false
local autoAgility = false
local autoDurability = false
local autoHandstand = false
local autoRebirth = false

-- Safe Remote Grabbers
local function getMuscleEvent()
    return LocalPlayer:FindFirstChild("muscleEvent") or LocalPlayer:WaitForChild("muscleEvent", 5)
end

local function getRebirthRemote()
    local rEvents = ReplicatedStorage:FindFirstChild("rEvents") or ReplicatedStorage:WaitForChild("rEvents", 5)
    if rEvents then
        return rEvents:FindFirstChild("rebirthRemote") or rEvents:WaitForChild("rebirthRemote", 5)
    end
    return nil
end

-- Safe Tool Equipper (Checks if item is already held to prevent unequip loops)
local function equipToolOnce(toolName)
    local character = LocalPlayer.Character
    if not character then return end
    
    -- If already held, DO NOT touch inventory
    if character:FindFirstChild(toolName) then return end
    
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if backpack and humanoid then
        local tool = backpack:FindFirstChild(toolName)
        if tool then
            humanoid:EquipTool(tool)
        end
    end
end

-- UI Tabs
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local RebirthTab = Window:CreateTab("Rebirth", 4483362458)

-- ==================== AUTO FARM SECTION ====================

FarmTab:CreateToggle({
   Name = "Auto Dumbbell (Strength)",
   CurrentValue = false,
   Flag = "AutoStrength",
   Callback = function(Value)
      autoStrength = Value
      if autoStrength then
         equipToolOnce("Weight")
         task.spawn(function()
            while autoStrength do
               local muscleEvent = getMuscleEvent()
               if muscleEvent then
                  muscleEvent:FireServer("rep")
               end
               task.wait(0.1)
            end
         end)
      end
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Pushups (Agility)",
   CurrentValue = false,
   Flag = "AutoAgility",
   Callback = function(Value)
      autoAgility = Value
      if autoAgility then
         equipToolOnce("Pushups")
         task.spawn(function()
            while autoAgility do
               local muscleEvent = getMuscleEvent()
               if muscleEvent then
                  muscleEvent:FireServer("pushups")
               end
               task.wait(0.1)
            end
         end)
      end
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Situps (Durability)",
   CurrentValue = false,
   Flag = "AutoDurability",
   Callback = function(Value)
      autoDurability = Value
      if autoDurability then
         equipToolOnce("Situps")
         task.spawn(function()
            while autoDurability do
               local muscleEvent = getMuscleEvent()
               if muscleEvent then
                  muscleEvent:FireServer("situps")
               end
               task.wait(0.1)
            end
         end)
      end
   end,
})

FarmTab:CreateToggle({
   Name = "Auto Handstands",
   CurrentValue = false,
   Flag = "AutoHandstand",
   Callback = function(Value)
      autoHandstand = Value
      if autoHandstand then
         equipToolOnce("Handstands")
         task.spawn(function()
            while autoHandstand do
               local muscleEvent = getMuscleEvent()
               if muscleEvent then
                  muscleEvent:FireServer("handstands")
               end
               task.wait(0.1)
            end
         end)
      end
   end,
})

-- ==================== REBIRTH SECTION ====================

RebirthTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "AutoRebirth",
   Callback = function(Value)
      autoRebirth = Value
      if autoRebirth then
         task.spawn(function()
            while autoRebirth do
               local rebirthRemote = getRebirthRemote()
               if rebirthRemote then
                  -- Attempt rebirth
                  rebirthRemote:InvokeServer("rebirthRequest")
               end
               task.wait(3) -- Delay prevents remote spamming and inventory resetting
            end
         end)
      end
   end,
})

-- Re-equip active tool automatically after a Rebirth or Respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1.5) -- Wait for character and inventory to load on rebirth
    if autoStrength then equipToolOnce("Weight") end
    if autoAgility then equipToolOnce("Pushups") end
    if autoDurability then equipToolOnce("Situps") end
    if autoHandstand then equipToolOnce("Handstands") end
end)
