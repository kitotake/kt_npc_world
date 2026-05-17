-- v1.1 : spawn intelligent
-- - Utilise les points de spawn fixes de la zone (GetSpawnPointInZone)
-- - Respecte zone.maxNPCs avant de spawner
-- - Fallback radius aléatoire si hors zone

CreateThread(function()
    while true do
        Wait(Config.Spawn.spawnInterval)

        local player = PlayerPedId()
        local coords = GetEntityCoords(player)

        -- Limite globale
        if GetActiveNPCCount() >= Config.Spawn.maxNPCs then goto continue end

        local zone  = GetZoneAt(coords)
        local class = "civil"
        local spawnCoords

        if zone then
            -- FIX: respecte le maxNPCs de la zone
            local zoneCount = GetNPCCountInRadius(zone.center, zone.radius)
            if zoneCount >= zone.maxNPCs then goto continue end

            -- Classe selon la zone
            if zone.spawnClasses and #zone.spawnClasses > 0 then
                class = RandomChoice(zone.spawnClasses)
            end

            -- Point de spawn intelligent
            spawnCoords = GetSpawnPointInZone(zone)
        else
            -- Hors zone : spawn radius classique autour du joueur
            local r = Config.Spawn.spawnRadius
            spawnCoords = vector3(
                coords.x + math.random(-r, r),
                coords.y + math.random(-r, r),
                coords.z
            )
        end

        local model = GetRandomModelForClass(class)
        SpawnNPC(model, spawnCoords, class)

        ::continue::
    end
end)
