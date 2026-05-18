-- client/vehicles/vehicle_system.lua
-- FIX v1.3 :
--   • EjectNPC : le Wait(1500) est maintenant dans un CreateThread dédié.
--     L'ancienne version bloquait le thread appelant pendant 1.5s, ce qui est
--     problématique si appelé depuis un handler ou la boucle principale.

VehicleSystem = {}

function VehicleSystem.CleanupVehicle(npc)
    if npc.vehicle and DoesEntityExist(npc.vehicle) then
        local player = PlayerPedId()
        local dist   = #(GetEntityCoords(npc.vehicle) - GetEntityCoords(player))
        if dist > Config.Spawn.despawnRadius then
            DeleteEntity(npc.vehicle)
            npc.vehicle = nil
        end
    end
end

-- FIX: Wait(1500) dans son propre thread pour ne pas bloquer l'appelant.
function VehicleSystem.EjectNPC(npc)
    if not npc.vehicle or not DoesEntityExist(npc.vehicle) then return end

    TaskLeaveVehicle(npc.ped, npc.vehicle, 0)

    local savedVehicle = npc.vehicle
    CreateThread(function()
        Wait(1500)
        -- Vérifier que le NPC n'a pas été supprimé pendant l'attente
        if DoesEntityExist(npc.ped) then
            npc.vehicle = nil
            npc.job     = "none"
        end
    end)
end

CreateThread(function()
    while true do
        Wait(5000)
        for _, npc in pairs(ActiveNPCs) do
            if npc.vehicle then
                VehicleSystem.CleanupVehicle(npc)
            end
        end
    end
end)