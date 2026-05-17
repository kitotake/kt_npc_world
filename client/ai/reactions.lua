-- Réactions ponctuelles aux événements du monde

AddEventHandler("npc:state_changed", function(npc, prevState, newState)
    if not DoesEntityExist(npc.ped) then return end

    -- Transition vers panicked : le NPC crie
    if newState == "panicked" then
        PlayAmbientSpeech1(npc.ped, "GENERIC_FRIGHTENED_HIGH", "SPEECH_PARAMS_FORCE")

    -- Transition vers aggressive : le NPC insulte
    elseif newState == "aggressive" then
        PlayAmbientSpeech1(npc.ped, "GENERIC_INSULT_HIGH", "SPEECH_PARAMS_FORCE")

    -- Retour au calme : relâchement
    elseif newState == "calm" and prevState ~= "calm" then
        PlayAmbientSpeech1(npc.ped, "GENERIC_THANKS", "SPEECH_PARAMS_FORCE")
    end
end)

-- Réaction au tir à proximité
AddEventHandler("npc:gunshot_nearby", function(coords)
    local pCoords = coords
    for _, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then
            local dist = #(GetEntityCoords(npc.ped) - pCoords)
            if dist < 30.0 then
                npc.emotion.fear   = Clamp(npc.emotion.fear + 30, 0, 100)
                npc.emotion.stress = Clamp(npc.emotion.stress + 20, 0, 100)
            end
        end
    end
end)

-- Réaction à une explosion
AddEventHandler("npc:explosion_nearby", function(coords)
    for _, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then
            local dist = #(GetEntityCoords(npc.ped) - coords)
            if dist < 60.0 then
                npc.emotion.fear   = 100
                npc.emotion.stress = 100
            end
        end
    end
end)

-- FIX (bug 1): suppression de la boucle de détection de tir native qui était ici en double.
-- La détection canonique est dans client/world/event_listener.lua.
