-- MikunnHub Master Loader
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local currentPlaceId = game.PlaceId

-- Map game Place IDs to their exact GitHub raw script URLs
local SUPPORTED_GAMES = {
   [120219252362013] = "https://raw.githubusercontent.com/mikunn0015/MikunnHub/MikunnHub/ThrowFoodForEggs.lua",
}

local targetScriptUrl = SUPPORTED_GAMES[currentPlaceId]

if targetScriptUrl then
   Rayfield:Notify({
      Title = "MikunnHub",
      Content = "Game recognized! Loading automation script...",
      Duration = 3,
   })
   
   local success, err = pcall(function()
      loadstring(game:HttpGet(targetScriptUrl))()
   end)
   
   if not success then
      Rayfield:Notify({
         Title = "Execution Error",
         Content = "Failed to run game script: " .. tostring(err),
         Duration = 6,
      })
   end
else
   Rayfield:Notify({
      Title = "MikunnHub",
      Content = "Unsupported Game ID: " .. tostring(currentPlaceId),
      Duration = 5,
   })
end
