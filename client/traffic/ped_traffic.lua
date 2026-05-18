-- FIX v1.2 :
--   • SpawnTransient : le thread capture maintenant savedId + savedPed pour détecter
--     si le NPC a été recyclé (son ID réattribué à un autre NPC) avant la suppression.

PedTraffic = {}

function PedTraffic.SpawnTransient(model, startCoords, endCoords, class)
    local npc = SpawnNPC(model, startCoords, class)
    if not npc then return end

    -- FIX: capture des identifiants avant tout Wait pour détecter le recyclage d'ID
    local savedId  = npc.id
    local savedPed = npc.ped

    TaskGoStraightToCoord(savedPed, endCoords.x, endCoords.y, endCoords.z, 1.0, 60000, 0.0, 0.5)

    CreateThread(function()
        local timeout = 60000
        local start   = GetGameTimer()
        while GetGameTimer() - start < timeout do
            Wait(1000)
            -- FIX: vérifier que l'ID n'a pas été recyclé vers un autre NPC
            local current = ActiveNPCs[savedId]
            if not current then return end                    -- déjà supprimé
            if current.ped ~= savedPed then return end       -- ID recyclé → ne pas toucher

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

        -- Timeout : même vérification avant suppression
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
