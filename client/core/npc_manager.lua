ActiveNPCs = {}

function RegisterNPC(ped, data)
    local id = #ActiveNPCs + 1

    ActiveNPCs[id] = {
        id = id,
        ped = ped,
        class = data.class or "civilian",
        state = "calm",

        emotion = {
            fear = 0,
            stress = 0,
            aggression = 0
        },

        job = data.job or "none",
        group = data.group or nil
    }

    return ActiveNPCs[id]
end

function GetNPCs()
    return ActiveNPCs
end

function RemoveNPC(id)
    if ActiveNPCs[id] then
        DeleteEntity(ActiveNPCs[id].ped)
        ActiveNPCs[id] = nil
    end
end