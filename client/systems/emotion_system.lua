-- client/systems/emotion_system.lua
-- FIX v1.2 :
--   • zoneMod appliqué indépendamment de la proximité du joueur (coefficient réduit à distance)
--   • NPCs morts ignorés proprement (état "dead" posé, cleanup différé)
--   • Contagion de peur sur liste pré-collectée (évite O(N²) sur ActiveNPCs modifié)

AddEventHandler("npc:update_emotion", function()
    local player  = PlayerPedId()
    local pCoords = GetEntityCoords(player)
    local cfg     = Config.Emotion

    local panicked = {}
    local toRemove = {}

    for id, npc in pairs(ActiveNPCs) do
        if not DoesEntityExist(npc.ped) then
            toRemove[#toRemove + 1] = id

        elseif IsEntityDead(npc.ped) then
            if npc.state ~= "dead" then
                local prev = npc.state
                npc.state  = "dead"
                TriggerEvent("npc:state_changed", npc, prev, "dead")
            end

        else
            local dist    = #(GetEntityCoords(npc.ped) - pCoords)
            local cd      = npc.classData
            local zone    = GetZoneAt(GetEntityCoords(npc.ped))
            local zoneMod = zone and zone.emotionMod or { fear = 0, stress = 0, aggression = 0 }

            if dist < cfg.proximityRange then
                npc.emotion.fear       = Clamp(npc.emotion.fear + (cfg.fearPerTick * cd.fearMultiplier) + zoneMod.fear, 0, 100)
                npc.emotion.stress     = Clamp(npc.emotion.stress + (cfg.stressPerTick * cd.stressMultiplier) + zoneMod.stress, 0, 100)
                npc.emotion.aggression = Clamp(npc.emotion.aggression + (2.0 * cd.aggressionMultiplier) + zoneMod.aggression, 0, 100)
            else
                local zoneFactor = 0.25
                npc.emotion.fear       = Clamp(math.max(0, npc.emotion.fear - cfg.fearDecay)        + (zoneMod.fear       * zoneFactor * cd.fearMultiplier),       0, 100)
                npc.emotion.stress     = Clamp(math.max(0, npc.emotion.stress - cfg.stressDecay)    + (zoneMod.stress     * zoneFactor * cd.stressMultiplier),     0, 100)
                npc.emotion.aggression = Clamp(math.max(0, npc.emotion.aggression - cfg.aggroDecay) + (zoneMod.aggression * zoneFactor * cd.aggressionMultiplier), 0, 100)
            end

            MemorySystem.ApplyMemoryModifiers(npc)

            if npc.state == "panicked" or npc.state == "fleeing" then
                panicked[#panicked + 1] = GetEntityCoords(npc.ped)
            end
        end
    end

    -- Contagion de peur sur liste pré-collectée
    if #panicked > 0 then
        for _, npc in pairs(ActiveNPCs) do
            if DoesEntityExist(npc.ped) and npc.state ~= "dead" then
                local nCoords = GetEntityCoords(npc.ped)
                for _, src in ipairs(panicked) do
                    if #(nCoords - src) < 15.0 then
                        npc.emotion.fear   = Clamp(npc.emotion.fear + 5,  0, 100)
                        npc.emotion.stress = Clamp(npc.emotion.stress + 3, 0, 100)
                        break
                    end
                end
            end
        end
    end

    for _, id in ipairs(toRemove) do
        TriggerEvent("npc:removed", ActiveNPCs[id])
        RemoveNPC(id)
    end
end)