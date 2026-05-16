-- Gestion du trafic piéton : groupes, horaires, densités

PedTraffic = {}

-- Fait marcher un NPC vers une destination puis le supprime à l'arrivée (NPC de passage)
function PedTraffic.SpawnTransient(model, startCoords, endCoords, class)
    local npc = SpawnNPC(model, startCoords, class)
    if not npc then return end

    TaskGoStraightToCoord(npc.ped, endCoords.x, endCoords.y, endCoords.z, 1.0, 60000, 0.0, 0.5)

    CreateThread(function()
        local timeout = 60000
        local start   = GetGameTimer()
        while GetGameTimer() - start < timeout do
            Wait(1000)
            if not ActiveNPCs[npc.id] then return end
            local dist = #(GetEntityCoords(npc.ped) - endCoords)
            if dist < 3.0 then
                RemoveNPC(npc.id)
                return
            end
        end
        RemoveNPC(npc.id)
    end)
end

-- Fait spawner un groupe de PNJ qui marchent ensemble
function PedTraffic.SpawnGroup(centerCoords, count, class)
    for i = 1, count do
        local offset = vector3(math.random(-3, 3), math.random(-3, 3), 0)
        local model  = GetRandomModelForClass(class or "civil")
        SpawnNPC(model, centerCoords + offset, class or "civil")
        Wait(200)
    end
end
