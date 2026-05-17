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
        ActiveNPCs[id] = nil
        ReleaseID(id)   -- FIX: recycle l'ID
    end
end

function GetActiveNPCCount()
    local count = 0
    for _ in pairs(ActiveNPCs) do count += 1 end
    return count
end

-- FIX: compte les NPCs dans un rayon donné (utilisé par zone maxNPCs)
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
