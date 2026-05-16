function SpawnNPC(model, coords, class)
    local hash = joaat(model)

    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(50) end

    local ped = CreatePed(4, hash, coords.x, coords.y, coords.z, 0.0, true, true)

    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAttributes(ped, 46, true)

    SetModelAsNoLongerNeeded(hash)

    return RegisterEntity(ped, { class = class })
end

function SpawnNPCWithJob(model, coords, class, job, routeId)
    local npc = SpawnNPC(model, coords, class)
    if not npc then return nil end

    npc.job     = job or "none"
    npc.routeId = routeId or nil
    npc.waypointIndex = 1

    if job == "patrol" and routeId then
        TriggerEvent("npc:start_patrol", npc.id)
    end

    return npc
end
