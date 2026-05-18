-- server/world_service.lua

WorldService = {}

local worldState = {
    hour       = 12,
    weather    = "CLEAR",
    alertLevel = 0,
}

function WorldService.GetState()
    return worldState
end

function WorldService.SetAlertLevel(level)
    worldState.alertLevel = Clamp(level, 0, 5)
    TriggerClientEvent("npc:alert_level_changed", -1, worldState.alertLevel)
end

CreateThread(function()
    while true do
        Wait(300000)
        worldState.hour = (worldState.hour + 1) % 24
        TriggerClientEvent("npc:world_hour_changed", -1, worldState.hour)
    end
end)