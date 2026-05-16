function SpawnNPC(model, coords, class)
    local hash = joaat(model)

    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(50) end

    local ped = CreatePed(4, hash, coords.x, coords.y, coords.z, 0.0, true, true)

    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityAsMissionEntity(ped, true, true)

    return RegisterEntity(ped, { class = class })
end