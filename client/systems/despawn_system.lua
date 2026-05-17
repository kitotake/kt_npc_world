AddEventHandler("npc:update_cleanup", function()
    local player  = PlayerPedId()
    local pCoords = GetEntityCoords(player)

    for id, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then
            local dist = #(GetEntityCoords(npc.ped) - pCoords)

            if dist > Config.Spawn.despawnRadius then
                TriggerEvent("npc:removed", npc)  -- v1.1 : notifie GroupAI
                if npc.vehicle and DoesEntityExist(npc.vehicle) then
                    DeleteEntity(npc.vehicle)
                end
                DeleteEntity(npc.ped)
                ActiveNPCs[id] = nil
                ReleaseID(id)
            end
        else
            TriggerEvent("npc:removed", npc)
            ActiveNPCs[id] = nil
            ReleaseID(id)
        end
    end
end)
