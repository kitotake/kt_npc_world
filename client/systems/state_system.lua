RegisterNetEvent("npc:update_state", function()
    for _, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then

            if npc.emotion.fear > 70 then
                npc.state = "panicked"

            elseif npc.emotion.aggression > 60 then
                npc.state = "aggressive"

            elseif npc.emotion.stress > 50 then
                npc.state = "scared"

            else
                npc.state = "calm"
            end

        end
    end
end)