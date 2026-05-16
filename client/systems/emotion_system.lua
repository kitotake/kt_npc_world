AddEventHandler("npc:update_emotion", function()
    local player  = PlayerPedId()
    local pCoords = GetEntityCoords(player)
    local cfg     = Config.Emotion

    for _, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then
            local dist      = #(GetEntityCoords(npc.ped) - pCoords)
            local cd        = npc.classData
            local zone      = GetZoneAt(GetEntityCoords(npc.ped))
            local zoneMod   = zone and zone.emotionMod or { fear = 0, stress = 0, aggression = 0 }

            if dist < cfg.proximityRange then
                npc.emotion.fear       = Clamp(npc.emotion.fear + (cfg.fearPerTick * cd.fearMultiplier) + zoneMod.fear, 0, 100)
                npc.emotion.stress     = Clamp(npc.emotion.stress + (cfg.stressPerTick * cd.stressMultiplier) + zoneMod.stress, 0, 100)
                npc.emotion.aggression = Clamp(npc.emotion.aggression + (2.0 * cd.aggressionMultiplier) + zoneMod.aggression, 0, 100)
            else
                npc.emotion.fear       = math.max(0, npc.emotion.fear - cfg.fearDecay)
                npc.emotion.stress     = math.max(0, npc.emotion.stress - cfg.stressDecay)
                npc.emotion.aggression = math.max(0, npc.emotion.aggression - cfg.aggroDecay)
            end
        end
    end
end)
