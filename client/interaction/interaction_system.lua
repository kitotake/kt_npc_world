-- Interactions disponibles selon la classe et l'état du NPC

InteractionSystem = {}

local interactionMap = {
    civil = {
        calm     = { "Parler", "Demander une information" },
        scared   = { "Rassurer" },
        panicked = {},
    },
    guard = {
        calm       = { "Parler", "Demander l'accès" },
        scared     = {},
        panicked   = {},
        aggressive = { "Se rendre" },
    },
    dealer = {
        calm = { "Parler", "Négocier" },
    },
    gang = {
        calm       = { "Parler" },
        aggressive = {},
    },
}

function InteractionSystem.GetAvailable(npc)
    if not npc then return {} end
    local classMap = interactionMap[npc.class]
    if not classMap then return {} end
    return classMap[npc.state] or {}
end

AddEventHandler("npc:target_acquired", function(npc)
    local options = InteractionSystem.GetAvailable(npc)
    if Config.Debug and #options > 0 then
        print(("[NPC WORLD] Interactions disponibles pour %s (%s): %s"):format(
            npc.class, npc.state, table.concat(options, ", ")
        ))
    end
end)
