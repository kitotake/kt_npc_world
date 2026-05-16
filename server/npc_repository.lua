NPCPool = {}

MySQL.query("SELECT * FROM npc_templates", {}, function(result)
    NPCPool = result or {}
    print(("^2[NPC WORLD]^0 Loaded %d NPC templates"):format(#NPCPool))
end)

lib.callback.register("npc:getPool", function()
    return NPCPool
end)
