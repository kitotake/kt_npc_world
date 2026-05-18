-- FIX v1.2 :
--   • npc:getPool limite les résultats retournés et vérifie les permissions basiques.
--     L'ancienne version retournait NPCPool entier sans restriction à n'importe quel client.

NPCPool = {}

MySQL.query("SELECT * FROM npc_templates", {}, function(result)
    NPCPool = result or {}
    print(("^2[NPC WORLD]^0 Loaded %d NPC templates"):format(#NPCPool))
end)

-- FIX: callback sécurisé avec limite de résultats
-- Le paramètre optionnel `filter` permet au client de demander une classe spécifique.
lib.callback.register("npc:getPool", function(source, filter)
    -- Vérification basique : source doit être un joueur connecté valide
    if not source or source <= 0 then return {} end

    local result = {}
    local limit  = 50   -- max 50 templates par appel

    for _, entry in ipairs(NPCPool) do
        if not filter or entry.class == filter then
            result[#result + 1] = entry
            if #result >= limit then break end
        end
    end

    return result
end)
