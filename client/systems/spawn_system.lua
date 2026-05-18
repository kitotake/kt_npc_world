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

    local npc = RegisterEntity(ped, { class = class })

    if npc then
        TriggerEvent("npc:registered", npc)
    end

    return npc
end

function SpawnNPCWithJob(model, coords, class, job, routeId, groupId)
    local npc = SpawnNPC(model, coords, class)
    if not npc then return nil end

    npc.job     = job or "none"
    npc.routeId = routeId or nil
    npc.group   = groupId or nil
    npc.waypointIndex = 1

    if job == "patrol" and routeId then
        TriggerEvent("npc:start_patrol", npc.id)
    end

    -- FIX: suppression de l'appel explicite GroupAI.Register(npc) qui doublonnait
    -- le hook npc:registered déjà déclenché dans SpawnNPC ci-dessus.
    -- group_ai.lua écoute npc:registered et appelle Register() automatiquement.
    -- Si le group est défini APRÈS SpawnNPC (comme c'est le cas ici), on force
    -- un re-enregistrement maintenant que npc.group est positionné.
    if groupId then
        GroupAI.Register(npc)
    end

    return npc
end
