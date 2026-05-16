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
    end
end

function GetActiveNPCCount()
    local count = 0
    for _ in pairs(ActiveNPCs) do count += 1 end
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
