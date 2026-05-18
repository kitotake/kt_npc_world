function GetNPCs()
    return ActiveNPCs
end

function GetNPC(id)
    return ActiveNPCs[id]
end

function RemoveNPC(id)
    if ActiveNPCs[id] then
        if DoesEntityExist(ActiveNPCs[id].ped) then
            DeleteEntity(ActiveNPCs[id].ped)
        end
        -- FIX: gestion du véhicule centralisée ici pour éviter les doubles DeleteEntity
        -- avec despawn_system qui supprimait aussi npc.vehicle séparément.
        if ActiveNPCs[id].vehicle and DoesEntityExist(ActiveNPCs[id].vehicle) then
            DeleteEntity(ActiveNPCs[id].vehicle)
        end
        ActiveNPCs[id] = nil
        ReleaseID(id)
    end
end

function GetActiveNPCCount()
    local count = 0
    for _ in pairs(ActiveNPCs) do count += 1 end
    return count
end

function GetNPCCountInRadius(coords, radius)
    local count = 0
    for _, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then
            if #(GetEntityCoords(npc.ped) - coords) <= radius then
                count += 1
            end
        end
    end
    return count
end

function GetNearestNPC(coords, maxDist)
    local nearest, nearestDist = nil, maxDist or 50.0
    for _, npc in pairs(ActiveNPCs) do
        if DoesEntityExist(npc.ped) then
            local d = #(GetEntityCoords(npc.ped) - coords)
            if d < nearestDist then
                nearest     = npc
                nearestDist = d
            end
        end
    end
    return nearest, nearestDist
end

-- FIX: itération sûre sur ActiveNPCs avec suppression différée.
-- Appeler ceci à la place d'un pairs() direct quand des suppressions peuvent
-- survenir pendant la boucle (comportement indéfini en Lua standard).
function ForEachNPC(fn)
    local toRemove = {}
    for id, npc in pairs(ActiveNPCs) do
        local remove = fn(id, npc)
        if remove then
            toRemove[#toRemove + 1] = id
        end
    end
    for _, id in ipairs(toRemove) do
        RemoveNPC(id)
    end
end
