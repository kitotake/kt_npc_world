-- Gestion des véhicules associés aux NPC

VehicleSystem = {}

-- Supprime le véhicule d'un NPC si celui-ci est trop loin
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

-- Fait sortir le NPC de son véhicule
function VehicleSystem.EjectNPC(npc)
    if npc.vehicle and DoesEntityExist(npc.vehicle) then
        TaskLeaveVehicle(npc.ped, npc.vehicle, 0)
        Wait(1500)
        npc.vehicle = nil
        npc.job     = "none"
    end
end

-- Vérifie les véhicules abandonnés chaque 5s
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
