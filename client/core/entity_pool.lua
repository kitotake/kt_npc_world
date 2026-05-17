-- FIX: EntityIndex ne grossit plus indéfiniment.
-- Les IDs libérés par RemoveNPC sont recyclés via FreeSlots.

local FreeSlots = {}

local function NextID()
    if #FreeSlots > 0 then
        return table.remove(FreeSlots)
    end
    EntityIndex += 1
    return EntityIndex
end

function ReleaseID(id)
    table.insert(FreeSlots, id)
end

function RegisterEntity(ped, data)
    local id        = NextID()
    local classData = GetClassData(data.class or "civil")

    ActiveNPCs[id] = {
        id        = id,
        ped       = ped,
        class     = data.class or "civil",
        state     = "calm",
        job       = data.job or "none",
        group     = data.group or nil,
        emotion   = {
            fear       = 0,
            stress     = 0,
            aggression = 0,
        },
        classData = classData,
        spawnedAt = GetGameTimer(),
        memory    = {},   -- utilisé par memory_system
    }

    return ActiveNPCs[id]
end
