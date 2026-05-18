-- client/systems/despawn_system.lua
-- FIX v1.2 : utilise RemoveNPC() centralisé, liste différée pour éviter
-- la modification d'ActiveNPCs pendant pairs().

AddEventHandler("npc:update_cleanup", function()
    local player  = PlayerPedId()
    local pCoords = GetEntityCoords(player)

    local toRemove = {}

    for id, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then
            local dist = #(GetEntityCoords(npc.ped) - pCoords)
            if dist > Config.Spawn.despawnRadius then
                TriggerEvent("npc:removed", npc)
                toRemove[#toRemove + 1] = id
            end
        else
            TriggerEvent("npc:removed", npc)
            toRemove[#toRemove + 1] = id
        end
    end

    for _, id in ipairs(toRemove) do
        RemoveNPC(id)
    end
end)