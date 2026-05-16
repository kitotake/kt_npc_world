-- Système de ciblage : détecte le NPC le plus proche du réticule

TargetSystem = {}
local targetedNPC = nil

CreateThread(function()
    while true do
        Wait(200)

        local player  = PlayerPedId()
        local coords  = GetEntityCoords(player)
        local nearest, dist = GetNearestNPC(coords, 5.0)

        if nearest ~= targetedNPC then
            if targetedNPC then
                TriggerEvent("npc:target_lost", targetedNPC)
            end
            if nearest then
                TriggerEvent("npc:target_acquired", nearest)
            end
            targetedNPC = nearest
        end
    end
end)

function GetTargetedNPC()
    return targetedNPC
end
