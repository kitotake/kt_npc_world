-- client/traffic/ped_traffic.lua
-- FIX v1.2 : SpawnTransient capture savedId + savedPed pour détecter le recyclage d'ID.

PedTraffic = {}

function PedTraffic.SpawnTransient(model, startCoords, endCoords, class)
    local npc = SpawnNPC(model, startCoords, class)
    if not npc then return end

    local savedId  = npc.id
    local savedPed = npc.ped

    TaskGoStraightToCoord(savedPed, endCoords.x, endCoords.y, endCoords.z, 1.0, 60000, 0.0, 0.5)

    CreateThread(function()
        local timeout = 60000
        local start   = GetGameTimer()
        while GetGameTimer() - start < timeout do
            Wait(1000)
            local current = ActiveNPCs[savedId]
            if not current then return end
            if current.ped ~= savedPed then return end

            if not DoesEntityExist(savedPed) then
                RemoveNPC(savedId)
                return
            end

            local dist = #(GetEntityCoords(savedPed) - endCoords)
            if dist < 3.0 then
                RemoveNPC(savedId)
                return
            end
        end

        local current = ActiveNPCs[savedId]
        if current and current.ped == savedPed then
            RemoveNPC(savedId)
        end
    end)
end

function PedTraffic.SpawnGroup(centerCoords, count, class)
    for i = 1, count do
        local offset = vector3(math.random(-3, 3), math.random(-3, 3), 0)
        local model  = GetRandomModelForClass(class or "civil")
        SpawnNPC(model, centerCoords + offset, class or "civil")
        Wait(200)
    end
end