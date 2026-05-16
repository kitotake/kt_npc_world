CreateThread(function()
    while true do
        Wait(Config.Spawn.spawnInterval)

        local player = PlayerPedId()
        local coords = GetEntityCoords(player)

        if GetActiveNPCCount() < Config.Spawn.maxNPCs then
            local zone  = GetZoneAt(coords)
            local class = "civil"
            local model = Config.Peds.maleModel

            if zone and zone.spawnClasses and #zone.spawnClasses > 0 then
                class = RandomChoice(zone.spawnClasses)
            end

            model = GetRandomModelForClass(class)

            local r  = Config.Spawn.spawnRadius
            local spawnCoords = vector3(
                coords.x + math.random(-r, r),
                coords.y + math.random(-r, r),
                coords.z
            )

            SpawnNPC(model, spawnCoords, class)
        end
    end
end)
