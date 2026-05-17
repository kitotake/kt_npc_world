-- Shared enums for kt_npc_world
-- All constants used across client and server

NPC_STATE = {
    CALM       = "calm",
    SCARED     = "scared",
    PANICKED   = "panicked",
    AGGRESSIVE = "aggressive",
    FLEEING    = "fleeing",
    DEAD       = "dead",
}

-- FIX (bug 5): all keys now uppercase, consistent with GUARD/DEALER/etc.
NPC_CLASS = {
    CIVIL  = "civil",
    GUARD  = "guard",
    DEALER = "dealer",
    GANG   = "gang",
    MEDIC  = "medic",
}

NPC_JOB = {
    NONE    = "none",
    PATROL  = "patrol",
    STAND   = "stand",
    DRIVE   = "drive",
    IDLE    = "idle",
}

EMOTION = {
    FEAR       = "fear",
    STRESS     = "stress",
    AGGRESSION = "aggression",
}

EMOTION_THRESHOLDS = {
    PANIC_FEAR   = 70,
    AGGRO        = 60,
    STRESS_SCARE = 50,
}

ZONE_TYPE = {
    SAFE    = "safe",
    DANGER  = "danger",
    NEUTRAL = "neutral",
    GANG    = "gang",
}
