Config = {}

Config.Peds = {
    maleModel   = "mp_m_freemode_01",
    femaleModel = "mp_f_freemode_01",
}

Config.Spawn = {
    maxNPCs       = 25,
    spawnRadius   = 50,
    despawnRadius = 200.0,
    spawnInterval = 4000,
}

Config.Emotion = {
    fearPerTick    = 10,
    stressPerTick  = 5,
    fearDecay      = 2,
    stressDecay    = 1,
    aggroDecay     = 1,   -- FIX: était manquant → math.max(0, aggression - nil) produisait une erreur Lua
    proximityRange = 10.0,
}

Config.Debug = false
