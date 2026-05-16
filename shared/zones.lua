-- World zone definitions
-- Zones influence NPC spawn density, emotion modifiers, and allowed classes

Zones = {
    {
        id      = "downtown",
        label   = "Downtown",
        type    = ZONE_TYPE and ZONE_TYPE.NEUTRAL or "neutral",
        center  = vector3(-266.0, -958.0, 31.0),
        radius  = 300.0,
        maxNPCs = 20,
        spawnClasses = { "civil", "guard" },
        emotionMod = { fear = 0, stress = 5, aggression = 0 },
    },
    {
        id      = "grove_street",
        label   = "Grove Street",
        type    = ZONE_TYPE and ZONE_TYPE.GANG or "gang",
        center  = vector3(80.0, -1946.0, 21.0),
        radius  = 150.0,
        maxNPCs = 10,
        spawnClasses = { "gang", "civil" },
        emotionMod = { fear = 10, stress = 10, aggression = 15 },
    },
    {
        id      = "airport",
        label   = "Airport",
        type    = ZONE_TYPE and ZONE_TYPE.SAFE or "safe",
        center  = vector3(-1037.0, -2737.0, 20.0),
        radius  = 400.0,
        maxNPCs = 15,
        spawnClasses = { "civil", "medic" },
        emotionMod = { fear = 0, stress = 0, aggression = 0 },
    },
    {
        id      = "lsmission_row",
        label   = "Mission Row",
        type    = ZONE_TYPE and ZONE_TYPE.SAFE or "safe",
        center  = vector3(428.0, -984.0, 30.0),
        radius  = 200.0,
        maxNPCs = 8,
        spawnClasses = { "civil", "guard" },
        emotionMod = { fear = -5, stress = -5, aggression = -10 },
    },
}

-- Returns the zone entry for the given world coords, or nil
function GetZoneAt(coords)
    for _, zone in ipairs(Zones) do
        if #(coords - zone.center) <= zone.radius then
            return zone
        end
    end
    return nil
end
