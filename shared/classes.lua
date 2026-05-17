-- NPC class definitions
-- Each class defines base emotion modifiers and behavior tendencies

NPC_CLASS_DATA = {
    civil = {
        fearMultiplier       = 1.5,
        aggressionMultiplier = 0.2,
        stressMultiplier     = 1.0,
        baseHealth           = 100,
        canFight             = false,
        preferFlee           = true,
        models = {
            "mp_m_freemode_01",
            "mp_f_freemode_01",
            "a_m_m_beach_01",
            "a_f_m_downtown_01",
        },
    },
    guard = {
        fearMultiplier       = 0.5,
        aggressionMultiplier = 1.5,
        stressMultiplier     = 0.7,
        baseHealth           = 200,
        canFight             = true,
        preferFlee           = false,
        models = {
            "s_m_m_security_01",
            "s_m_m_armoured_01",
        },
    },
    dealer = {
        fearMultiplier       = 1.0,
        aggressionMultiplier = 1.0,
        stressMultiplier     = 1.2,
        baseHealth           = 120,
        canFight             = true,
        preferFlee           = true,
        models = {
            "g_m_m_armboss_01",
            "g_m_m_armgoon_01",
        },
    },
    gang = {
        fearMultiplier       = 0.4,
        aggressionMultiplier = 2.0,
        stressMultiplier     = 0.5,
        baseHealth           = 150,
        canFight             = true,
        preferFlee           = false,
        models = {
            "g_m_y_lost_01",
            "g_m_y_famca_01",
            "g_m_y_ballaeast_01",
        },
    },
    medic = {
        fearMultiplier       = 0.8,
        aggressionMultiplier = 0.1,
        stressMultiplier     = 0.6,
        baseHealth           = 100,
        canFight             = false,
        preferFlee           = true,
        models = {
            "s_m_m_paramedic_01",
            "s_f_m_paramedic_01",
        },
    },
}

-- Returns the class data table for a given class string, defaulting to civil
function GetClassData(class)
    return NPC_CLASS_DATA[class] or NPC_CLASS_DATA["civil"]
end

-- Returns a random model for a given class
function GetRandomModelForClass(class)
    local data = GetClassData(class)
    return data.models[math.random(#data.models)]
end
