-- client/debug/debug_menu.lua
-- FIX v1.2 :
--   • /npc_clear utilise RemoveNPC() pour recycler les IDs correctement
--   • /npc_spawn valide la classe avant spawn

RegisterCommand("npc_debug", function()
    Config.Debug = not Config.Debug
    print(("^3[NPC WORLD]^0 Debug: %s"):format(Config.Debug and "^2ON" or "^1OFF"))
end, false)

RegisterCommand("npc_info", function()
    local coords = GetEntityCoords(PlayerPedId())
    local npc, d = GetNearestNPC(coords, 10.0)
    if npc then
        print(("^3[NPC WORLD]^0 NPC #%d | class: %s | state: %s | job: %s"):format(
            npc.id, npc.class, npc.state, npc.job
        ))
        print(("  fear: %d | stress: %d | aggression: %d | dist: %.1fm"):format(
            npc.emotion.fear, npc.emotion.stress, npc.emotion.aggression, d
        ))
        print(("  lastDecision: %s | lastState: %s"):format(
            tostring(npc._lastDecision), tostring(npc._lastState)
        ))
    else
        print("^3[NPC WORLD]^0 Aucun NPC à moins de 10m")
    end
end, false)

RegisterCommand("npc_spawn", function(_, args)
    local class = args[1] or "civil"
    if not NPC_CLASS_DATA[class] then
        print(("^3[NPC WORLD]^0 Classe inconnue '%s', utilisation de 'civil'"):format(class))
        class = "civil"
    end
    local model  = GetRandomModelForClass(class)
    local coords = GetEntityCoords(PlayerPedId())
    SpawnNPC(model, coords + vector3(2.0, 0.0, 0.0), class)
    print(("^3[NPC WORLD]^0 Spawned %s (%s)"):format(class, model))
end, false)

RegisterCommand("npc_clear", function()
    local ids = {}
    for id in pairs(ActiveNPCs) do
        ids[#ids + 1] = id
    end
    for _, id in ipairs(ids) do
        RemoveNPC(id)
    end
    print(("^3[NPC WORLD]^0 Supprimé %d NPC"):format(#ids))
end, false)