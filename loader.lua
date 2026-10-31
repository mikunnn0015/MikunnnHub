-- MikunnHub Master Loader
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local currentPlaceId = game.PlaceId

local SUPPORTED_GAMES = {
   [120219252362013] = "https://raw.githubusercontent.com/mikunnn0015/MikunnnnHub/main/ThrowFoodForEggs.lua",
}

local targetScriptUrl = SUPPORTED_GAMES[currentPlaceId]

if targetScriptUrl then
   Rayfield:Notify({
      Title = "MikunnHub",
      Content = "Loading script for game...",
      Duration = 2,
   })
   
   local success, err = pcall(function()
      loadstring(game:HttpGet(targetScriptUrl))()
   end)
   
   if not success then
      Rayfield:Notify({
         Title = "Execution Error",
         Content = tostring(err),
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
