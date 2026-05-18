-- client/traffic/vehicle_traffic.lua

local vehicleModels = { "blista", "dilettante", "surge", "panto", "issi2" }

AddEventHandler("npc:spawn_vehicle_for", function(id)
    local npc = ActiveNPCs[id]
    if not npc then return end

    local modelName = RandomChoice(vehicleModels)
    local vehHash   = joaat(modelName)

    RequestModel(vehHash)
    while not HasModelLoaded(vehHash) do Wait(50) end

    local coords = GetEntityCoords(npc.ped)
    local veh    = CreateVehicle(vehHash, coords.x, coords.y, coords.z, GetEntityHeading(npc.ped), true, false)

    SetVehicleAsNoLongerNeeded(veh)
    SetModelAsNoLongerNeeded(vehHash)

    TaskWarpPedIntoVehicle(npc.ped, veh, -1)
    TaskVehicleDriveWander(npc.ped, veh, 20.0, 786603)

    npc.vehicle = veh
    npc.job     = "drive"
end)

function SpawnVehicleNPC(coords, class)
    local model = GetRandomModelForClass(class or "civil")
    local npc   = SpawnNPC(model, coords, class or "civil")
    if not npc then return end

    TriggerEvent("npc:spawn_vehicle_for", npc.id)
    return npc
end