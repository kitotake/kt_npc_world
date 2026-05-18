-- client/traffic/traffic_manager.lua
-- v1.1 : spawn intelligent avec points fixes par zone et respect zone.maxNPCs

CreateThread(function()
    while true do
        Wait(Config.Spawn.spawnInterval)

        local player = PlayerPedId()
        local coords = GetEntityCoords(player)

        if GetActiveNPCCount() >= Config.Spawn.maxNPCs then goto continue end

        local zone  = GetZoneAt(coords)
        local class = "civil"
        local spawnCoords

        if zone then
            local zoneCount = GetNPCCountInRadius(zone.center, zone.radius)
            if zoneCount >= zone.maxNPCs then goto continue end

            if zone.spawnClasses and #zone.spawnClasses > 0 then
                class = RandomChoice(zone.spawnClasses)
            end

            spawnCoords = GetSpawnPointInZone(zone)
        else
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