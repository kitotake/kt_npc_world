-- Événements monde déclenchés côté serveur et broadcastés aux clients

EventService = {}

-- Déclenche un événement de tir à une position
function EventService.TriggerGunshot(coords)
    TriggerClientEvent("npc:gunshot_nearby", -1, coords)
end

-- Déclenche une explosion
function EventService.TriggerExplosion(coords)
    TriggerClientEvent("npc:explosion_nearby", -1, coords)
end

-- Événement réseau entrant : un joueur signale un tir
RegisterNetEvent("npc:report_gunshot", function(coords)
    EventService.TriggerGunshot(coords)
end)

RegisterNetEvent("npc:report_explosion", function(coords)
    EventService.TriggerExplosion(coords)
end)
