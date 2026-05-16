function RegisterEntity(ped, data)
    EntityIndex += 1

    ActiveNPCs[EntityIndex] = {
        id = EntityIndex,
        ped = ped,
        class = data.class or "civilian",
        state = "calm",
        emotion = {
            fear = 0,
            stress = 0,
            aggression = 0
        }
    }

    return ActiveNPCs[EntityIndex]
end