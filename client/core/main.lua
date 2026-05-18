-- client/core/main.lua
print("^2[NPC WORLD]^0 core loaded")

ActiveNPCs = {}
EntityIndex = 0

CreateThread(function()
    while true do
        Wait(1000)

        local playerPed = PlayerPedId()
        local playerId  = PlayerId()

        -- Densité monde : tout désactivé, géré par kt_npc_world
        SetPedDensityMultiplierThisFrame(0.0)
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
        SetVehicleDensityMultiplierThisFrame(0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)

        -- Police / dispatch
        SetPoliceIgnorePlayer(playerId, true)
        SetDispatchCopsForPlayer(playerId, false)
        SetCreateRandomCops(false)
        SetCreateRandomCopsNotOnScenarios(false)
        SetCreateRandomCopsOnScenarios(false)
        DistantCopCarSirens(false)

        -- Wanted level
        ClearPlayerWantedLevel(playerId)
        SetMaxWantedLevel(0)

        DisablePlayerVehicleRewards(playerId)
    end
end)