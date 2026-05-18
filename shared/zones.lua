-- shared/zones.lua
-- v1.1 : spawnPoints fixes + maxNPCs par zone

Zones = {
    {
        id      = "downtown",
        label   = "Downtown",
        type    = "neutral",
        center  = vector3(-266.0, -958.0, 31.0),
        radius  = 300.0,
        maxNPCs = 20,
        spawnClasses = { "civil", "guard" },
        emotionMod   = { fear = 0, stress = 5, aggression = 0 },
        spawnPoints  = {
            vector3(-270.0, -960.0, 31.2),
            vector3(-230.0, -940.0, 31.2),
            vector3(-200.0, -980.0, 29.8),
            vector3(-300.0, -1000.0, 29.5),
            vector3(-250.0, -920.0, 31.0),
        },
    },
    {
        id      = "grove_street",
        label   = "Grove Street",
        type    = "gang",
        center  = vector3(80.0, -1946.0, 21.0),
        radius  = 150.0,
        maxNPCs = 10,
        spawnClasses = { "gang", "civil" },
        emotionMod   = { fear = 10, stress = 10, aggression = 15 },
        spawnPoints  = {
            vector3(82.0,  -1946.0, 21.0),
            vector3(100.0, -1930.0, 21.0),
            vector3(115.0, -1960.0, 21.0),
            vector3(90.0,  -1975.0, 21.0),
        },
    },
    {
        id      = "airport",
        label   = "Airport",
        type    = "safe",
        center  = vector3(-1037.0, -2737.0, 20.0),
        radius  = 400.0,
        maxNPCs = 15,
        spawnClasses = { "civil", "medic" },
        emotionMod   = { fear = 0, stress = 0, aggression = 0 },
        spawnPoints  = {
            vector3(-1060.0, -2710.0, 20.0),
            vector3(-1000.0, -2700.0, 20.0),
            vector3(-980.0,  -2750.0, 20.0),
            vector3(-1040.0, -2760.0, 20.0),
        },
    },
    {
        id      = "lsmission_row",
        label   = "Mission Row",
        type    = "safe",
        center  = vector3(428.0, -984.0, 30.0),
        radius  = 200.0,
        maxNPCs = 8,
        spawnClasses = { "civil", "guard" },
        emotionMod   = { fear = -5, stress = -5, aggression = -10 },
        spawnPoints  = {
            vector3(428.0, -984.0,  30.0),
            vector3(450.0, -1000.0, 30.0),
            vector3(410.0, -970.0,  30.0),
        },
    },
}

function GetZoneAt(coords)
    for _, zone in ipairs(Zones) do
        if #(coords - zone.center) <= zone.radius then
            return zone
        end
    end
    return nil
end

function GetSpawnPointInZone(zone)
    if zone.spawnPoints and #zone.spawnPoints > 0 then
        local pt = zone.spawnPoints[math.random(#zone.spawnPoints)]
        return vector3(
            pt.x + math.random(-3, 3),
            pt.y + math.random(-3, 3),
            pt.z
        )
    end
    local r = zone.radius * 0.8
    return vector3(
        zone.center.x + math.random(-r, r),
        zone.center.y + math.random(-r, r),
        zone.center.z
    )
end