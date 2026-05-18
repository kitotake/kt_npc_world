-- client/core/npc_manager.lua

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

-- Itération sûre sur ActiveNPCs avec suppression différée.
-- Utiliser cette fonction quand des suppressions peuvent survenir pendant la boucle.
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