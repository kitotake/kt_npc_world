-- server/npc_repository.lua
-- FIX v1.2 : callback sécurisé avec limite de résultats et vérification source

NPCPool = {}

MySQL.query("SELECT * FROM npc_templates", {}, function(result)
    NPCPool = result or {}
    print(("^2[NPC WORLD]^0 Loaded %d NPC templates"):format(#NPCPool))
end)

lib.callback.register("npc:getPool", function(source, filter)
    if not source or source <= 0 then return {} end

    local result = {}
    local limit  = 50

    for _, entry in ipairs(NPCPool) do
        if not filter or entry.class == filter then
            result[#result + 1] = entry
            if #result >= limit then break end
        end
    end

    return result
end)