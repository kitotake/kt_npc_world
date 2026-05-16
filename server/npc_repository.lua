NPCPool = {}

MySQL.query("SELECT * FROM npc_templates", {}, function(result)
    NPCPool = result or {}
end)

lib.callback.register("npc:getPool", function()
    return NPCPool
end)