-- Commandes de debug accessibles en jeu

-- ~g~[NPC WORLD] commandes disponibles :
-- /npc_debug     — toggle overlay debug
-- /npc_info      — affiche les stats du NPC le plus proche
-- /npc_spawn     — spawn un NPC à votre position
-- /npc_clear     — supprime tous les NPC actifs
-- /npc_gunshot   — simule un tir à votre position
-- /npc_explosion — simule une explosion à votre position

RegisterCommand("npc_debug", function()
    Config.Debug = not Config.Debug
    print(("^3[NPC WORLD]^0 Debug: %s"):format(Config.Debug and "^2ON" or "^1OFF"))
end, false)

RegisterCommand("npc_info", function()
    local coords  = GetEntityCoords(PlayerPedId())
    local npc, d  = GetNearestNPC(coords, 10.0)
    if npc then
        print(("^3[NPC WORLD]^0 NPC #%d | class: %s | state: %s | job: %s"):format(
            npc.id, npc.class, npc.state, npc.job
        ))
        print(("  fear: %d | stress: %d | aggression: %d | dist: %.1fm"):format(
            npc.emotion.fear, npc.emotion.stress, npc.emotion.aggression, d
        ))
    else
        print("^3[NPC WORLD]^0 Aucun NPC à moins de 10m")
    end
end, false)

RegisterCommand("npc_spawn", function(_, args)
    local class  = args[1] or "civil"
    local model  = GetRandomModelForClass(class)
    local coords = GetEntityCoords(PlayerPedId())
    SpawnNPC(model, coords + vector3(2.0, 0.0, 0.0), class)
    print(("^3[NPC WORLD]^0 Spawned %s (%s)"):format(class, model))
end, false)

RegisterCommand("npc_clear", function()
    local count = 0
    for id, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then
            DeleteEntity(npc.ped)
        end
        ActiveNPCs[id] = nil
        count += 1
    end
    print(("^3[NPC WORLD]^0 Supprimé %d NPC"):format(count))
end, false)
