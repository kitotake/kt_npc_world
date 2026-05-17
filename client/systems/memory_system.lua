-- client/systems/memory_system.lua
-- v1.1 : mémoire locale des NPCs
-- Chaque NPC se souvient des événements qui le concernent (agressions, interactions,
-- tirs proches vécus). La mémoire influence les émotions et les réactions futures.

MemorySystem = {}

-- Durée de rétention d'un souvenir en ms (5 minutes)
local MEMORY_TTL = 300000

-- Types d'événements mémorisables
local MemoryEvent = {
    ATTACKED      = "attacked",       -- le joueur a attaqué ce NPC
    WITNESSED_SHOT = "witnessed_shot", -- a entendu/vu un tir
    WITNESSED_EXPLOSION = "witnessed_explosion",
    INTERACTED    = "interacted",     -- le joueur lui a parlé
    PLAYER_DIED   = "player_died",    -- a vu le joueur mourir
}

-- ==============================================================
-- ENREGISTREMENT
-- ==============================================================

-- Ajoute un souvenir au NPC
function MemorySystem.Record(npc, eventType, data)
    if not npc or not npc.memory then return end

    table.insert(npc.memory, {
        event     = eventType,
        data      = data or {},
        timestamp = GetGameTimer(),
    })

    -- Optionnel : persiste côté serveur pour analytics
    TriggerServerEvent("npc:memory_event", npc.id, eventType, data)
end

-- Retourne true si le NPC a un souvenir du type donné encore valide
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

-- Retourne le nombre de souvenirs d'un type donné encore valides
function MemorySystem.Count(npc, eventType)
    if not npc or not npc.memory then return 0 end
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

-- Purge les souvenirs expirés (appelé toutes les 30s)
function MemorySystem.Cleanup(npc)
    if not npc or not npc.memory then return end
    local now    = GetGameTimer()
    local pruned = {}
    for _, mem in ipairs(npc.memory) do
        if (now - mem.timestamp) < MEMORY_TTL then
            table.insert(pruned, mem)
        end
    end
    npc.memory = pruned
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
-- HOOKS SUR LES ÉVÉNEMENTS EXISTANTS
-- ==============================================================

-- Quand un NPC entend un tir
AddEventHandler("npc:gunshot_nearby", function(coords)
    for _, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then
            local dist = #(GetEntityCoords(npc.ped) - coords)
            if dist < 30.0 then
                MemorySystem.Record(npc, MemoryEvent.WITNESSED_SHOT, { coords = coords })

                -- Plus il a vécu de tirs, plus il stresse vite au prochain
                local shots = MemorySystem.Count(npc, MemoryEvent.WITNESSED_SHOT)
                if shots >= 3 then
                    npc.emotion.stress = Clamp(npc.emotion.stress + 10, 0, 100)
                end
            end
        end
    end
end)

-- Quand un NPC est interagi
AddEventHandler("npc:interact", function(npc)
    if npc then
        MemorySystem.Record(npc, MemoryEvent.INTERACTED)
    end
end)

-- Quand le joueur meurt
AddEventHandler("gameEventTriggered", function(name, args)
    if name == "CEventNetworkEntityDamage" then
        local victim = args[1]
        if victim == PlayerPedId() and IsEntityDead(victim) then
            local pCoords = GetEntityCoords(victim)
            for _, npc in pairs(ActiveNPCs) do
                if DoesEntityExist(npc.ped) then
                    local dist = #(GetEntityCoords(npc.ped) - pCoords)
                    if dist < 40.0 then
                        MemorySystem.Record(npc, MemoryEvent.PLAYER_DIED)
                        -- Voir le joueur mourir calme les NPCs proches
                        npc.emotion.fear       = math.max(0, npc.emotion.fear - 40)
                        npc.emotion.aggression = math.max(0, npc.emotion.aggression - 40)
                    end
                end
            end
        end
    end
end)

-- ==============================================================
-- INFLUENCE SUR L'ÉMOTION AU TICK
-- ==============================================================

-- Appelé depuis emotion_system : ajuste les émotions selon la mémoire
function MemorySystem.ApplyMemoryModifiers(npc)
    if not npc or not npc.memory then return end

    -- NPC attaqué dans le passé : aggression et fear de base plus élevées
    if MemorySystem.Has(npc, MemoryEvent.ATTACKED) then
        npc.emotion.fear       = Clamp(npc.emotion.fear + 2, 0, 100)
        npc.emotion.aggression = Clamp(npc.emotion.aggression + (npc.classData.canFight and 3 or 1), 0, 100)
    end

    -- A vu le joueur mourir : légère détente
    if MemorySystem.Has(npc, MemoryEvent.PLAYER_DIED) then
        npc.emotion.fear   = math.max(0, npc.emotion.fear - 1)
        npc.emotion.stress = math.max(0, npc.emotion.stress - 1)
    end
end

-- Export pour usage externe
MemorySystem.Event = MemoryEvent
