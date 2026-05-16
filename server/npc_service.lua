-- Service principal NPC côté serveur

NpcService = {}

-- Enregistre un NPC persistant en base
function NpcService.Save(data)
    MySQL.insert(
        "INSERT INTO npc_templates (model, class, job, group_id) VALUES (?, ?, ?, ?)",
        { data.model, data.class, data.job, data.group }
    )
end

-- Supprime un template
function NpcService.Delete(id)
    MySQL.execute("DELETE FROM npc_templates WHERE id = ?", { id })
end

-- Log d'un événement NPC (optionnel, pour analytics RP)
function NpcService.LogEvent(npcId, event, data)
    MySQL.insert(
        "INSERT INTO npc_memory (npc_id, event, data, created_at) VALUES (?, ?, ?, NOW())",
        { npcId, event, json.encode(data or {}) }
    )
end
