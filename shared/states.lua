-- State definitions and valid transitions for NPC state machine

StateTransitions = {
    calm = {
        scared     = function(npc) return npc.emotion.stress > EMOTION_THRESHOLDS.STRESS_SCARE end,
        panicked   = function(npc) return npc.emotion.fear > EMOTION_THRESHOLDS.PANIC_FEAR end,
        aggressive = function(npc) return npc.emotion.aggression > EMOTION_THRESHOLDS.AGGRO end,
    },
    scared = {
        calm     = function(npc) return npc.emotion.stress <= 20 and npc.emotion.fear <= 20 end,
        panicked = function(npc) return npc.emotion.fear > EMOTION_THRESHOLDS.PANIC_FEAR end,
        -- FIX: fleeing maintenant accessible — un NPC scared qui préfère fuir bascule ici
        fleeing  = function(npc) return npc.classData.preferFlee and npc.emotion.fear > 35 end,
        aggressive = function(npc) return npc.emotion.aggression > EMOTION_THRESHOLDS.AGGRO end,
    },
    panicked = {
        scared  = function(npc) return npc.emotion.fear <= 40 end,
        calm    = function(npc) return npc.emotion.fear <= 10 end,
        -- FIX: un NPC paniqué qui préfère fuir bascule en fleeing
        fleeing = function(npc) return npc.classData.preferFlee end,
    },
    aggressive = {
        calm     = function(npc) return npc.emotion.aggression <= 10 end,
        panicked = function(npc) return npc.emotion.fear > EMOTION_THRESHOLDS.PANIC_FEAR end,
        -- Un combattant trop blessé peut fuir (si preferFlee)
        fleeing  = function(npc) return npc.classData.preferFlee and npc.emotion.fear > 80 end,
    },
    -- FIX: fleeing a maintenant des transitions de sortie cohérentes
    fleeing = {
        calm     = function(npc) return npc.emotion.fear <= 10 end,
        scared   = function(npc) return npc.emotion.fear <= 35 and not npc.classData.preferFlee == false end,
        panicked = function(npc) return npc.emotion.fear > EMOTION_THRESHOLDS.PANIC_FEAR and not npc.classData.preferFlee end,
    },
    dead = {},
}

-- Priorité déterministe : évite les résultats aléatoires quand pairs() itère
local transitionPriority = { "panicked", "aggressive", "fleeing", "scared", "calm" }

function ResolveNextState(npc)
    local transitions = StateTransitions[npc.state]
    if not transitions then return nil end

    for _, nextState in ipairs(transitionPriority) do
        local cond = transitions[nextState]
        if cond and cond(npc) then
            return nextState
        end
    end
    return nil
end
