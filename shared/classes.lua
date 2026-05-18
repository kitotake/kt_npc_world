-- shared/classes.lua
-- FIX v1.3 : ajout de aggroThreshold et attackedAggroModifier par classe.
-- decision_tree.lua lit ces valeurs au lieu d'utiliser des constantes hardcodées.
-- Si absent, fallback sur Config.AI.aggroThreshold / Config.AI.attackedAggroModifier.

NPC_CLASS_DATA = {
    civil = {
        fearMultiplier         = 1.5,
        aggressionMultiplier   = 0.2,
        stressMultiplier       = 1.0,
        baseHealth             = 100,
        canFight               = false,
        preferFlee             = true,
        -- Les civils ne s'engagent quasi jamais (seuil très haut)
        aggroThreshold         = 80,
        attackedAggroModifier  = 50,
        models = {
            "mp_m_freemode_01",
            "mp_f_freemode_01",
        },
    },
    guard = {
        fearMultiplier         = 0.5,
        aggressionMultiplier   = 1.5,
        stressMultiplier       = 0.7,
        baseHealth             = 200,
        canFight               = true,
        preferFlee             = false,
        -- Gardes : seuil modéré, réactifs si attaqués
        aggroThreshold         = 30,
        attackedAggroModifier  = 10,
        models = {
            "mp_m_freemode_01",
            "mp_f_freemode_01",
        },
    },
    dealer = {
        fearMultiplier         = 1.0,
        aggressionMultiplier   = 1.0,
        stressMultiplier       = 1.2,
        baseHealth             = 120,
        canFight               = true,
        preferFlee             = true,
        -- Dealers : réactifs mais préfèrent fuir
        aggroThreshold         = 35,
        attackedAggroModifier  = 15,
        models = {
            "mp_m_freemode_01",
            "mp_f_freemode_01",
        },
    },
    gang = {
        fearMultiplier         = 0.4,
        aggressionMultiplier   = 2.0,
        stressMultiplier       = 0.5,
        baseHealth             = 150,
        canFight               = true,
        preferFlee             = false,
        -- Gangs : très réactifs, seuil bas
        aggroThreshold         = 15,
        attackedAggroModifier  = 5,
        models = {
            "mp_m_freemode_01",
            "mp_f_freemode_01",
        },
    },
    medic = {
        fearMultiplier         = 0.8,
        aggressionMultiplier   = 0.1,
        stressMultiplier       = 0.6,
        baseHealth             = 100,
        canFight               = false,
        preferFlee             = true,
        -- Médics : ne s'engagent jamais
        aggroThreshold         = 100,
        attackedAggroModifier  = 100,
        models = {
            "mp_m_freemode_01",
            "mp_f_freemode_01",
        },
    },
}

function GetClassData(class)
    return NPC_CLASS_DATA[class] or NPC_CLASS_DATA["civil"]
end

function GetRandomModelForClass(class)
    local data = GetClassData(class)
    return data.models[math.random(#data.models)]
end