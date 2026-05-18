-- server/event_service.lua

EventService = {}

function EventService.TriggerGunshot(coords)
    TriggerClientEvent("npc:gunshot_nearby", -1, coords)
end

function EventService.TriggerExplosion(coords)
    TriggerClientEvent("npc:explosion_nearby", -1, coords)
end

RegisterNetEvent("npc:report_gunshot", function(coords)
    EventService.TriggerGunshot(coords)
end)

RegisterNetEvent("npc:report_explosion", function(coords)
    EventService.TriggerExplosion(coords)
end)