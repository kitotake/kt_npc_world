print("^2[NPC WORLD]^0 core loaded")

ActiveNPCs = {}
EntityIndex = 0

CreateThread(function()
    while true do
        Wait(1000) -- optimisation (pas besoin de spam chaque frame)

        local playerPed = PlayerPedId()
        local playerId = PlayerId()

        -- 🌍 densité monde
        SetPedDensityMultiplierThisFrame(0.0)
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
        SetVehicleDensityMultiplierThisFrame(0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)

        -- 🚓 police / dispatch
        SetPoliceIgnorePlayer(playerId, true)
        SetDispatchCopsForPlayer(playerId, false)

        SetCreateRandomCops(false)
        SetCreateRandomCopsNotOnScenarios(false)
        SetCreateRandomCopsOnScenarios(false)

        DistantCopCarSirens(false)

        -- 💀 suppression complète wanted level
        ClearPlayerWantedLevel(playerId)
        SetMaxWantedLevel(0)

        -- 🚫 sécurité supplémentaire (optionnel mais utile)
        DisablePlayerVehicleRewards(playerId)
    end
end)