-- Service monde : gestion de l'état global de la simulation

WorldService = {}

local worldState = {
    hour         = 12,
    weather      = "CLEAR",
    alertLevel   = 0,
}

function WorldService.GetState()
    return worldState
end

function WorldService.SetAlertLevel(level)
    worldState.alertLevel = Clamp and Clamp(level, 0, 5) or math.max(0, math.min(5, level))
    TriggerClientEvent("npc:alert_level_changed", -1, worldState.alertLevel)
end

-- Mise à jour de l'heure de jeu toutes les 5 minutes
CreateThread(function()
    while true do
        Wait(300000)
        worldState.hour = (worldState.hour + 1) % 24
        TriggerClientEvent("npc:world_hour_changed", -1, worldState.hour)
    end
end)
