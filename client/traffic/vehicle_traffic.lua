RegisterNetEvent("npc:spawn_vehicle_for", function(id)
    local npc = ActiveNPCs[id]
    if not npc then return end

    local vehHash = joaat("blista")
    RequestModel(vehHash)
    while not HasModelLoaded(vehHash) do Wait(50) end

    local coords = GetEntityCoords(npc.ped)

    local veh = CreateVehicle(vehHash, coords.x, coords.y, coords.z, 0.0, true, false)

    TaskWarpPedIntoVehicle(npc.ped, veh, -1)
    TaskVehicleDriveWander(npc.ped, veh, 20.0, 786603)
end)