function RegisterEntity(ped, data)
    EntityIndex += 1

    local classData = GetClassData(data.class or "civil")

    ActiveNPCs[EntityIndex] = {
        id        = EntityIndex,
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
    }

    return ActiveNPCs[EntityIndex]
end
