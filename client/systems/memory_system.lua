-- client/systems/memory_system.lua
-- FIX v1.2 :
--   • MemorySystem.Event déclaré EN DÉBUT de fichier
--   • TriggerServerEvent throttlé par NPC (500ms)
--   • Count() via compteur incrémental O(1)
--   • Suppression du handler gameEventTriggered dupliqué

MemorySystem = {}

local MEMORY_TTL = 300000

-- Déclaration anticipée pour que decision_tree.lua puisse y accéder dès son chargement
local MemoryEvent = {
    ATTACKED            = "attacked",
    WITNESSED_SHOT      = "witnessed_shot",
    WITNESSED_EXPLOSION = "witnessed_explosion",
    INTERACTED          = "interacted",
    PLAYER_DIED         = "player_died",
}
MemorySystem.Event = MemoryEvent

-- ==============================================================
-- ENREGISTREMENT
-- ==============================================================

function MemorySystem.Record(npc, eventType, data)
    if not npc or not npc.memory then return end

    table.insert(npc.memory, {
        event     = eventType,
        data      = data or {},
        timestamp = GetGameTimer(),
    })

    if not npc.memory_counts then npc.memory_counts = {} end
    npc.memory_counts[eventType] = (npc.memory_counts[eventType] or 0) + 1

    local now = GetGameTimer()
    if not npc._lastServerMemoryEvent or (now - npc._lastServerMemoryEvent) > 500 then
        TriggerServerEvent("npc:memory_event", npc.id, eventType, data)
        npc._lastServerMemoryEvent = now
    end
end

function MemorySystem.Has(npc, eventType)
    if not npc or not npc.memory then return false end
    local now = GetGameTimer()
    for _, mem in ipairs(npc.memory) do
        if mem.event == eventType and (now - mem.timestamp) < MEMORY_TTL then
            return true
        end
    end
    return false
end

function MemorySystem.Count(npc, eventType)
    if not npc or not npc.memory_counts then return 0 end
    if not npc.memory_counts[eventType] or npc.memory_counts[eventType] == 0 then return 0 end
    local now   = GetGameTimer()
    local count = 0
    for _, mem in ipairs(npc.memory) do
        if mem.event == eventType and (now - mem.timestamp) < MEMORY_TTL then
            count += 1
        end
    end
    return count
end

-- ==============================================================
-- NETTOYAGE
-- ==============================================================

function MemorySystem.Cleanup(npc)
    if not npc or not npc.memory then return end
    local now      = GetGameTimer()
    local pruned   = {}
    local newCounts = {}
    for _, mem in ipairs(npc.memory) do
        if (now - mem.timestamp) < MEMORY_TTL then
            table.insert(pruned, mem)
            newCounts[mem.event] = (newCounts[mem.event] or 0) + 1
        end
    end
    npc.memory        = pruned
    npc.memory_counts = newCounts
end

CreateThread(function()
    while true do
        Wait(30000)
        for _, npc in pairs(ActiveNPCs) do
            MemorySystem.Cleanup(npc)
        end
    end
end)

-- ==============================================================
-- HOOKS
-- ==============================================================

AddEventHandler("npc:gunshot_nearby", function(coords)
    for _, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then
            local dist = #(GetEntityCoords(npc.ped) - coords)
            if dist < 30.0 then
                MemorySystem.Record(npc, MemoryEvent.WITNESSED_SHOT, { coords = coords })
                local shots = MemorySystem.Count(npc, MemoryEvent.WITNESSED_SHOT)
                if shots >= 3 then
                    npc.emotion.stress = Clamp(npc.emotion.stress + 10, 0, 100)
                end
            end
        end
    end
end)

AddEventHandler("npc:interact", function(npc)
    if npc then
        MemorySystem.Record(npc, MemoryEvent.INTERACTED)
    end
end)

AddEventHandler("npc:player_died_nearby", function(pCoords)
    for _, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then
            local dist = #(GetEntityCoords(npc.ped) - pCoords)
            if dist < 40.0 then
                MemorySystem.Record(npc, MemoryEvent.PLAYER_DIED)
            end
        end
    end
end)

-- ==============================================================
-- INFLUENCE SUR L'ÉMOTION AU TICK
-- ==============================================================

function MemorySystem.ApplyMemoryModifiers(npc)
    if not npc or not npc.memory then return end

    if MemorySystem.Has(npc, MemoryEvent.ATTACKED) then
        npc.emotion.fear       = Clamp(npc.emotion.fear + 2, 0, 100)
        npc.emotion.aggression = Clamp(npc.emotion.aggression + (npc.classData.canFight and 3 or 1), 0, 100)
    end

    if MemorySystem.Has(npc, MemoryEvent.PLAYER_DIED) then
        npc.emotion.fear   = math.max(0, npc.emotion.fear - 1)
        npc.emotion.stress = math.max(0, npc.emotion.stress - 1)
    end
end