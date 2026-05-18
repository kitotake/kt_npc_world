-- client/world/zone_manager.lua
-- Surveille la zone courante du joueur et notifie les changements

local currentZone = nil

CreateThread(function()
    while true do
        Wait(2000)

        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        local zone   = GetZoneAt(coords)

        local zoneId = zone and zone.id or nil

        if zoneId ~= (currentZone and currentZone.id or nil) then
            TriggerEvent("npc:zone_changed", currentZone, zone)
            currentZone = zone
        end
    end
end)

function GetCurrentZone()
    return currentZone
end

AddEventHandler("npc:zone_changed", function(prev, next)
    if not next then return end

    if Config.Debug then
        print(("^3[NPC WORLD]^0 Zone changed: %s → %s"):format(
            prev and prev.id or "none",
            next and next.id or "none"
        ))
    end
end)