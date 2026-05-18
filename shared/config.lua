-- shared/config.lua
-- FIX v1.3 : ajout de Config.AI pour les seuils du decision_tree.
-- Évite les valeurs hardcodées dans decision_tree.lua (15/30 identiques pour toutes les classes).

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
    aggroDecay     = 1,
    proximityRange = 10.0,
}

-- FIX v1.3 : seuils du decision_tree extraits ici.
-- Peuvent être surchargés par classe via NPC_CLASS_DATA[class].aggroThreshold.
Config.AI = {
    aggroThreshold        = 30,   -- seuil d'agression par défaut (joueur armé proche)
    attackedAggroModifier = 15,   -- seuil réduit si le NPC a été attaqué récemment
}

Config.Debug = false