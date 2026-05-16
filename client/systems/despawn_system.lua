RegisterNetEvent("npc:update_cleanup", function()
    local player = PlayerPedId()
    local pCoords = GetEntityCoords(player)

    for id, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then

            local dist = #(GetEntityCoords(npc.ped) - pCoords)

            if dist > 200.0 then
                DeleteEntity(npc.ped)
                ActiveNPCs[id] = nil
            end

        end
    end
end)