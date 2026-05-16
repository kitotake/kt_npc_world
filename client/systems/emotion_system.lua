RegisterNetEvent("npc:update_emotion", function()
    local player = PlayerPedId()
    local pCoords = GetEntityCoords(player)

    for _, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then

            local dist = #(GetEntityCoords(npc.ped) - pCoords)

            if dist < 10.0 then
                npc.emotion.fear += 10
                npc.emotion.stress += 5
            else
                npc.emotion.fear = math.max(0, npc.emotion.fear - 2)
                npc.emotion.stress = math.max(0, npc.emotion.stress - 1)
            end

        end
    end
end)